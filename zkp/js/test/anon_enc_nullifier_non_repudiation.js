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
const { Merkletree, InMemoryDB, str2Bytes, ZERO_HASH } = require('@iden3/js-merkletree');
const { Poseidon, newSalt, poseidonDecrypt } = require('../index.js');

const SMT_HEIGHT = 64;
const poseidonHash = Poseidon.poseidon4;
const poseidonHash3 = Poseidon.poseidon3;

describe('main circuit tests for Zeto fungible tokens with encryption for non-repudiation and anonymity using nullifiers', () => {
  let circuit, smtAlice, smtBob;

  const Alice = {};
  const Bob = {};
  const Regulator = {};
  let senderPrivateKey;

  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(join(__dirname, '../../circuits/anon_enc_nullifier_non_repudiation.circom'));

    let keypair = genKeypair();
    Alice.privKey = keypair.privKey;
    Alice.pubKey = keypair.pubKey;
    senderPrivateKey = formatPrivKeyForBabyJub(Alice.privKey);

    keypair = genKeypair();
    Bob.privKey = keypair.privKey;
    Bob.pubKey = keypair.pubKey;

    keypair = genKeypair();
    Regulator.privKey = keypair.privKey;
    Regulator.pubKey = keypair.pubKey;

    // initialize the local storage for Alice to manage her UTXOs in the Spart Merkle Tree
    const storage1 = new InMemoryDB(str2Bytes(''));
    smtAlice = new Merkletree(storage1, true, SMT_HEIGHT);

    // initialize the local storage for Bob to manage his UTXOs in the Spart Merkle Tree
    const storage2 = new InMemoryDB(str2Bytes(''));
    smtBob = new Merkletree(storage2, true, SMT_HEIGHT);
  });

  it('should succeed for valid witness, produce an encypted value and regulator is able to decrypt', async () => {
    const inputValues = [32, 40];
    const outputValues = [20, 52];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(inputValues[0]), salt1, ...Alice.pubKey]);
    const salt2 = newSalt();
    const input2 = poseidonHash([BigInt(inputValues[1]), salt2, ...Alice.pubKey]);
    const inputCommitments = [input1, input2];

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

    const encryptionNonce = genRandomSalt();
    const encryptInputs = stringifyBigInts({
      encryptionNonce,
    });

    const witness = await circuit.calculateWitness(
      {
        nullifiers,
        inputCommitments,
        inputValues,
        inputSalts: [salt1, salt2],
        inputOwnerPrivateKey: senderPrivateKey,
        root: proof1.root.bigInt(),
        merkleProof: [proof1.siblings.map((s) => s.bigInt()), proof2.siblings.map((s) => s.bigInt())],
        enabled: [1, 1],
        outputCommitments,
        outputValues,
        outputSalts: [salt3, salt4],
        outputOwnerPublicKeys: [Bob.pubKey, Alice.pubKey],
        authorityPublicKey: Regulator.pubKey,
        ...encryptInputs,
      },
      true
    );

    // console.log('witness', witness.slice(0, 25));
    // console.log('nullifiers', nullifiers);
    // console.log('inputCommitments', inputCommitments);
    // console.log('inputValues', inputValues);
    // console.log('inputSalts', [salt1, salt2]);
    // console.log('outputCommitments', outputCommitments);
    // console.log('root', proof1.root.bigInt());
    // console.log('outputValues', outputValues);
    // console.log('outputSalt', salt3);
    // console.log('outputOwnerPublicKeys', [Bob.pubKey, Alice.pubKey]);
    // console.log('encryptionNonce', encryptionNonce);

    expect(witness[17]).to.equal(BigInt(nullifiers[0]));
    expect(witness[18]).to.equal(BigInt(nullifiers[1]));
    expect(witness[19]).to.equal(proof1.root.bigInt());

    // take the output from the proof circuit and attempt to decrypt
    // as the receiver
    const cipherText = [witness[1], witness[2]]; // index 1 is the encrypted value, index 2 is the encrypted salt
    const recoveredKey = genEcdhSharedKey(Bob.privKey, Alice.pubKey);
    const plainText = poseidonDecrypt(cipherText, recoveredKey, encryptionNonce);
    expect(plainText).to.deep.equal([20n, salt3]);

    // take the output from the proof circuit and attempt to decrypt
    // as the regulator
    const recoveredKey2 = genEcdhSharedKey(Regulator.privKey, Alice.pubKey);
    const cipherText2 = witness.slice(3, 17);
    const plainText2 = poseidonDecrypt(cipherText2, recoveredKey2, encryptionNonce);
    expect(plainText2).to.deep.equal([
      Alice.pubKey[0], // input owner public key
      Alice.pubKey[1],
      BigInt(inputValues[0]), // input values
      salt1, // input salts
      BigInt(inputValues[1]),
      salt2,
      Bob.pubKey[0], // output owner public key
      Bob.pubKey[1],
      Alice.pubKey[0],
      Alice.pubKey[1],
      BigInt(outputValues[0]), // output values
      salt3, // output salts
      BigInt(outputValues[1]),
      salt4,
    ]);
  });

  it('should succeed for valid witness and produce an encypted value - single input', async () => {
    const inputValues = [72, 0];
    const outputValues = [20, 52];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(inputValues[0]), salt1, ...Alice.pubKey]);
    const inputCommitments = [input1, 0];

    // create the nullifiers for the inputs
    const nullifier1 = poseidonHash3([BigInt(inputValues[0]), salt1, senderPrivateKey]);
    const nullifiers = [nullifier1, 0];

    // calculate the root of the SMT
    await smtAlice.add(input1, input1);

    // generate the merkle proof for the inputs
    const proof1 = await smtAlice.generateCircomVerifierProof(input1, ZERO_HASH);
    const proof2 = await smtAlice.generateCircomVerifierProof(0, ZERO_HASH);

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(outputValues[0]), salt3, ...Bob.pubKey]);
    const salt4 = newSalt();
    const output2 = poseidonHash([BigInt(outputValues[1]), salt4, ...Alice.pubKey]);
    const outputCommitments = [output1, output2];

    const encryptionNonce = genRandomSalt();
    const encryptInputs = stringifyBigInts({
      encryptionNonce,
    });

    const witness = await circuit.calculateWitness(
      {
        nullifiers,
        inputCommitments,
        inputValues,
        inputSalts: [salt1, 0],
        inputOwnerPrivateKey: senderPrivateKey,
        root: proof1.root.bigInt(),
        merkleProof: [proof1.siblings.map((s) => s.bigInt()), proof2.siblings.map((s) => s.bigInt())],
        enabled: [1, 0],
        outputCommitments,
        outputValues,
        outputSalts: [salt3, salt4],
        outputOwnerPublicKeys: [Bob.pubKey, Alice.pubKey],
        authorityPublicKey: Regulator.pubKey,
        ...encryptInputs,
      },
      true
    );

    // console.log('witness', witness);
    // console.log('nullifiers', nullifiers);
    // console.log('inputCommitments', inputCommitments);
    // console.log('inputValues', inputValues);
    // console.log('inputSalts', [salt1, salt2]);
    // console.log('outputCommitments', outputCommitments);
    // console.log('root', proof1.root.bigInt());
    // console.log('outputValues', outputValues);
    // console.log('outputSalt', salt3);
    // console.log('outputOwnerPublicKeys', [receiver.pubKey, sender.pubKey]);
    // console.log('encryptionNonce', encryptionNonce);

    expect(witness[17]).to.equal(BigInt(nullifiers[0]));
    expect(witness[18]).to.equal(BigInt(nullifiers[1]));
    expect(witness[19]).to.equal(proof1.root.bigInt());

    // take the output from the proof circuit and attempt to decrypt
    // as the receiver
    const cipherText = [witness[1], witness[2]]; // index 1 is the encrypted value, index 2 is the encrypted salt
    const recoveredKey = genEcdhSharedKey(Bob.privKey, Alice.pubKey);
    const plainText = poseidonDecrypt(cipherText, recoveredKey, encryptionNonce);
    expect(plainText).to.deep.equal([20n, salt3]);

    // take the output from the proof circuit and attempt to decrypt
    // as the regulator
    const recoveredKey2 = genEcdhSharedKey(Regulator.privKey, Alice.pubKey);
    const cipherText2 = witness.slice(3, 17);
    const plainText2 = poseidonDecrypt(cipherText2, recoveredKey2, encryptionNonce);
    expect(plainText2).to.deep.equal([
      Alice.pubKey[0],
      Alice.pubKey[1],
      BigInt(inputValues[0]),
      salt1,
      BigInt(inputValues[1]),
      0n,
      Bob.pubKey[0],
      Bob.pubKey[1],
      Alice.pubKey[0],
      Alice.pubKey[1],
      BigInt(outputValues[0]),
      salt3,
      BigInt(outputValues[1]),
      salt4,
    ]);
  });

  it('should fail to generate a witness because mass conservation is not obeyed', async () => {
    const inputValues = [15, 100];
    const outputValues = [90, 35];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(inputValues[0]), salt1, ...Alice.pubKey]);
    const salt2 = newSalt();
    const input2 = poseidonHash([BigInt(inputValues[1]), salt2, ...Alice.pubKey]);
    const inputCommitments = [input1, input2];

    // create the nullifiers for the input UTXOs
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
    const output2 = poseidonHash([BigInt(outputValues[1]), salt3, ...Alice.pubKey]);
    const outputCommitments = [output1, output2];

    const sharedSecret = genEcdhSharedKey(Alice.privKey, Bob.pubKey);
    const encryptionNonce = genRandomSalt();
    const encryptInputs = stringifyBigInts({
      encryptionNonce,
    });

    let err;
    try {
      await circuit.calculateWitness(
        {
          nullifiers,
          inputCommitments,
          inputValues,
          inputSalts: [salt1, salt2],
          inputOwnerPrivateKey: senderPrivateKey,
          root: proof1.root.bigInt(),
          merkleProof: [proof1.siblings.map((s) => s.bigInt()), proof2.siblings.map((s) => s.bigInt())],
          enabled: [1, 1],
          outputCommitments,
          outputValues,
          outputSalts: [salt3, salt3],
          outputOwnerPublicKeys: [Bob.pubKey, Alice.pubKey],
          authorityPublicKey: Regulator.pubKey,
          ...encryptInputs,
        },
        true
      );
    } catch (e) {
      err = e;
    }
    // console.log(err);
    expect(err).to.match(/Error in template CheckSum_161 line: 44/);
    expect(err).to.match(/Error in template Zeto_259 line: 99/);
  });
});
