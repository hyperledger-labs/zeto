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

describe('SHA3_512_bytes circuit tests', () => {
  let circuit;
  before(async function () {
    this.timeout(60000);
    circuit = await wasm_tester(join(__dirname, '../circuits/sha3_bytes.circom'));
  });

  it('should generate the right sha3 hash', async () => {
    const circuitInputs = {
      inp_bytes: [49, 50],
    };
    const witness = await circuit.calculateWitness(circuitInputs);
    const array = witness.slice(1, 65);
    const hash = Buffer.from(array.map((x) => Number(x))).toString('hex');
    expect(hash).to.equal('f235c129089233ce3c9c85f1d1554b9cb21952b27e0765bcbcf75d550dd4d2874e546889da5c44db9c066e05e268f4742d672889ff62fb9cb18a3d1b57f00658');
  });
});

describe('SHA3_512 (bits) circuit tests', () => {
  let circuit;
  before(async function () {
    this.timeout(60000);
    circuit = await wasm_tester(join(__dirname, '../circuits/sha3_bits.circom'));
  });

  it('should generate the right sha3 hash', async () => {
    const inputBits = bytesToBits([49, 50]);
    const circuitInputs = {
      inp: inputBits,
    };
    const witness = await circuit.calculateWitness(circuitInputs);
    const array = witness.slice(1, 513);
    const hash = Buffer.from(bitsToBytes(array.map((x) => Number(x)))).toString('hex');
    expect(hash).to.equal('f235c129089233ce3c9c85f1d1554b9cb21952b27e0765bcbcf75d550dd4d2874e546889da5c44db9c066e05e268f4742d672889ff62fb9cb18a3d1b57f00658');
  });
});

describe('Keccak_512_bytes circuit tests', () => {
  let circuit;
  before(async function () {
    this.timeout(60000);
    circuit = await wasm_tester(join(__dirname, '../circuits/keccak_bytes.circom'));
  });

  it('should generate the right keccak hash', async () => {
    const circuitInputs = {
      inp_bytes: [49, 50],
    };
    const witness = await circuit.calculateWitness(circuitInputs);
    const array = witness.slice(1, 65);
    const hash = Buffer.from(array.map((x) => Number(x))).toString('hex');
    expect(hash).to.equal('aa42aca73bd7f8a17e987f281422b266e44f0de1615d2d393c620c8c5a2c80b4f06178c8455bf98179603f2f1bcb30b2559f282c799e40533b0665f97a2a706a');
  });
});

describe('Unpack bytes circuit tests', () => {
  let circuit;
  before(async function () {
    this.timeout(60000);
    circuit = await wasm_tester(join(__dirname, '../circuits/unpack_bytes.circom'));
  });

  it('test bytesToBits() is equivalent to the UnpackBytes circuit', async () => {
    const bytes = [49, 50];
    const circuitInputs = {
      bytes,
    };
    const witness = await circuit.calculateWitness(circuitInputs);
    const array = witness.slice(1, 17);
    const expectedBits = bytesToBits(bytes).map((bit) => BigInt(bit));
    expect(array).to.deep.equal(expectedBits);
  });
});

describe('Pack bytes circuit tests', () => {
  let circuit;
  before(async function () {
    this.timeout(60000);
    circuit = await wasm_tester(join(__dirname, '../circuits/pack_bytes.circom'));
  });

  it('test bitToBytes() is equivalent to the PackBits circuit', async () => {
    const bits = [1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0];
    const circuitInputs = {
      bits,
    };
    const witness = await circuit.calculateWitness(circuitInputs);
    const array = witness.slice(1, 3);
    const expectedBytes = bitsToBytes(bits);
    expect(array).to.deep.equal(expectedBytes.map((byte) => BigInt(byte)));
  });
});

describe('bitsToBytes and bytesToBits functions', () => {
  it('should convert bits to bytes and back to bits', () => {
    const bits = [1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0];
    const bytes = bitsToBytes(bits);
    const backToBits = bytesToBits(bytes);
    expect(backToBits).to.deep.equal(bits);
  });

  it('should convert bytes to bits and back to bytes', () => {
    const bytes = [49, 50];
    const bits = bytesToBits(bytes);
    const backToBytes = bitsToBytes(bits);
    expect(backToBytes).to.deep.equal(bytes);
  });
});
