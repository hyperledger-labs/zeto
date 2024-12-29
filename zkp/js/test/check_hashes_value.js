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

const { expect } = require("chai");
const { join } = require("path");
const { wasm: wasm_tester } = require("circom_tester");
const { genKeypair } = require("maci-crypto");
const { Poseidon, newSalt } = require("../index.js");

const MAX_VALUE = 2n ** 100n - 1n;
const poseidonHash = Poseidon.poseidon4;

describe("check_hashes_value circuit tests", () => {
  let circuit;
  const sender = {};

  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(
      join(__dirname, "../../circuits/check_hashes_value.circom"),
    );

    let keypair = genKeypair();
    sender.privKey = keypair.privKey;
    sender.pubKey = keypair.pubKey;
  });

  it("should return true for valid witness", async () => {
    const outputValues = [100, 200];

    // create the output UTXO
    const salt1 = newSalt();
    const salt2 = newSalt();
    const output1 = poseidonHash([
      BigInt(outputValues[0]),
      salt1,
      ...sender.pubKey,
    ]);
    const output2 = poseidonHash([
      BigInt(outputValues[1]),
      salt2,
      ...sender.pubKey,
    ]);
    const outputCommitments = [output1, output2];

    let witness = await circuit.calculateWitness(
      {
        outputCommitments,
        outputCommitmentInputs: [
          BigInt(outputValues[0]),
          salt1,
          ...sender.pubKey,
          BigInt(outputValues[1]),
          salt2,
          ...sender.pubKey,
        ],
      },
      true,
    );

    expect(witness[1]).to.equal(BigInt(300)); // index 1 is the output, for the calculated value
  });

  it("should return true for valid witness (using 0 value for one of the outputs)", async () => {
    const outputValues = [300, 0];

    // create the output UTXO
    const salt1 = newSalt();
    const salt2 = newSalt();
    const output1 = poseidonHash([
      BigInt(outputValues[0]),
      salt1,
      ...sender.pubKey,
    ]);
    const output2 = poseidonHash([
      BigInt(outputValues[1]),
      salt2,
      ...sender.pubKey,
    ]);
    const outputCommitments = [output1, output2];

    let witness = await circuit.calculateWitness(
      {
        outputCommitments,
        outputCommitmentInputs: [
          BigInt(outputValues[0]),
          salt1,
          ...sender.pubKey,
          BigInt(outputValues[1]),
          salt2,
          ...sender.pubKey,
        ],
      },
      true,
    );

    expect(witness[1]).to.equal(BigInt(300)); // index 1 is the output, for the calculated value
  });

  it("should fail to generate a witness because of invalid output commitments", async () => {
    const outputValues = [100, 200];

    // create the output UTXO
    const salt1 = newSalt();
    const output1 = poseidonHash([
      BigInt(outputValues[0] + 100),
      salt1,
      ...sender.pubKey,
    ]);
    const output2 = poseidonHash([
      BigInt(outputValues[1]),
      salt1,
      ...sender.pubKey,
    ]);
    const outputCommitments = [output1, output2];

    let error;
    try {
      await circuit.calculateWitness(
        {
          outputCommitments,
          outputCommitmentInputs: [
            BigInt(outputValues[0]),
            salt1,
            ...sender.pubKey,
            BigInt(outputValues[1]),
            salt1,
            ...sender.pubKey,
          ],
        },
        true,
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckHashes_80 line: 62/); // hash check failed
  });

  it("should fail to generate a witness because of negative values in output commitments", async () => {
    // in the finite field used in the Poseidon hash implementation, -100n is equivalent to
    // 21888242871839275222246405745257275088548364400416034343698204186575808495517n
    const outputValues = [-100, 200];

    // create the output UTXO
    const salt1 = newSalt();
    const output1 = poseidonHash([
      BigInt(outputValues[0]),
      salt1,
      ...sender.pubKey,
    ]);
    const output2 = poseidonHash([
      BigInt(outputValues[1]),
      salt1,
      ...sender.pubKey,
    ]);
    const outputCommitments = [output1, output2];

    let error;
    try {
      await circuit.calculateWitness(
        {
          outputCommitments,
          outputCommitmentInputs: [
            BigInt(outputValues[0]),
            salt1,
            ...sender.pubKey,
            BigInt(outputValues[1]),
            salt1,
            ...sender.pubKey,
          ],
        },
        true,
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckPositiveValues_3 line: 34/); // positive range check failed
  });

  it("should fail to generate a witness because of using the inverse of a negative value in output commitments", async () => {
    // in the finite field used in the Poseidon hash implementation, -100n is equivalent to
    // 21888242871839275222246405745257275088548364400416034343698204186575808495517n. This number
    // is considered negative by the circuit, because we allow the range of 0 to (2**40 - 1)
    const outputValues = [
      21888242871839275222246405745257275088548364400416034343698204186575808495518n,
      100,
    ];

    // create the output UTXO
    const salt1 = newSalt();
    const output1 = poseidonHash([
      BigInt(outputValues[0]),
      salt1,
      ...sender.pubKey,
    ]);
    const output2 = poseidonHash([
      BigInt(outputValues[1]),
      salt1,
      ...sender.pubKey,
    ]);
    const outputCommitments = [output1, output2];

    let error;
    try {
      await circuit.calculateWitness(
        {
          outputCommitments,
          outputCommitmentInputs: [
            BigInt(outputValues[0]),
            salt1,
            ...sender.pubKey,
            BigInt(outputValues[1]),
            salt1,
            ...sender.pubKey,
          ],
        },
        true,
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckPositiveValues_3 line: 34/); // positive range check failed
  });

  it("should fail to generate a witness because a larger than MAX_VALUE is used in output", async () => {
    const outputValues = [MAX_VALUE + 1n, 0];

    // create the output UTXO
    const salt1 = newSalt();
    const output1 = poseidonHash([
      BigInt(outputValues[0]),
      salt1,
      ...sender.pubKey,
    ]);
    const output2 = poseidonHash([
      BigInt(outputValues[1]),
      salt1,
      ...sender.pubKey,
    ]);
    const outputCommitments = [output1, output2];

    let error;
    try {
      await circuit.calculateWitness(
        {
          outputCommitments,
          outputCommitmentInputs: [
            BigInt(outputValues[0]),
            salt1,
            ...sender.pubKey,
            BigInt(outputValues[1]),
            salt1,
            ...sender.pubKey,
          ],
        },
        true,
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckPositiveValues_3 line: 34/); // positive range check failed
  });
});
