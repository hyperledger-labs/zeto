// Copyright © 2025 Kaleido, Inc.
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
const { MlKem512 } = require('mlkem');
const { poseidonDecrypt } = require('../index.js');
const { wasm: wasm_tester } = require('circom_tester');
const { genKeypair, formatPrivKeyForBabyJub } = require('maci-crypto');
const { Merkletree, InMemoryDB, str2Bytes, ZERO_HASH } = require('@iden3/js-merkletree');
const { Poseidon, newSalt, newEncryptionNonce } = require('../index.js');
const { bytesToBits, publicKeyFromSeed, recoverMlKemCiphertextBytes } = require('../lib/util.js');
const { testKeyPair } = require('./lib/util.js');

const SMT_HEIGHT = 64;
const poseidonHash = Poseidon.poseidon4;
const poseidonHash3 = Poseidon.poseidon3;

describe('main circuit tests for Zeto fungible tokens with anonymity using nullifiers and Kyber encryption for auditability', () => {
  let circuit, smtAlice, smtBob;

  const Alice = {};
  const Bob = {};
  let senderPrivateKey;

  before(async function () {
    this.timeout(120000);

    circuit = await wasm_tester(join(__dirname, '../../circuits/anon_nullifier_qurrency_transfer.circom'));

    let keypair = genKeypair();
    Alice.privKey = keypair.privKey;
    Alice.pubKey = keypair.pubKey;
    senderPrivateKey = formatPrivKeyForBabyJub(Alice.privKey);

    keypair = genKeypair();
    Bob.privKey = keypair.privKey;
    Bob.pubKey = keypair.pubKey;

    // initialize the local storage for Alice to manage her UTXOs in the Spart Merkle Tree
    const storage1 = new InMemoryDB(str2Bytes(''));
    smtAlice = new Merkletree(storage1, true, SMT_HEIGHT);

    // initialize the local storage for Bob to manage his UTXOs in the Spart Merkle Tree
    const storage2 = new InMemoryDB(str2Bytes(''));
    smtBob = new Merkletree(storage2, true, SMT_HEIGHT);
  });

  it('should succeed for valid witness - input size = 2', async function () {
    this.timeout(120000);

    const inputValues = [32, 40];
    const outputValues = [20, 52];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(inputValues[0]), salt1, ...Alice.pubKey]);
    const salt2 = newSalt();
    const input2 = poseidonHash([BigInt(inputValues[1]), salt2, ...Alice.pubKey]);
    const inputCommitments = [input1, input2];
    const inputSalts = [salt1, salt2];

    // create the nullifiers for the inputs
    const nullifier1 = poseidonHash3([BigInt(inputValues[0]), salt1, senderPrivateKey]);
    const nullifier2 = poseidonHash3([BigInt(inputValues[1]), salt2, senderPrivateKey]);
    const nullifiers = [nullifier1, nullifier2];

    // calculate the root of the SMT
    await smtAlice.add(input1, input1);
    await smtAlice.add(input2, input2);

    // generate the merkle proof for the inputs
    const proof1 = await smtAlice.generateCircomVerifierProof(input1, ZERO_HASH);
    const proof2 = await smtAlice.generateCircomVerifierProof(input2, ZERO_HASH);

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(outputValues[0]), salt3, ...Bob.pubKey]);
    const salt4 = newSalt();
    const output2 = poseidonHash([BigInt(outputValues[1]), salt4, ...Alice.pubKey]);
    const outputCommitments = [output1, output2];
    const outputSalts = [salt3, salt4];
    const enabled = [1, 1];

    const randomness = crypto.randomBytes(32); // 32 bytes for randomness
    const m = bytesToBits(randomness);
    const encryptionNonce = newEncryptionNonce();

    const witness = await circuit.calculateWitness(
      {
        nullifiers,
        inputCommitments,
        inputValues,
        inputSalts: inputSalts,
        inputOwnerPrivateKey: senderPrivateKey,
        root: proof1.root.bigInt(),
        merkleProof: [proof1.siblings.map((s) => s.bigInt()), proof2.siblings.map((s) => s.bigInt())],
        enabled,
        outputCommitments,
        outputValues,
        outputSalts: outputSalts,
        outputOwnerPublicKeys: [Bob.pubKey, Alice.pubKey],
        randomness: m,
        encryptionNonce,
      },
      true
    );

    await circuit.checkConstraints(witness);

    // console.log('nullifiers', nullifiers);
    // console.log('inputCommitments', inputCommitments);
    // console.log('inputValues', inputValues);
    // console.log('root', proof1.root.bigInt());
    // console.log('inputSalts', [salt1, salt2]);
    // console.log('inputOwnerPrivateKey', senderPrivateKey);
    // console.log('inputOwnerPublicKey', Alice.pubKey);
    // console.log('outputCommitments', outputCommitments);
    // console.log('outputValues', outputValues);
    // console.log('outputSalts', [salt3, salt4]);
    // console.log('outputOwnerPublicKeys', [Bob.pubKey, Alice.pubKey]);

    // the first 25 signals are the encapsulated shared secret for ML-KEM
    const kemCiphertext = witness.slice(1, 26);
    // the receiver can build the encapsulated shared secret from the public signals
    const cBytes = recoverMlKemCiphertextBytes(kemCiphertext);

    // verify the circuit witnesses were generated correctly
    const sender = new MlKem512();
    const pkR = new Uint8Array(testKeyPair.pk);
    const [ct, _] = await sender.encap(pkR, new Uint8Array(randomness));
    expect(ct.length).to.equal(768);
    expect(ct).to.deep.equal(new Uint8Array(cBytes));

    // the receiver can decap the ciphertext, and recover the shared secret
    // using the mlkem ciphertext and the receiver's private key
    const receiver = new MlKem512();
    const ssReceiver = await receiver.decap(new Uint8Array(cBytes), new Uint8Array(testKeyPair.sk));
    // corresponding to the logic in the circuit "pubkey.circom", we derive the symmetric key
    // from the shared secret
    expect(ssReceiver.length).to.equal(32);
    const recoveredKey = publicKeyFromSeed(ssReceiver);

    // the next 16 (14 encrypted elements, so 3n+1 is 16) signals are the
    // cipher text for the symmetric encryption of the output secrets
    const encryptedElementsLength = 14;
    const l = 16; // the length of the cipher text is 16
    const cipherTexts = witness.slice(26, 26 + l);

    let plainText = poseidonDecrypt(cipherTexts, recoveredKey, encryptionNonce, encryptedElementsLength);
    // input owner public key
    expect(plainText[0]).to.equal(BigInt(Alice.pubKey[0]));
    expect(plainText[1]).to.equal(BigInt(Alice.pubKey[1]));
    // input values and salts
    expect(plainText[2]).to.equal(BigInt(inputValues[0]));
    expect(plainText[3]).to.equal(BigInt(inputSalts[0]));
    expect(plainText[4]).to.equal(BigInt(inputValues[1]));
    expect(plainText[5]).to.equal(BigInt(inputSalts[1]));
    // output owner public keys
    expect(plainText[6]).to.equal(BigInt(Bob.pubKey[0]));
    expect(plainText[7]).to.equal(BigInt(Bob.pubKey[1]));
    expect(plainText[8]).to.equal(BigInt(Alice.pubKey[0]));
    expect(plainText[9]).to.equal(BigInt(Alice.pubKey[1]));
    // output values and salts
    expect(plainText[10]).to.equal(BigInt(outputValues[0]));
    expect(plainText[11]).to.equal(BigInt(outputSalts[0]));
    expect(plainText[12]).to.equal(BigInt(outputValues[1]));
    expect(plainText[13]).to.equal(BigInt(outputSalts[1]));
  });
});

describe('batch circuit tests for Zeto fungible tokens with anonymity using nullifiers and Kyber encryption for auditability', () => {
  let circuit, smtAlice, smtBob;

  const Alice = {};
  const Bob = {};
  let senderPrivateKey;

  before(async function () {
    this.timeout(120000);

    circuit = await wasm_tester(join(__dirname, '../../circuits/anon_nullifier_qurrency_transfer_batch.circom'));

    let keypair = genKeypair();
    Alice.privKey = keypair.privKey;
    Alice.pubKey = keypair.pubKey;
    senderPrivateKey = formatPrivKeyForBabyJub(Alice.privKey);

    keypair = genKeypair();
    Bob.privKey = keypair.privKey;
    Bob.pubKey = keypair.pubKey;

    // initialize the local storage for Alice to manage her UTXOs in the Spart Merkle Tree
    const storage1 = new InMemoryDB(str2Bytes(''));
    smtAlice = new Merkletree(storage1, true, SMT_HEIGHT);

    // initialize the local storage for Bob to manage his UTXOs in the Spart Merkle Tree
    const storage2 = new InMemoryDB(str2Bytes(''));
    smtBob = new Merkletree(storage2, true, SMT_HEIGHT);
  });

  it('should succeed for valid witness - input size = 10', async function () {
    this.timeout(120000);

    const inputValues = [32, 40, 0, 0, 0, 0, 0, 0, 0, 0];
    const outputValues = [20, 52, 0, 0, 0, 0, 0, 0, 0, 0];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(inputValues[0]), salt1, ...Alice.pubKey]);
    const salt2 = newSalt();
    const input2 = poseidonHash([BigInt(inputValues[1]), salt2, ...Alice.pubKey]);
    const inputCommitments = [input1, input2, 0, 0, 0, 0, 0, 0, 0, 0];
    const inputSalts = [salt1, salt2, 0, 0, 0, 0, 0, 0, 0, 0];

    // create the nullifiers for the inputs
    const nullifier1 = poseidonHash3([BigInt(inputValues[0]), salt1, senderPrivateKey]);
    const nullifier2 = poseidonHash3([BigInt(inputValues[1]), salt2, senderPrivateKey]);
    const nullifiers = [nullifier1, nullifier2, 0, 0, 0, 0, 0, 0, 0, 0];

    // calculate the root of the SMT
    await smtAlice.add(input1, input1);
    await smtAlice.add(input2, input2);

    // generate the merkle proof for the inputs
    const proof1 = await smtAlice.generateCircomVerifierProof(input1, ZERO_HASH);
    const proof2 = await smtAlice.generateCircomVerifierProof(input2, ZERO_HASH);

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(outputValues[0]), salt3, ...Bob.pubKey]);
    const salt4 = newSalt();
    const output2 = poseidonHash([BigInt(outputValues[1]), salt4, ...Alice.pubKey]);
    const outputCommitments = [output1, output2, 0, 0, 0, 0, 0, 0, 0, 0];
    const outputSalts = [salt3, salt4, 0, 0, 0, 0, 0, 0, 0, 0];
    const enabled = [1, 1, 0, 0, 0, 0, 0, 0, 0, 0];

    const mp1 = proof1.siblings.map((s) => s.bigInt());
    const mp2 = proof2.siblings.map((s) => s.bigInt());

    const randomness = crypto.randomBytes(32); // 32 bytes for randomness
    const m = bytesToBits(randomness);
    const encryptionNonce = newEncryptionNonce();

    const witness = await circuit.calculateWitness(
      {
        nullifiers,
        inputCommitments,
        inputValues,
        inputSalts: inputSalts,
        inputOwnerPrivateKey: senderPrivateKey,
        root: proof1.root.bigInt(),
        merkleProof: [mp1, mp2, mp2, mp2, mp2, mp2, mp2, mp2, mp2, mp2],
        enabled,
        outputCommitments,
        outputValues,
        outputSalts: outputSalts,
        outputOwnerPublicKeys: [Bob.pubKey, Alice.pubKey, Alice.pubKey, Alice.pubKey, Alice.pubKey, Alice.pubKey, Alice.pubKey, Alice.pubKey, Alice.pubKey, Alice.pubKey],
        randomness: m,
        encryptionNonce,
      },
      true
    );

    await circuit.checkConstraints(witness);

    // the first 25 signals are the encapsulated shared secret for ML-KEM
    const kemCiphertext = witness.slice(1, 26);
    // the receiver can build the encapsulated shared secret from the public signals
    const cBytes = recoverMlKemCiphertextBytes(kemCiphertext);

    // verify the circuit witnesses were generated correctly
    const sender = new MlKem512();
    const pkR = new Uint8Array(testKeyPair.pk);
    const [ct, _] = await sender.encap(pkR, new Uint8Array(randomness));
    expect(ct.length).to.equal(768);
    expect(ct).to.deep.equal(new Uint8Array(cBytes));

    // the receiver can decap the ciphertext, and recover the shared secret
    // using the mlkem ciphertext and the receiver's private key
    const receiver = new MlKem512();
    const ssReceiver = await receiver.decap(new Uint8Array(cBytes), new Uint8Array(testKeyPair.sk));
    // corresponding to the logic in the circuit "pubkey.circom", we derive the symmetric key
    // from the shared secret
    expect(ssReceiver.length).to.equal(32);
    const recoveredKey = publicKeyFromSeed(ssReceiver);

    // the next 16 (14 encrypted elements, so 3n+1 is 16) signals are the
    // cipher text for the symmetric encryption of the output secrets
    const encryptedElementsLength = 62;
    const l = 64; // the length of the cipher text is 64
    const cipherTexts = witness.slice(26, 26 + l);

    let plainText = poseidonDecrypt(cipherTexts, recoveredKey, encryptionNonce, encryptedElementsLength);
    // input owner public key
    expect(plainText[0]).to.equal(BigInt(Alice.pubKey[0]));
    expect(plainText[1]).to.equal(BigInt(Alice.pubKey[1]));
    // input values and salts
    expect(plainText[2]).to.equal(BigInt(inputValues[0]));
    expect(plainText[3]).to.equal(BigInt(inputSalts[0]));
    expect(plainText[4]).to.equal(BigInt(inputValues[1]));
    expect(plainText[5]).to.equal(BigInt(inputSalts[1]));
  });
});
