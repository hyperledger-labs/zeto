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
const { MlKem512 } = require('mlkem');
const { bitsToBytes, bytesToBits } = require('../../lib/util');
const { testKeyPair, h, g } = require('./util');

describe('kpke_enc circuit tests', () => {
  let circuit, witness;

  before(async function () {
    this.timeout(60000);
    circuit = await wasm_tester(join(__dirname, '../circuits/kpke_enc.circom'));
  });

  it('should generate the right 6144 bits (768 bytes) as output', async () => {
    const randomness = [59, 33, 225, 54, 96, 22, 97, 134, 55, 158, 65, 251, 97, 133, 236, 153, 194, 58, 180, 157, 136, 222, 78, 71, 187, 20, 156, 248, 106, 26, 179, 146];

    const pkR = new Uint8Array(testKeyPair.pk);
    const pkHash = h(pkR);
    const gBytes = g(new Uint8Array(randomness), pkHash);
    const K = gBytes[0];
    const r = gBytes[1];

    const circuitInputs = {
      randomness: bytesToBits(r),
      m: bytesToBits(randomness),
    };
    witness = await circuit.calculateWitness(circuitInputs);

    // the ciphertext is at index 1...6144, which is 768*8
    const ciphertext = witness.slice(1, 6145);
    const ctBytes = bitsToBytes(ciphertext.map((x) => Number(x)));

    const sender = new MlKem512();
    const [ct, ss] = await sender.encap(pkR, new Uint8Array(randomness));

    expect(ct).to.deep.equal(new Uint8Array(ctBytes));
    expect(ss).to.deep.equal(new Uint8Array(K));
  }).timeout(60000);
});
