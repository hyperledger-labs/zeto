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
const { readFileSync } = require('fs');
const { join } = require('path');
const { wasm: wasm_tester } = require('circom_tester');
const { genKeypair } = require('maci-crypto');
const { Poseidon, newSalt } = require('../../index.js');

const MAX_VALUE = 2n ** 40n - 1n;
const ZERO_PUBKEY = [0n, 0n];
const poseidonHash = Poseidon.poseidon4;

describe('check-hashes circuit tests', () => {
  let circuit;
  const sender = {};
  const receiver = {};

  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(join(__dirname, '../circuits/check-hashes.circom'));

    let keypair = genKeypair();
    sender.privKey = keypair.privKey;
    sender.pubKey = keypair.pubKey;

    keypair = genKeypair();
    receiver.privKey = keypair.privKey;
    receiver.pubKey = keypair.pubKey;
  });

  it('should return true for valid witness', async () => {
    const values = [32, 40];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(values[0]), salt1, ...sender.pubKey]);
    const salt2 = newSalt();
    const input2 = poseidonHash([BigInt(values[1]), salt2, ...sender.pubKey]);
    const commitments = [input1, input2];

    const witness = await circuit.calculateWitness(
      {
        commitments,
        values,
        salts: [salt1, salt2],
        ownerPublicKeys: [sender.pubKey, sender.pubKey],
      },
      true
    );

    // console.log(witness.slice(0, 10));
    // console.log('commitments', commitments);
    // console.log('sender public key', sender.pubKey);
    expect(witness[1]).to.equal(BigInt(commitments[0]));
    expect(witness[2]).to.equal(BigInt(commitments[1]));
    expect(witness[3]).to.equal(BigInt(sender.pubKey[0]));
    expect(witness[4]).to.equal(BigInt(sender.pubKey[1]));
  });

  it('should return true for valid witness using a single input value', async () => {
    const values = [72, 0];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(values[0]), salt1, ...sender.pubKey]);
    const commitments = [input1, 0];

    const witness = await circuit.calculateWitness(
      {
        commitments,
        values,
        salts: [salt1, 0],
        ownerPublicKeys: [sender.pubKey, [0n, 0n]],
      },
      true
    );

    expect(witness[1]).to.equal(BigInt(commitments[0]));
    expect(witness[2]).to.equal(BigInt(commitments[1]));
    expect(witness[3]).to.equal(BigInt(sender.pubKey[0]));
    expect(witness[4]).to.equal(BigInt(sender.pubKey[1]));
  });

  it('should return true for valid witness using a single input value', async () => {
    const values = [0, 72];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(values[1]), salt1, ...sender.pubKey]);
    const commitments = [0n, input1];

    const witness = await circuit.calculateWitness(
      {
        commitments,
        values,
        salts: [0, salt1],
        ownerPublicKeys: [[0n, 0n], sender.pubKey],
      },
      true
    );

    expect(witness[1]).to.equal(BigInt(commitments[0]));
    expect(witness[2]).to.equal(BigInt(commitments[1]));
    expect(witness[3]).to.equal(0n);
    expect(witness[4]).to.equal(0n);
    expect(witness[5]).to.equal(BigInt(sender.pubKey[0]));
    expect(witness[6]).to.equal(BigInt(sender.pubKey[1]));
  });

  it('should fail to generate a witness because of invalid input commitments', async () => {
    const inputValues = [25, 100];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(inputValues[0]), salt1, ...sender.pubKey]);
    const salt2 = newSalt();
    const input2 = poseidonHash([BigInt(inputValues[1]), salt2, ...sender.pubKey]);
    const inputCommitments = [input1 + BigInt(1), input2];

    let error;
    try {
      await circuit.calculateWitness(
        {
          commitments: inputCommitments,
          values: inputValues,
          salts: [salt1, salt2],
          ownerPublicKeys: [sender.pubKey, sender.pubKey],
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckHashes_74 line: 60/); // hash check failed
  });
});
