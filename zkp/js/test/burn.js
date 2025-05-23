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

const { expect } = require('chai');
const { join } = require('path');
const { wasm: wasm_tester } = require('circom_tester');
const { genKeypair, formatPrivKeyForBabyJub } = require('maci-crypto');
const { Poseidon, newSalt } = require('../index.js');

const poseidonHash = Poseidon.poseidon4;

describe('burn circuit tests', () => {
  let circuit;

  const Alice = {};
  let senderPrivateKey;

  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(join(__dirname, '../../circuits/burn.circom'));

    let keypair = genKeypair();
    Alice.privKey = keypair.privKey;
    Alice.pubKey = keypair.pubKey;
    senderPrivateKey = formatPrivKeyForBabyJub(Alice.privKey);
  });

  it('should succeed for valid witness', async () => {
    const values = [32, 40];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(values[0]), salt1, ...Alice.pubKey]);
    const salt2 = newSalt();
    const input2 = poseidonHash([BigInt(values[1]), salt2, ...Alice.pubKey]);
    const inputCommitments = [input1, input2];

    const salt3 = newSalt();
    const outputCommitment = poseidonHash([BigInt(70), salt3, ...Alice.pubKey]);

    const witness = await circuit.calculateWitness(
      {
        inputCommitments,
        inputValues: values,
        inputSalts: [salt1, salt2],
        ownerPrivateKey: senderPrivateKey,
        outputCommitment,
        outputValue: 70,
        outputSalt: salt3,
      },
      true
    );

    // console.log('witness', witness.slice(0, 10));
    // console.log('inputCommitments', commitments);
    // console.log('inputValues', values);
    // console.log('inputSalts', [salt1, salt2]);

    expect(witness[1]).to.equal(BigInt(inputCommitments[0]));
    expect(witness[2]).to.equal(BigInt(inputCommitments[1]));
  });

  it('should succeed for valid witness - single input', async () => {
    const values = [72, 0];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(values[0]), salt1, ...Alice.pubKey]);
    const inputCommitments = [input1, 0];

    const salt3 = newSalt();
    const outputCommitment = poseidonHash([BigInt(70), salt3, ...Alice.pubKey]);

    const witness = await circuit.calculateWitness(
      {
        inputCommitments,
        inputValues: values,
        inputSalts: [salt1, 0],
        ownerPrivateKey: senderPrivateKey,
        outputCommitment,
        outputValue: 70,
        outputSalt: salt3,
      },
      true
    );

    expect(witness[1]).to.equal(BigInt(inputCommitments[0]));
    expect(witness[2]).to.equal(BigInt(inputCommitments[1]));
  });

  it('should fail if output is greater than sum of the inputs', async () => {
    const values = [32, 40];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(values[0]), salt1, ...Alice.pubKey]);
    const salt2 = newSalt();
    const input2 = poseidonHash([BigInt(values[1]), salt2, ...Alice.pubKey]);
    const inputCommitments = [input1, input2];

    const salt3 = newSalt();
    const outputCommitment = poseidonHash([BigInt(80), salt3, ...Alice.pubKey]);

    let error;
    try {
      await circuit.calculateWitness(
        {
          inputCommitments,
          inputValues: values,
          inputSalts: [salt1, salt2],
          ownerPrivateKey: senderPrivateKey,
          outputCommitment,
          outputValue: 80,
          outputSalt: salt3,
        },
        true
      );
    } catch (e) {
      // console.log(e);
      error = e;
    }
    expect(error).to.match(/Error in template Burn_94 line: 69/);
  });
});
