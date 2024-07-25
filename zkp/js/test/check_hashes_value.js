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
const { genKeypair } = require('maci-crypto');
const { Poseidon, newSalt, loadCircuit } = require('../index.js');
const { loadProvingKeys } = require('./utils.js');

const MAX_VALUE = 2n ** 40n - 1n;
const poseidonHash = Poseidon.poseidon4;

describe('check-hashes-value circuit tests', () => {
  let circuit;
  const sender = {};
  before(async () => {
    circuit = await loadCircuit('check_hashes_value');
    let keypair = genKeypair();
    sender.privKey = keypair.privKey;
    sender.pubKey = keypair.pubKey;
  });

  it('should return true for valid witness', async () => {
    const outputValues = [200];

    // create the output UTXO
    const salt1 = newSalt();
    const output1 = poseidonHash([BigInt(outputValues[0]), salt1, ...sender.pubKey]);
    const outputCommitments = [output1];

    let witness = await circuit.calculateWitness(
      {
        outputCommitments,
        outputValues,
        outputSalts: [salt1],
        outputOwnerPublicKeys: [sender.pubKey],
      },
      true
    );

    expect(witness[1]).to.equal(BigInt(200)); // index 1 is the output, for the calculated value

    witness = await circuit.calculateWTNSBin(
      {
        outputCommitments,
        outputValues,
        outputSalts: [salt1],
        outputOwnerPublicKeys: [sender.pubKey],
      },
      true
    );
    const { provingKeyFile, verificationKey } = loadProvingKeys('check_hashes_value');
    const startTime = Date.now();
    const { proof, publicSignals } = await groth16.prove(provingKeyFile, witness);
    console.log('Proving time: ', (Date.now() - startTime) / 1000, 's');
    const success = await groth16.verify(verificationKey, publicSignals, proof);
    expect(success, true);
    // console.log('output commitments', outputCommitments);
    // console.log('output values', outputValues);
    // console.log('public signals', publicSignals);
  }).timeout(20000);

  it('should fail to generate a witness because of invalid output commitments', async () => {
    const outputValues = [200];

    // create the output UTXO
    const salt1 = newSalt();
    const output1 = poseidonHash([BigInt(outputValues[0] + 100), salt1, ...sender.pubKey]);
    const outputCommitments = [output1];

    let error;
    try {
      await circuit.calculateWTNSBin(
        {
          outputCommitments,
          outputValues,
          outputSalts: [salt1],
          outputOwnerPublicKeys: [sender.pubKey],
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckHashesValue_77 line: 67/); // hash check failed
  });

  it('should fail to generate a witness because of negative values in output commitments', async () => {
    // in the finite field used in the Poseidion hash implementation, -100n is equivalent to
    // 21888242871839275222246405745257275088548364400416034343698204186575808495517n
    const outputValues = [-100];

    // create the output UTXO
    const salt1 = newSalt();
    const output1 = poseidonHash([BigInt(outputValues[0]), salt1, ...sender.pubKey]);
    const outputCommitments = [output1];

    let error;
    try {
      await circuit.calculateWTNSBin(
        {
          outputCommitments,
          outputValues,
          outputSalts: [salt1],
          outputOwnerPublicKeys: [sender.pubKey],
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckHashesValue_77 line: 46/); // positive range check failed
  });

  it('should fail to generate a witness because of using the inverse of a negative value in output commitments', async () => {
    // in the finite field used in the Poseidion hash implementation, -100n is equivalent to
    // 21888242871839275222246405745257275088548364400416034343698204186575808495517n. This number
    // is considered negative by the circuit, because we allow the range of 0 to (2**40 - 1)
    const outputValues = [21888242871839275222246405745257275088548364400416034343698204186575808495518n];

    // create the output UTXO
    const salt1 = newSalt();
    const output1 = poseidonHash([BigInt(outputValues[0]), salt1, ...sender.pubKey]);
    const outputCommitments = [output1];

    let error;
    try {
      await circuit.calculateWTNSBin(
        {
          outputCommitments,
          outputValues,
          outputSalts: [salt1],
          outputOwnerPublicKeys: [sender.pubKey],
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckHashesValue_77 line: 46/); // positive range check failed
  });

  it('should fail to generate a witness because a larger than MAX_VALUE is used in output', async () => {
    const outputValues = [MAX_VALUE + 1n];

    // create the output UTXO
    const salt1 = newSalt();
    const output1 = poseidonHash([BigInt(outputValues[0]), salt1, ...sender.pubKey]);
    const outputCommitments = [output1];

    let error;
    try {
      await circuit.calculateWTNSBin(
        {
          outputCommitments,
          outputValues,
          outputSalts: [salt1],
          outputOwnerPublicKeys: [sender.pubKey],
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckHashesValue_77 line: 46/); // positive range check failed
  });
});
