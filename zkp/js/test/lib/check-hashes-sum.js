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
const { genKeypair } = require('maci-crypto');
const { Poseidon, newSalt } = require('../../index.js');

const MAX_VALUE = 2n ** 40n - 1n;
const ZERO_PUBKEY = [0n, 0n];
const poseidonHash = Poseidon.poseidon4;

describe('check-hashes-sum circuit tests', () => {
  let circuit;
  const sender = {};
  const receiver = {};
  before(async () => {
    circuit = await loadCircuits();
    let keypair = genKeypair();
    sender.privKey = keypair.privKey;
    sender.pubKey = keypair.pubKey;

    keypair = genKeypair();
    receiver.privKey = keypair.privKey;
    receiver.pubKey = keypair.pubKey;
  });

  it('should return true for valid witness', async () => {
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

    const witness = await circuit.calculateWitness(
      {
        inputCommitments,
        inputValues,
        inputSalts: [salt1, salt2],
        inputOwnerPublicKey: sender.pubKey,
        outputCommitments,
        outputValues,
        outputSalts: [salt3, salt4],
        outputOwnerPublicKeys: [receiver.pubKey, sender.pubKey],
      },
      true
    );

    expect(witness[1]).to.equal(BigInt(1)); // index 1 is the output, value of 1 means valid proof
    expect(witness[2]).to.equal(BigInt(inputCommitments[0]));
    expect(witness[3]).to.equal(BigInt(inputCommitments[1]));
    expect(witness[4]).to.equal(BigInt(sender.pubKey[0]));
    expect(witness[5]).to.equal(BigInt(sender.pubKey[1]));
    expect(witness[6]).to.equal(BigInt(outputCommitments[0]));
    expect(witness[7]).to.equal(BigInt(outputCommitments[1]));
  });

  it('should return true for valid witness using a single input value', async () => {
    const inputValues = [72, 0];
    const outputValues = [20, 52];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(inputValues[0]), salt1, ...sender.pubKey]);
    const inputCommitments = [input1, 0];

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(outputValues[0]), salt3, ...receiver.pubKey]);
    const salt4 = newSalt();
    const output2 = poseidonHash([BigInt(outputValues[1]), salt4, ...sender.pubKey]);
    const outputCommitments = [output1, output2];

    const witness = await circuit.calculateWitness(
      {
        inputCommitments,
        inputValues,
        inputSalts: [salt1, 0],
        inputOwnerPublicKey: sender.pubKey,
        outputCommitments,
        outputValues,
        outputSalts: [salt3, salt4],
        outputOwnerPublicKeys: [receiver.pubKey, sender.pubKey],
      },
      true
    );

    expect(witness[1]).to.equal(BigInt(1)); // index 1 is the output, value of 1 means valid proof
    expect(witness[2]).to.equal(BigInt(inputCommitments[0]));
    expect(witness[3]).to.equal(BigInt(inputCommitments[1]));
    expect(witness[4]).to.equal(BigInt(sender.pubKey[0]));
    expect(witness[5]).to.equal(BigInt(sender.pubKey[1]));
    expect(witness[6]).to.equal(BigInt(outputCommitments[0]));
    expect(witness[7]).to.equal(BigInt(outputCommitments[1]));
  });

  it('should return true for valid witness giving all values to receiver, without change to self', async () => {
    const inputValues = [32, 40];
    const outputValues = [72, 0];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(inputValues[0]), salt1, ...sender.pubKey]);
    const salt2 = newSalt();
    const input2 = poseidonHash([BigInt(inputValues[1]), salt2, ...sender.pubKey]);
    const inputCommitments = [input1, input2];

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(outputValues[0]), salt3, ...receiver.pubKey]);
    const outputCommitments = [output1, 0];

    const witness = await circuit.calculateWitness(
      {
        inputCommitments,
        inputValues,
        inputSalts: [salt1, salt2],
        inputOwnerPublicKey: sender.pubKey,
        outputCommitments,
        outputValues,
        outputSalts: [salt3, 0],
        outputOwnerPublicKeys: [receiver.pubKey, ZERO_PUBKEY],
      },
      true
    );

    expect(witness[1]).to.equal(BigInt(1)); // index 1 is the output, value of 1 means valid proof
    expect(witness[2]).to.equal(BigInt(inputCommitments[0]));
    expect(witness[3]).to.equal(BigInt(inputCommitments[1]));
    expect(witness[4]).to.equal(BigInt(sender.pubKey[0]));
    expect(witness[5]).to.equal(BigInt(sender.pubKey[1]));
    expect(witness[6]).to.equal(BigInt(outputCommitments[0]));
    expect(witness[7]).to.equal(BigInt(outputCommitments[1]));
  });

  it('should return true for valid witness using single input to transfer to receiver, without change to self', async () => {
    const inputValues = [72, 0];
    const outputValues = [72, 0];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(inputValues[0]), salt1, ...sender.pubKey]);
    const inputCommitments = [input1, 0];

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(outputValues[0]), salt3, ...receiver.pubKey]);
    const outputCommitments = [output1, 0];

    const witness = await circuit.calculateWitness(
      {
        inputCommitments,
        inputValues,
        inputSalts: [salt1, 0],
        inputOwnerPublicKey: sender.pubKey,
        outputCommitments,
        outputValues,
        outputSalts: [salt3, 0],
        outputOwnerPublicKeys: [receiver.pubKey, ZERO_PUBKEY],
      },
      true
    );

    expect(witness[1]).to.equal(BigInt(1)); // index 1 is the output, value of 1 means valid proof
    expect(witness[2]).to.equal(BigInt(inputCommitments[0]));
    expect(witness[3]).to.equal(BigInt(inputCommitments[1]));
    expect(witness[4]).to.equal(BigInt(sender.pubKey[0]));
    expect(witness[5]).to.equal(BigInt(sender.pubKey[1]));
    expect(witness[6]).to.equal(BigInt(outputCommitments[0]));
    expect(witness[7]).to.equal(BigInt(outputCommitments[1]));
  });

  it('should return true for valid witness when merging UTXOs to a single UTXO for self', async () => {
    const inputValues = [72, 28];
    const outputValues = [0, 100];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(inputValues[0]), salt1, ...sender.pubKey]);
    const salt2 = newSalt();
    const input2 = poseidonHash([BigInt(inputValues[1]), salt2, ...sender.pubKey]);
    const inputCommitments = [input1, input2];

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(outputValues[1]), salt3, ...sender.pubKey]);
    const outputCommitments = [0, output1];

    const witness = await circuit.calculateWitness(
      {
        inputCommitments,
        inputValues,
        inputSalts: [salt1, salt2],
        inputOwnerPublicKey: sender.pubKey,
        outputCommitments,
        outputValues,
        outputSalts: [0, salt3],
        outputOwnerPublicKeys: [ZERO_PUBKEY, sender.pubKey],
      },
      true
    );

    expect(witness[1]).to.equal(BigInt(1)); // index 1 is the output, value of 1 means valid proof
    expect(witness[2]).to.equal(BigInt(inputCommitments[0]));
    expect(witness[3]).to.equal(BigInt(inputCommitments[1]));
    expect(witness[4]).to.equal(BigInt(sender.pubKey[0]));
    expect(witness[5]).to.equal(BigInt(sender.pubKey[1]));
    expect(witness[6]).to.equal(BigInt(outputCommitments[0]));
    expect(witness[7]).to.equal(BigInt(outputCommitments[1]));
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
    const salt4 = newSalt();
    const output2 = poseidonHash([BigInt(outputValues[1]), salt4, ...sender.pubKey]);
    const outputCommitments = [output1, output2];

    let error;
    try {
      await circuit.calculateWTNSBin(
        {
          inputCommitments,
          inputValues,
          inputSalts: [salt1, salt2],
          inputOwnerPublicKey: sender.pubKey,
          outputCommitments,
          outputValues,
          outputSalts: [salt3, salt4],
          outputOwnerPublicKeys: [receiver.pubKey, sender.pubKey],
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckHashesAndSum_77 line: 89/);
  });

  it('should fail to generate a witness because of invalid input commitments', async () => {
    const inputValues = [25, 100];
    const outputValues = [90, 35];
    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(inputValues[0]), salt1, ...sender.pubKey]);
    const salt2 = newSalt();
    const input2 = poseidonHash([BigInt(inputValues[1]), salt2, ...sender.pubKey]);
    const inputCommitments = [input1 + BigInt(1), input2];

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(outputValues[0]), salt3, ...receiver.pubKey]);
    const salt4 = newSalt();
    const output2 = poseidonHash([BigInt(outputValues[1]), salt4, ...sender.pubKey]);
    const outputCommitments = [output1, output2];

    let error;
    try {
      await circuit.calculateWTNSBin(
        {
          inputCommitments,
          inputValues,
          inputSalts: [salt1, salt2],
          inputOwnerPublicKey: sender.pubKey,
          outputCommitments,
          outputValues,
          outputSalts: [salt3, salt4],
          outputOwnerPublicKeys: [receiver.pubKey, sender.pubKey],
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckHashesAndSum_77 line: 56/); // hash check failed
    expect(error).to.match(/Error in template CheckHashesAndSum_77 line: 89/); // sum check failed
  });

  it('should fail to generate a witness because of invalid output commitments', async () => {
    const inputValues = [25, 100];
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
    const salt4 = newSalt();
    const output2 = poseidonHash([BigInt(outputValues[1]), salt4, ...sender.pubKey]);
    const outputCommitments = [output1 + BigInt(1), output2];

    let error;
    try {
      await circuit.calculateWTNSBin(
        {
          inputCommitments,
          inputValues,
          inputSalts: [salt1, salt2],
          inputOwnerPublicKey: sender.pubKey,
          outputCommitments,
          outputValues,
          outputSalts: [salt3, salt4],
          outputOwnerPublicKeys: [receiver.pubKey, sender.pubKey],
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckHashesAndSum_77 line: 77/); // hash check failed
  });

  it('should fail to generate a witness because of negative values in output commitments', async () => {
    const inputValues = [25, 100];
    // in the finite field used in the Poseidion hash implementation, -100n is equivalent to
    // 21888242871839275222246405745257275088548364400416034343698204186575808495517n
    const outputValues = [-100, 225];
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

    let error;
    try {
      await circuit.calculateWTNSBin(
        {
          inputCommitments,
          inputValues,
          inputSalts: [salt1, salt2],
          inputOwnerPublicKey: sender.pubKey,
          outputCommitments,
          outputValues,
          outputSalts: [salt3, salt4],
          outputOwnerPublicKeys: [receiver.pubKey, sender.pubKey],
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckHashesAndSum_77 line: 32/); // positive range check failed
  });

  it('should fail to generate a witness because of using the inverse of a negative value in output commitments', async () => {
    const inputValues = [25, 100];
    // in the finite field used in the Poseidion hash implementation, -100n is equivalent to
    // 21888242871839275222246405745257275088548364400416034343698204186575808495517n. This number
    // is considered negative by the circuit, because we allow the range of 0 to (2**40 - 1)
    const outputValues = [21888242871839275222246405745257275088548364400416034343698204186575808495518n, 225];
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

    let error;
    try {
      await circuit.calculateWTNSBin(
        {
          inputCommitments,
          inputValues,
          inputSalts: [salt1, salt2],
          inputOwnerPublicKey: sender.pubKey,
          outputCommitments,
          outputValues,
          outputSalts: [salt3, salt4],
          outputOwnerPublicKeys: [receiver.pubKey, sender.pubKey],
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckHashesAndSum_77 line: 32/); // positive range check failed
  });

  it('should succeed to generate a witness using the MAX_VALUE for output', async () => {
    const inputValues = [MAX_VALUE - 100n, 200];
    const outputValues = [MAX_VALUE, 100];
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

    let error;
    try {
      await circuit.calculateWTNSBin(
        {
          inputCommitments,
          inputValues,
          inputSalts: [salt1, salt2],
          inputOwnerPublicKey: sender.pubKey,
          outputCommitments,
          outputValues,
          outputSalts: [salt3, salt4],
          outputOwnerPublicKeys: [receiver.pubKey, sender.pubKey],
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.be.undefined;
  });

  it('should fail to generate a witness because a larger than MAX_VALUE is used in output', async () => {
    const inputValues = [MAX_VALUE - 100n, 200];
    const outputValues = [MAX_VALUE + 1n, 99];

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

    let error;
    try {
      await circuit.calculateWTNSBin(
        {
          inputCommitments,
          inputValues,
          inputSalts: [salt1, salt2],
          inputOwnerPublicKey: sender.pubKey,
          outputCommitments,
          outputValues,
          outputSalts: [salt3, salt4],
          outputOwnerPublicKeys: [receiver.pubKey, sender.pubKey],
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckHashesAndSum_77 line: 32/); // positive range check failed
  });
});

// the circuit is a library, to test it we need a top-level circuit with "main"
// which is placed in the test/circuits directory
async function loadCircuits() {
  const WitnessCalculator = require('../circuits/check-hashes-sum_js/witness_calculator.js');
  const buffer = readFileSync(path.join(__dirname, '../circuits/check-hashes-sum_js/check-hashes-sum.wasm'));
  const circuit = await WitnessCalculator(buffer);
  return circuit;
}
