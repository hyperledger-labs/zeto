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
const { Merkletree, InMemoryDB, str2Bytes, ZERO_HASH } = require('@iden3/js-merkletree');

const { Poseidon, newSalt, poseidonDecrypt, loadCircuits } = require('../index.js');

const SMT_HEIGHT = 64;
const poseidonHash = Poseidon.poseidon4;
const poseidonHash3 = Poseidon.poseidon3;

describe('main circuit tests for ConfidentialUTXO with encryption and anonymity using nullifiers', () => {
  let circuit, provingKeyFile, verificationKey, smtAlice, smtBob;

  const Alice = {};
  const Bob = {};
  let senderPrivateKey;

  before(async () => {
    const result = await loadCircuits('anon_enc_nullifier');
    circuit = result.circuit;
    provingKeyFile = result.provingKeyFile;
    verificationKey = result.verificationKey;

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

  it('should succeed for valid witness and produce an encypted value', async () => {
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

    expect(witness[3]).to.equal(BigInt(nullifiers[0]));
    expect(witness[4]).to.equal(BigInt(nullifiers[1]));
    expect(witness[5]).to.equal(proof1.root.bigInt());

    // take the output from the proof circuit and attempt to decrypt
    // as the receiver
    const cipherText = [witness[1], witness[2]]; // index 1 is the encrypted value, index 2 is the encrypted salt
    const recoveredKey = genEcdhSharedKey(Bob.privKey, Alice.pubKey);
    const plainText = poseidonDecrypt(cipherText, recoveredKey, encryptionNonce);
    expect(plainText).to.deep.equal([20n, salt3]);
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

    expect(witness[3]).to.equal(BigInt(nullifiers[0]));
    expect(witness[4]).to.equal(BigInt(nullifiers[1]));
    expect(witness[5]).to.equal(proof1.root.bigInt());

    // take the output from the proof circuit and attempt to decrypt
    // as the receiver
    const cipherText = [witness[1], witness[2]]; // index 1 is the encrypted value, index 2 is the encrypted salt
    const recoveredKey = genEcdhSharedKey(Bob.privKey, Alice.pubKey);
    const plainText = poseidonDecrypt(cipherText, recoveredKey, encryptionNonce);
    expect(plainText).to.deep.equal([20n, salt3]);
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
      await circuit.calculateWTNSBin(
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
          ...encryptInputs,
        },
        true
      );
    } catch (e) {
      err = e;
    }
    // console.log(err);
    expect(err).to.match(/Error in template CheckNullifierHashesAndSum_246 line: 157/);
    expect(err).to.match(/Error in template ConfidentialUTXO_254 line: 46/);
  });

  it('should generate a valid proof that can be verified successfully', async () => {
    const inputValues = [15, 100];
    const outputValues = [80, 35];
    // create two input UTXOs, each has their own salt, but same owner
    const senderPrivateKey = formatPrivKeyForBabyJub(Alice.privKey);
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

    const encryptionNonce = genRandomSalt();
    const encryptInputs = stringifyBigInts({
      encryptionNonce,
    });

    const startTime = Date.now();
    const witness = await circuit.calculateWTNSBin(
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
        ...encryptInputs,
      },
      true
    );

    const { proof, publicSignals } = await groth16.prove(provingKeyFile, witness);
    console.log('Proving time: ', (Date.now() - startTime) / 1000, 's');

    const success = await groth16.verify(verificationKey, publicSignals, proof);
    // console.log('nullifiers', nullifiers);
    // console.log('inputCommitments', inputCommitments);
    // console.log('outputCommitments', outputCommitments);
    // console.log('root', proof1.root.bigInt());
    // console.log('encryptionNonce', encryptionNonce);
    // console.log('publicSignals', publicSignals);
    expect(success, true);
  }).timeout(600000);
});
