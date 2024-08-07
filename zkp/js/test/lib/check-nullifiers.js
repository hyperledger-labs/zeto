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

const { expect } = require('chai');
const { join } = require('path');
const { wasm: wasm_tester } = require('circom_tester');
const { genKeypair, formatPrivKeyForBabyJub } = require('maci-crypto');
const { Poseidon, newSalt } = require('../../index.js');

const poseidonHash3 = Poseidon.poseidon3;

describe('check-nullifiers circuit tests', () => {
  let circuit, smt;
  const sender = {};
  let senderPrivateKey;

  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(join(__dirname, '../circuits/check-nullifiers.circom'));

    let keypair = genKeypair();
    sender.privKey = keypair.privKey;
    sender.pubKey = keypair.pubKey;
    senderPrivateKey = formatPrivKeyForBabyJub(sender.privKey);
  });

  it('should return true for valid witness', async () => {
    const values = [32, 40];

    // create two input nullifiers, corresponding to the input UTXOs
    const salt1 = newSalt();
    const nullifier1 = poseidonHash3([BigInt(values[0]), salt1, senderPrivateKey]);
    const salt2 = newSalt();
    const nullifier2 = poseidonHash3([BigInt(values[1]), salt2, senderPrivateKey]);
    const nullifiers = [nullifier1, nullifier2];

    const witness = await circuit.calculateWitness(
      {
        nullifiers,
        values,
        salts: [salt1, salt2],
        ownerPrivateKey: senderPrivateKey,
      },
      true
    );

    // console.log(witness.slice(0, 10));
    // console.log('nullifiers', nullifiers);
    // console.log('inputValues', inputValues);
    // console.log('inputSalts', [salt1, salt2]);
    // console.log('owner private key', sender.privKey);

    expect(witness[1]).to.equal(BigInt(nullifiers[0]));
    expect(witness[2]).to.equal(BigInt(nullifiers[1]));
    expect(witness[3]).to.equal(BigInt(values[0]));
    expect(witness[4]).to.equal(BigInt(values[1]));
  });

  it('should return true for valid witness - single input', async () => {
    const inputValues = [72, 0];

    // create two input nullifiers, corresponding to the input UTXOs
    const salt1 = newSalt();
    const nullifier1 = poseidonHash3([BigInt(inputValues[0]), salt1, senderPrivateKey]);
    const nullifiers = [nullifier1, 0];

    const witness = await circuit.calculateWitness(
      {
        nullifiers,
        values: inputValues,
        salts: [salt1, 0],
        ownerPrivateKey: senderPrivateKey,
      },
      true
    );

    expect(witness[1]).to.equal(BigInt(nullifiers[0]));
    expect(witness[2]).to.equal(BigInt(nullifiers[1]));
  });
});
