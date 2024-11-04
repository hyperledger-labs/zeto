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

const { expect } = require("chai");
const { join } = require("path");
const { wasm: wasm_tester } = require("circom_tester");
const {
  genRandomSalt,
  genKeypair,
  genEcdhSharedKey,
  formatPrivKeyForBabyJub,
  stringifyBigInts,
} = require("maci-crypto");
const {
  Poseidon,
  newSalt,
  poseidonDecrypt,
  newEncryptionNonce,
} = require("../index.js");

const poseidonHash = Poseidon.poseidon4;

describe("main circuit tests for Zeto fungible tokens with anonymity with encryption", () => {
  let circuit;

  const sender = {};
  const receiver = {};

  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(
      join(__dirname, "../../circuits/anon_enc.circom"),
    );

    let keypair = genKeypair();
    sender.privKey = keypair.privKey;
    sender.pubKey = keypair.pubKey;

    keypair = genKeypair();
    receiver.privKey = keypair.privKey;
    receiver.pubKey = keypair.pubKey;
  });

  it("should succeed for valid witness and produce an encypted value", async () => {
    const inputValues = [32, 40];
    const outputValues = [20, 52];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([
      BigInt(inputValues[0]),
      salt1,
      ...sender.pubKey,
    ]);
    const salt2 = newSalt();
    const input2 = poseidonHash([
      BigInt(inputValues[1]),
      salt2,
      ...sender.pubKey,
    ]);
    const inputCommitments = [input1, input2];

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([
      BigInt(outputValues[0]),
      salt3,
      ...receiver.pubKey,
    ]);
    const salt4 = newSalt();
    const output2 = poseidonHash([
      BigInt(outputValues[1]),
      salt4,
      ...sender.pubKey,
    ]);
    const outputCommitments = [output1, output2];

    const encryptionNonce = newEncryptionNonce();
    const ephemeralKeypair = genKeypair();
    const encryptInputs = stringifyBigInts({
      encryptionNonce,
      ecdhPrivateKey: formatPrivKeyForBabyJub(ephemeralKeypair.privKey),
    });

    const witness = await circuit.calculateWitness(
      {
        inputCommitments,
        inputValues,
        inputSalts: [salt1, salt2],
        inputOwnerPrivateKey: formatPrivKeyForBabyJub(sender.privKey),
        outputCommitments,
        outputValues,
        outputSalts: [salt3, salt4],
        outputOwnerPublicKeys: [receiver.pubKey, sender.pubKey],
        ...encryptInputs,
      },
      true,
    );

    // console.log("witness", witness.slice(0, 15));
    // console.log('senderPublicKey', sender.pubKey);
    // console.log('receiverPublicKey', receiver.pubKey);
    // console.log('ephemeralPubkey', ephemeralKeypair.pubKey);
    // console.log('inputCommitments', inputCommitments);
    // console.log('encryptionNonce', encryptionNonce);

    expect(witness[1]).to.equal(BigInt(ephemeralKeypair.pubKey[0]));
    expect(witness[2]).to.equal(BigInt(ephemeralKeypair.pubKey[1]));
    expect(witness[11]).to.equal(BigInt(inputCommitments[0]));
    expect(witness[12]).to.equal(BigInt(inputCommitments[1]));
    expect(witness[13]).to.equal(BigInt(outputCommitments[0]));
    expect(witness[14]).to.equal(BigInt(outputCommitments[1]));

    // take the output from the proof circuit and attempt to decrypt
    // as the receiver
    // decrypting the first utxo should succeed
    let cipherText = witness.slice(3, 7);
    let recoveredKey = genEcdhSharedKey(
      receiver.privKey,
      ephemeralKeypair.pubKey,
    );
    let plainText = poseidonDecrypt(
      cipherText,
      recoveredKey,
      encryptionNonce,
      2,
    );
    // use the recovered value (plainText[0]) and salt (plainText[1]) to verify the output commitment
    let calculatedHash = poseidonHash([
      BigInt(plainText[0]),
      BigInt(plainText[1]),
      ...receiver.pubKey,
    ]);
    expect(calculatedHash).to.equal(outputCommitments[0]);

    // decrypting the second utxo should fail as it belongs to the sender
    cipherText = witness.slice(7, 11);
    recoveredKey = genEcdhSharedKey(receiver.privKey, ephemeralKeypair.pubKey);
    expect(function () {
      plainText = poseidonDecrypt(cipherText, recoveredKey, encryptionNonce, 2);
    }).to.throw(
      "The last ciphertext element must match the second item of the permuted state",
    );

    // decrypt using the sender's key should success
    recoveredKey = genEcdhSharedKey(sender.privKey, ephemeralKeypair.pubKey);
    plainText = poseidonDecrypt(cipherText, recoveredKey, encryptionNonce, 2);
    calculatedHash = poseidonHash([
      BigInt(plainText[0]),
      BigInt(plainText[1]),
      ...sender.pubKey,
    ]);
    expect(calculatedHash).to.equal(outputCommitments[1]);
  });

  it("should fail to generate a witness because mass conservation is not obeyed", async () => {
    const inputValues = [15, 100];
    const outputValues = [90, 35];
    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([
      BigInt(inputValues[0]),
      salt1,
      ...sender.pubKey,
    ]);
    const salt2 = newSalt();
    const input2 = poseidonHash([
      BigInt(inputValues[1]),
      salt2,
      ...sender.pubKey,
    ]);
    const inputCommitments = [input1, input2];

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([
      BigInt(outputValues[0]),
      salt3,
      ...receiver.pubKey,
    ]);
    const output2 = poseidonHash([
      BigInt(outputValues[1]),
      salt3,
      ...sender.pubKey,
    ]);
    const outputCommitments = [output1, output2];

    const encryptionNonce = newEncryptionNonce();
    const ephemeralKeypair = genKeypair();
    const encryptInputs = stringifyBigInts({
      encryptionNonce,
      ecdhPrivateKey: formatPrivKeyForBabyJub(ephemeralKeypair.privKey),
    });

    let err;
    try {
      await circuit.calculateWitness(
        {
          inputCommitments,
          inputValues,
          inputSalts: [salt1, salt2],
          inputOwnerPrivateKey: formatPrivKeyForBabyJub(sender.privKey),
          outputCommitments,
          outputValues,
          outputSalts: [salt3, salt3],
          outputOwnerPublicKeys: [receiver.pubKey, sender.pubKey],
          ...encryptInputs,
        },
        true,
      );
    } catch (e) {
      err = e;
    }
    // console.log(err);
    expect(err).to.match(/Error in template CheckSum_93 line: 40/);
  });

  it("should failed to match output UTXO after decrypting the cipher texts from the events if using the wrong sender public keys", async () => {
    const inputValues = [32, 40];
    const outputValues = [20, 52];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([
      BigInt(inputValues[0]),
      salt1,
      ...sender.pubKey,
    ]);
    const salt2 = newSalt();
    const input2 = poseidonHash([
      BigInt(inputValues[1]),
      salt2,
      ...sender.pubKey,
    ]);
    const inputCommitments = [input1, input2];

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([
      BigInt(outputValues[0]),
      salt3,
      ...receiver.pubKey,
    ]);
    const salt4 = newSalt();
    const output2 = poseidonHash([
      BigInt(outputValues[1]),
      salt4,
      ...sender.pubKey,
    ]);
    const outputCommitments = [output1, output2];

    const encryptionNonce = newEncryptionNonce();
    const ephemeralKeypair = genKeypair();
    const encryptInputs = stringifyBigInts({
      encryptionNonce,
      ecdhPrivateKey: formatPrivKeyForBabyJub(ephemeralKeypair.privKey),
    });

    const witness = await circuit.calculateWitness(
      {
        inputCommitments,
        inputValues,
        inputSalts: [salt1, salt2],
        inputOwnerPrivateKey: formatPrivKeyForBabyJub(sender.privKey),
        outputCommitments,
        outputValues,
        outputSalts: [salt3, salt4],
        outputOwnerPublicKeys: [receiver.pubKey, sender.pubKey],
        ...encryptInputs,
      },
      true,
    );

    // take the output from the proof circuit and attempt to decrypt
    // as the receiver, but without using the correct sender public key
    const wrongSender = genKeypair();
    const cipherText = witness.slice(3, 7);
    const recoveredKey = genEcdhSharedKey(receiver.privKey, wrongSender.pubKey);
    // the decryption scheme has self-checking mechanism, so it should throw an error
    expect(function () {
      poseidonDecrypt(cipherText, recoveredKey, encryptionNonce, 2);
    }).to.throw(
      "The last ciphertext element must match the second item of the permuted state",
    );
  });
});
