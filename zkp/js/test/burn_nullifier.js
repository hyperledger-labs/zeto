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

const { expect } = require("chai");
const { join } = require("path");
const { wasm: wasm_tester } = require("circom_tester");
const { genKeypair, formatPrivKeyForBabyJub } = require("maci-crypto");
const { Poseidon, newSalt } = require("../index.js");
const {
  Merkletree,
  InMemoryDB,
  str2Bytes,
  ZERO_HASH,
} = require("@iden3/js-merkletree");

const SMT_HEIGHT = 64;
const poseidonHash = Poseidon.poseidon4;
const poseidonHash3 = Poseidon.poseidon3;

describe("burn_nullifier circuit tests", () => {
  let circuit, smtAlice;

  const Alice = {};
  let senderPrivateKey;

  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(
      join(__dirname, "../../circuits/burn_nullifier.circom"),
    );

    let keypair = genKeypair();
    Alice.privKey = keypair.privKey;
    Alice.pubKey = keypair.pubKey;
    senderPrivateKey = formatPrivKeyForBabyJub(Alice.privKey);

    // initialize the local storage for Alice to manage her UTXOs in the Spart Merkle Tree
    const storage1 = new InMemoryDB(str2Bytes(""));
    smtAlice = new Merkletree(storage1, true, SMT_HEIGHT);
  });

  it("should succeed for valid witness", async () => {
    const values = [32, 40];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(values[0]), salt1, ...Alice.pubKey]);
    const salt2 = newSalt();
    const input2 = poseidonHash([BigInt(values[1]), salt2, ...Alice.pubKey]);
    const inputCommitments = [input1, input2];

    const salt3 = newSalt();
    const outputCommitment = poseidonHash([BigInt(70), salt3, ...Alice.pubKey]);

    // create the nullifiers for the inputs
    const nullifier1 = poseidonHash3([
      BigInt(values[0]),
      salt1,
      senderPrivateKey,
    ]);
    const nullifier2 = poseidonHash3([
      BigInt(values[1]),
      salt2,
      senderPrivateKey,
    ]);
    const nullifiers = [nullifier1, nullifier2];

    // calculate the root of the SMT
    await smtAlice.add(input1, input1);
    await smtAlice.add(input2, input2);

    // generate the merkle proof for the inputs
    const proof1 = await smtAlice.generateCircomVerifierProof(
      input1,
      ZERO_HASH,
    );
    const proof2 = await smtAlice.generateCircomVerifierProof(
      input2,
      ZERO_HASH,
    );

    const witness = await circuit.calculateWitness(
      {
        nullifiers,
        inputCommitments,
        inputValues: values,
        inputSalts: [salt1, salt2],
        ownerPrivateKey: senderPrivateKey,
        root: proof1.root.bigInt(),
        merkleProof: [
          proof1.siblings.map((s) => s.bigInt()),
          proof2.siblings.map((s) => s.bigInt()),
        ],
        enabled: [1, 1],
        outputCommitment,
        outputValue: 70,
        outputSalt: salt3,
      },
      true,
    );

    // console.log('witness', witness.slice(0, 10));
    // console.log('nullifiers', nullifiers);
    // console.log('commitments', commitments);
    // console.log('values', values);
    // console.log('salts', [salt1, salt2]);

    expect(witness[1]).to.equal(BigInt(nullifiers[0]));
    expect(witness[2]).to.equal(BigInt(nullifiers[1]));
  });

  it("should succeed for valid witness - single input", async () => {
    const values = [72, 0];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(values[0]), salt1, ...Alice.pubKey]);
    const inputCommitments = [input1, 0];

    // create the nullifiers for the inputs
    const nullifier1 = poseidonHash3([
      BigInt(values[0]),
      salt1,
      senderPrivateKey,
    ]);
    const nullifiers = [nullifier1, 0];

    const salt3 = newSalt();
    const outputCommitment = poseidonHash([BigInt(70), salt3, ...Alice.pubKey]);

    // calculate the root of the SMT
    await smtAlice.add(input1, input1);

    // generate the merkle proof for the inputs
    const proof1 = await smtAlice.generateCircomVerifierProof(
      input1,
      ZERO_HASH,
    );
    const proof2 = await smtAlice.generateCircomVerifierProof(0, ZERO_HASH);

    const witness = await circuit.calculateWitness(
      {
        nullifiers,
        inputCommitments,
        inputValues: values,
        inputSalts: [salt1, 0],
        ownerPrivateKey: senderPrivateKey,
        root: proof1.root.bigInt(),
        merkleProof: [
          proof1.siblings.map((s) => s.bigInt()),
          proof2.siblings.map((s) => s.bigInt()),
        ],
        enabled: [1, 0],
        outputCommitment,
        outputValue: 70,
        outputSalt: salt3,
      },
      true,
    );

    expect(witness[1]).to.equal(BigInt(nullifiers[0]));
    expect(witness[2]).to.equal(BigInt(nullifiers[1]));
  });

  it("should fail if the output UTXO has a bigger value", async () => {
    const values = [32, 40];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(values[0]), salt1, ...Alice.pubKey]);
    const salt2 = newSalt();
    const input2 = poseidonHash([BigInt(values[1]), salt2, ...Alice.pubKey]);
    const inputCommitments = [input1, input2];

    const salt3 = newSalt();
    const outputCommitment = poseidonHash([BigInt(80), salt3, ...Alice.pubKey]);

    // create the nullifiers for the inputs
    const nullifier1 = poseidonHash3([
      BigInt(values[0]),
      salt1,
      senderPrivateKey,
    ]);
    const nullifier2 = poseidonHash3([
      BigInt(values[1]),
      salt2,
      senderPrivateKey,
    ]);
    const nullifiers = [nullifier1, nullifier2];

    // calculate the root of the SMT
    await smtAlice.add(input1, input1);
    await smtAlice.add(input2, input2);

    // generate the merkle proof for the inputs
    const proof1 = await smtAlice.generateCircomVerifierProof(
      input1,
      ZERO_HASH,
    );
    const proof2 = await smtAlice.generateCircomVerifierProof(
      input2,
      ZERO_HASH,
    );

    let error;
    try {
      await circuit.calculateWitness(
        {
          nullifiers,
          inputCommitments,
          inputValues: values,
          inputSalts: [salt1, salt2],
          ownerPrivateKey: senderPrivateKey,
          root: proof1.root.bigInt(),
          merkleProof: [
            proof1.siblings.map((s) => s.bigInt()),
            proof2.siblings.map((s) => s.bigInt()),
          ],
          enabled: [1, 1],
          outputCommitment,
          outputValue: 80,
          outputSalt: salt3,
        },
        true,
      );
    } catch (e) {
      // console.log('error', e);
      error = e;
    }
    expect(error).to.match(/Error in template BurnNullifiers_251 line: 93/);
  });
});
