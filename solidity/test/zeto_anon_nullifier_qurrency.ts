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

    circuit = await loadCircuit("anon_nullifier_transfer_qurrency");
    ({ provingKeyFile: provingKey } = loadProvingKeys(
      "anon_nullifier_transfer_qurrency",
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

  describe("lock() tests", function () {
    let lockedUtxo1: UTXO;
    let smtBobForLocked: Merkletree;
    let utxo10: UTXO;
    let utxo11: UTXO;
    let utxo12: UTXO;

    before(async function () {
      const storage1 = new InMemoryDB(str2Bytes(""));
      smtBobForLocked = new Merkletree(storage1, true, 64);

      // mint a UTXO for Bob and spend it (to use it in a failure case test)
      utxo12 = newUTXO(1, Alice);
      await doMint(zeto, deployer, [utxo12]);
      await smtAlice.add(utxo12.hash, utxo12.hash);
      await smtBob.add(utxo12.hash, utxo12.hash);

      const _utxo1 = newUTXO(1, Bob);
      const nullifier1 = newNullifier(utxo12, Alice);
      let root = await smtAlice.root();
      const proof1 = await smtAlice.generateCircomVerifierProof(utxo12.hash, root);
      const proof2 = await smtAlice.generateCircomVerifierProof(utxo12.hash, root);
      const merkleProofs = [
        proof1.siblings.map((s) => s.bigInt()),
        proof2.siblings.map((s) => s.bigInt()),
      ];

      await doTransfer(
        Alice,
        [utxo12, ZERO_UTXO],
        [nullifier1, ZERO_UTXO],
        [_utxo1, ZERO_UTXO],
        root.bigInt(),
        merkleProofs,
        [Bob, Alice],
      );
      await smtAlice.add(_utxo1.hash, _utxo1.hash);
      await smtBob.add(_utxo1.hash, _utxo1.hash);
    });

    describe("lock -> transfer flow", function () {
      it("lock() should succeed when using unlocked states", async function () {
        const nullifier1 = newNullifier(utxo7, Bob);
        lockedUtxo1 = newUTXO(utxo7.value!, Bob);
        const root = await smtBob.root();
        const proof1 = await smtBob.generateCircomVerifierProof(
          utxo7.hash,
          root,
        );
        const proof2 = await smtBob.generateCircomVerifierProof(0n, root);
        const merkleProofs = [
          proof1.siblings.map((s) => s.bigInt()),
          proof2.siblings.map((s) => s.bigInt()),
        ];
        const { outputCommitments, encodedProof } = await prepareProof(
          circuit,
          provingKey,
          Bob,
          [utxo7, ZERO_UTXO],
          [nullifier1, ZERO_UTXO],
          [lockedUtxo1, ZERO_UTXO],
          root.bigInt(),
          merkleProofs,
          [Bob, Bob],
        );

        const tx = await zeto.connect(Bob.signer).lock(
          [nullifier1.hash],
          [],
          outputCommitments,
          root.bigInt(),
          encodedProof,
          Alice.ethAddress, // make Alice the delegate who can spend the state (if she has the right proof)
          "0x",
        );
        const result: ContractTransactionReceipt | null = await tx.wait();

        // Note that the locked UTXO should NOT be added to the local SMT for UTXOs because it's tracked in a separate SMT onchain
        // we add it to the local SMT for locked UTXOs
        const events = parseUTXOEvents(zeto, result!);
        await smtBobForLocked.add(
          events[0].lockedOutputs[0],
          ethers.toBigInt(events[0].delegate),
        );
      });

      it("onchain SMT root for the locked UTXOs should be equal to the offchain SMT root", async function () {
        const root = await smtBobForLocked.root();
        const onchainRoot = await zeto.getRootForLocked();
        expect(root.string()).to.equal(onchainRoot.toString());
      });

      it("the designated delegate can use the proper proof to spend the locked state", async function () {
        // Bob generates inclusion proofs for the UTXOs to be spent, as private input to the proof generation
        const nullifier1 = newNullifier(lockedUtxo1, Bob);
        const root = await smtBobForLocked.root();
        const proof1 = await smtBobForLocked.generateCircomVerifierProof(
          lockedUtxo1.hash,
          root,
        );
        const proof2 = await smtBobForLocked.generateCircomVerifierProof(
          0n,
          root,
        );
        const merkleProofs = [
          proof1.siblings.map((s) => s.bigInt()),
          proof2.siblings.map((s) => s.bigInt()),
        ];
        // Bob proposes the output UTXOs, attempting to transfer the locked UTXO to Alice
        utxo9 = newUTXO(10, Alice);
        utxo10 = newUTXO(5, Bob);

        const result = await prepareProof(
          circuitForLocked,
          provingKeyForLocked,
          Bob,
          [lockedUtxo1, ZERO_UTXO],
          [nullifier1, ZERO_UTXO],
          [utxo9, utxo10],
          root.bigInt(),
          merkleProofs,
          [Alice, Bob],
          Alice.ethAddress, // current lock delegate
        );
        const nullifiers = [nullifier1.hash];

        // Alice (in reality this is usually a contract that orchestrates a trade flow) can spend the locked state
        // using the proof generated by the trade counterparty (Bob in this case)
        await expect(
          sendTx(
            Alice,
            nullifiers,
            result.outputCommitments,
            root.bigInt(),
            result.encodedProof,
            true,
          ),
        ).to.be.fulfilled;

        // Alice and Bob keep the local SMT in sync
        await smtAlice.add(utxo9.hash, utxo9.hash);
        await smtAlice.add(utxo10.hash, utxo10.hash);
        await smtBob.add(utxo9.hash, utxo9.hash);
        await smtBob.add(utxo10.hash, utxo10.hash);
      });

      it("onchain SMT root for the locked UTXOs should be equal to the offchain SMT root", async function () {
        const root = await smtBobForLocked.root();
        const onchainRoot = await zeto.getRootForLocked();
        expect(root.string()).to.equal(onchainRoot.toString());
      });

      it("onchain SMT root for the unlocked UTXOs should be equal to the offchain SMT root", async function () {
        const root = await smtBob.root();
        const onchainRoot = await zeto.getRoot();
        expect(root.string()).to.equal(onchainRoot.toString());
      });
    });
  });

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
    const startTx = Date.now();
    let tx: any;
    if (!isLocked) {
      tx = await zeto.connect(signer.signer).transfer(
        nullifiers.filter((ic) => ic !== 0n), // trim off empty utxo hashes to check padding logic for batching works
        outputCommitments.filter((oc) => oc !== 0n), // trim off empty utxo hashes to check padding logic for batching works
        root,
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
