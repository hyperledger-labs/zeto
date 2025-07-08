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
    circuit = await wasm_tester(join(__dirname, '../circuits/mlkem_encaps_internal.circom'));
  });

  it('should generate the right K and r signals', async () => {
    const randomness = [59, 33, 225, 54, 96, 22, 97, 134, 55, 158, 65, 251, 97, 133, 236, 153, 194, 58, 180, 157, 136, 222, 78, 71, 187, 20, 156, 248, 106, 26, 179, 146];
    const hashOfEk = [100, 230, 14, 143, 197, 150, 72, 151, 243, 148, 81, 201, 33, 192, 50, 191, 113, 47, 129, 36, 24, 204, 58, 241, 167, 98, 234, 57, 146, 73, 129, 157];

    const randomBits = bytesToBits(randomness);
    const circuitInputs = {
      m: randomBits,
    };
    witness = await circuit.calculateWitness(circuitInputs);

    const K = witness.slice(1, 257);
    const KBytes = bitsToBytes(K.map((x) => Number(x)));

    const c = witness.slice(257, 257 + 768 * 8);
    const cBytes = bitsToBytes(c.map((x) => Number(x)));
    console.log('c: ', Buffer.from(cBytes).toString('hex'));

    const sender = new MlKem512();
    const pkR = new Uint8Array(testKeyPair.pk);
    const [ct, ss] = await sender.encap(pkR, new Uint8Array(randomness));

    // ss is the shared secret, corresponds to K in the circuit
    expect(ss).to.deep.equal(new Uint8Array(KBytes));

    console.log('ciphertext: ', ct);
  }).timeout(60000);
});
