// Copyright © 2024 Kaleido, Inc.
//
// SPDX-License-Identifier: Apache-2.0
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import { ethers } from 'hardhat';
import { Signer, BigNumberish } from 'ethers';
import { expect } from 'chai';
import { MyContract } from "../../typechain-types";
import { genKeypair, Keypair } from 'maci-crypto';
import { Merkletree, InMemoryDB, str2Bytes, ZERO_HASH } from '@iden3/js-merkletree';
import { groth16 } from 'snarkjs';
import { poseidonContract } from "circomlibjs";
import { loadCircuit, encodeProof, Poseidon } from "zeto-js";
import { loadProvingKeys } from '../utils';

describe('Registry tests', function () {
  let registry: MyContract;
  let smt: any;
  let owner: Signer;
  let sender: Signer;
  let receiver: Signer;
  let senderKeypair: Keypair;
  let receiverKeypair: Keypair;
  let circuit: any, provingKey: any;

  before(async function () {
    [owner, sender, receiver] = await ethers.getSigners();
    const Poseidon2 = await deployPoseidon(2, owner);
    const Poseidon3 = await deployPoseidon(3, owner);
    const SmtLib = await ethers.getContractFactory("SmtLib", {
      signer: owner,
      libraries: {
        PoseidonUnit2L: Poseidon2,
        PoseidonUnit3L: Poseidon3,
      },
    });
    const smtLib = await SmtLib.deploy();

    const Groth16Verifier_CheckSMTProof = await ethers.getContractFactory("Groth16Verifier_CheckSMTProof", owner);
    const verifier = await Groth16Verifier_CheckSMTProof.deploy();
    const Registry = await ethers.getContractFactory("MyContract", {
      signer: owner,
      libraries: {
        SmtLib: smtLib,
        PoseidonUnit2L: Poseidon2,
        PoseidonUnit3L: Poseidon3,
      },
    });
    registry = await Registry.deploy(verifier.target);
    console.log(`Sample Registry deployed to ${registry.target}`);

    circuit = await loadCircuit('check_smt_proof');
    ({ provingKeyFile: provingKey } = loadProvingKeys('check_smt_proof'));

    // create an SMT to track the users locally
    const storage1 = new InMemoryDB(str2Bytes(""))
    smt = new Merkletree(storage1, true, 64);
  });

  it('should register a new user', async function () {
    senderKeypair = genKeypair();
    receiverKeypair = genKeypair();

    const tx1 = await registry.connect(owner).register(senderKeypair.pubKey as [BigNumberish, BigNumberish]);
    const receipt1 = await tx1.wait();
    expect(receipt1!.status).to.equal(1);
    const senderKeyHash = Poseidon.poseidon2([senderKeypair.pubKey[0], senderKeypair.pubKey[1]]);
    await smt.add(senderKeyHash, senderKeyHash);

    const tx2 = await registry.connect(owner).register(receiverKeypair.pubKey as [BigNumberish, BigNumberish]);
    const receipt2 = await tx2.wait();
    expect(receipt2!.status).to.equal(1);
    const receiverKeyHash = Poseidon.poseidon2([receiverKeypair.pubKey[0], receiverKeypair.pubKey[1]]);
    await smt.add(receiverKeyHash, receiverKeyHash);
  });

  it('should return the correct query result', async function () {
    const pubKey = await registry.connect(owner).isRegistered(senderKeypair.pubKey as [BigNumberish, BigNumberish]);
    expect(pubKey).to.equal(true);
  });

  it('should perform a transaction between two registered users', async function () {
    const root = await smt.root();
    const senderKeyHash = Poseidon.poseidon2([senderKeypair.pubKey[0], senderKeypair.pubKey[1]]);
    const proof1 = await smt.generateCircomVerifierProof(senderKeyHash, root);

    const receiverKeyHash = Poseidon.poseidon2([receiverKeypair.pubKey[0], receiverKeypair.pubKey[1]]);
    const proof2 = await smt.generateCircomVerifierProof(receiverKeyHash, root);

    const merkleProofs = [proof1.siblings.map((s: any) => s.bigInt()), proof2.siblings.map((s: any) => s.bigInt())];
    const { encodedProof } = await prepareProof(senderKeypair, receiverKeypair, root.bigInt(), merkleProofs);

    const tx = await registry.connect(owner).myMethod(encodedProof);
    const receipt = await tx.wait();
    expect(receipt!.status).to.equal(1);
  });

  it('should fail to perform a transaction that involve unregistered users', async function () {
    const unregisteredKeypair = genKeypair();
    const user1KeyHash = Poseidon.poseidon2([unregisteredKeypair.pubKey[0], unregisteredKeypair.pubKey[1]]);
    await smt.add(user1KeyHash, user1KeyHash);

    const root = await smt.root();
    const senderKeyHash = Poseidon.poseidon2([senderKeypair.pubKey[0], senderKeypair.pubKey[1]]);
    const proof1 = await smt.generateCircomVerifierProof(senderKeyHash, root);

    const proof2 = await smt.generateCircomVerifierProof(user1KeyHash, root);

    const merkleProofs = [proof1.siblings.map((s: any) => s.bigInt()), proof2.siblings.map((s: any) => s.bigInt())];
    const { encodedProof } = await prepareProof(senderKeypair, unregisteredKeypair, root.bigInt(), merkleProofs);

    await expect(registry.connect(owner).myMethod(encodedProof)).rejectedWith("reverted with reason string 'Identity not registered'");
  });

  async function prepareProof(sender: any, receiver: any, root: BigInt, merkleProof: BigInt[][]) {
    const senderKeyHash = Poseidon.poseidon2([sender.pubKey[0], sender.pubKey[1]]);
    const receiverKeyHash = Poseidon.poseidon2([receiver.pubKey[0], receiver.pubKey[1]]);
    const startWitnessCalculation = Date.now();
    const inputObj = {
      root,
      merkleProof,
      leafNodeIndexes: [senderKeyHash, receiverKeyHash],
    };
    const witness = await circuit.calculateWTNSBin(
      inputObj,
      true
    );
    const timeWithnessCalculation = Date.now() - startWitnessCalculation;

    const startProofGeneration = Date.now();
    const { proof, publicSignals } = await groth16.prove(provingKey, witness) as { proof: BigNumberish[]; publicSignals: BigNumberish[] };
    const timeProofGeneration = Date.now() - startProofGeneration;

    console.log(`Witness calculation time: ${timeWithnessCalculation}ms. Proof generation time: ${timeProofGeneration}ms.`);

    const encodedProof = encodeProof(proof);
    return {
      encodedProof
    };
  }
});

async function deployPoseidon(size: number, deployer: any) {
  const abi = poseidonContract.generateABI(size);
  const code = poseidonContract.createCode(size);
  const PoseidonElements = new ethers.ContractFactory(abi, code, deployer);
  const poseidonElements = await PoseidonElements.deploy();
  await poseidonElements.waitForDeployment();
  console.log(`Poseidon${size}Elements deployed to:`, await poseidonElements.getAddress());
  return poseidonElements;
};

