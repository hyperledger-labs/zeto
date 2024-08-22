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
const { genKeypair, genEcdhSharedKey, stringifyBigInts } = require('maci-crypto');
const { poseidonEncrypt, poseidonDecrypt } = require('../../lib/util.js');

describe('Encryption circuit tests', () => {
  let circuit;
  let senderPrivKey, senderPubKey, receiverPrivKey, receiverPubKey;
  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(join(__dirname, '../circuits/encrypt.circom'));

    let keypair = genKeypair();
    senderPrivKey = keypair.privKey;
    senderPubKey = keypair.pubKey;

    keypair = genKeypair();
    receiverPrivKey = keypair.privKey;
    receiverPubKey = keypair.pubKey;
  });

  it('using poseidonEncrypt() to generate the cipher text, and poseidonDecrypt() to recover the plain text', async () => {
    const key = genEcdhSharedKey(senderPrivKey, receiverPubKey);
    const hex = crypto.randomBytes(16).toString('hex');
    const nonce = BigInt(`0x${hex}`);

    const result = await poseidonEncrypt([1234567890n, 2345678901n], key, nonce);

    const recoveredKey = genEcdhSharedKey(receiverPrivKey, senderPubKey);
    const plainText = await poseidonDecrypt(result, recoveredKey, nonce, 2);
    expect(plainText).to.deep.equal([1234567890n, 2345678901n]);
  });

  it('using poseidonEncrypt() to generate the cipher text with inputs longer than 3, and poseidonDecrypt() to recover the plain text', async () => {
    const key = genEcdhSharedKey(senderPrivKey, receiverPubKey);
    const hex = crypto.randomBytes(16).toString('hex');
    const nonce = BigInt(`0x${hex}`);

    const result = await poseidonEncrypt([1234567890n, 2345678901n, 3456789012n, 4567890123n], key, nonce);

    const recoveredKey = genEcdhSharedKey(receiverPrivKey, senderPubKey);
    const plainText = await poseidonDecrypt(result, recoveredKey, nonce, 4);
    expect(plainText).to.deep.equal([1234567890n, 2345678901n, 3456789012n, 4567890123n]);
  });

  it('should generate the cipher text in the proof circuit, which can be decrypted by the receiver', async () => {
    const key = genEcdhSharedKey(senderPrivKey, receiverPubKey);
    const hex = crypto.randomBytes(16).toString('hex');
    const nonce = BigInt(`0x${hex}`);

    const circuitInputs = stringifyBigInts({
      plainText: [1234567890, 2345678901],
      nonce,
      key,
    });

    const witness = await circuit.calculateWitness(circuitInputs);

    const ciphertext = witness.slice(1, 5).map((x) => BigInt(x));
    const recoveredKey = genEcdhSharedKey(receiverPrivKey, senderPubKey);

    const plainText = await poseidonDecrypt(ciphertext, recoveredKey, nonce, 2);
    expect(plainText).to.deep.equal([1234567890n, 2345678901n]);
  });
});
