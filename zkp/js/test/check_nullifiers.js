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
const { genKeypair, formatPrivKeyForBabyJub } = require('maci-crypto');
const { Poseidon, newSalt } = require('../index.js');

const poseidonHash4 = Poseidon.poseidon4;
const poseidonHash3 = Poseidon.poseidon3;

describe('check_nullifiers circuit tests', () => {
  let circuit;
  const sender = {};
  const receiver = {};
  let senderPrivateKey;

  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(join(__dirname, '../../circuits/check_nullifiers.circom'));

    let keypair = genKeypair();
    sender.privKey = keypair.privKey;
    sender.pubKey = keypair.pubKey;
    senderPrivateKey = formatPrivKeyForBabyJub(sender.privKey);

    keypair = genKeypair();
    receiver.privKey = keypair.privKey;
    receiver.pubKey = keypair.pubKey;
  });

  it('should return true for valid witness', async () => {
    const inputValues = [32, 40];

    // create two input UTXOs
    const salt1 = newSalt();
    const input1 = poseidonHash4([BigInt(inputValues[0]), salt1, ...sender.pubKey]);
    const salt2 = newSalt();
    const input2 = poseidonHash4([BigInt(inputValues[1]), salt2, ...sender.pubKey]);
    const inputCommitments = [input1, input2];

    // create two input nullifiers, corresponding to the input UTXOs
    const nullifier1 = poseidonHash3([BigInt(inputValues[0]), salt1, senderPrivateKey]);
    const nullifier2 = poseidonHash3([BigInt(inputValues[1]), salt2, senderPrivateKey]);
    const nullifiers = [nullifier1, nullifier2];

    const witness = await circuit.calculateWitness(
      {
        nullifiers,
        inputCommitments,
        inputValues,
        inputSalts: [salt1, salt2],
        inputOwnerPrivateKey: senderPrivateKey,
      },
      true
    );

    // console.log('nullifiers', nullifiers);
    // console.log('input commitments', inputCommitments);
    // console.log('inputValues', inputValues);
    // console.log('inputSalts', [salt1, salt2]);
    // console.log('owner private key', senderPrivateKey);
    // console.log(witness.slice(0, 15));

    expect(witness[1]).to.equal(BigInt(nullifiers[0]));
    expect(witness[2]).to.equal(BigInt(nullifiers[1]));
    expect(witness[3]).to.equal(BigInt(inputCommitments[0]));
    expect(witness[4]).to.equal(BigInt(inputCommitments[1]));
    expect(witness[5]).to.equal(BigInt(inputValues[0]));
    expect(witness[6]).to.equal(BigInt(inputValues[1]));
  });

  it('should fail to generate a witness because incorrect values are not used', async () => {
    const inputValues = [15, 100];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash4([BigInt(inputValues[0]), salt1, ...sender.pubKey]);
    const salt2 = newSalt();
    const input2 = poseidonHash4([BigInt(inputValues[1]), salt2, ...sender.pubKey]);
    const inputCommitments = [input1, input2];

    // create two input nullifiers, corresponding to the input UTXOs
    const nullifier1 = poseidonHash3([BigInt(inputValues[0]), salt1, senderPrivateKey]);
    const nullifier2 = poseidonHash3([BigInt(inputValues[1] + 1), salt2, senderPrivateKey]);
    const nullifiers = [nullifier1, nullifier2];

    let err;
    try {
      await circuit.calculateWitness(
        {
          nullifiers,
          inputCommitments,
          inputValues,
          inputSalts: [salt1, salt2],
          inputOwnerPrivateKey: senderPrivateKey,
        },
        true
      );
    } catch (e) {
      err = e;
    }
    // console.log(err);
    expect(err).to.match(/Error in template Zeto_157 line: 62/);
  });
});
