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
const { readFileSync } = require('fs');
const path = require('path');
const { genKeypair, formatPrivKeyForBabyJub } = require('maci-crypto');
const { Poseidon, newSalt } = require('../../index.js');
const { Merkletree, InMemoryDB, str2Bytes, ZERO_HASH } = require('@iden3/js-merkletree');

const SMT_HEIGHT = 64;
const poseidonHash = Poseidon.poseidon4;
const poseidonHash3 = Poseidon.poseidon3;

describe('check-nullifier-hashes-sum circuit tests', () => {
  let circuit, smt;
  const sender = {};
  const receiver = {};
  let senderPrivateKey;

  before(async () => {
    circuit = await loadCircuits();
    let keypair = genKeypair();
    sender.privKey = keypair.privKey;
    sender.pubKey = keypair.pubKey;
    senderPrivateKey = formatPrivKeyForBabyJub(sender.privKey);

    keypair = genKeypair();
    receiver.privKey = keypair.privKey;
    receiver.pubKey = keypair.pubKey;

    const storage = new InMemoryDB(str2Bytes(''));
    smt = new Merkletree(storage, true, SMT_HEIGHT);
  });

  it('should return true for valid witness', async () => {
    const inputValues = [32, 40];
    const outputValues = [20, 52];

    // create two input UTXOs
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(inputValues[0]), salt1, ...sender.pubKey]);
    const salt2 = newSalt();
    const input2 = poseidonHash([BigInt(inputValues[1]), salt2, ...sender.pubKey]);
    const inputCommitments = [input1, input2];

    // create two input nullifiers, corresponding to the input UTXOs
    const nullifier1 = poseidonHash3([BigInt(inputValues[0]), salt1, senderPrivateKey]);
    const nullifier2 = poseidonHash3([BigInt(inputValues[1]), salt2, senderPrivateKey]);
    const nullifiers = [nullifier1, nullifier2];

    // calculate the root of the SMT
    await smt.add(input1, input1);
    await smt.add(input2, input2);

    // generate the merkle proof for the inputs
    const proof1 = await smt.generateCircomVerifierProof(input1, ZERO_HASH);
    const proof2 = await smt.generateCircomVerifierProof(input2, ZERO_HASH);

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(outputValues[0]), salt3, ...receiver.pubKey]);
    const salt4 = newSalt();
    const output2 = poseidonHash([BigInt(outputValues[1]), salt4, ...sender.pubKey]);
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
        outputOwnerPublicKeys: [receiver.pubKey, sender.pubKey],
      },
      true
    );

    // console.log('nullifiers', nullifiers);
    // console.log('inputValues', inputValues);
    // console.log('inputSalts', [salt1, salt2]);
    // console.log('owner private key', sender.privKey);
    // console.log('outputCommitments', outputCommitments);
    // console.log('outputValues', outputValues);
    // console.log('outputSalt', salt3);
    // console.log('outputOwnerPublicKeys', [receiver.pubKey, sender.pubKey]);
    // console.log(witness);

    expect(witness[1]).to.equal(BigInt(1)); // index 1 is the output, value of 1 means valid proof
    expect(witness[2]).to.equal(BigInt(nullifiers[0]));
    expect(witness[3]).to.equal(BigInt(nullifiers[1]));
    expect(witness[4]).to.equal(BigInt(1));
    expect(witness[5]).to.equal(BigInt(1));
    expect(witness[6]).to.equal(BigInt(outputCommitments[0]));
    expect(witness[7]).to.equal(BigInt(outputCommitments[1]));
    expect(witness[8]).to.equal(BigInt(receiver.pubKey[0]));
    expect(witness[9]).to.equal(BigInt(receiver.pubKey[1]));
    expect(witness[10]).to.equal(BigInt(sender.pubKey[0]));
    expect(witness[11]).to.equal(BigInt(sender.pubKey[1]));
  });

  it('should return true for valid witness - single input', async () => {
    const inputValues = [72, 0];
    const outputValues = [20, 52];

    // create two input UTXOs
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(inputValues[0]), salt1, ...sender.pubKey]);
    const inputCommitments = [input1, 0];

    // create two input nullifiers, corresponding to the input UTXOs
    const nullifier1 = poseidonHash3([BigInt(inputValues[0]), salt1, senderPrivateKey]);
    const nullifiers = [nullifier1, 0];

    // calculate the root of the SMT
    await smt.add(input1, input1);

    // generate the merkle proof for the inputs
    const proof1 = await smt.generateCircomVerifierProof(input1, ZERO_HASH);
    const proof2 = await smt.generateCircomVerifierProof(0, ZERO_HASH);

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(outputValues[0]), salt3, ...receiver.pubKey]);
    const salt4 = newSalt();
    const output2 = poseidonHash([BigInt(outputValues[1]), salt4, ...sender.pubKey]);
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
        outputOwnerPublicKeys: [receiver.pubKey, sender.pubKey],
      },
      true
    );

    expect(witness[1]).to.equal(BigInt(1)); // index 1 is the output, value of 1 means valid proof
    expect(witness[2]).to.equal(BigInt(nullifiers[0]));
    expect(witness[3]).to.equal(BigInt(nullifiers[1]));
    expect(witness[4]).to.equal(BigInt(1));
    expect(witness[5]).to.equal(BigInt(0));
    expect(witness[6]).to.equal(BigInt(outputCommitments[0]));
    expect(witness[7]).to.equal(BigInt(outputCommitments[1]));
    expect(witness[8]).to.equal(BigInt(receiver.pubKey[0]));
    expect(witness[9]).to.equal(BigInt(receiver.pubKey[1]));
    expect(witness[10]).to.equal(BigInt(sender.pubKey[0]));
    expect(witness[11]).to.equal(BigInt(sender.pubKey[1]));
  });

  it('should fail due to using single input but with both merkle proof enablement indicators set to "enabled"', async () => {
    const inputValues = [72, 0];
    const outputValues = [20, 52];

    // create two input UTXOs
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(inputValues[0]), salt1, ...sender.pubKey]);
    const inputCommitments = [input1, 0];

    // create two input nullifiers, corresponding to the input UTXOs
    const nullifier1 = poseidonHash3([BigInt(inputValues[0]), salt1, senderPrivateKey]);
    const nullifiers = [nullifier1, 0];

    // calculate the root of the SMT
    await smt.add(input1, input1);

    // generate the merkle proof for the inputs
    const proof1 = await smt.generateCircomVerifierProof(input1, ZERO_HASH);
    const proof2 = await smt.generateCircomVerifierProof(0, ZERO_HASH);

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(outputValues[0]), salt3, ...receiver.pubKey]);
    const salt4 = newSalt();
    const output2 = poseidonHash([BigInt(outputValues[1]), salt4, ...sender.pubKey]);
    const outputCommitments = [output1, output2];

    let err;
    try {
      const witness = await circuit.calculateWitness(
        {
          nullifiers,
          inputCommitments,
          inputValues,
          inputSalts: [salt1, 0],
          inputOwnerPrivateKey: senderPrivateKey,
          root: proof1.root.bigInt(),
          merkleProof: [proof1.siblings.map((s) => s.bigInt()), proof2.siblings.map((s) => s.bigInt())],
          enabled: [1, 1],
          outputCommitments,
          outputValues,
          outputSalts: [salt3, salt4],
          outputOwnerPublicKeys: [receiver.pubKey, sender.pubKey],
        },
        true
      );
    } catch (e) {
      err = e;
    }
    // console.log(err);
    expect(err).to.match(/Error in template ForceEqualIfEnabled_244 line: 56/);
    expect(err).to.match(/Error in template SMTVerifier_245 line: 134/);
    expect(err).to.match(/Error in template CheckNullifierHashesAndSum_246 line: 116/);
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

    // create two input nullifiers, corresponding to the input UTXOs
    const nullifier1 = poseidonHash3([BigInt(inputValues[0]), salt1, senderPrivateKey]);
    const nullifier2 = poseidonHash3([BigInt(inputValues[1]), salt2, senderPrivateKey]);
    const nullifiers = [nullifier1, nullifier2];

    // calculate the root of the SMT
    await smt.add(input1, input1);
    await smt.add(input2, input2);

    // generate the merkle proof for the inputs
    const proof1 = await smt.generateCircomVerifierProof(input1, ZERO_HASH);
    const proof2 = await smt.generateCircomVerifierProof(input2, ZERO_HASH);

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(outputValues[0]), salt3, ...receiver.pubKey]);
    const salt4 = newSalt();
    const output2 = poseidonHash([BigInt(outputValues[1]), salt4, ...sender.pubKey]);
    const outputCommitments = [output1, output2];

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
          outputSalts: [salt3, salt4],
          outputOwnerPublicKeys: [receiver.pubKey, sender.pubKey],
        },
        true
      );
    } catch (e) {
      err = e;
    }
    // console.log(err);
    expect(err).to.match(/Error in template CheckNullifierHashesAndSum_246 line: 149/);
  });
});

// the circuit is a library, to test it we need a top-level circuit with "main"
// which is placed in the test/circuits directory
async function loadCircuits() {
  const WitnessCalculator = require('../circuits/check-nullifier-hashes-sum_js/witness_calculator.js');
  const buffer = readFileSync(path.join(__dirname, '../circuits/check-nullifier-hashes-sum_js/check-nullifier-hashes-sum.wasm'));
  const circuit = await WitnessCalculator(buffer);
  return circuit;
}
