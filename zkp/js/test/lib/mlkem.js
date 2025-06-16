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
const { bytesToBits, bitsToBytes } = require('../../lib/util');
const { testCipher } = require('./util');

describe('mlkem circuit tests', () => {
  let circuit, witness;

  before(async function () {
    this.timeout(60000);
    circuit = await wasm_tester(join(__dirname, '../circuits/mlkem.circom'));
  });

  it('should generate the right 6144 bits (768 bytes) as interim signals', async () => {
    const circuitInputs = {
      randomness: testCipher.randomness,
      m: testCipher.m,
    };
    witness = await circuit.calculateWitness(circuitInputs);
    const bits = bytesToBits(testCipher.hack);
    // locate the ciphertext bits in the witness array
    let ctIndex = -1;
    for (let i = 0; i < witness.length; i++) {
      // check consecutive 10 bits to find the start of the ciphertext
      if (i + 6144 >= witness.length) {
        break; // prevent out of bounds access
      }
      let notMatch = false;
      for (let j = 0; j < 6144; j++) {
        if (Number(witness[i + j]) !== Number(bits[j])) {
          notMatch = true;
          break; // not a match, continue searching
        }
      }
      if (notMatch) continue; // continue to the next index if not a match
      // if we found a match, extract the next 6144 bits
      const array = witness.slice(i, i + 6144);
      const bytes = bitsToBytes(array.map((x) => Number(x)));
      expect(bytes).to.deep.equal(testCipher.hack);
      ctIndex = i;
      break;
    }
    console.log('Ciphertext found at index:', ctIndex);
    expect(ctIndex).to.be.greaterThan(0, 'Ciphertext not found in witness');
  }).timeout(60000);
});
