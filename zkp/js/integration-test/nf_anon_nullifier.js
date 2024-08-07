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
const { Poseidon, newSalt, tokenUriHash, loadCircuit } = require('../index.js');
const { loadProvingKeys } = require('./utils.js');

const SMT_HEIGHT = 64;
const poseidonHash = Poseidon.poseidon5;
const poseidonHash4 = Poseidon.poseidon4;

describe('main circuit tests for Zeto non-fungible tokens with anonymity using nullifiers and without encryption', () => {
  let circuit, provingKeyFile, verificationKey, smtAlice, smtBob;

  const Alice = {};
  const Bob = {};
  let senderPrivateKey;

  before(async () => {
    circuit = await loadCircuit('nf_anon_nullifier');
    ({ provingKeyFile, verificationKey } = loadProvingKeys('nf_anon_nullifier'));

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

  it('should generate a valid proof that can be verified successfully', async () => {
    const tokenId = 1001;
    const tokenUri = tokenUriHash('http://ipfs.io/some-file-hash');

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(tokenId), tokenUri, salt1, ...Alice.pubKey]);

    // create the nullifiers for the inputs
    const nullifier1 = poseidonHash4([BigInt(tokenId), tokenUri, salt1, senderPrivateKey]);

    // calculate the root of the SMT
    await smtAlice.add(input1, input1);

    // generate the merkle proof for the inputs
    const proof1 = await smtAlice.generateCircomVerifierProof(input1, ZERO_HASH);

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(tokenId), tokenUri, salt3, ...Bob.pubKey]);

    const startTime = Date.now();
    const witness = await circuit.calculateWTNSBin(
      {
        tokenId,
        tokenUri,
        nullifier: nullifier1,
        inputCommitment: input1,
        inputSalt: salt1,
        inputOwnerPrivateKey: senderPrivateKey,
        root: proof1.root.bigInt(),
        merkleProof: proof1.siblings.map((s) => s.bigInt()),
        outputCommitment: output1,
        outputSalt: salt3,
        outputOwnerPublicKey: Bob.pubKey,
      },
      true
    );

    const { proof, publicSignals } = await groth16.prove(provingKeyFile, witness);
    console.log('Proving time: ', (Date.now() - startTime) / 1000, 's');

    const success = await groth16.verify(verificationKey, publicSignals, proof);
    // console.log('nullifiers', nullifier1);
    // console.log('outputCommitments', output1);
    // console.log('root', proof1.root.bigInt());
    // console.log('publicSignals', publicSignals);
    expect(success, true);
  }).timeout(600000);
});
