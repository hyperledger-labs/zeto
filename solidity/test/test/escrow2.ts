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

import { ethers, ignition, network } from "hardhat";
import { Signer, encodeBytes32String, ZeroHash, lock, AbiCoder } from "ethers";
import { expect } from "chai";
import { loadCircuit, getProofHash } from "zeto-js";
import { Merkletree, InMemoryDB, str2Bytes } from "@iden3/js-merkletree";
import zkEscrowModule from "../../ignition/modules/test/escrow2";
import zetoAnonNullifierTests from "../zeto_anon_nullifier";
import {
  UTXO,
  User,
  newUser,
  newUTXO,
  newNullifier,
  doMint,
  ZERO_UTXO,
  parseUTXOEvents,
} from "../lib/utils";
import { loadProvingKeys } from "../utils";
import { deployZeto } from "../lib/deploy";

describe("Escrow flow for payment with Zeto_AnonNullifier", function () {
  let Alice: User;
  let Bob: User;
  let Charlie: User;

  // instances of the contracts
  let zkPayment: any;
  let zkEscrow: any;

  // payment UTXOs to be minted and transferred
  let payment1: UTXO;
  let payment2: UTXO;

  // UTXOs involved in the escrow flow
  let lockedPayment1: UTXO;
  let nullifier1: UTXO;
  let paymentToBob: UTXO;

  // other variables
  let deployer: Signer;
  let circuit: any, circuitLocked: any;
  let provingKey: string, provingKeyLocked: string;
  let paymentId: any;
  let smtAlice: Merkletree, smtAliceLocked: Merkletree;
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

    circuit = await loadCircuit("anon_nullifier_transfer");
    ({ provingKeyFile: provingKey } = loadProvingKeys(
      "anon_nullifier_transfer",
    ));
    circuitLocked = await loadCircuit("anon_nullifier_transferLocked");
    ({ provingKeyFile: provingKeyLocked } = loadProvingKeys(
      "anon_nullifier_transferLocked",
    ));

    const storage1 = new InMemoryDB(str2Bytes(""));
    smtAlice = new Merkletree(storage1, true, 64);

    const storage2 = new InMemoryDB(str2Bytes(""));
    smtAliceLocked = new Merkletree(storage2, true, 64);

    ({ deployer, zeto: zkPayment } = await deployZeto("Zeto_AnonNullifier"));
    console.log(`ZK Payment contract deployed at ${zkPayment.target}`);
    ({ zkEscrow } = await ignition.deploy(zkEscrowModule, {
      parameters: {
        zkEscrow2: {
          paymentToken: zkPayment.target,
        },
      },
    }));
  });

  it("mint to Alice some payment tokens", async function () {
    payment1 = newUTXO(10, Alice);
    payment2 = newUTXO(20, Alice);
    const result = await doMint(zkPayment, deployer, [payment1, payment2]);

    // simulate Alice and Bob listening to minting events and updating his local merkle tree
    for (const log of result.logs) {
      const event = zkPayment.interface.parseLog(log as any);
      expect(event.args.outputs.length).to.equal(2);
    }

    await smtAlice.add(payment1.hash, payment1.hash);
    await smtAlice.add(payment2.hash, payment2.hash);
  });

  it("Alice locks some payment tokens and designates the escrow as the delegate", async function () {
    // Alice generates the nullifiers for the UTXOs to be spent
    const nullifier1 = newNullifier(payment1, Alice);

    // Alice generates inclusion proofs for the UTXOs to be spent
    let root = await smtAlice.root();
    const proof1 = await smtAlice.generateCircomVerifierProof(
      payment1.hash,
      root,
    );
    const proof2 = await smtAlice.generateCircomVerifierProof(0n, root);
    const merkleProofs = [
      proof1.siblings.map((s) => s.bigInt()),
      proof2.siblings.map((s) => s.bigInt()),
    ];

    lockedPayment1 = newUTXO(payment1.value!, Alice);
    const { outputCommitments, encodedProof } =
      await zetoAnonNullifierTests.prepareProof(
        circuit,
        provingKey,
        Alice,
        [payment1, ZERO_UTXO],
        [nullifier1, ZERO_UTXO],
        [lockedPayment1, ZERO_UTXO],
        root.bigInt(),
        merkleProofs,
        [Alice, Alice],
      );
    const tx = await zkPayment
      .connect(Alice.signer)
      .lock(
        [nullifier1.hash],
        [],
        outputCommitments,
        encodeToBytes(root.bigInt(), encodedProof),
        zkEscrow.target,
        "0x",
      );
    const result = await tx.wait();
    const events = parseUTXOEvents(zkPayment, result);

    // simulate Alice's tradinig partner listening to the locking events and verifying the committed (locked) value
    const lockedUTXO = events[0].lockedOutputs[0];
    const lockDelegate = events[0].delegate;
    // Alice's trading partner is sent the secrets for the locked UTXO (which is still owned by Alice)
    // in an off-chain message. so they can be used to verify the locked UTXO, and the lock delegate
    const check = newUTXO(lockedPayment1.value!, Alice, lockedPayment1.salt);
    expect(lockedUTXO).to.equal(check.hash);
    expect(lockDelegate).to.equal(zkEscrow.target);

    await smtAliceLocked.add(
      lockedPayment1.hash,
      ethers.toBigInt(zkEscrow.target),
    );
  });

  it("Alice initiates a payment transaction to Bob through the escrow", async function () {
    nullifier1 = newNullifier(lockedPayment1, Alice);
    paymentToBob = newUTXO(lockedPayment1.value!, Bob);
    const tx = await zkEscrow
      .connect(Alice.signer)
      .initiatePayment([nullifier1.hash], [paymentToBob.hash], "0x");
    const result = await tx.wait();
    const events = parseUTXOEvents(zkEscrow, result);
    // simulate Bob listening to the payment events and verifying the proposed payment
    const proposedPayment = events[0].outputs[0];
    expect(proposedPayment).to.equal(paymentToBob.hash);
    paymentId = events[0].paymentId;
  });

  it("Alice approves the payment by submitting a valid proof that can successfully verify the proposed payment", async function () {
    let root = await smtAliceLocked.root();
    const proof1 = await smtAliceLocked.generateCircomVerifierProof(
      lockedPayment1.hash,
      root,
    );
    const proof2 = await smtAliceLocked.generateCircomVerifierProof(0n, root);
    const merkleProofs = [
      proof1.siblings.map((s) => s.bigInt()),
      proof2.siblings.map((s) => s.bigInt()),
    ];
    const { encodedProof } = await zetoAnonNullifierTests.prepareProof(
      circuitLocked,
      provingKeyLocked,
      Alice,
      [lockedPayment1, ZERO_UTXO],
      [nullifier1, ZERO_UTXO],
      [paymentToBob, ZERO_UTXO],
      root.bigInt(),
      merkleProofs,
      [Bob, Bob],
      zkEscrow.target,
    );
    const tx = await zkEscrow
      .connect(Alice.signer)
      .approvePayment(
        paymentId,
        encodeToBytes(root.bigInt(), encodedProof),
        "0x",
      );
    const result = await tx.wait();
    // simulate Bob listening to the escrow events and verifying the payment has been approved.
    // the escrow contract guaratees that the proof is valid
    const events = parseUTXOEvents(zkEscrow, result);
    const approvedPayment = events[0].paymentId;
    expect(approvedPayment).to.equal(paymentId);
  });

  it("Bob, or anyone, can call the escrow to finalize the payment and receive the locked UTXO", async function () {
    const tx = await zkEscrow
      .connect(Bob.signer)
      .completePayment(paymentId, "0x");
    const result = await tx.wait();
    // simulate Bob listening to the payment events and verifying
    // the expected UTXO has been transferred to him
    let events = parseUTXOEvents(zkPayment, result);
    const transferredPayment = events[0].outputs[0];
    const check = newUTXO(paymentToBob.value!, Bob, paymentToBob.salt);
    expect(transferredPayment).to.equal(check.hash);
    // simulate Bob listening to the escrow events and verifying the payment has been completed
    events = parseUTXOEvents(zkEscrow, result);
    const completedPayment = events[1].paymentId;
    expect(completedPayment).to.equal(paymentId);
  });
});

function encodeToBytes(root: any, proof: any) {
  return new AbiCoder().encode(
    ["uint256 root", "tuple(uint256[2] pA, uint256[2][2] pB, uint256[2] pC)"],
    [root, proof],
  );
}
