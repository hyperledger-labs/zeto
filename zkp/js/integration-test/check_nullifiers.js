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
const { genKeypair, formatPrivKeyForBabyJub } = require('maci-crypto');
const { Poseidon, newSalt, loadCircuit } = require('../index.js');
const { loadProvingKeys } = require('./utils.js');

const poseidonHash4 = Poseidon.poseidon4;
const poseidonHash3 = Poseidon.poseidon3;

describe('check-nullifiers circuit tests', () => {
  let circuit, provingKeyFile, verificationKey;
  const sender = {};
  const receiver = {};
  let senderPrivateKey;

  before(async () => {
    circuit = await loadCircuit('check_nullifiers');
    ({ provingKeyFile, verificationKey } = loadProvingKeys('check_nullifiers'));

    let keypair = genKeypair();
    sender.privKey = keypair.privKey;
    sender.pubKey = keypair.pubKey;
    senderPrivateKey = formatPrivKeyForBabyJub(sender.privKey);

    keypair = genKeypair();
    receiver.privKey = keypair.privKey;
    receiver.pubKey = keypair.pubKey;
  });

  it('should generate a valid proof using groth16 that can be verified successfully', async () => {
    const inputValues = [15, 100];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash4([BigInt(inputValues[0]), salt1, ...sender.pubKey]);
    const salt2 = newSalt();
    const input2 = poseidonHash4([BigInt(inputValues[1]), salt2, ...sender.pubKey]);
    const inputCommitments = [input1, input2];

    // create the nullifiers for the input UTXOs
    const nullifier1 = poseidonHash3([BigInt(inputValues[0]), salt1, senderPrivateKey]);
    const nullifier2 = poseidonHash3([BigInt(inputValues[1]), salt2, senderPrivateKey]);
    const nullifiers = [nullifier1, nullifier2];

    const witness = await circuit.calculateWTNSBin(
      {
        nullifiers,
        inputCommitments,
        inputValues,
        inputSalts: [salt1, salt2],
        inputOwnerPrivateKey: senderPrivateKey,
      },
      true
    );

    const startTime = Date.now();
    const { proof, publicSignals } = await groth16.prove(provingKeyFile, witness);
    console.log('Proving time: ', (Date.now() - startTime) / 1000, 's');
    const success = await groth16.verify(verificationKey, publicSignals, proof);
    expect(success, true);
  }).timeout(20000);
});
