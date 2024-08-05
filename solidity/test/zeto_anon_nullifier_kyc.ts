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
import { loadCircuit, Poseidon, encodeProof, kycHash } from "zeto-js";
import { groth16 } from 'snarkjs';
import { Merkletree, InMemoryDB, str2Bytes } from '@iden3/js-merkletree';
import zetoModule from '../ignition/modules/zeto_anon_nullifier_kyc';
import erc20Module from '../ignition/modules/erc20';
import { UTXO, User, newUser, newUTXO, newNullifier, doMint, ZERO_UTXO, parseUTXOEvents } from './lib/utils';
import { loadProvingKeys, prepareDepositProof, prepareNullifierWithdrawProof } from './utils';

describe("Zeto based fungible token with anonymity, KYC, using nullifiers without encryption", function () {
  let deployer: Signer;
  let Alice: User;
  let Bob: User;
  let Charlie: User;
  let erc20: any;
  let zeto: any;
  let utxo100: UTXO;
  let utxo1: UTXO;
  let utxo2: UTXO;
  let utxo3: UTXO;
  let utxo4: UTXO;
  let utxo7: UTXO;
  let circuit: any, provingKey: any;
  let smtAlice: Merkletree;
  let smtBob: Merkletree;
  let smtKyc: Merkletree;

  before(async function () {
    let [d, a, b, c] = await ethers.getSigners();
    deployer = d;
    Alice = await newUser(a);
    Bob = await newUser(b);
    Charlie = await newUser(c);
    ({ zeto } = await ignition.deploy(zetoModule));
    ({ erc20 } = await ignition.deploy(erc20Module));
    const tx1 = await zeto.connect(deployer).setERC20(erc20.target);
    await tx1.wait();

    const tx2 = await zeto.connect(deployer).register(Alice.babyJubPublicKey);
    await tx2.wait();
    const tx3 = await zeto.connect(deployer).register(Bob.babyJubPublicKey);
    await tx3.wait();
    const tx4 = await zeto.connect(deployer).register(Charlie.babyJubPublicKey);
    await tx4.wait();

    circuit = await loadCircuit('anon_nullifier_kyc');
    ({ provingKeyFile: provingKey } = loadProvingKeys('anon_nullifier_kyc'));

    const storage1 = new InMemoryDB(str2Bytes(""))
    smtAlice = new Merkletree(storage1, true, 64);

    const storage2 = new InMemoryDB(str2Bytes(""))
    smtBob = new Merkletree(storage2, true, 64);

    const storage3 = new InMemoryDB(str2Bytes(""))
    smtKyc = new Merkletree(storage3, true, 10);
    await smtKyc.add(kycHash(Alice.babyJubPublicKey), kycHash(Alice.babyJubPublicKey));
    await smtKyc.add(kycHash(Bob.babyJubPublicKey), kycHash(Bob.babyJubPublicKey));
    await smtKyc.add(kycHash(Charlie.babyJubPublicKey), kycHash(Charlie.babyJubPublicKey));
  });

  it("onchain SMT root should be equal to the offchain SMT root", async function () {
    const root = await smtAlice.root();
    const onchainRoot = await zeto.getRoot();
    expect(onchainRoot).to.equal(0n);
    expect(root.string()).to.equal(onchainRoot.toString());
  });

  it("mint ERC20 tokens to Alice to deposit to Zeto should succeed", async function () {
    const tx = await erc20.connect(deployer).mint(Alice.ethAddress, 100);
    await tx.wait();
    const balance = await erc20.balanceOf(Alice.ethAddress);
    expect(balance).to.equal(100);

    const tx1 = await erc20.connect(Alice.signer).approve(zeto.target, 100);
    await tx1.wait();

    utxo100 = newUTXO(100, Alice);
    const { outputCommitments, encodedProof } = await prepareDepositProof(Alice, utxo100);
    const tx2 = await zeto.connect(Alice.signer).deposit(100, outputCommitments[0], encodedProof);
    await tx2.wait();

    await smtAlice.add(utxo100.hash, utxo100.hash);
    await smtBob.add(utxo100.hash, utxo100.hash);
  });

  it("mint to Alice and transfer UTXOs honestly to Bob should succeed", async function () {
    // The authority mints a new UTXO and assigns it to Alice
    utxo1 = newUTXO(10, Alice);
    utxo2 = newUTXO(20, Alice);
    const result1 = await doMint(zeto, deployer, [utxo1, utxo2]);

    // Alice locally tracks the UTXOs inside the Sparse Merkle Tree
    // hardhat doesn't have a good way to subscribe to events so we have to parse the Tx result object
    const mintEvents = parseUTXOEvents(zeto, result1);
    const [_utxo1, _utxo2] = mintEvents[0].outputs;
    await smtAlice.add(_utxo1, _utxo1);
    await smtAlice.add(_utxo2, _utxo2);
    let utxosRoot = await smtAlice.root();
    let onchainRoot = await zeto.getRoot();
    expect(utxosRoot.string()).to.equal(onchainRoot.toString());
    // Bob also locally tracks the UTXOs inside the Sparse Merkle Tree
    await smtBob.add(_utxo1, _utxo1);
    await smtBob.add(_utxo2, _utxo2);

    // Alice proposes the output UTXOs for the transfer to Bob
    const _utxo3 = newUTXO(25, Bob);
    utxo4 = newUTXO(5, Alice);

    // Alice generates the nullifiers for the UTXOs to be spent
    const nullifier1 = newNullifier(utxo1, Alice);
    const nullifier2 = newNullifier(utxo2, Alice);

    // Alice generates inclusion proofs for the UTXOs to be spent
    const proof1 = await smtAlice.generateCircomVerifierProof(utxo1.hash, utxosRoot);
    const proof2 = await smtAlice.generateCircomVerifierProof(utxo2.hash, utxosRoot);
    const utxoMerkleProofs = [proof1.siblings.map((s) => s.bigInt()), proof2.siblings.map((s) => s.bigInt())];

    // Alice generates inclusion proofs for the identities in the transaction
    const identitiesRoot = await smtKyc.root();
    const proof3 = await smtKyc.generateCircomVerifierProof(kycHash(Alice.babyJubPublicKey), identitiesRoot);
    const proof4 = await smtKyc.generateCircomVerifierProof(kycHash(Bob.babyJubPublicKey), identitiesRoot);
    const identityMerkleProofs = [
      proof3.siblings.map((s) => s.bigInt()), // identity proof for the sender (Alice)
      proof4.siblings.map((s) => s.bigInt()), // identity proof for the 1st owner of the output UTXO (Bob)
      proof3.siblings.map((s) => s.bigInt())  // identity proof for the 2nd owner of the output UTXO (Alice)
    ];

    // Alice transfers her UTXOs to Bob
    const result2 = await doTransfer(Alice, [utxo1, utxo2], [nullifier1, nullifier2], [_utxo3, utxo4], utxosRoot.bigInt(), utxoMerkleProofs, identitiesRoot.bigInt(), identityMerkleProofs, [Bob, Alice]);

    // Alice locally tracks the UTXOs inside the Sparse Merkle Tree
    await smtAlice.add(_utxo3.hash, _utxo3.hash);
    await smtAlice.add(utxo4.hash, utxo4.hash);
    utxosRoot = await smtAlice.root();
    onchainRoot = await zeto.getRoot();
    expect(utxosRoot.string()).to.equal(onchainRoot.toString());

    // Bob locally tracks the UTXOs inside the Sparse Merkle Tree
    // Bob parses the UTXOs from the onchain event
    const signerAddress = await Alice.signer.getAddress();
    const events = parseUTXOEvents(zeto, result2.txResult!);
    expect(events[0].submitter).to.equal(signerAddress);
    expect(events[0].inputs).to.deep.equal([nullifier1.hash, nullifier2.hash]);
    expect(events[0].outputs).to.deep.equal([_utxo3.hash, utxo4.hash]);
    await smtBob.add(events[0].outputs[0], events[0].outputs[0]);
    await smtBob.add(events[0].outputs[1], events[0].outputs[1]);

    // Bob uses the information received from Alice to reconstruct the UTXO sent to him
    const receivedValue = _utxo3.value!;
    const receivedSalt = _utxo3.salt;
    const incomingUTXOs: any = events[0].outputs;
    const hash = Poseidon.poseidon4([BigInt(receivedValue), receivedSalt, Bob.babyJubPublicKey[0], Bob.babyJubPublicKey[1]]);
    expect(incomingUTXOs[0]).to.equal(hash);

    // Bob uses the decrypted values to construct the UTXO received from the transaction
    utxo3 = newUTXO(receivedValue, Bob, receivedSalt);
  }).timeout(600000);

  it("Bob transfers UTXOs, previously received from Alice, honestly to Charlie should succeed", async function () {
    // Bob generates the nullifiers for the UTXO to be spent
    const nullifier1 = newNullifier(utxo3, Bob);

    // Bob generates inclusion proofs for the UTXOs to be spent, as private input to the proof generation
    const utxosRoot = await smtBob.root();
    const proof1 = await smtBob.generateCircomVerifierProof(utxo3.hash, utxosRoot);
    const proof2 = await smtBob.generateCircomVerifierProof(0n, utxosRoot);
    const utxosMerkleProofs = [proof1.siblings.map((s) => s.bigInt()), proof2.siblings.map((s) => s.bigInt())];

    // Bob proposes the output UTXOs
    const utxo6 = newUTXO(10, Charlie);
    utxo7 = newUTXO(15, Bob);

    // Bob generates inclusion proofs for the identities in the transaction
    // using a shortcut with a shared SMT for all identities, but obviously
    // Bob would need his own SMT instance in a real-world scenario
    const identitiesRoot = await smtKyc.root();
    const proof3 = await smtKyc.generateCircomVerifierProof(kycHash(Bob.babyJubPublicKey), identitiesRoot);
    const proof4 = await smtKyc.generateCircomVerifierProof(kycHash(Charlie.babyJubPublicKey), identitiesRoot);
    const identitiesMerkleProofs = [
      proof3.siblings.map((s) => s.bigInt()), // identity proof for the sender (Bob)
      proof4.siblings.map((s) => s.bigInt()), // identity proof for the 1st owner of the output UTXO (Charlie)
      proof3.siblings.map((s) => s.bigInt())  // identity proof for the 2nd owner of the output UTXO (Bob)
    ];

    // Bob should be able to spend the UTXO that was reconstructed from the previous transaction
    const result = await doTransfer(Bob, [utxo3, ZERO_UTXO], [nullifier1, ZERO_UTXO], [utxo6, utxo7], utxosRoot.bigInt(), utxosMerkleProofs, identitiesRoot.bigInt(), identitiesMerkleProofs, [Charlie, Bob]);

    // Bob keeps the local SMT in sync
    await smtBob.add(utxo6.hash, utxo6.hash);
    await smtBob.add(utxo7.hash, utxo7.hash);

    // Alice gets the new UTXOs from the onchain event and keeps the local SMT in sync
    const events = parseUTXOEvents(zeto, result.txResult!);
    await smtAlice.add(events[0].outputs[0], events[0].outputs[0]);
    await smtAlice.add(events[0].outputs[1], events[0].outputs[1]);
  }).timeout(600000);

  it("Alice withdraws her UTXOs to ERC20 tokens should succeed", async function () {
    // Alice generates the nullifiers for the UTXOs to be spent
    const nullifier1 = newNullifier(utxo100, Alice);

    // Alice generates inclusion proofs for the UTXOs to be spent
    let root = await smtAlice.root();
    const proof1 = await smtAlice.generateCircomVerifierProof(utxo100.hash, root);
    const proof2 = await smtAlice.generateCircomVerifierProof(0n, root);
    const merkleProofs = [proof1.siblings.map((s) => s.bigInt()), proof2.siblings.map((s) => s.bigInt())];

    // Alice proposes the output ERC20 tokens
    const outputCommitment = newUTXO(20, Alice);

    const { nullifiers, outputCommitments, encodedProof } = await prepareNullifierWithdrawProof(Alice, [utxo100, ZERO_UTXO], [nullifier1, ZERO_UTXO], outputCommitment, root.bigInt(), merkleProofs);

    // Alice withdraws her UTXOs to ERC20 tokens
    const tx = await zeto.connect(Alice.signer).withdraw(80, nullifiers, outputCommitments[0], root.bigInt(), encodedProof);
    await tx.wait();

    // Alice checks her ERC20 balance
    const balance = await erc20.balanceOf(Alice.ethAddress);
    expect(balance).to.equal(80);
  });

  it("mint existing unspent UTXOs should fail", async function () {
    await expect(doMint(zeto, deployer, [utxo4])).rejectedWith("UTXOAlreadyOwned");
  });

  it("mint existing spent UTXOs should fail", async function () {
    await expect(doMint(zeto, deployer, [utxo1])).rejectedWith("UTXOAlreadyOwned");
  });

  it("transfer spent UTXOs should fail (double spend protection)", async function () {
    // create outputs
    const _utxo1 = newUTXO(25, Bob);
    const _utxo2 = newUTXO(5, Alice);

    // generate the nullifiers for the UTXOs to be spent
    const nullifier1 = newNullifier(utxo1, Alice);
    const nullifier2 = newNullifier(utxo2, Alice);

    // generate inclusion proofs for the UTXOs to be spent
    let root = await smtAlice.root();
    const proof1 = await smtAlice.generateCircomVerifierProof(utxo1.hash, root);
    const proof2 = await smtAlice.generateCircomVerifierProof(utxo2.hash, root);
    const merkleProofs = [proof1.siblings.map((s) => s.bigInt()), proof2.siblings.map((s) => s.bigInt())];

    const identitiesRoot = await smtKyc.root();
    const proof3 = await smtKyc.generateCircomVerifierProof(kycHash(Alice.babyJubPublicKey), identitiesRoot);
    const proof4 = await smtKyc.generateCircomVerifierProof(kycHash(Bob.babyJubPublicKey), identitiesRoot);
    const identitiesMerkleProofs = [
      proof3.siblings.map((s) => s.bigInt()), // identity proof for the sender (Alice)
      proof4.siblings.map((s) => s.bigInt()), // identity proof for the 1st owner of the output UTXO (Bob)
      proof3.siblings.map((s) => s.bigInt())  // identity proof for the 2nd owner of the output UTXO (Alice)
    ];

    await expect(doTransfer(Alice, [utxo1, utxo2], [nullifier1, nullifier2], [_utxo1, _utxo2], root.bigInt(), merkleProofs, identitiesRoot.bigInt(), identitiesMerkleProofs, [Bob, Alice])).rejectedWith("UTXOAlreadySpent")
  }).timeout(600000);

  it("transfer with existing UTXOs in the output should fail (mass conservation protection)", async function () {
    // give Bob another UTXO to be able to spend
    const _utxo1 = newUTXO(15, Bob);
    await doMint(zeto, deployer, [_utxo1]);
    await smtBob.add(_utxo1.hash, _utxo1.hash);

    const nullifier1 = newNullifier(utxo7, Bob);
    const nullifier2 = newNullifier(_utxo1, Bob);
    let root = await smtBob.root();
    const proof1 = await smtBob.generateCircomVerifierProof(utxo7.hash, root);
    const proof2 = await smtBob.generateCircomVerifierProof(_utxo1.hash, root);
    const merkleProofs = [proof1.siblings.map((s) => s.bigInt()), proof2.siblings.map((s) => s.bigInt())];

    const identitiesRoot = await smtKyc.root();
    const proof3 = await smtKyc.generateCircomVerifierProof(kycHash(Bob.babyJubPublicKey), identitiesRoot);
    const proof4 = await smtKyc.generateCircomVerifierProof(kycHash(Alice.babyJubPublicKey), identitiesRoot);
    const identitiesMerkleProofs = [
      proof3.siblings.map((s) => s.bigInt()), // identity proof for the sender (Bob)
      proof4.siblings.map((s) => s.bigInt()), // identity proof for the 1st owner of the output UTXO (Alice)
      proof4.siblings.map((s) => s.bigInt())  // identity proof for the 2nd owner of the output UTXO (Alice)
    ];

    await expect(doTransfer(Bob, [utxo7, _utxo1], [nullifier1, nullifier2], [utxo1, utxo2], root.bigInt(), merkleProofs, identitiesRoot.bigInt(), identitiesMerkleProofs, [Alice, Alice])).rejectedWith("UTXOAlreadyOwned")
  }).timeout(600000);

  it("spend by using the same UTXO as both inputs should fail", async function () {
    const _utxo1 = newUTXO(20, Alice);
    const _utxo2 = newUTXO(10, Bob);
    const nullifier1 = newNullifier(utxo7, Bob);
    const nullifier2 = newNullifier(utxo7, Bob);
    // generate inclusion proofs for the UTXOs to be spent
    let root = await smtBob.root();
    const proof1 = await smtBob.generateCircomVerifierProof(utxo7.hash, root);
    const proof2 = await smtBob.generateCircomVerifierProof(utxo7.hash, root);
    const merkleProofs = [proof1.siblings.map((s) => s.bigInt()), proof2.siblings.map((s) => s.bigInt())];

    const identitiesRoot = await smtKyc.root();
    const proof3 = await smtKyc.generateCircomVerifierProof(kycHash(Bob.babyJubPublicKey), identitiesRoot);
    const proof4 = await smtKyc.generateCircomVerifierProof(kycHash(Alice.babyJubPublicKey), identitiesRoot);
    const identitiesMerkleProofs = [
      proof3.siblings.map((s) => s.bigInt()), // identity proof for the sender (Bob)
      proof4.siblings.map((s) => s.bigInt()), // identity proof for the 1st owner of the output UTXO (Alice)
      proof3.siblings.map((s) => s.bigInt())  // identity proof for the 2nd owner of the output UTXO (Bob)
    ];

    await expect(doTransfer(Bob, [utxo7, utxo7], [nullifier1, nullifier2], [_utxo1, _utxo2], root.bigInt(), merkleProofs, identitiesRoot.bigInt(), identitiesMerkleProofs, [Alice, Bob])).rejectedWith(`UTXODuplicate`);
  }).timeout(600000);

  it("transfer non-existing UTXOs should fail", async function () {
    const nonExisting1 = newUTXO(25, Alice);
    const nonExisting2 = newUTXO(20, Alice, nonExisting1.salt);

    // add to our local SMT (but they don't exist on the chain)
    await smtAlice.add(nonExisting1.hash, nonExisting1.hash);
    await smtAlice.add(nonExisting2.hash, nonExisting2.hash);

    // generate the nullifiers for the UTXOs to be spent
    const nullifier1 = newNullifier(nonExisting1, Alice);
    const nullifier2 = newNullifier(nonExisting2, Alice);

    // generate inclusion proofs for the UTXOs to be spent
    let root = await smtAlice.root();
    const proof1 = await smtAlice.generateCircomVerifierProof(nonExisting1.hash, root);
    const proof2 = await smtAlice.generateCircomVerifierProof(nonExisting2.hash, root);
    const merkleProofs = [proof1.siblings.map((s) => s.bigInt()), proof2.siblings.map((s) => s.bigInt())];

    // propose the output UTXOs
    const _utxo1 = newUTXO(30, Charlie);
    utxo7 = newUTXO(15, Bob);

    const identitiesRoot = await smtKyc.root();
    const proof3 = await smtKyc.generateCircomVerifierProof(kycHash(Alice.babyJubPublicKey), identitiesRoot);
    const proof4 = await smtKyc.generateCircomVerifierProof(kycHash(Bob.babyJubPublicKey), identitiesRoot);
    const proof5 = await smtKyc.generateCircomVerifierProof(kycHash(Charlie.babyJubPublicKey), identitiesRoot);
    const identitiesMerkleProofs = [
      proof3.siblings.map((s) => s.bigInt()), // identity proof for the sender (Alice)
      proof4.siblings.map((s) => s.bigInt()), // identity proof for the 1st owner of the output UTXO (Bob)
      proof5.siblings.map((s) => s.bigInt())  // identity proof for the 2nd owner of the output UTXO (Charlie)
    ];

    await expect(doTransfer(Alice, [nonExisting1, nonExisting2], [nullifier1, nullifier2], [utxo7, _utxo1], root.bigInt(), merkleProofs, identitiesRoot.bigInt(), identitiesMerkleProofs, [Bob, Charlie])).rejectedWith("UTXORootNotFound");

    // clean up the fake UTXOs from the local SMT
    await smtAlice.delete(nonExisting1.hash);
    await smtAlice.delete(nonExisting2.hash);
  }).timeout(600000);

  async function doTransfer(signer: User, inputs: UTXO[], _nullifiers: UTXO[], outputs: UTXO[], utxosRoot: BigInt, utxosMerkleProofs: BigInt[][], identitiesRoot: BigInt, identitiesMerkleProof: BigInt[][], owners: User[]) {
    let nullifiers: [BigNumberish, BigNumberish];
    let outputCommitments: [BigNumberish, BigNumberish];
    let encodedProof: any;
    const result = await prepareProof(signer, inputs, _nullifiers, outputs, utxosRoot, utxosMerkleProofs, identitiesRoot, identitiesMerkleProof, owners);
    nullifiers = _nullifiers.map((nullifier) => nullifier.hash) as [BigNumberish, BigNumberish];
    outputCommitments = result.outputCommitments;
    encodedProof = result.encodedProof;

    const txResult = await sendTx(signer, nullifiers, outputCommitments, utxosRoot, encodedProof);
    // add the clear text value so that it can be used by tests to compare with the decrypted value
    return { txResult, plainTextSalt: outputs[0].salt };
  }

  async function prepareProof(signer: User, inputs: UTXO[], _nullifiers: UTXO[], outputs: UTXO[], utxosRoot: BigInt, utxosMerkleProof: BigInt[][], identitiesRoot: BigInt, identitiesMerkleProof: BigInt[][], owners: User[]) {
    const nullifiers = _nullifiers.map((nullifier) => nullifier.hash) as [BigNumberish, BigNumberish];
    const inputCommitments: [BigNumberish, BigNumberish] = inputs.map((input) => input.hash) as [BigNumberish, BigNumberish];
    const inputValues = inputs.map((input) => BigInt(input.value || 0n));
    const inputSalts = inputs.map((input) => input.salt || 0n);
    const outputCommitments: [BigNumberish, BigNumberish] = outputs.map((output) => output.hash) as [BigNumberish, BigNumberish];
    const outputValues = outputs.map((output) => BigInt(output.value || 0n));
    const outputOwnerPublicKeys: [[BigNumberish, BigNumberish], [BigNumberish, BigNumberish]] = owners.map(owner => owner.babyJubPublicKey) as [[BigNumberish, BigNumberish], [BigNumberish, BigNumberish]];

    const startWitnessCalculation = Date.now();
    const inputObj = {
      nullifiers,
      inputCommitments,
      inputValues,
      inputSalts,
      inputOwnerPrivateKey: signer.formattedPrivateKey,
      utxosRoot,
      enabled: [nullifiers[0] !== 0n ? 1 : 0, nullifiers[1] !== 0n ? 1 : 0],
      utxosMerkleProof,
      identitiesRoot,
      identitiesMerkleProof,
      outputCommitments,
      outputValues,
      outputSalts: outputs.map((output) => output.salt),
      outputOwnerPublicKeys,
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
      inputCommitments,
      outputCommitments,
      encodedProof
    };
  }

  async function sendTx(
    signer: User,
    nullifiers: [BigNumberish, BigNumberish],
    outputCommitments: [BigNumberish, BigNumberish],
    root: BigNumberish,
    encodedProof: any
  ) {
    const startTx = Date.now();
    const tx = await zeto.connect(signer.signer).transfer(nullifiers, outputCommitments, root, encodedProof);
    const results: ContractTransactionReceipt | null = await tx.wait();
    console.log(`Time to execute transaction: ${Date.now() - startTx}ms. Gas used: ${results?.gasUsed}`);
    return results;
  }
});
