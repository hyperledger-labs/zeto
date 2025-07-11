// Copyright © 2025 Kaleido, Inc.
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
import { BigNumberish, ContractTransactionReceipt } from "ethers";
import crypto from "crypto";
import { groth16 } from "snarkjs";
import { Merkletree, InMemoryDB, str2Bytes } from "@iden3/js-merkletree";
import { loadCircuit, encodeProof, newEncryptionNonce, bytesToBits } from "zeto-js";
import qurrencyModule from "../../ignition/modules/test/qurrency";
import { User, newUser, newUTXO, newNullifier } from "../lib/utils";
import { loadProvingKeys } from "../utils";

describe("Test Qurrency verifier", function () {
  let qurrency: any;
  let smtAlice: Merkletree;

  let Alice: User;
  let Bob: User;
  let circuit: any, provingKey: any;

  before(async function () {
    if (network.name !== "hardhat") {
      // accommodate for longer block times on public networks
      this.timeout(120000);
    }
    let [_, a, b] = await ethers.getSigners();
    ({ qurrency } = await ignition.deploy(qurrencyModule));
    console.log(`Qurrency test contract deployed at ${qurrency.target}`);

    Alice = await newUser(a);
    Bob = await newUser(b);

    const storage1 = new InMemoryDB(str2Bytes(""));
    smtAlice = new Merkletree(storage1, true, 64);

    circuit = await loadCircuit("anon_nullifier_qurrency_transfer");
    ({ provingKeyFile: provingKey } = loadProvingKeys(
      "anon_nullifier_qurrency_transfer",
    ));
  });

  it("test prepared inputs", async function () {
    this.timeout(120000);

    const utxo1 = newUTXO(10, Alice);
    const utxo2 = newUTXO(20, Alice);

    await smtAlice.add(utxo1.hash, utxo1.hash);
    await smtAlice.add(utxo2.hash, utxo2.hash);

    // Alice generates the nullifiers for the UTXOs to be spent
    const nullifier1 = newNullifier(utxo1, Alice);
    const nullifier2 = newNullifier(utxo2, Alice);
    const nullifiers = [nullifier1.hash, nullifier2.hash];
    const inputCommitments = [utxo1.hash, utxo2.hash];
    const inputValues = [utxo1.value, utxo2.value];
    const inputSalts = [utxo1.salt, utxo2.salt];

    // Alice generates inclusion proofs for the UTXOs to be spent
    let root = await smtAlice.root();
    const proof1 = await smtAlice.generateCircomVerifierProof(utxo1.hash, root);
    const proof2 = await smtAlice.generateCircomVerifierProof(utxo2.hash, root);
    const merkleProofs = [
      proof1.siblings.map((s) => s.bigInt()),
      proof2.siblings.map((s) => s.bigInt()),
    ];

    const utxo3 = newUTXO(25, Bob);
    const utxo4 = newUTXO(5, Alice);
    const outputCommitments = [utxo3.hash, utxo4.hash];
    const outputValues = [utxo3.value, utxo4.value];
    const outputSalts = [utxo3.salt, utxo4.salt];
    const outputOwnerPublicKeys = [
      Bob.babyJubPublicKey,
      Alice.babyJubPublicKey,
    ];

    const randomness = crypto.randomBytes(32);
    const r = bytesToBits(randomness);
    const encryptionNonce = newEncryptionNonce();

    const inputObj: any = {
      nullifiers,
      inputCommitments,
      inputValues,
      inputSalts,
      inputOwnerPrivateKey: Alice.formattedPrivateKey,
      root: root.bigInt(),
      enabled: nullifiers.map((n) => (n !== 0n ? 1 : 0)),
      merkleProof: merkleProofs,
      outputCommitments,
      outputValues,
      outputSalts,
      outputOwnerPublicKeys,
      randomness: r,
      encryptionNonce,
    };
    const witness = await circuit.calculateWTNSBin(inputObj, true);
    const startProofGeneration = Date.now();
    const { proof, publicSignals } = (await groth16.prove(
      provingKey,
      witness,
    )) as { proof: BigNumberish[]; publicSignals: BigNumberish[] };
    const timeProofGeneration = Date.now() - startProofGeneration;

    console.log(`Proof generation time: ${timeProofGeneration}ms.`);

    const encodedProof = encodeProof(proof);

    const result = await qurrency.verifyProof(encodedProof, publicSignals);
    const receipt: ContractTransactionReceipt | null = await result.wait();
    console.log(`Qurrency test tx gas cost: ${receipt?.gasUsed}`);
  });
});
