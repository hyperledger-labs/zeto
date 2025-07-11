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
const { testKeyPair } = require('./util');

describe('mlkem circuit tests', () => {
  let circuit, witness;

  before(async function () {
    this.timeout(60000);
    circuit = await wasm_tester(join(__dirname, '../circuits/mlkem.circom'));
  });

  it('should generate the right ciphertext as 25 254-bit signals and used to recover the shared secret', async () => {
    const randomness = crypto.randomBytes(32); // 32 bytes for randomness
    const randomBits = bytesToBits(randomness);
    const circuitInputs = {
      m: randomBits,
    };
    witness = await circuit.calculateWitness(circuitInputs);

    const KBits = witness.slice(1, 257);
    const KBytes = bitsToBytes(KBits.map((x) => Number(x)));

    const cNumbers = witness.slice(257, 257 + 25);
    const cBytes = [];
    for (let i = 0; i < 24; i++) {
      const bytes = bitsToBytes(cNumbers[i].toString(2).padStart(248, '0').split('').map(Number).reverse());
      cBytes.push(...bytes);
    }
    // The last number is 192 bits, so we need to handle it separately
    const lastBytes = bitsToBytes(cNumbers[24].toString(2).padStart(192, '0').split('').map(Number).reverse());
    cBytes.push(...lastBytes);

    const sender = new MlKem512();
    const pkR = new Uint8Array(testKeyPair.pk);
    const [ct, ssSender] = await sender.encap(pkR, new Uint8Array(randomness));

    expect(ct.length).to.equal(768);
    expect(ct).to.deep.equal(new Uint8Array(cBytes));
    expect(ssSender).to.deep.equal(new Uint8Array(KBytes));

    // check that the receiver can decap the ciphertext, and recover the same shared secret
    const receiver = new MlKem512();
    const ssReceiver = await receiver.decap(ct, new Uint8Array(testKeyPair.sk));
    expect(ssReceiver).to.deep.equal(new Uint8Array(KBytes));
  }).timeout(60000);
});
