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
import { ContractTransactionReceipt, Signer, BigNumberish, AddressLike } from 'ethers';
import { expect } from 'chai';
import { loadCircuits, Poseidon, encodeProof, hashTokenUri } from "zk-utxo";
import { groth16 } from 'snarkjs';
import { Merkletree, InMemoryDB, str2Bytes } from '@iden3/js-merkletree';
import RegistryModule from '../ignition/modules/registry';
import zkConfidentialUTXOModule from '../ignition/modules/zkConfidentialUTXO_nf_anon_nullifier';
import { UTXO, User, newUser, newAssetUTXO, newAssetNullifier, doMint, ZERO_UTXO, parseUTXOBranchEvents } from './lib/utils';

describe("zkConfidentialUTXO for non-fungible assets with anonymity using nullifiers without encryption", function () {
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
  let smtAlice: Merkletree;
  let smtBob: Merkletree;

  before(async function () {
    let [d, a, b, c] = await ethers.getSigners();
    deployer = d;
    Alice = await newUser(a);
    Bob = await newUser(b);
    Charlie = await newUser(c);
    const { registry } = await ignition.deploy(RegistryModule);
    ({ zkConfidentialUTXO } = await ignition.deploy(zkConfidentialUTXOModule, { parameters: { zkConfidentialUTXO_NF_Anonymity_Nullifier: { registry: registry.target } } }));

    const tx1 = await registry.connect(deployer).register(Alice.ethAddress, Alice.babyJubPublicKey as [BigNumberish, BigNumberish]);
    await tx1.wait();
    const tx2 = await registry.connect(deployer).register(Bob.ethAddress, Bob.babyJubPublicKey as [BigNumberish, BigNumberish]);
    await tx2.wait();
    const tx3 = await registry.connect(deployer).register(Charlie.ethAddress, Charlie.babyJubPublicKey as [BigNumberish, BigNumberish]);
    await tx3.wait();

    const result = await loadCircuits('nf_anon_nullifier');
    circuit = result.circuit;
    provingKey = result.provingKeyFile;

    const storage1 = new InMemoryDB(str2Bytes(""))
    smtAlice = new Merkletree(storage1, true, 64);

    const storage2 = new InMemoryDB(str2Bytes(""))
    smtBob = new Merkletree(storage2, true, 64);
  });

  it("onchain SMT root should be equal to the offchain SMT root", async function () {
    const root = await smtAlice.root();
    const onchainRoot = await zkConfidentialUTXO.getRoot();
    expect(onchainRoot).to.equal(0n);
    expect(root.string()).to.equal(onchainRoot.toString());
  });

  it("mint to Alice and transfer UTXOs honestly to Bob should succeed", async function () {
    // The authority mints a new UTXO and assigns it to Alice
    const tokenId = 1001;
    const uri = 'http://ipfs.io/file-hash-1';
    utxo1 = newAssetUTXO(tokenId, uri, Alice);
    const result1 = await doMint(zkConfidentialUTXO, deployer, [utxo1]);

    // Alice locally tracks the UTXOs inside the Sparse Merkle Tree
    // hardhat doesn't have a good way to subscribe to events so we have to parse the Tx result object
    const mintEvents = parseUTXOBranchEvents(zkConfidentialUTXO, result1);
    const [_utxo1] = mintEvents[0].outputs;
    await smtAlice.add(_utxo1, _utxo1);
    let root = await smtAlice.root();
    let onchainRoot = await zkConfidentialUTXO.getRoot();
    expect(root.string()).to.equal(onchainRoot.toString());
    // Bob also locally tracks the UTXOs inside the Sparse Merkle Tree
    await smtBob.add(_utxo1, _utxo1);

    // Alice proposes the output UTXOs for the transfer to Bob
    const _utxo3 = newAssetUTXO(tokenId, uri, Bob);

    // Alice generates the nullifiers for the UTXOs to be spent
    const nullifier1 = newAssetNullifier(utxo1, Alice);

    // Alice generates inclusion proofs for the UTXOs to be spent
    const proof1 = await smtAlice.generateCircomVerifierProof(utxo1.hash, root);
    const merkleProof = proof1.siblings.map((s) => s.bigInt());

    // Alice transfers her UTXOs to Bob
    const result2 = await doBranch(Alice, utxo1, nullifier1, _utxo3, root.bigInt(), merkleProof, Bob);

    // Alice locally tracks the UTXOs inside the Sparse Merkle Tree
    await smtAlice.add(_utxo3.hash, _utxo3.hash);
    root = await smtAlice.root();
    onchainRoot = await zkConfidentialUTXO.getRoot();
    expect(root.string()).to.equal(onchainRoot.toString());

    // Bob locally tracks the UTXOs inside the Sparse Merkle Tree
    // Bob parses the UTXOs from the onchain event
    const signerAddress = await Alice.signer.getAddress();
    const events = parseUTXOBranchEvents(zkConfidentialUTXO, result2.txResult!);
    expect(events[0].submitter).to.equal(signerAddress);
    expect(events[0].inputs).to.deep.equal([nullifier1.hash]);
    expect(events[0].outputs).to.deep.equal([_utxo3.hash]);
    await smtBob.add(events[0].outputs[0], events[0].outputs[0]);

    // Bob uses the information received from Alice to reconstruct the UTXO sent to him
    const receivedTokenId = _utxo3.tokenId!;
    const receivedUri = _utxo3.uri!;
    const receivedSalt = _utxo3.salt;
    const incomingUTXOs: any = events[0].outputs;
    const hash = Poseidon.poseidon5([BigInt(receivedTokenId), hashTokenUri(receivedUri), receivedSalt, Bob.babyJubPublicKey[0], Bob.babyJubPublicKey[1]]);
    expect(incomingUTXOs[0]).to.equal(hash);

    // Bob uses the decrypted values to construct the UTXO received from the transaction
    utxo3 = newAssetUTXO(receivedTokenId, receivedUri, Bob, receivedSalt);
  }).timeout(600000);

  it("Bob transfers UTXOs, previously received from Alice, honestly to Charlie should succeed", async function () {
    // Bob generates the nullifiers for the UTXO to be spent
    const nullifier1 = newAssetNullifier(utxo3, Bob);

    // Bob generates inclusion proofs for the UTXOs to be spent, as private input to the proof generation
    const root = await smtBob.root();
    const proof1 = await smtBob.generateCircomVerifierProof(utxo3.hash, root);
    const merkleProof = proof1.siblings.map((s) => s.bigInt());

    // Bob proposes the output UTXOs
    const utxo6 = newAssetUTXO(utxo3.tokenId!, utxo3.uri!, Charlie);

    // Bob should be able to spend the UTXO that was reconstructed from the previous transaction
    const result = await doBranch(Bob, utxo3, nullifier1, utxo6, root.bigInt(), merkleProof, Charlie);

    // Bob keeps the local SMT in sync
    await smtBob.add(utxo6.hash, utxo6.hash);

    // Alice gets the new UTXOs from the onchain event and keeps the local SMT in sync
    const events = parseUTXOBranchEvents(zkConfidentialUTXO, result.txResult!);
    await smtAlice.add(events[0].outputs[0], events[0].outputs[0]);
  }).timeout(600000);

  it("mint existing unspent UTXOs should fail", async function () {
    await expect(doMint(zkConfidentialUTXO, deployer, [utxo3])).rejectedWith("UTXOAlreadyOwned");
  });

  it("mint existing spent UTXOs should fail", async function () {
    await expect(doMint(zkConfidentialUTXO, deployer, [utxo1])).rejectedWith("UTXOAlreadyOwned");
  });

  it("transfer spent UTXOs should fail (double spend protection)", async function () {
    // Alice create outputs in an attempt to send to Charlie an already spent asset
    const _utxo1 = newAssetUTXO(utxo1.tokenId!, utxo1.uri!, Charlie);

    // generate the nullifiers for the UTXOs to be spent
    const nullifier1 = newAssetNullifier(utxo1, Alice);

    // generate inclusion proofs for the UTXOs to be spent
    let root = await smtAlice.root();
    const proof1 = await smtAlice.generateCircomVerifierProof(utxo1.hash, root);
    const merkleProof = proof1.siblings.map((s) => s.bigInt());

    await expect(doBranch(Alice, utxo1, nullifier1, _utxo1, root.bigInt(), merkleProof, Charlie)).rejectedWith("UTXOAlreadySpent")
  }).timeout(600000);

  it("transfer non-existing UTXOs should fail", async function () {
    const nonExisting1 = newAssetUTXO(1002, 'http://ipfs.io/file-hash-2', Alice);

    // add to our local SMT (but they don't exist on the chain)
    await smtAlice.add(nonExisting1.hash, nonExisting1.hash);

    // generate the nullifiers for the UTXOs to be spent
    const nullifier1 = newAssetNullifier(nonExisting1, Alice);

    // generate inclusion proofs for the UTXOs to be spent
    let root = await smtAlice.root();
    const proof1 = await smtAlice.generateCircomVerifierProof(nonExisting1.hash, root);
    const merkleProof = proof1.siblings.map((s) => s.bigInt());

    // propose the output UTXOs
    const _utxo1 = newAssetUTXO(nonExisting1.tokenId!, nonExisting1.uri!, Charlie);

    await expect(doBranch(Alice, nonExisting1, nullifier1, _utxo1, root.bigInt(), merkleProof, Charlie)).rejectedWith("UTXORootNotFound");

    // clean up the fake UTXOs from the local SMT
    await smtAlice.delete(nonExisting1.hash);
  }).timeout(600000);

  async function doBranch(signer: User, input: UTXO, _nullifier: UTXO, output: UTXO, root: BigInt, merkleProof: BigInt[], owner: User) {
    let nullifier: BigNumberish;
    let outputCommitment: BigNumberish;
    let encodedProof: any;
    const result = await prepareProof(signer, input, _nullifier, output, root, merkleProof, owner);
    nullifier = _nullifier.hash as BigNumberish;
    outputCommitment = result.outputCommitment;
    encodedProof = result.encodedProof;

    const txResult = await sendTx(signer, nullifier, outputCommitment, root, encodedProof);
    return { txResult };
  }

  async function prepareProof(signer: User, input: UTXO, _nullifier: UTXO, output: UTXO, root: BigInt, merkleProof: BigInt[], owner: User) {
    const nullifier = _nullifier.hash as BigNumberish;
    const inputCommitment: BigNumberish = input.hash as BigNumberish;
    const tokenId = BigInt(input.tokenId!);
    const tokenUri = hashTokenUri(input.uri!);
    const inputSalt = input.salt!;
    const outputCommitment: BigNumberish = output.hash as BigNumberish;
    const outputSalt = output.salt!;
    const outputOwnerPublicKey: [BigNumberish, BigNumberish] = owner.babyJubPublicKey as [BigNumberish, BigNumberish];

    const startWitnessCalculation = Date.now();
    const inputObj = {
      nullifier,
      inputCommitment,
      tokenId,
      tokenUri,
      inputSalt,
      inputOwnerPrivateKey: signer.formattedPrivateKey,
      root,
      merkleProof,
      outputCommitment,
      outputSalt,
      outputOwnerPublicKey,
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
      inputCommitment,
      outputCommitment,
      encodedProof
    };
  }

  async function sendTx(
    signer: User,
    nullifier: BigNumberish,
    outputCommitment: BigNumberish,
    root: BigNumberish,
    encodedProof: any
  ) {
    const startTx = Date.now();
    const tx = await zkConfidentialUTXO.connect(signer.signer).branch(nullifier, outputCommitment, root, encodedProof);
    const results: ContractTransactionReceipt | null = await tx.wait();
    console.log(`Time to execute transaction: ${Date.now() - startTx}ms. Gas used: ${results?.gasUsed}`);
    return results;
  }
});
