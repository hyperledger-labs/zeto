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
const { convert256To254 } = require('../lib/util');

describe('sha256_signals circuit tests', () => {
  let circuit;

  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(join(__dirname, './circuits/sha256_signals.circom'));
  });

  it('should return an array of 256 numbers each for a bit in the hash', async function () {
    // make sure the inputs are in the field range and 256 bits long
    const n1 = Buffer.concat([Buffer.from('00', 'hex'), crypto.randomBytes(31)]);
    const n2 = Buffer.concat([Buffer.from('00', 'hex'), crypto.randomBytes(31)]);
    const n3 = Buffer.concat([Buffer.from('00', 'hex'), crypto.randomBytes(31)]);
    const b = Buffer.concat([n1, n2, n3]);
    expect(b.length).to.equal(96);

    const hash = crypto.createHash('sha256').update(b).digest('hex');
    const hashBuffer = Buffer.from(hash, 'hex');
    const computed_pubSignals = [BigInt(0), BigInt(0)];
    // Calculate h0: sum of the first 16 bytes
    for (let i = 0; i < 16; i++) {
      computed_pubSignals[0] += BigInt(hashBuffer[i] * 2 ** (8 * i));
    }
    // Calculate h1: sum of the next 16 bytes
    for (let i = 16; i < 32; i++) {
      computed_pubSignals[1] += BigInt(hashBuffer[i] * 2 ** (8 * (i - 16)));
    }
    // compare these with the console.log printout in Solidity
    console.log('computed_pubSignals[0]: ', computed_pubSignals[0]);
    console.log('computed_pubSignals[1]: ', computed_pubSignals[1]);

    const witness = await circuit.calculateWitness({ signals: [BigInt('0x' + n1.toString('hex')), BigInt('0x' + n2.toString('hex')), BigInt('0x' + n3.toString('hex'))] }, true);
    const hash_h0 = witness[1].toString(16);
    const hash_h1 = witness[2].toString(16);

    expect(hash_h0).to.equal(computed_pubSignals[0].toString(16));
    expect(hash_h1).to.equal(computed_pubSignals[1].toString(16));
  });
});
