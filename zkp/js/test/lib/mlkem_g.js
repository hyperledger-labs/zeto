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
const { testKeyPair, h, g } = require('./util');

describe('mlkem protocol G(m || H(ek)) circuit tests', () => {
  let circuit;

  before(async function () {
    this.timeout(60000);
    circuit = await wasm_tester(join(__dirname, '../circuits/mlkem_g.circom'));
  });

  it('verify the hash of the public key in the circuit is properly set', async () => {
    // the hashOfEk is statically encoded in the circuit,
    // with each byte in the Little Endian format
    const hashOfEk = [
      0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1,
      1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0,
      0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1,
      0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1,
    ];
    const hashOfEkBytes = bitsToBytes(hashOfEk);
    const pkR = new Uint8Array(testKeyPair.pk);
    const pkHash = h(pkR);
    expect(pkHash).deep.equal(new Uint8Array(hashOfEkBytes));
  });

  it('should generate the right K and r signals', async () => {
    const randomness = [59, 33, 225, 54, 96, 22, 97, 134, 55, 158, 65, 251, 97, 133, 236, 153, 194, 58, 180, 157, 136, 222, 78, 71, 187, 20, 156, 248, 106, 26, 179, 146];

    // the circuit expects the input to be in a bit array,
    // with each byte in the Little Endian format
    const randomBits = bytesToBits(randomness);
    const circuitInputs = {
      m: randomBits,
    };
    witness = await circuit.calculateWitness(circuitInputs);

    const K = witness.slice(1, 257);
    const r = witness.slice(257, 513);
    // encode the output bits, in Little Endian format,
    // as bytes to compare with the expected output
    const KBytes = bitsToBytes(K.map((x) => Number(x)));
    const rBytes = bitsToBytes(r.map((x) => Number(x)));

    const pkR = new Uint8Array(testKeyPair.pk);
    const pkHash = h(pkR);
    const gBytes = g(new Uint8Array(randomness), pkHash);
    expect(gBytes[0]).deep.equal(new Uint8Array(KBytes));
    expect(gBytes[1]).deep.equal(new Uint8Array(rBytes));
  }).timeout(60000);
});
