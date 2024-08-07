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
const { Merkletree, InMemoryDB, str2Bytes, ZERO_HASH } = require('@iden3/js-merkletree');
const { Poseidon, newSalt } = require('../index.js');

const SMT_HEIGHT = 64;
const poseidonHash = Poseidon.poseidon4;
const poseidonHash3 = Poseidon.poseidon3;

describe('main circuit tests for Zeto fungible tokens with anonymity using nullifiers and without encryption', () => {
  let circuit, smtAlice, smtBob;

  const Alice = {};
  const Bob = {};
  let senderPrivateKey;

  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(join(__dirname, '../../circuits/anon_nullifier.circom'));

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

  it('should succeed for valid witness', async () => {
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
      },
      true
    );

    // console.log('witness', witness.slice(0, 10));
    // console.log('nullifiers', nullifiers);
    // console.log('inputCommitments', inputCommitments);
    // console.log('inputValues', inputValues);
    // console.log('inputSalts', [salt1, salt2]);
    // console.log('outputCommitments', outputCommitments);
    // console.log('root', proof1.root.bigInt());
    // console.log('outputValues', outputValues);
    // console.log('outputSalt', salt3);
    // console.log('outputOwnerPublicKeys', [receiver.pubKey, sender.pubKey]);

    expect(witness[1]).to.equal(BigInt(nullifiers[0]));
    expect(witness[2]).to.equal(BigInt(nullifiers[1]));
    expect(witness[3]).to.equal(proof1.root.bigInt());
  });

  it('should succeed for valid witness - single input', async () => {
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
      },
      true
    );

    expect(witness[1]).to.equal(BigInt(nullifiers[0]));
    expect(witness[2]).to.equal(BigInt(nullifiers[1]));
    expect(witness[3]).to.equal(proof1.root.bigInt());
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
        },
        true
      );
    } catch (e) {
      err = e;
    }
    // console.log(err);
    expect(err).to.match(/Error in template CheckSum_161 line: 44/);
    expect(err).to.match(/Error in template Zeto_251 line: 86/);
  });
});
