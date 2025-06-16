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
const { bitsToBytes, bytesToBits } = require('../../lib/util');
const { testCipher } = require('./util');

describe('kpke_enc circuit tests', () => {
  let circuit, witness;

  before(async function () {
    this.timeout(60000);
    circuit = await wasm_tester(join(__dirname, '../circuits/kpke_enc.circom'));
  });

  it('should generate the right 6144 bits (768 bytes) as output', async () => {
    const circuitInputs = {
      randomness: testCipher.randomness,
      m: testCipher.m,
    };
    witness = await circuit.calculateWitness(circuitInputs);
    // the ciphertext is at index 1...6144, which is 768*8
    const array = witness.slice(1, 6145);
    const bytes = bitsToBytes(array.map((x) => Number(x)));
    expect(bytes).to.deep.equal(testCipher.hack);
    // if we recover the bits from the expected hack bytes, they should match the witness bits
    const bits = bytesToBits(testCipher.hack);
    expect(array.map((n) => Number(n))).to.deep.equal(bits.map((n) => Number(n)));
  }).timeout(60000);
});
