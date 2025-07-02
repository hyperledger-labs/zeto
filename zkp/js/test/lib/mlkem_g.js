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
const crypto = require('crypto');
const { MlKem512 } = require('mlkem');
const { wasm: wasm_tester } = require('circom_tester');
const { bytesToBits, bitsToBytes } = require('../../lib/util');
const { testCipher, testKeyPair } = require('./util');

describe('mlkem protocol G(m || H(ek)) circuit tests', () => {
  let circuit;

  before(async function () {
    this.timeout(60000);
    circuit = await wasm_tester(join(__dirname, '../circuits/mlkem_g.circom'));
  });

  it('should generate the right K and r signals', async () => {
    const randomness = [59, 33, 225, 54, 96, 22, 97, 134, 55, 158, 65, 251, 97, 133, 236, 153, 194, 58, 180, 157, 136, 222, 78, 71, 187, 20, 156, 248, 106, 26, 179, 146];
    const hashOfEk = bitsToBytes([
      0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 1,
      1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1,
      1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 1,
      0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 1,
    ]);
    console.log('circuit: h(pk)', hashOfEk);
    const randomBits = bytesToBits(randomness);
    const circuitInputs = {
      m: randomBits,
    };
    witness = await circuit.calculateWitness(circuitInputs);
    // the K is 1...256, which is 256 bits
    console.log('witness 1-100: ', witness.slice(1, 101));
    console.log('witness 101-200: ', witness.slice(101, 201));
    console.log('witness 201-256: ', witness.slice(201, 257));
    // the r is the next 256 bits, which is at index 257...512
    console.log('witness 257-356: ', witness.slice(257, 357));

    const sender = new MlKem512();
    const pkR = new Uint8Array(testKeyPair.pk);
    const [ct, ssS] = await sender.encap(pkR, new Uint8Array(randomness));
    console.log('shared secret: ', ssS);
    console.log('ciphertext: ', ct);
  }).timeout(60000);
});
