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
    const hack = [
      153, 180, 68, 235, 189, 233, 191, 4, 236, 89, 22, 35, 178, 239, 102, 163, 71, 123, 55, 19, 165, 82, 197, 168, 222, 159, 54, 198, 122, 202, 46, 61, 71, 249, 202, 155, 165, 186, 117, 41, 235, 141,
      35, 149, 53, 129, 42, 95, 212, 128, 192, 80, 112, 120, 127, 192, 205, 189, 251, 33, 173, 173, 209, 111, 0, 208, 195, 74, 118, 98, 48, 178, 40, 203, 127, 185, 133, 93, 106, 112, 154, 50, 56, 184,
      51, 20, 48, 2, 153, 106, 230, 56, 31, 252, 43, 23, 133, 140, 101, 183, 92, 250, 234, 28, 192, 208, 54, 250, 254, 120, 214, 74, 140, 53, 236, 105, 36, 182, 61, 100, 161, 226, 69, 83, 148, 134,
      252, 102, 226, 97, 203, 135, 10, 211, 251, 52, 154, 236, 218, 31, 236, 237, 252, 36, 25, 28, 150, 249, 52, 121, 152, 78, 9, 180, 23, 211, 126, 133, 153, 69, 197, 208, 190, 241, 118, 207, 183,
      27, 127, 51, 78, 77, 203, 153, 57, 21, 165, 163, 218, 41, 72, 219, 42, 130, 246, 112, 178, 196, 125, 46, 249, 103, 12, 28, 209, 111, 134, 22, 178, 180, 248, 88, 239, 238, 183, 191, 191, 235,
      219, 239, 102, 91, 90, 37, 218, 170, 234, 76, 91, 208, 38, 23, 74, 215, 14, 49, 149, 60, 145, 150, 3, 11, 251, 182, 73, 231, 14, 95, 217, 195, 182, 171, 2, 171, 19, 234, 75, 157, 205, 141, 181,
      171, 227, 213, 212, 44, 159, 98, 183, 226, 99, 144, 219, 130, 92, 110, 65, 184, 4, 2, 228, 3, 159, 193, 180, 197, 79, 248, 55, 139, 73, 238, 189, 48, 102, 251, 155, 199, 19, 14, 205, 136, 186,
      253, 214, 230, 253, 171, 217, 157, 23, 191, 73, 242, 132, 144, 134, 38, 255, 202, 79, 191, 124, 17, 103, 7, 55, 166, 5, 16, 82, 103, 169, 250, 141, 231, 235, 218, 185, 26, 125, 37, 95, 68, 72,
      248, 78, 214, 49, 88, 204, 17, 106, 221, 149, 143, 225, 254, 230, 120, 5, 166, 34, 200, 9, 60, 204, 9, 72, 205, 85, 231, 104, 186, 17, 172, 183, 67, 222, 23, 184, 112, 235, 253, 54, 150, 70, 42,
      73, 68, 233, 174, 108, 200, 42, 240, 108, 88, 54, 31, 217, 176, 29, 139, 231, 201, 132, 118, 104, 205, 47, 226, 184, 119, 199, 152, 49, 164, 123, 255, 16, 176, 83, 10, 140, 215, 228, 222, 202,
      64, 88, 213, 123, 106, 246, 53, 208, 42, 2, 43, 80, 203, 8, 155, 12, 216, 15, 221, 82, 20, 137, 22, 99, 66, 254, 146, 238, 82, 139, 25, 202, 33, 89, 156, 30, 48, 226, 103, 130, 148, 197, 126,
      23, 131, 211, 75, 155, 62, 231, 73, 32, 151, 196, 231, 226, 0, 249, 180, 140, 111, 18, 4, 60, 240, 76, 199, 81, 248, 84, 10, 117, 15, 191, 189, 209, 163, 146, 37, 185, 128, 54, 214, 175, 96,
      215, 150, 138, 140, 228, 102, 60, 133, 11, 185, 130, 110, 160, 121, 197, 129, 57, 150, 43, 222, 191, 64, 80, 107, 122, 33, 132, 67, 85, 141, 97, 124, 82, 173, 216, 224, 102, 220, 210, 24, 51,
      192, 167, 135, 19, 212, 218, 170, 74, 105, 104, 58, 237, 203, 181, 197, 77, 23, 92, 210, 143, 195, 129, 37, 205, 61, 98, 61, 112, 36, 245, 192, 225, 83, 81, 159, 134, 235, 86, 221, 172, 191,
      213, 5, 131, 183, 118, 196, 78, 206, 255, 9, 32, 58, 10, 189, 63, 95, 45, 85, 106, 74, 115, 51, 112, 123, 59, 45, 148, 13, 237, 84, 223, 249, 210, 176, 16, 228, 207, 248, 180, 91, 210, 71, 150,
      167, 205, 123, 140, 39, 66, 3, 110, 249, 38, 86, 41, 181, 163, 96, 211, 181, 98, 58, 133, 136, 250, 23, 117, 4, 207, 219, 168, 118, 85, 200, 123, 30, 143, 56, 117, 197, 242, 205, 130, 45, 200,
      77, 51, 56, 31, 41, 151, 118, 118, 162, 204, 65, 112, 243, 109, 142, 224, 81, 250, 103, 25, 91, 9, 189, 105, 23, 75, 95, 167, 149, 49, 103, 76, 105, 74, 67, 75, 3, 43, 103, 30, 157, 71, 34, 103,
      136, 198, 229, 206, 182, 11, 255, 246, 247, 16, 221, 142, 40, 137, 89, 63, 23, 151, 111, 31, 74, 70, 38, 210, 240, 18, 209, 62, 111, 84, 203, 151, 195, 212, 18, 203, 83, 2, 98, 120, 73, 251, 3,
      220, 241, 162, 8, 76, 55, 163, 201, 118, 42,
    ];
    const buff = Buffer.alloc(hack.length);
    for (let i = 0; i < hack.length; i++) {
      buff.writeUInt8(hack[i], i);
    }
    const b = Buffer.concat([n1, n2, n3, buff]);

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

    const witness = await circuit.calculateWitness(
      {
        signals: [BigInt('0x' + n1.toString('hex')), BigInt('0x' + n2.toString('hex')), BigInt('0x' + n3.toString('hex'))],
        ciphertext_bytes: hack,
      },
      true
    );
    const hash_h0 = witness[1].toString(16);
    const hash_h1 = witness[2].toString(16);

    expect(hash_h0).to.equal(computed_pubSignals[0].toString(16));
    expect(hash_h1).to.equal(computed_pubSignals[1].toString(16));
  });
});
