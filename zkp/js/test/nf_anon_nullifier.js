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
const { Poseidon, newSalt, tokenUriHash } = require('../index.js');

const SMT_HEIGHT = 64;
const poseidonHash = Poseidon.poseidon5;
const poseidonHash4 = Poseidon.poseidon4;

describe('main circuit tests for Zeto non-fungible tokens with anonymity using nullifiers and without encryption', () => {
  let circuit, smtAlice, smtBob;

  const Alice = {};
  const Bob = {};
  let senderPrivateKey;

  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(join(__dirname, '../../circuits/nf_anon_nullifier.circom'));

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

    const witness = await circuit.calculateWitness(
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

    // console.log('witness', witness.slice(0, 15));
    // console.log('tokenId', tokenId);
    // console.log('tokenUri', tokenUri);
    // console.log('nullifier1', nullifier1);
    // console.log('root', proof1.root.bigInt());
    // console.log('salt1', salt1);
    // console.log('salt3', salt3);
    // console.log('input1', input1);
    // console.log('output1', output1);

    expect(witness[1]).to.equal(BigInt(nullifier1));
    expect(witness[2]).to.equal(BigInt(proof1.root.bigInt()));
    expect(witness[3]).to.equal(BigInt(output1));
  });

  it('should fail to generate a witness because token ID changed', async () => {
    const tokenId = 1001;
    const tokenUri = tokenUriHash('http://ipfs.io/some-file-hash');

    // create two input UTXOs
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(tokenId), tokenUri, salt1, ...Alice.pubKey]);

    // create two input nullifiers, corresponding to the input UTXOs
    const nullifier1 = poseidonHash4([BigInt(tokenId), tokenUri, salt1, senderPrivateKey]);

    // calculate the root of the SMT
    await smtAlice.add(input1, input1);

    // generate the merkle proof for the inputs
    const proof1 = await smtAlice.generateCircomVerifierProof(input1, ZERO_HASH);

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(tokenId + 1), tokenUri, salt3, ...Bob.pubKey]);

    let err;
    try {
      await circuit.calculateWitness(
        {
          tokenId,
          tokenUri,
          nullifier: nullifier1,
          inputCommitment: input1,
          inputSalt: salt1,
          inputOwnerPrivateKey: senderPrivateKey,
          root: proof1.root.bigInt(),
          merkleProof: [proof1.siblings.map((s) => s.bigInt())],
          outputCommitment: output1,
          outputSalt: salt3,
          outputOwnerPublicKey: Bob.pubKey,
        },
        true
      );
    } catch (e) {
      err = e;
    }
    // console.log(err);
    expect(err).to.match(/Error in template Zeto_319 line: 76/);
    expect(err).to.match(/Error in template CheckHashesForTokenIdAndUri_86 line: 58/);
  });

  it('should fail to generate a witness because token URI changed', async () => {
    const tokenId = 1001;
    const tokenUri = tokenUriHash('http://ipfs.io/some-file-hash');

    // create two input UTXOs
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(tokenId), tokenUri, salt1, ...Alice.pubKey]);

    // create two input nullifiers, corresponding to the input UTXOs
    const nullifier1 = poseidonHash4([BigInt(tokenId), tokenUri, salt1, senderPrivateKey]);

    // calculate the root of the SMT
    await smtAlice.add(input1, input1);

    // generate the merkle proof for the inputs
    const proof1 = await smtAlice.generateCircomVerifierProof(input1, ZERO_HASH);

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const tokenUriBad = tokenUriHash('http://ipfs.io/some-other-file-hash');
    const output1 = poseidonHash([BigInt(tokenId), tokenUriBad, salt3, ...Bob.pubKey]);

    let err;
    try {
      await circuit.calculateWitness(
        {
          tokenId,
          tokenUri,
          nullifier: nullifier1,
          inputCommitment: input1,
          inputSalt: salt1,
          inputOwnerPrivateKey: senderPrivateKey,
          root: proof1.root.bigInt(),
          merkleProof: [proof1.siblings.map((s) => s.bigInt())],
          outputCommitment: output1,
          outputSalt: salt3,
          outputOwnerPublicKey: Bob.pubKey,
        },
        true
      );
    } catch (e) {
      err = e;
    }
    // console.log(err);
    expect(err).to.match(/Error in template Zeto_319 line: 76/);
    expect(err).to.match(/Error in template CheckHashesForTokenIdAndUri_86 line: 58/);
  });

  it('should fail to generate a witness because of invalid input commitments', async () => {
    const tokenId = 1001;
    const tokenUri = tokenUriHash('http://ipfs.io/some-file-hash');

    // create two input UTXOs
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(tokenId), tokenUri, salt1, ...Alice.pubKey]);

    // create two input nullifiers, corresponding to the input UTXOs
    const nullifier1 = poseidonHash4([BigInt(tokenId), tokenUri, salt1, senderPrivateKey]);

    // calculate the root of the SMT
    await smtAlice.add(input1, input1);

    // generate the merkle proof for the inputs
    const proof1 = await smtAlice.generateCircomVerifierProof(input1, ZERO_HASH);

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const tokenUriBad = tokenUriHash('http://ipfs.io/some-other-file-hash');
    const output1 = poseidonHash([BigInt(tokenId), tokenUriBad, salt3, ...Bob.pubKey]);

    let err;
    try {
      await circuit.calculateWitness(
        {
          tokenId,
          tokenUri,
          nullifier: nullifier1,
          inputCommitment: input1 + BigInt(1),
          inputSalt: salt1,
          inputOwnerPrivateKey: senderPrivateKey,
          root: proof1.root.bigInt(),
          merkleProof: [proof1.siblings.map((s) => s.bigInt())],
          outputCommitment: output1,
          outputSalt: salt3,
          outputOwnerPublicKey: Bob.pubKey,
        },
        true
      );
    } catch (e) {
      err = e;
    }
    // console.log(err);
    expect(err).to.match(/Error in template CheckHashesForTokenIdAndUri_86 line: 58/);
  });

  it('should fail to generate a witness because of invalid output commitments', async () => {
    const tokenId = 1001;
    const tokenUri = tokenUriHash('http://ipfs.io/some-file-hash');

    // create two input UTXOs
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(tokenId), tokenUri, salt1, ...Alice.pubKey]);

    // create two input nullifiers, corresponding to the input UTXOs
    const nullifier1 = poseidonHash4([BigInt(tokenId), tokenUri, salt1, senderPrivateKey]);

    // calculate the root of the SMT
    await smtAlice.add(input1, input1);

    // generate the merkle proof for the inputs
    const proof1 = await smtAlice.generateCircomVerifierProof(input1, ZERO_HASH);

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const tokenUriBad = tokenUriHash('http://ipfs.io/some-other-file-hash');
    const output1 = poseidonHash([BigInt(tokenId), tokenUriBad, salt3, ...Bob.pubKey]);

    let err;
    try {
      await circuit.calculateWitness(
        {
          tokenId,
          tokenUri,
          nullifier: nullifier1,
          inputCommitment: input1,
          inputSalt: salt1,
          inputOwnerPrivateKey: senderPrivateKey,
          root: proof1.root.bigInt(),
          merkleProof: [proof1.siblings.map((s) => s.bigInt())],
          outputCommitment: output1 + BigInt(1),
          outputSalt: salt3,
          outputOwnerPublicKey: Bob.pubKey,
        },
        true
      );
    } catch (e) {
      err = e;
    }
    // console.log(err);
    expect(err).to.match(/Error in template CheckHashesForTokenIdAndUri_86 line: 58/);
  });
});
