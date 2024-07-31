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
const { Merkletree, InMemoryDB, str2Bytes, ZERO_HASH } = require('@iden3/js-merkletree');
const { Poseidon, newSalt, loadCircuit } = require('../index.js');
const { loadProvingKeys } = require('./utils.js');

const SMT_HEIGHT = 64;
const poseidonHash = Poseidon.poseidon2;

describe('check_smt_proof circuit tests', () => {
  let circuit, provingKeyFile, verificationKey, smt;

  const Alice = {};
  const Bob = {};
  const Charlie = {};
  const David = {};

  before(async () => {
    circuit = await loadCircuit('check_smt_proof');
    ({ provingKeyFile, verificationKey } = loadProvingKeys('check_smt_proof'));

    let keypair = genKeypair();
    Alice.privKey = keypair.privKey;
    Alice.pubKey = keypair.pubKey;
    Alice.keyHash = poseidonHash(Alice.pubKey);

    keypair = genKeypair();
    Bob.privKey = keypair.privKey;
    Bob.pubKey = keypair.pubKey;
    Bob.keyHash = poseidonHash(Bob.pubKey);

    keypair = genKeypair();
    Charlie.privKey = keypair.privKey;
    Charlie.pubKey = keypair.pubKey;
    Charlie.keyHash = poseidonHash(Charlie.pubKey);

    keypair = genKeypair();
    David.privKey = keypair.privKey;
    David.pubKey = keypair.pubKey;
    David.keyHash = poseidonHash(David.pubKey);

    // initialize the local storage for Alice to manage her UTXOs in the Spart Merkle Tree
    const storage1 = new InMemoryDB(str2Bytes(''));
    smt = new Merkletree(storage1, true, SMT_HEIGHT);
  });

  it('should succeed for valid witness', async () => {
    await smt.add(Alice.keyHash, Alice.keyHash);
    await smt.add(Bob.keyHash, Bob.keyHash);
    await smt.add(Charlie.keyHash, Charlie.keyHash);
    await smt.add(David.keyHash, David.keyHash);

    // generate the merkle proof for the inputs
    const senderProof = await smt.generateCircomVerifierProof(Alice.keyHash, ZERO_HASH);
    const receiverProof = await smt.generateCircomVerifierProof(David.keyHash, ZERO_HASH);

    const witness = await circuit.calculateWitness(
      {
        root: senderProof.root.bigInt(),
        merkleProof: [senderProof.siblings.map((s) => s.bigInt()), receiverProof.siblings.map((s) => s.bigInt())],
        leafNodeIndexes: [Alice.keyHash, David.keyHash],
      },
      true
    );

    // console.log('witness', witness.slice(0, 10));
    // console.log('root', senderProof.root.bigInt());
    // console.log('keys', [Alice.keyHash, David.keyHash]);

    expect(witness[1]).to.equal(senderProof.root.bigInt());
    expect(witness[2]).to.equal(Alice.keyHash);
    expect(witness[3]).to.equal(David.keyHash);
  });

  it('should generate a valid proof that can be verified successfully', async () => {
    // generate the merkle proof for the inputs
    const senderProof = await smt.generateCircomVerifierProof(Alice.keyHash, ZERO_HASH);
    const receiverProof = await smt.generateCircomVerifierProof(David.keyHash, ZERO_HASH);

    const startTime = Date.now();
    const witness = await circuit.calculateWTNSBin(
      {
        root: senderProof.root.bigInt(),
        merkleProof: [senderProof.siblings.map((s) => s.bigInt()), receiverProof.siblings.map((s) => s.bigInt())],
        leafNodeIndexes: [Alice.keyHash, David.keyHash],
      },
      true
    );

    const { proof, publicSignals } = await groth16.prove(provingKeyFile, witness);
    console.log('Proving time: ', (Date.now() - startTime) / 1000, 's');

    const success = await groth16.verify(verificationKey, publicSignals, proof);
    // console.log('root', senderProof.root.bigInt());
    // console.log('keys', [Alice.keyHash, David.keyHash]);
    // console.log('publicSignals', publicSignals);
    expect(success, true);
  }).timeout(600000);
});
