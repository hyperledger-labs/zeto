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
const { sha3_256, sha3_512 } = require('@noble/hashes/sha3');
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
    const hashOfEk = [100, 230, 14, 143, 197, 150, 72, 151, 243, 148, 81, 201, 33, 192, 50, 191, 113, 47, 129, 36, 24, 204, 58, 241, 167, 98, 234, 57, 146, 73, 129, 157];

    // the above hashOfEk is statically encoded in the circuit,
    // with each byte in the Little Endian format
    const pkR = new Uint8Array(testKeyPair.pk);
    const pkHash = h(pkR);
    expect(pkHash).deep.equal(new Uint8Array(hashOfEk));

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

    const gBytes = g(new Uint8Array(randomness), pkHash);
    expect(gBytes[0]).deep.equal(new Uint8Array(KBytes));
    expect(gBytes[1]).deep.equal(new Uint8Array(rBytes));
  }).timeout(60000);
});

// copied from node_modules/mlkem/script/src/mlKemBase.js
function h(pk) {
  const hash = sha3_256.create();
  hash.update(pk);
  return hash.digest();
}

function g(m, hpk) {
  const hash = sha3_512.create();
  hash.update(m);
  hash.update(hpk);
  const res = hash.digest();
  return [res.subarray(0, 32), res.subarray(32, 64)];
}
