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

import { ethers, network } from "hardhat";
import { ContractTransactionReceipt, Signer, BigNumberish, lock } from "ethers";
import { expect } from "chai";
import { loadCircuit, Poseidon, encodeProof } from "zeto-js";
import { groth16 } from "snarkjs";
import { Merkletree, InMemoryDB, str2Bytes } from "@iden3/js-merkletree";
import {
  UTXO,
  User,
  newUser,
  newUTXO,
  newNullifier,
  doMint,
  ZERO_UTXO,
  parseUTXOEvents,
} from "./lib/utils";
import {
  loadProvingKeys,
  prepareDepositProof,
  prepareNullifierWithdrawProof,
} from "./utils";
import { deployZeto } from "./lib/deploy";

describe("Zeto based fungible token with anonymity using nullifiers with Kyber encryption for auditability", function () {
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
  let utxo9: UTXO;
  let circuit: any, provingKey: any;
  let circuitForLocked: any, provingKeyForLocked: any;
  let batchCircuit: any, batchProvingKey: any;
  let smtAlice: Merkletree;
  let smtBob: Merkletree;

  before(async function () {
    if (network.name !== "hardhat") {
      // accommodate for longer block times on public networks
      this.timeout(120000);
    }

    let [d, a, b, c] = await ethers.getSigners();
    deployer = d;
    Alice = await newUser(a);
    Bob = await newUser(b);
    Charlie = await newUser(c);

    ({ deployer, zeto, erc20 } = await deployZeto("Zeto_AnonNullifierQurrency"));

    const storage1 = new InMemoryDB(str2Bytes(""));
    smtAlice = new Merkletree(storage1, true, 64);

    const storage2 = new InMemoryDB(str2Bytes(""));
    smtBob = new Merkletree(storage2, true, 64);

    circuit = await loadCircuit("anon_nullifier_qurrency_transfer");
    ({ provingKeyFile: provingKey } = loadProvingKeys(
      "anon_nullifier_qurrency_transfer",
    ));
  });

  it("onchain SMT root should be equal to the offchain SMT root", async function () {
    const root = await smtAlice.root();
    const onchainRoot = await zeto.getRoot();
    expect(onchainRoot).to.equal(0n);
    expect(root.string()).to.equal(onchainRoot.toString());
  });

  it("mint ERC20 tokens to Alice to deposit to Zeto should succeed", async function () {
    const startingBalance = await erc20.balanceOf(Alice.ethAddress);
    const tx = await erc20.connect(deployer).mint(Alice.ethAddress, 100);
    await tx.wait();
    const endingBalance = await erc20.balanceOf(Alice.ethAddress);
    expect(endingBalance - startingBalance).to.be.equal(100);

    const tx1 = await erc20.connect(Alice.signer).approve(zeto.target, 100);
    await tx1.wait();

    utxo100 = newUTXO(100, Alice);
    const utxo0 = newUTXO(0, Alice);
    const { outputCommitments, encodedProof } = await prepareDepositProof(
      Alice,
      [utxo0, utxo100],
    );
    const tx2 = await zeto
      .connect(Alice.signer)
      .deposit(100, outputCommitments, encodedProof, "0x");
    await tx2.wait();

    await smtAlice.add(utxo100.hash, utxo100.hash);
    await smtAlice.add(utxo0.hash, utxo0.hash);
    await smtBob.add(utxo100.hash, utxo100.hash);
    await smtBob.add(utxo0.hash, utxo0.hash);
  });

  it("mint to Alice and transfer UTXOs honestly to Bob should succeed", async function () {
    const startingBalance = await erc20.balanceOf(Alice.ethAddress);
    // The authority mints a new UTXO and assigns it to Alice
    utxo1 = newUTXO(10, Alice);
    utxo2 = newUTXO(20, Alice);
    const result1 = await doMint(zeto, deployer, [utxo1, utxo2]);

    // check the private mint activity is not exposed in the ERC20 contract
    const afterMintBalance = await erc20.balanceOf(Alice.ethAddress);
    expect(afterMintBalance).to.equal(startingBalance);

    // Alice locally tracks the UTXOs inside the Sparse Merkle Tree
    // hardhat doesn't have a good way to subscribe to events so we have to parse the Tx result object
    const mintEvents = parseUTXOEvents(zeto, result1);
    const [_utxo1, _utxo2] = mintEvents[0].outputs;
    await smtAlice.add(_utxo1, _utxo1);
    await smtAlice.add(_utxo2, _utxo2);
    let root = await smtAlice.root();
    let onchainRoot = await zeto.getRoot();
    expect(root.string()).to.equal(onchainRoot.toString());
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
    const proof1 = await smtAlice.generateCircomVerifierProof(utxo1.hash, root);
    const proof2 = await smtAlice.generateCircomVerifierProof(utxo2.hash, root);
    const merkleProofs = [
      proof1.siblings.map((s) => s.bigInt()),
      proof2.siblings.map((s) => s.bigInt()),
    ];

    // Alice transfers her UTXOs to Bob
    const result2 = await doTransfer(
      Alice,
      [utxo1, utxo2],
      [nullifier1, nullifier2],
      [_utxo3, utxo4],
      root.bigInt(),
      merkleProofs,
      [Bob, Alice],
    );

    // check the private transfer activity is not exposed in the ERC20 contract
    const afterTransferBalance = await erc20.balanceOf(Alice.ethAddress);
    expect(afterTransferBalance).to.equal(startingBalance);

    // Alice locally tracks the UTXOs inside the Sparse Merkle Tree
    await smtAlice.add(_utxo3.hash, _utxo3.hash);
    await smtAlice.add(utxo4.hash, utxo4.hash);
    root = await smtAlice.root();
    onchainRoot = await zeto.getRoot();
    expect(root.string()).to.equal(onchainRoot.toString());

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
    const hash = Poseidon.poseidon4([
      BigInt(receivedValue),
      receivedSalt,
      Bob.babyJubPublicKey[0],
      Bob.babyJubPublicKey[1],
    ]);
    expect(incomingUTXOs[0]).to.equal(hash);

    // Bob uses the decrypted values to construct the UTXO received from the transaction
    utxo3 = newUTXO(receivedValue, Bob, receivedSalt);
  }).timeout(600000);

  // describe("lock() tests", function () {
  //   let lockedUtxo1: UTXO;
  //   let smtBobForLocked: Merkletree;
  //   let utxo10: UTXO;
  //   let utxo11: UTXO;
  //   let utxo12: UTXO;

  //   before(async function () {
  //     const storage1 = new InMemoryDB(str2Bytes(""));
  //     smtBobForLocked = new Merkletree(storage1, true, 64);

  //     // mint a UTXO for Bob and spend it (to use it in a failure case test)
  //     utxo12 = newUTXO(1, Alice);
  //     await doMint(zeto, deployer, [utxo12]);
  //     await smtAlice.add(utxo12.hash, utxo12.hash);
  //     await smtBob.add(utxo12.hash, utxo12.hash);

  //     const _utxo1 = newUTXO(1, Bob);
  //     const nullifier1 = newNullifier(utxo12, Alice);
  //     let root = await smtAlice.root();
  //     const proof1 = await smtAlice.generateCircomVerifierProof(utxo12.hash, root);
  //     const proof2 = await smtAlice.generateCircomVerifierProof(utxo12.hash, root);
  //     const merkleProofs = [
  //       proof1.siblings.map((s) => s.bigInt()),
  //       proof2.siblings.map((s) => s.bigInt()),
  //     ];

  //     await doTransfer(
  //       Alice,
  //       [utxo12, ZERO_UTXO],
  //       [nullifier1, ZERO_UTXO],
  //       [_utxo1, ZERO_UTXO],
  //       root.bigInt(),
  //       merkleProofs,
  //       [Bob, Alice],
  //     );
  //     await smtAlice.add(_utxo1.hash, _utxo1.hash);
  //     await smtBob.add(_utxo1.hash, _utxo1.hash);
  //   });

  //   describe("lock -> transfer flow", function () {
  //     it("lock() should succeed when using unlocked states", async function () {
  //       const nullifier1 = newNullifier(utxo7, Bob);
  //       lockedUtxo1 = newUTXO(utxo7.value!, Bob);
  //       const root = await smtBob.root();
  //       const proof1 = await smtBob.generateCircomVerifierProof(
  //         utxo7.hash,
  //         root,
  //       );
  //       const proof2 = await smtBob.generateCircomVerifierProof(0n, root);
  //       const merkleProofs = [
  //         proof1.siblings.map((s) => s.bigInt()),
  //         proof2.siblings.map((s) => s.bigInt()),
  //       ];
  //       const { outputCommitments, encodedProof } = await prepareProof(
  //         circuit,
  //         provingKey,
  //         Bob,
  //         [utxo7, ZERO_UTXO],
  //         [nullifier1, ZERO_UTXO],
  //         [lockedUtxo1, ZERO_UTXO],
  //         root.bigInt(),
  //         merkleProofs,
  //         [Bob, Bob],
  //       );

  //       const tx = await zeto.connect(Bob.signer).lock(
  //         [nullifier1.hash],
  //         [],
  //         outputCommitments,
  //         root.bigInt(),
  //         encodedProof,
  //         Alice.ethAddress, // make Alice the delegate who can spend the state (if she has the right proof)
  //         "0x",
  //       );
  //       const result: ContractTransactionReceipt | null = await tx.wait();

  //       // Note that the locked UTXO should NOT be added to the local SMT for UTXOs because it's tracked in a separate SMT onchain
  //       // we add it to the local SMT for locked UTXOs
  //       const events = parseUTXOEvents(zeto, result!);
  //       await smtBobForLocked.add(
  //         events[0].lockedOutputs[0],
  //         ethers.toBigInt(events[0].delegate),
  //       );
  //     });

  //     it("onchain SMT root for the locked UTXOs should be equal to the offchain SMT root", async function () {
  //       const root = await smtBobForLocked.root();
  //       const onchainRoot = await zeto.getRootForLocked();
  //       expect(root.string()).to.equal(onchainRoot.toString());
  //     });

  //     it("the designated delegate can use the proper proof to spend the locked state", async function () {
  //       // Bob generates inclusion proofs for the UTXOs to be spent, as private input to the proof generation
  //       const nullifier1 = newNullifier(lockedUtxo1, Bob);
  //       const root = await smtBobForLocked.root();
  //       const proof1 = await smtBobForLocked.generateCircomVerifierProof(
  //         lockedUtxo1.hash,
  //         root,
  //       );
  //       const proof2 = await smtBobForLocked.generateCircomVerifierProof(
  //         0n,
  //         root,
  //       );
  //       const merkleProofs = [
  //         proof1.siblings.map((s) => s.bigInt()),
  //         proof2.siblings.map((s) => s.bigInt()),
  //       ];
  //       // Bob proposes the output UTXOs, attempting to transfer the locked UTXO to Alice
  //       utxo9 = newUTXO(10, Alice);
  //       utxo10 = newUTXO(5, Bob);

  //       const result = await prepareProof(
  //         circuitForLocked,
  //         provingKeyForLocked,
  //         Bob,
  //         [lockedUtxo1, ZERO_UTXO],
  //         [nullifier1, ZERO_UTXO],
  //         [utxo9, utxo10],
  //         root.bigInt(),
  //         merkleProofs,
  //         [Alice, Bob],
  //         Alice.ethAddress, // current lock delegate
  //       );
  //       const nullifiers = [nullifier1.hash];

  //       // Alice (in reality this is usually a contract that orchestrates a trade flow) can spend the locked state
  //       // using the proof generated by the trade counterparty (Bob in this case)
  //       await expect(
  //         sendTx(
  //           Alice,
  //           nullifiers,
  //           result.outputCommitments,
  //           root.bigInt(),
  //           result.encodedProof,
  //           true,
  //         ),
  //       ).to.be.fulfilled;

  //       // Alice and Bob keep the local SMT in sync
  //       await smtAlice.add(utxo9.hash, utxo9.hash);
  //       await smtAlice.add(utxo10.hash, utxo10.hash);
  //       await smtBob.add(utxo9.hash, utxo9.hash);
  //       await smtBob.add(utxo10.hash, utxo10.hash);
  //     });

  //     it("onchain SMT root for the locked UTXOs should be equal to the offchain SMT root", async function () {
  //       const root = await smtBobForLocked.root();
  //       const onchainRoot = await zeto.getRootForLocked();
  //       expect(root.string()).to.equal(onchainRoot.toString());
  //     });

  //     it("onchain SMT root for the unlocked UTXOs should be equal to the offchain SMT root", async function () {
  //       const root = await smtBob.root();
  //       const onchainRoot = await zeto.getRoot();
  //       expect(root.string()).to.equal(onchainRoot.toString());
  //     });
  //   });
  // });

  async function doTransfer(
    signer: User,
    inputs: UTXO[],
    _nullifiers: UTXO[],
    outputs: UTXO[],
    root: BigInt,
    merkleProofs: BigInt[][],
    owners: User[],
    lockDelegate?: User,
  ) {
    let nullifiers: BigNumberish[];
    let outputCommitments: BigNumberish[];
    let encodedProof: any;
    const circuitToUse = lockDelegate
      ? circuitForLocked
      : inputs.length > 2
        ? batchCircuit
        : circuit;
    const provingKeyToUse = lockDelegate
      ? provingKeyForLocked
      : inputs.length > 2
        ? batchProvingKey
        : provingKey;
    const result = await prepareProof(
      circuitToUse,
      provingKeyToUse,
      signer,
      inputs,
      _nullifiers,
      outputs,
      root,
      merkleProofs,
      owners,
      lockDelegate?.ethAddress,
    );
    nullifiers = _nullifiers.map(
      (nullifier) => nullifier.hash,
    ) as BigNumberish[];
    outputCommitments = result.outputCommitments;
    encodedProof = result.encodedProof;

    const txResult = await sendTx(
      signer,
      nullifiers,
      outputCommitments,
      root,
      encodedProof,
      lockDelegate !== undefined,
    );
    // add the clear text value so that it can be used by tests to compare with the decrypted value
    return {
      txResult,
      expectedPlainText: outputs.reduce((acc, o, i) => {
        acc.push(BigInt(o.value || 0n) as BigNumberish);
        acc.push((o.salt || 0n) as BigNumberish);
        return acc;
      }, [] as BigNumberish[]),
    };
  }

  async function sendTx(
    signer: User,
    nullifiers: BigNumberish[],
    outputCommitments: BigNumberish[],
    root: BigNumberish,
    encodedProof: any,
    isLocked: boolean = false,
  ) {
    // TODO: get the ciphertext from the witness object
    const hack = [153, 180, 68, 235, 189, 233, 191, 4, 236, 89, 22, 35, 178, 239, 102, 163, 71, 123, 55, 19, 165, 82, 197, 168, 222, 159, 54, 198, 122, 202, 46, 61, 71, 249, 202, 155, 165, 186, 117, 41, 235, 141, 35, 149, 53, 129, 42, 95, 212, 128, 192, 80, 112, 120, 127, 192, 205, 189, 251, 33, 173, 173, 209, 111, 0, 208, 195, 74, 118, 98, 48, 178, 40, 203, 127, 185, 133, 93, 106, 112, 154, 50, 56, 184, 51, 20, 48, 2, 153, 106, 230, 56, 31, 252, 43, 23, 133, 140, 101, 183, 92, 250, 234, 28, 192, 208, 54, 250, 254, 120, 214, 74, 140, 53, 236, 105, 36, 182, 61, 100, 161, 226, 69, 83, 148, 134, 252, 102, 226, 97, 203, 135, 10, 211, 251, 52, 154, 236, 218, 31, 236, 237, 252, 36, 25, 28, 150, 249, 52, 121, 152, 78, 9, 180, 23, 211, 126, 133, 153, 69, 197, 208, 190, 241, 118, 207, 183, 27, 127, 51, 78, 77, 203, 153, 57, 21, 165, 163, 218, 41, 72, 219, 42, 130, 246, 112, 178, 196, 125, 46, 249, 103, 12, 28, 209, 111, 134, 22, 178, 180, 248, 88, 239, 238, 183, 191, 191, 235, 219, 239, 102, 91, 90, 37, 218, 170, 234, 76, 91, 208, 38, 23, 74, 215, 14, 49, 149, 60, 145, 150, 3, 11, 251, 182, 73, 231, 14, 95, 217, 195, 182, 171, 2, 171, 19, 234, 75, 157, 205, 141, 181, 171, 227, 213, 212, 44, 159, 98, 183, 226, 99, 144, 219, 130, 92, 110, 65, 184, 4, 2, 228, 3, 159, 193, 180, 197, 79, 248, 55, 139, 73, 238, 189, 48, 102, 251, 155, 199, 19, 14, 205, 136, 186, 253, 214, 230, 253, 171, 217, 157, 23, 191, 73, 242, 132, 144, 134, 38, 255, 202, 79, 191, 124, 17, 103, 7, 55, 166, 5, 16, 82, 103, 169, 250, 141, 231, 235, 218, 185, 26, 125, 37, 95, 68, 72, 248, 78, 214, 49, 88, 204, 17, 106, 221, 149, 143, 225, 254, 230, 120, 5, 166, 34, 200, 9, 60, 204, 9, 72, 205, 85, 231, 104, 186, 17, 172, 183, 67, 222, 23, 184, 112, 235, 253, 54, 150, 70, 42, 73, 68, 233, 174, 108, 200, 42, 240, 108, 88, 54, 31, 217, 176, 29, 139, 231, 201, 132, 118, 104, 205, 47, 226, 184, 119, 199, 152, 49, 164, 123, 255, 16, 176, 83, 10, 140, 215, 228, 222, 202, 64, 88, 213, 123, 106, 246, 53, 208, 42, 2, 43, 80, 203, 8, 155, 12, 216, 15, 221, 82, 20, 137, 22, 99, 66, 254, 146, 238, 82, 139, 25, 202, 33, 89, 156, 30, 48, 226, 103, 130, 148, 197, 126, 23, 131, 211, 75, 155, 62, 231, 73, 32, 151, 196, 231, 226, 0, 249, 180, 140, 111, 18, 4, 60, 240, 76, 199, 81, 248, 84, 10, 117, 15, 191, 189, 209, 163, 146, 37, 185, 128, 54, 214, 175, 96, 215, 150, 138, 140, 228, 102, 60, 133, 11, 185, 130, 110, 160, 121, 197, 129, 57, 150, 43, 222, 191, 64, 80, 107, 122, 33, 132, 67, 85, 141, 97, 124, 82, 173, 216, 224, 102, 220, 210, 24, 51, 192, 167, 135, 19, 212, 218, 170, 74, 105, 104, 58, 237, 203, 181, 197, 77, 23, 92, 210, 143, 195, 129, 37, 205, 61, 98, 61, 112, 36, 245, 192, 225, 83, 81, 159, 134, 235, 86, 221, 172, 191, 213, 5, 131, 183, 118, 196, 78, 206, 255, 9, 32, 58, 10, 189, 63, 95, 45, 85, 106, 74, 115, 51, 112, 123, 59, 45, 148, 13, 237, 84, 223, 249, 210, 176, 16, 228, 207, 248, 180, 91, 210, 71, 150, 167, 205, 123, 140, 39, 66, 3, 110, 249, 38, 86, 41, 181, 163, 96, 211, 181, 98, 58, 133, 136, 250, 23, 117, 4, 207, 219, 168, 118, 85, 200, 123, 30, 143, 56, 117, 197, 242, 205, 130, 45, 200, 77, 51, 56, 31, 41, 151, 118, 118, 162, 204, 65, 112, 243, 109, 142, 224, 81, 250, 103, 25, 91, 9, 189, 105, 23, 75, 95, 167, 149, 49, 103, 76, 105, 74, 67, 75, 3, 43, 103, 30, 157, 71, 34, 103, 136, 198, 229, 206, 182, 11, 255, 246, 247, 16, 221, 142, 40, 137, 89, 63, 23, 151, 111, 31, 74, 70, 38, 210, 240, 18, 209, 62, 111, 84, 203, 151, 195, 212, 18, 203, 83, 2, 98, 120, 73, 251, 3, 220, 241, 162, 8, 76, 55, 163, 201, 118, 42];
    const buff = Buffer.alloc(hack.length);
    for (let i = 0; i < hack.length; i++) {
      buff.writeUInt8(hack[i], i);
    }
    const ciphertext = '0x' + buff.toString("hex");

    const startTx = Date.now();
    let tx: any;
    if (!isLocked) {
      tx = await zeto.connect(signer.signer).transfer(
        nullifiers.filter((ic) => ic !== 0n), // trim off empty utxo hashes to check padding logic for batching works
        outputCommitments.filter((oc) => oc !== 0n), // trim off empty utxo hashes to check padding logic for batching works
        root,
        ciphertext,
        encodedProof,
        "0x",
      );
    } else {
      tx = await zeto.connect(signer.signer).transferLocked(
        nullifiers.filter((ic) => ic !== 0n), // trim off empty utxo hashes to check padding logic for batching works
        outputCommitments.filter((oc) => oc !== 0n), // trim off empty utxo hashes to check padding logic for batching works
        root,
        encodedProof,
        "0x",
      );
    }
    const results: ContractTransactionReceipt | null = await tx.wait();
    console.log(
      `Time to execute transaction: ${Date.now() - startTx}ms. Gas used: ${results?.gasUsed}`,
    );
    return results;
  }
});

async function prepareProof(
  circuit: any,
  provingKey: any,
  signer: User,
  inputs: UTXO[],
  _nullifiers: UTXO[],
  outputs: UTXO[],
  root: BigInt,
  merkleProof: BigInt[][],
  owners: User[],
  lockDelegate?: string,
) {
  const nullifiers = _nullifiers.map((nullifier) => nullifier.hash) as [
    BigNumberish,
    BigNumberish,
  ];
  const inputCommitments: BigNumberish[] = inputs.map(
    (input) => input.hash,
  ) as BigNumberish[];
  const inputValues = inputs.map((input) => BigInt(input.value || 0n));
  const inputSalts = inputs.map((input) => input.salt || 0n);
  const outputCommitments: BigNumberish[] = outputs.map(
    (output) => output.hash,
  ) as BigNumberish[];
  const outputValues = outputs.map((output) => BigInt(output.value || 0n));
  const outputOwnerPublicKeys: BigNumberish[][] = owners.map(
    (owner) => owner.babyJubPublicKey,
  ) as BigNumberish[][];

  // TODO: construct the message from the output UTXO secrets
  const m = [
    1665, 1665, 0, 1665, 0, 1665, 1665, 0, 1665, 0, 0, 1665, 1665, 1665, 1665, 0, 0, 1665, 0, 0, 0, 1665, 1665, 0, 1665, 0, 1665, 0, 0, 1665, 1665, 0, 0, 1665, 0, 0, 1665, 1665, 1665, 0, 0, 0, 0, 0,
    0, 1665, 0, 0, 1665, 0, 0, 1665, 0, 1665, 1665, 0, 1665, 1665, 0, 0, 1665, 1665, 1665, 0, 0, 0, 0, 0, 0, 1665, 0, 0, 1665, 1665, 0, 0, 0, 1665, 1665, 0, 1665, 1665, 1665, 1665, 0, 1665, 1665, 0,
    1665, 1665, 1665, 1665, 0, 1665, 1665, 0, 0, 0, 1665, 1665, 0, 1665, 1665, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  ];

  const randomness = [
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  ];

  const startWitnessCalculation = Date.now();
  const inputObj: any = {
    nullifiers,
    inputCommitments,
    inputValues,
    inputSalts,
    inputOwnerPrivateKey: signer.formattedPrivateKey,
    root,
    enabled: nullifiers.map((n) => (n !== 0n ? 1 : 0)),
    merkleProof,
    outputCommitments,
    outputValues,
    outputSalts: outputs.map((output) => output.salt || 0n),
    outputOwnerPublicKeys,
    randomness,
    m,
  };
  if (lockDelegate) {
    inputObj["lockDelegate"] = ethers.toBigInt(lockDelegate);
  }

  const witness = await circuit.calculateWTNSBin(inputObj, true);
  const timeWithnessCalculation = Date.now() - startWitnessCalculation;

  const startProofGeneration = Date.now();
  const { proof, publicSignals } = (await groth16.prove(
    provingKey,
    witness,
  )) as { proof: BigNumberish[]; publicSignals: BigNumberish[] };
  const timeProofGeneration = Date.now() - startProofGeneration;

  console.log(
    `Witness calculation time: ${timeWithnessCalculation}ms. Proof generation time: ${timeProofGeneration}ms.`,
  );

  const encodedProof = encodeProof(proof);
  return {
    inputCommitments,
    outputCommitments,
    encodedProof,
  };
}

module.exports = {
  prepareProof,
};
