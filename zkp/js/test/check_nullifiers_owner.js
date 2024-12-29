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

const poseidonHash3 = Poseidon.poseidon3;

describe('check_nullifiers_owner circuit tests', () => {
  let circuit;
  const sender = {};
  const receiver = {};
  let senderPrivateKey;

  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(join(__dirname, '../../circuits/check_nullifiers_owner.circom'));

    let keypair = genKeypair();
    sender.privKey = keypair.privKey;
    sender.pubKey = keypair.pubKey;
    senderPrivateKey = formatPrivKeyForBabyJub(sender.privKey);

    keypair = genKeypair();
    receiver.privKey = keypair.privKey;
    receiver.pubKey = keypair.pubKey;
  });

  it('should return true for valid witness', async () => {
    const values = [32, 40];
    const salt1 = newSalt();
    const salt2 = newSalt();

    // create two input nullifiers, corresponding to the input UTXOs
    const nullifier1 = poseidonHash3([BigInt(values[0]), salt1, senderPrivateKey]);
    const nullifier2 = poseidonHash3([BigInt(values[1]), salt2, senderPrivateKey]);
    const nullifiers = [nullifier1, nullifier2];

    const witness = await circuit.calculateWitness(
      {
        nullifiers,
        values,
        salts: [salt1, salt2],
        ownerPrivateKey: senderPrivateKey,
      },
      true
    );

    // console.log('nullifiers', nullifiers);
    // console.log('inputValues', inputValues);
    // console.log('inputSalts', [salt1, salt2]);
    // console.log('owner private key', senderPrivateKey);
    // console.log(witness.slice(0, 15));

    expect(witness[1]).to.equal(BigInt(nullifiers[0]));
    expect(witness[2]).to.equal(BigInt(nullifiers[1]));
    expect(witness[3]).to.equal(BigInt(values[0]));
    expect(witness[4]).to.equal(BigInt(values[1]));
    expect(witness[7]).to.equal(senderPrivateKey);
  });

  it('should fail to generate a witness because incorrect values are not used', async () => {
    const values = [15, 100];
    const salt1 = newSalt();
    const salt2 = newSalt();

    // create two input nullifiers, corresponding to the input UTXOs
    const nullifier1 = poseidonHash3([BigInt(values[0]), salt1, senderPrivateKey]);
    const nullifier2 = poseidonHash3([BigInt(values[1] + 1), salt2, senderPrivateKey]);
    const nullifiers = [nullifier1, nullifier2];

    let err;
    try {
      await circuit.calculateWitness(
        {
          nullifiers,
          values,
          salts: [salt1, salt2],
          ownerPrivateKey: senderPrivateKey,
        },
        true
      );
    } catch (e) {
      err = e;
    }
    // console.log(err);
    expect(err).to.match(/Error in template CheckNullifiers_72 line: 51/);
  });
});
