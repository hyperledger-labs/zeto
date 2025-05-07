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
const { genKeypair, formatPrivKeyForBabyJub } = require('maci-crypto');
const { Merkletree, InMemoryDB, str2Bytes, ZERO_HASH } = require('@iden3/js-merkletree');
const { Poseidon, newSalt } = require('../index.js');
const { convert256To254 } = require('../lib/util.js');

const SMT_HEIGHT = 64;
const poseidonHash = Poseidon.poseidon4;
const poseidonHash3 = Poseidon.poseidon3;

function bitArray2buffer(a) {
  const len = Math.floor((a.length - 1) / 8) + 1;
  const b = new Buffer.alloc(len);

  for (let i = 0; i < a.length; i++) {
    const p = Math.floor(i / 8);
    b[p] = b[p] | (Number(a[i]) << (7 - (i % 8)));
  }
  return b;
}

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
    const enabled = [1n, 1n];

    const m = [
      1665, 1665, 0, 1665, 0, 1665, 1665, 0, 1665, 0, 0, 1665, 1665, 1665, 1665, 0, 0, 1665, 0, 0, 0, 1665, 1665, 0, 1665, 0, 1665, 0, 0, 1665, 1665, 0, 0, 1665, 0, 0, 1665, 1665, 1665, 0, 0, 0, 0, 0,
      0, 1665, 0, 0, 1665, 0, 0, 1665, 0, 1665, 1665, 0, 1665, 1665, 0, 0, 1665, 1665, 1665, 0, 0, 0, 0, 0, 0, 1665, 0, 0, 1665, 1665, 0, 0, 0, 1665, 1665, 0, 1665, 1665, 1665, 1665, 0, 1665, 1665, 0,
      1665, 1665, 1665, 1665, 0, 1665, 1665, 0, 0, 0, 1665, 1665, 0, 1665, 1665, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    ];

    const randomness = [
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    ];

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
        randomness,
        m,
      },
      true
    );

    // console.log('witness[1-30]', witness.slice(1, 30));
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

    //////
    // the pre-defined ciphertext is used to find the intermediate witness signals
    // for the cipher texts. run the following once whenever the circuit changes
    //////
    // const bits = [153n, 180n, 68n];
    // for (let i = 0; i < witness.length; i++) {
    //   if (witness[i] === bits[0] && witness[i + 1] === bits[1] && witness[i + 2] === bits[2]) {
    //     console.log(`ciphertext starts at index ${i}: ${witness.slice(i, i + 768)}`);
    //     break;
    //   }
    // }
    ////// end of logic to locate ciphertext witness index

    const CT_INDEX = 250507;
    const cipherTexts = witness.slice(CT_INDEX, CT_INDEX + 768);
    const buff = Buffer.alloc(cipherTexts.length);
    for (let i = 0; i < cipherTexts.length; i++) {
      buff.writeUInt8(parseInt(cipherTexts[i].toString()), i);
    }
    const hash = crypto.createHash('sha256').update(buff).digest('hex');
    // compare this with the console.log printout in Solidity
    console.log('ciphertext hash', hash);

    const hashBuffer = Buffer.from(hash, 'hex');
    const computed_pubSignals = [BigInt(0), BigInt(0)];
    // Calculate h0: sum of the first 16 bytes
    for (let i = 0; i < 16; i++) {
      computed_pubSignals[0] += BigInt(hashBuffer[i] * 2 ** (8 * i));
    }
    // Calculate h1: sum of the next 16 bytes
    for (let i = 16; i < 32; i++) {
      computed_pubSignals[1] += BigInt(hashBuffer[i] * 2 ** (8 * (i - 16)));
    }
    // compare these with the console.log printout in Solidity
    console.log('computed_pubSignals for ciphertext[0]: ', computed_pubSignals[0]);
    console.log('computed_pubSignals for ciphertext[1]: ', computed_pubSignals[1]);

    // calculate the expected hash for verification
    const elements = [...nullifiers, proof1.root.bigInt(), ...enabled, ...outputCommitments, ...computed_pubSignals].map((n) => n.toString(16).padStart(64, '0'));
    expect(elements.length).to.equal(9);
    const hexes = Buffer.concat(elements.map((e) => Buffer.from(e, 'hex')));
    const expectedHash = crypto.createHash('sha256').update(hexes).digest('hex');
    const hashBuffer1 = Buffer.from(expectedHash, 'hex');
    const computed_pubSignals1 = [BigInt(0), BigInt(0)];
    // Calculate h0: sum of the first 16 bytes
    for (let i = 0; i < 16; i++) {
      computed_pubSignals1[0] += BigInt(hashBuffer1[i] * 2 ** (8 * i));
    }
    // Calculate h1: sum of the next 16 bytes
    for (let i = 16; i < 32; i++) {
      computed_pubSignals1[1] += BigInt(hashBuffer1[i] * 2 ** (8 * (i - 16)));
    }
    // compare these with the console.log printout in Solidity
    console.log('computed_pubSignals for final hash[0]: ', computed_pubSignals1[0]);
    console.log('computed_pubSignals for final hash[1]: ', computed_pubSignals1[1]);

    expect(witness[1].toString(16)).to.equal(computed_pubSignals1[0].toString(16));
    expect(witness[2].toString(16)).to.equal(computed_pubSignals1[1].toString(16));
    expect(witness[3]).to.equal(BigInt(nullifiers[0]));
    expect(witness[4]).to.equal(BigInt(nullifiers[1]));
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

    const m = [
      1665, 1665, 0, 1665, 0, 1665, 1665, 0, 1665, 0, 0, 1665, 1665, 1665, 1665, 0, 0, 1665, 0, 0, 0, 1665, 1665, 0, 1665, 0, 1665, 0, 0, 1665, 1665, 0, 0, 1665, 0, 0, 1665, 1665, 1665, 0, 0, 0, 0, 0,
      0, 1665, 0, 0, 1665, 0, 0, 1665, 0, 1665, 1665, 0, 1665, 1665, 0, 0, 1665, 1665, 1665, 0, 0, 0, 0, 0, 0, 1665, 0, 0, 1665, 1665, 0, 0, 0, 1665, 1665, 0, 1665, 1665, 1665, 1665, 0, 1665, 1665, 0,
      1665, 1665, 1665, 1665, 0, 1665, 1665, 0, 0, 0, 1665, 1665, 0, 1665, 1665, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    ];

    const randomness = [
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    ];

    const mp1 = proof1.siblings.map((s) => s.bigInt());
    const mp2 = proof2.siblings.map((s) => s.bigInt());
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
        randomness,
        m,
      },
      true
    );

    // find the cipher texts. run this once whenever the circuit changes
    // TODO: calculate the ciphertexts with Kyber
    // const bits = [153n, 180n, 68n];
    // for (let i = 0; i < witness.length; i++) {
    //   if (witness[i] === bits[0] && witness[i + 1] === bits[1] && witness[i + 2] === bits[2]) {
    //     console.log(`ciphertext starts at index ${i}: ${witness.slice(i, i + 768)}`);
    //     break;
    //   }
    // }
    const CT_INDEX = 919323;
    const cipherTexts = witness.slice(CT_INDEX, CT_INDEX + 768);
    const buff = Buffer.alloc(cipherTexts.length);
    for (let i = 0; i < cipherTexts.length; i++) {
      buff.writeUInt8(parseInt(cipherTexts[i].toString()), i);
    }
    const hash = crypto.createHash('sha256').update(buff).digest('hex');
    // compare this with the console.log printout in Solidity
    console.log('ciphertext hash', hash);

    const hashBuffer = Buffer.from(hash, 'hex');
    const computed_pubSignals = [BigInt(0), BigInt(0)];
    // Calculate h0: sum of the first 16 bytes
    for (let i = 0; i < 16; i++) {
      computed_pubSignals[0] += BigInt(hashBuffer[i] * 2 ** (8 * i));
    }
    // Calculate h1: sum of the next 16 bytes
    for (let i = 16; i < 32; i++) {
      computed_pubSignals[1] += BigInt(hashBuffer[i] * 2 ** (8 * (i - 16)));
    }
    // compare these with the console.log printout in Solidity
    console.log('computed_pubSignals for ciphertext[0]: ', computed_pubSignals[0]);
    console.log('computed_pubSignals for ciphertext[1]: ', computed_pubSignals[1]);

    // calculate the expected hash for verification
    const elements = [...nullifiers, proof1.root.bigInt(), ...enabled, ...outputCommitments, ...computed_pubSignals].map((n) => n.toString(16).padStart(64, '0'));
    expect(elements.length).to.equal(33);
    const hexes = Buffer.concat(elements.map((e) => Buffer.from(e, 'hex')));
    const expectedHash = crypto.createHash('sha256').update(hexes).digest('hex');
    const hashBuffer1 = Buffer.from(expectedHash, 'hex');
    const computed_pubSignals1 = [BigInt(0), BigInt(0)];
    // Calculate h0: sum of the first 16 bytes
    for (let i = 0; i < 16; i++) {
      computed_pubSignals1[0] += BigInt(hashBuffer1[i] * 2 ** (8 * i));
    }
    // Calculate h1: sum of the next 16 bytes
    for (let i = 16; i < 32; i++) {
      computed_pubSignals1[1] += BigInt(hashBuffer1[i] * 2 ** (8 * (i - 16)));
    }
    // compare these with the console.log printout in Solidity
    console.log('computed_pubSignals for final hash[0]: ', computed_pubSignals1[0]);
    console.log('computed_pubSignals for final hash[1]: ', computed_pubSignals1[1]);

    expect(witness[1].toString(16)).to.equal(computed_pubSignals1[0].toString(16));
    expect(witness[2].toString(16)).to.equal(computed_pubSignals1[1].toString(16));
    expect(witness[3]).to.equal(BigInt(nullifiers[0]));
    expect(witness[4]).to.equal(BigInt(nullifiers[1]));
  });
});
