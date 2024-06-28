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

import { ethers, ignition } from 'hardhat';
import { Signer, BigNumberish, AddressLike, ContractTransactionReceipt, ZeroAddress } from 'ethers';
import { expect } from 'chai';
import { loadCircuits, encodeProof, Poseidon } from "zk-utxo";
import { groth16 } from 'snarkjs';
import { formatPrivKeyForBabyJub, stringifyBigInts } from 'maci-crypto';
import { User, UTXO, newUser, newUTXO, doMint, parseUTXOBranchEvents } from './lib/utils';

import RegistryModule from '../ignition/modules/registry';
import zkConfidentialUTXOModule from '../ignition/modules/zkConfidentialUTXO_anon';

const ZERO_PUBKEY = [0, 0];
const poseidonHash = Poseidon.poseidon4;

describe("zkConfidentialUTXO with anonymity without encryption", function () {
  let deployer: Signer;
  let Alice: User;
  let Bob: User;
  let Charlie: User;
  let zkConfidentialUTXO: any;
  let utxo1: UTXO;
  let utxo2: UTXO;
  let utxo3: UTXO;
  let utxo4: UTXO;
  let utxo7: UTXO;
  let circuit: any, provingKey: any;

  before(async function () {
    let [d, a, b, c] = await ethers.getSigners();
    deployer = d;
    Alice = await newUser(a);
    Bob = await newUser(b);
    Charlie = await newUser(c);
    const { registry } = await ignition.deploy(RegistryModule);
    ({ zkConfidentialUTXO } = await ignition.deploy(zkConfidentialUTXOModule, { parameters: { zkConfidentialUTXO_Anonymity: { registry: registry.target } } }));

    const tx1 = await registry.connect(deployer).register(Alice.ethAddress, Alice.babyJubPublicKey as [BigNumberish, BigNumberish]);
    await tx1.wait();
    const tx2 = await registry.connect(deployer).register(Bob.ethAddress, Bob.babyJubPublicKey as [BigNumberish, BigNumberish]);
    await tx2.wait();
    const tx3 = await registry.connect(deployer).register(Charlie.ethAddress, Charlie.babyJubPublicKey as [BigNumberish, BigNumberish]);
    await tx3.wait();

    const result = await loadCircuits('anon');
    circuit = result.circuit;
    provingKey = result.provingKeyFile;
  });

  it("mint to Alice and transfer UTXOs honestly to Bob should succeed", async function () {
    // first the authority mints UTXOs to Alice
    utxo1 = newUTXO(10, Alice);
    utxo2 = newUTXO(20, Alice);
    await doMint(zkConfidentialUTXO, deployer, [utxo1, utxo2]);

    // Alice proposes the output UTXOs
    const _txo3 = newUTXO(25, Bob);
    utxo4 = newUTXO(5, Alice, _txo3.salt);

    // Alice transfers UTXOs to Bob
    const result = await doBranch(Alice, [utxo1, utxo2], [_txo3, utxo4], [Bob, Alice]);

    // Bob reconstructs the UTXO from off-chain secure message channels with Alice
    // first obtain the UTXOs from the transaction event
    const events = parseUTXOBranchEvents(zkConfidentialUTXO, result);
    const incomingUTXOs: any = events[0].outputs;

    // Bob uses the information received from Alice to reconstruct the UTXO sent to him
    const receivedValue = 25;
    const receivedSalt = _txo3.salt;
    const hash = poseidonHash([BigInt(receivedValue), receivedSalt, Bob.babyJubPublicKey[0], Bob.babyJubPublicKey[1]]);
    expect(incomingUTXOs[0]).to.equal(hash);

    // now Bob can reconstruct the UTXO using the information received from Alice
    utxo3 = newUTXO(receivedValue, Bob, receivedSalt);
  });

  it("Bob transfers UTXOs, previously received from Alice, honestly to Charlie should succeed", async function () {
    // give Bob another UTXO to be able to spend
    const _utxo1 = newUTXO(20, Bob);
    await doMint(zkConfidentialUTXO, deployer, [_utxo1]);

    // propose the output UTXOs
    const _utxo2 = newUTXO(30, Charlie);
    utxo7 = newUTXO(15, Bob);

    // Bob should be able to spend the UTXO that was reconstructed from the previous transaction
    await doBranch(Bob, [utxo3, _utxo1], [_utxo2, utxo7], [Charlie, Bob]);
  });

  it("mint existing unspent UTXOs should fail", async function () {
    await expect(doMint(zkConfidentialUTXO, deployer, [utxo4])).rejectedWith("UTXOAlreadyOwned");
  });

  it("mint existing spent UTXOs should fail", async function () {
    await expect(doMint(zkConfidentialUTXO, deployer, [utxo1])).rejectedWith("UTXOAlreadySpent");
  });

  it("transfer non-existing UTXOs should fail", async function () {
    const nonExisting1 = newUTXO(10, Alice);
    const nonExisting2 = newUTXO(20, Alice, nonExisting1.salt);
    await expect(doBranch(Alice, [nonExisting1, nonExisting2], [nonExisting1, nonExisting2], [Alice, Alice])).rejectedWith("UTXONotMinted");
  });

  it("transfer spent UTXOs should fail (double spend protection)", async function () {
    // create outputs
    const utxo5 = newUTXO(25, Bob);
    const utxo6 = newUTXO(5, Alice, utxo5.salt);
    await expect(doBranch(Alice, [utxo1, utxo2], [utxo5, utxo6], [Bob, Alice])).rejectedWith("UTXOAlreadySpent")
  });

  it("spend by using the same UTXO as both inputs should fail", async function () {
    const utxo5 = newUTXO(20, Alice);
    const utxo6 = newUTXO(10, Bob, utxo5.salt);
    await expect(doBranch(Bob, [utxo7, utxo7], [utxo5, utxo6], [Alice, Bob])).rejectedWith(`UTXODuplicate(${utxo7.hash.toString()}`);
  });

  async function doBranch(signer: User, inputs: UTXO[], outputs: UTXO[], owners: User[]) {
    let inputCommitments: [BigNumberish, BigNumberish];
    let outputCommitments: [BigNumberish, BigNumberish];
    let outputOwnerAddresses: [AddressLike, AddressLike];
    let encodedProof: any;
    const result = await prepareProof(circuit, provingKey, signer, inputs, outputs, owners);
    inputCommitments = result.inputCommitments;
    outputCommitments = result.outputCommitments;
    outputOwnerAddresses = owners.map(owner => owner.ethAddress || ZeroAddress) as [AddressLike, AddressLike];
    encodedProof = result.encodedProof;

    return await sendTx(signer, inputCommitments, outputCommitments, outputOwnerAddresses, encodedProof);
  }

  async function sendTx(
    signer: User,
    inputCommitments: [BigNumberish, BigNumberish],
    outputCommitments: [BigNumberish, BigNumberish],
    outputOwnerAddresses: [AddressLike, AddressLike],
    encodedProof: any
  ) {
    const signerAddress = await signer.signer.getAddress();
    const tx = await zkConfidentialUTXO.connect(signer.signer).branch(inputCommitments, outputCommitments, encodedProof);
    const results = await tx.wait();
    console.log(`Method branch() complete. Gas used: ${results?.gasUsed}`);

    for (const input of inputCommitments) {
      const owner = await zkConfidentialUTXO.spent(input);
      expect(owner).to.equal(true);
    }
    for (let i = 0; i < outputCommitments.length; i++) {
      expect(await zkConfidentialUTXO.spent(outputCommitments[i])).to.equal(false);
    }

    return results;
  }
});

async function prepareProof(circuit: any, provingKey: any, signer: User, inputs: UTXO[], outputs: UTXO[], owners: User[]) {
  const inputCommitments: [BigNumberish, BigNumberish] = inputs.map((input) => input.hash) as [BigNumberish, BigNumberish];
  const inputValues = inputs.map((input) => BigInt(input.value || 0n));
  const inputSalts = inputs.map((input) => input.salt || 0n);
  const outputCommitments: [BigNumberish, BigNumberish] = outputs.map((output) => output.hash) as [BigNumberish, BigNumberish];
  const outputValues = outputs.map((output) => BigInt(output.value || 0n));
  const outputSalts = outputs.map(o => o.salt || 0n);
  const outputOwnerPublicKeys: [[BigNumberish, BigNumberish], [BigNumberish, BigNumberish]] = owners.map(owner => owner.babyJubPublicKey || ZERO_PUBKEY) as [[BigNumberish, BigNumberish], [BigNumberish, BigNumberish]];
  const otherInputs = stringifyBigInts({
    senderPrivateKey: formatPrivKeyForBabyJub(signer.babyJubPrivateKey),
  });

  const startWitnessCalculation = Date.now();
  const witness = await circuit.calculateWTNSBin(
    {
      inputCommitments,
      inputValues,
      inputSalts,
      outputCommitments,
      outputValues,
      outputSalts,
      outputOwnerPublicKeys,
      ...otherInputs
    },
    true
  );
  const timeWitnessCalculation = Date.now() - startWitnessCalculation;

  const startProofGeneration = Date.now();
  const { proof, publicSignals } = await groth16.prove(provingKey, witness) as { proof: BigNumberish[]; publicSignals: BigNumberish[] };
  const timeProofGeneration = Date.now() - startProofGeneration;
  console.log(`Witness calculation time: ${timeWitnessCalculation}ms, Proof generation time: ${timeProofGeneration}ms`);
  const encodedProof = encodeProof(proof);
  return {
    inputCommitments,
    outputCommitments,
    encodedProof
  };
}

module.exports = {
  prepareProof,
};