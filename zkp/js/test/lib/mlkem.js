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

describe('mlkem circuit tests', () => {
  let circuit, witness;

  before(async function () {
    this.timeout(60000);
    // circuit = await wasm_tester(join(__dirname, '../circuits/mlkem.circom'));
  });

  it('should generate the right 6144 bits (768 bytes) as interim signals', async () => {
    const randomness = crypto.randomBytes(32); // 32 bytes for randomness
    // const randomBits = bytesToBits(randomness);
    // const circuitInputs = {
    //   m: randomBits,
    // };
    // witness = await circuit.calculateWitness(circuitInputs);
    // // the shared secret is 1...256, which is 256 bits
    // console.log('witness 1-100: ', witness.slice(1, 101));
    // console.log('witness 101-200: ', witness.slice(101, 201));
    // console.log('witness 201-256: ', witness.slice(201, 257));
    // // the ciphertext is at index 257...282(257+25)
    // const array = witness.slice(257, 283);
    // console.log('witness 257-282: ', array);

    const sender = new MlKem512();
    const pkR = new Uint8Array(testKeyPair.pk);
    const [ct, ssS] = await sender.encap(pkR, new Uint8Array(randomness));
    console.log('shared secret: ', ssS);
    console.log('ciphertext: ', ct);
  }).timeout(60000);
});
