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
const { groth16 } = require('snarkjs');
const { genRandomSalt, genKeypair, genEcdhSharedKey, formatPrivKeyForBabyJub, stringifyBigInts } = require('maci-crypto');
const { Poseidon, newSalt, poseidonDecrypt, loadCircuit } = require('../index.js');
const { loadProvingKeys } = require('./utils.js');

const ZERO_PUBKEY = [0, 0];
const poseidonHash = Poseidon.poseidon4;

describe('main circuit tests for Zeto fungible tokens with anonymity with encryption', () => {
  let circuit, provingKeyFile, verificationKey;

  const sender = {};
  const receiver = {};

  before(async () => {
    circuit = await loadCircuit('anon_enc');
    ({ provingKeyFile, verificationKey } = loadProvingKeys('anon_enc'));

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
      senderPrivateKey: formatPrivKeyForBabyJub(sender.privKey),
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
    expect(plainText).to.deep.equal([20n, salt3]);
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

    const sharedSecret = genEcdhSharedKey(sender.privKey, receiver.pubKey);
    const encryptionNonce = genRandomSalt();
    const encryptInputs = stringifyBigInts({
      encryptionNonce,
      senderPrivateKey: formatPrivKeyForBabyJub(sender.privKey),
    });

    let err;
    try {
      await circuit.calculateWTNSBin(
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

  it('should generate a valid proof that can be verified successfully', async () => {
    const inputValues = [115, 0];
    const outputValues = [115, 0];
    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(inputValues[0]), salt1, ...sender.pubKey]);
    const inputCommitments = [input1, 0];

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(outputValues[0]), salt3, ...receiver.pubKey]);
    const outputCommitments = [output1, 0];

    const encryptionNonce = genRandomSalt();
    const encryptInputs = stringifyBigInts({
      encryptionNonce,
      senderPrivateKey: formatPrivKeyForBabyJub(sender.privKey),
    });

    const startTime = Date.now();
    const witness = await circuit.calculateWTNSBin(
      {
        inputCommitments,
        inputValues,
        inputSalts: [salt1, 0],
        outputCommitments,
        outputValues,
        outputSalts: [salt3, 0],
        outputOwnerPublicKeys: [receiver.pubKey, ZERO_PUBKEY],
        ...encryptInputs,
      },
      true
    );

    const { proof, publicSignals } = await groth16.prove(provingKeyFile, witness);
    console.log('Proving time: ', (Date.now() - startTime) / 1000, 's');

    const success = await groth16.verify(verificationKey, publicSignals, proof);
    // console.log('inputCommitments', inputCommitments);
    // console.log('outputCommitments', outputCommitments);
    // console.log('senderPublicKey', sender.pubKey);
    // console.log('receiverPublicKey', receiver.pubKey);
    // console.log('encryptionNonce', encryptionNonce);
    // console.log('publicSignals', publicSignals);
    expect(success, true);
  }).timeout(60000);
});
