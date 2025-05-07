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
const { wasm: wasm_tester } = require('circom_tester');

describe('sha256_signals circuit tests', () => {
  let circuit;

  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(join(__dirname, './circuits/sha256_signals.circom'));
  });

  it('should return an array of 256 numbers each for a bit in the hash', async () => {
    const n1 = Buffer.from('0000000000000000000000000000000000000000000000000000000000001234', 'hex');
    const n2 = Buffer.from('0000000000000000000000000000000000000000000000000000000000001235', 'hex');
    const n3 = Buffer.from('0000000000000000000000000000000000000000000000000000000000001236', 'hex');
    const b = Buffer.concat([n1, n2, n3]);

    const hash = crypto.createHash('sha256').update(b).digest('hex');
    const buff = Buffer.from(hash, 'hex');
    // disgard the first 2 bits and replace them with 0, because the circuit
    // output is a 254 bit field element by replacing the first 2 bits with 0
    buff[0] = Buffer.from(parseInt('00' + buff[0].toString(2).padStart(8, '0').slice(2), 2).toString(16), 'hex')[0];
    const hash1 = buff.toString('hex');

    const witness = await circuit.calculateWitness({ signals: [4660, 4661, 4662] }, true);
    const hash2 = witness[1].toString(16);

    expect(hash2).to.equal(hash1);
  });
});
