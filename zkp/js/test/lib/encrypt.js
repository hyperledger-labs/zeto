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
const path = require('path');
const { readFileSync } = require('fs');
const { genRandomSalt, genKeypair, genEcdhSharedKey, stringifyBigInts } = require('maci-crypto');
const { poseidonDecrypt } = require('../../lib/util.js');

describe('Encryption circuit tests', () => {
  let circuit;
  let senderPrivKey, senderPubKey, receiverPrivKey, receiverPubKey;
  before(async () => {
    circuit = await loadCircuits();

    let keypair = genKeypair();
    senderPrivKey = keypair.privKey;
    senderPubKey = keypair.pubKey;

    keypair = genKeypair();
    receiverPrivKey = keypair.privKey;
    receiverPubKey = keypair.pubKey;
  });

  it('should generate the cipher text in the proof circuit, which can be decrypted by the receiver', async () => {
    const messageAndSalt = [1234567890, 24680135791234567890].map((x) => BigInt(x));

    const key = genEcdhSharedKey(senderPrivKey, receiverPubKey);
    const nonce = genRandomSalt();

    const circuitInputs = stringifyBigInts({
      plainText: messageAndSalt,
      nonce,
      key,
    });

    const witness = await circuit.calculateWitness(circuitInputs);

    const encryptedValue = witness[1];
    const encryptedNonce = witness[2];
    const recoveredKey = genEcdhSharedKey(receiverPrivKey, senderPubKey);
    const plainText = poseidonDecrypt([encryptedValue, encryptedNonce], recoveredKey, nonce);
    expect(plainText).to.deep.equal(messageAndSalt);
  });
});

// the circuit is a library, to test it we need a top-level circuit with "main"
// which is placed in the test/circuits directory
async function loadCircuits() {
  const WitnessCalculator = require('../circuits/encrypt_js/witness_calculator.js');
  const buffer = readFileSync(path.join(__dirname, '../circuits/encrypt_js/encrypt.wasm'));
  const circuit = await WitnessCalculator(buffer);
  return circuit;
}
