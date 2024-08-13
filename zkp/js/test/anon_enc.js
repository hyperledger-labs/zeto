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
const { genRandomSalt, genKeypair, genEcdhSharedKey, formatPrivKeyForBabyJub, stringifyBigInts } = require('maci-crypto');
const { Poseidon, newSalt, poseidonDecrypt } = require('../index.js');

const poseidonHash = Poseidon.poseidon4;

describe('main circuit tests for Zeto fungible tokens with anonymity with encryption', () => {
  let circuit;

  const sender = {};
  const receiver = {};

  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(join(__dirname, '../../circuits/anon_enc.circom'));

    let keypair = genKeypair();
    sender.privKey = keypair.privKey;
    sender.pubKey = keypair.pubKey;

    keypair = genKeypair();
    receiver.privKey = keypair.privKey;
    receiver.pubKey = keypair.pubKey;
  });

  it('should succeed for valid witness and produce an encypted value', async () => {
    const inputValues = [32, 40];
    const outputValues = [20, 52];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(inputValues[0]), salt1, ...sender.pubKey]);
    const salt2 = newSalt();
    const input2 = poseidonHash([BigInt(inputValues[1]), salt2, ...sender.pubKey]);
    const inputCommitments = [input1, input2];

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(outputValues[0]), salt3, ...receiver.pubKey]);
    const salt4 = newSalt();
    const output2 = poseidonHash([BigInt(outputValues[1]), salt4, ...sender.pubKey]);
    const outputCommitments = [output1, output2];

    const encryptionNonce = genRandomSalt();
    const encryptInputs = stringifyBigInts({
      encryptionNonce,
      inputOwnerPrivateKey: formatPrivKeyForBabyJub(sender.privKey),
    });

    const witness = await circuit.calculateWitness(
      {
        inputCommitments,
        inputValues,
        inputSalts: [salt1, salt2],
        outputCommitments,
        outputValues,
        outputSalts: [salt3, salt4],
        outputOwnerPublicKeys: [receiver.pubKey, sender.pubKey],
        ...encryptInputs,
      },
      true
    );

    // console.log('witness', witness.slice(0, 15));
    // console.log('salt3', salt3);
    // console.log('inputCommitments', inputCommitments);
    // console.log('senderPublicKey', senderPubKey);
    // console.log('receiverPublicKey', receiverPubKey);
    // console.log('encryptionNonce', encryptionNonce);

    expect(witness[3]).to.equal(BigInt(inputCommitments[0]));
    expect(witness[4]).to.equal(BigInt(inputCommitments[1]));
    expect(witness[5]).to.equal(BigInt(outputCommitments[0]));
    expect(witness[6]).to.equal(BigInt(outputCommitments[1]));

    // take the output from the proof circuit and attempt to decrypt
    // as the receiver
    const cipherText = [witness[1], witness[2]]; // index 1 is the encrypted value, index 2 is the encrypted salt
    const recoveredKey = genEcdhSharedKey(receiver.privKey, sender.pubKey);
    const plainText = poseidonDecrypt(cipherText, recoveredKey, encryptionNonce);
    // use the recovered value (plainText[0]) and salt (plainText[1]) to verify the output commitment
    const calculatedHash = poseidonHash([BigInt(plainText[0]), BigInt(plainText[1]), ...receiver.pubKey]);
    expect(calculatedHash).to.equal(outputCommitments[0]);
  });

  it('should fail to generate a witness because mass conservation is not obeyed', async () => {
    const inputValues = [15, 100];
    const outputValues = [90, 35];
    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(inputValues[0]), salt1, ...sender.pubKey]);
    const salt2 = newSalt();
    const input2 = poseidonHash([BigInt(inputValues[1]), salt2, ...sender.pubKey]);
    const inputCommitments = [input1, input2];

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(outputValues[0]), salt3, ...receiver.pubKey]);
    const output2 = poseidonHash([BigInt(outputValues[1]), salt3, ...sender.pubKey]);
    const outputCommitments = [output1, output2];

    const encryptionNonce = genRandomSalt();
    const encryptInputs = stringifyBigInts({
      encryptionNonce,
      inputOwnerPrivateKey: formatPrivKeyForBabyJub(sender.privKey),
    });

    let err;
    try {
      await circuit.calculateWitness(
        {
          inputCommitments,
          inputValues,
          inputSalts: [salt1, salt2],
          outputCommitments,
          outputValues,
          outputSalts: [salt3, salt3],
          outputOwnerPublicKeys: [receiver.pubKey, sender.pubKey],
          ...encryptInputs,
        },
        true
      );
    } catch (e) {
      err = e;
    }
    // console.log(err);
    expect(err).to.match(/Error in template Zeto_100 line: 77/);
  });

  it('should failed to match output UTXO after decrypting the cipher texts from the events if using the wrong sender public keys', async () => {
    const inputValues = [32, 40];
    const outputValues = [20, 52];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(inputValues[0]), salt1, ...sender.pubKey]);
    const salt2 = newSalt();
    const input2 = poseidonHash([BigInt(inputValues[1]), salt2, ...sender.pubKey]);
    const inputCommitments = [input1, input2];

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(outputValues[0]), salt3, ...receiver.pubKey]);
    const salt4 = newSalt();
    const output2 = poseidonHash([BigInt(outputValues[1]), salt4, ...sender.pubKey]);
    const outputCommitments = [output1, output2];

    const encryptionNonce = genRandomSalt();
    const encryptInputs = stringifyBigInts({
      encryptionNonce,
      inputOwnerPrivateKey: formatPrivKeyForBabyJub(sender.privKey),
    });

    const witness = await circuit.calculateWitness(
      {
        inputCommitments,
        inputValues,
        inputSalts: [salt1, salt2],
        outputCommitments,
        outputValues,
        outputSalts: [salt3, salt4],
        outputOwnerPublicKeys: [receiver.pubKey, sender.pubKey],
        ...encryptInputs,
      },
      true
    );

    // take the output from the proof circuit and attempt to decrypt
    // as the receiver, but without using the correct sender public key
    const wrongSender = genKeypair();
    const cipherText = [witness[1], witness[2]]; // index 1 is the encrypted value, index 2 is the encrypted salt
    const recoveredKey = genEcdhSharedKey(receiver.privKey, wrongSender.pubKey);
    const plainText = poseidonDecrypt(cipherText, recoveredKey, encryptionNonce);
    // use the recovered value (plainText[0]) and salt (plainText[1]) to verify the output commitment
    const calculatedHash = poseidonHash([BigInt(plainText[0]), BigInt(plainText[1]), ...receiver.pubKey]);
    expect(calculatedHash).to.not.equal(outputCommitments[0]);
  });
});
