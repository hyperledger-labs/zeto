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
const { Poseidon, newSalt, hashTokenUri } = require('../../index.js');
const { Merkletree, InMemoryDB, str2Bytes, ZERO_HASH } = require('@iden3/js-merkletree');

const SMT_HEIGHT = 64;
const poseidonHash = Poseidon.poseidon5;
const poseidonHash4 = Poseidon.poseidon4;

describe('check-nullifier-tokenid-uri circuit tests', () => {
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
    const tokenId = 1001;
    const tokenUri = hashTokenUri('http://ipfs.io/some-file-hash');

    // create two input UTXOs
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(tokenId), tokenUri, salt1, ...sender.pubKey]);

    // create two input nullifiers, corresponding to the input UTXOs
    const nullifier1 = poseidonHash4([BigInt(tokenId), tokenUri, salt1, senderPrivateKey]);

    // calculate the root of the SMT
    await smt.add(input1, input1);

    // generate the merkle proof for the inputs
    const proof1 = await smt.generateCircomVerifierProof(input1, ZERO_HASH);

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(tokenId), tokenUri, salt3, ...receiver.pubKey]);

    const witness = await circuit.calculateWitness(
      {
        tokenIds: [tokenId],
        tokenUris: [tokenUri],
        nullifiers: [nullifier1],
        inputCommitments: [input1],
        inputSalts: [salt1],
        inputOwnerPrivateKey: senderPrivateKey,
        root: proof1.root.bigInt(),
        merkleProof: [proof1.siblings.map((s) => s.bigInt())],
        enabled: [1],
        outputCommitments: [output1],
        outputSalts: [salt3],
        outputOwnerPublicKeys: [receiver.pubKey],
      },
      true
    );

    // console.log('tokenUri', tokenUri);
    // console.log('nullifier1', nullifier1);
    // console.log('inputCommitment', input1);
    // console.log('inputSalt', salt1);
    // console.log('owner private key', sender.privKey);
    // console.log('outputCommitment', output1);
    // console.log('outputSalt', salt3);
    // console.log('outputOwnerPublicKeys', [receiver.pubKey]);
    // console.log(witness);

    expect(witness[1]).to.equal(BigInt(1)); // index 1 is the output, value of 1 means valid proof
    expect(witness[2]).to.equal(BigInt(nullifier1));
    expect(witness[3]).to.equal(BigInt(1)); // enabled
    expect(witness[4]).to.equal(BigInt(output1));
    expect(witness[5]).to.equal(BigInt(receiver.pubKey[0]));
    expect(witness[6]).to.equal(BigInt(receiver.pubKey[1]));
    expect(witness[7]).to.equal(BigInt(tokenId));
    expect(witness[8]).to.equal(tokenUri);
  });

  it('should fail to generate a witness because token ID changed', async () => {
    const tokenId = 1001;
    const tokenUri = hashTokenUri('http://ipfs.io/some-file-hash');

    // create two input UTXOs
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(tokenId), tokenUri, salt1, ...sender.pubKey]);

    // create two input nullifiers, corresponding to the input UTXOs
    const nullifier1 = poseidonHash4([BigInt(tokenId), tokenUri, salt1, senderPrivateKey]);

    // calculate the root of the SMT
    await smt.add(input1, input1);

    // generate the merkle proof for the inputs
    const proof1 = await smt.generateCircomVerifierProof(input1, ZERO_HASH);

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(tokenId + 1), tokenUri, salt3, ...receiver.pubKey]);

    let err;
    try {
      await circuit.calculateWTNSBin(
        {
          tokenIds: [tokenId],
          tokenUris: [tokenUri],
          nullifiers: [nullifier1],
          inputCommitments: [input1],
          inputSalts: [salt1],
          inputOwnerPrivateKey: senderPrivateKey,
          root: proof1.root.bigInt(),
          merkleProof: [proof1.siblings.map((s) => s.bigInt())],
          enabled: [1],
          outputCommitments: [output1],
          outputSalts: [salt3],
          outputOwnerPublicKeys: [receiver.pubKey],
        },
        true
      );
    } catch (e) {
      err = e;
    }
    // console.log(err);
    expect(err).to.match(/Error in template CheckNullifierForTokenIdAndUri_316 line: 130/);
  });

  it('should fail to generate a witness because token URI changed', async () => {
    const tokenId = 1001;
    const tokenUri = hashTokenUri('http://ipfs.io/some-file-hash');

    // create two input UTXOs
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(tokenId), tokenUri, salt1, ...sender.pubKey]);

    // create two input nullifiers, corresponding to the input UTXOs
    const nullifier1 = poseidonHash4([BigInt(tokenId), tokenUri, salt1, senderPrivateKey]);

    // calculate the root of the SMT
    await smt.add(input1, input1);

    // generate the merkle proof for the inputs
    const proof1 = await smt.generateCircomVerifierProof(input1, ZERO_HASH);

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const tokenUriBad = hashTokenUri('http://ipfs.io/some-other-file-hash');
    const output1 = poseidonHash([BigInt(tokenId), tokenUriBad, salt3, ...receiver.pubKey]);

    let err;
    try {
      await circuit.calculateWTNSBin(
        {
          tokenIds: [tokenId],
          tokenUris: [tokenUri],
          nullifiers: [nullifier1],
          inputCommitments: [input1],
          inputSalts: [salt1],
          inputOwnerPrivateKey: senderPrivateKey,
          root: proof1.root.bigInt(),
          merkleProof: [proof1.siblings.map((s) => s.bigInt())],
          enabled: [1],
          outputCommitments: [output1],
          outputSalts: [salt3],
          outputOwnerPublicKeys: [receiver.pubKey],
        },
        true
      );
    } catch (e) {
      err = e;
    }
    // console.log(err);
    expect(err).to.match(/Error in template CheckNullifierForTokenIdAndUri_316 line: 130/);
  });

  it('should fail to generate a witness because of invalid input commitments', async () => {
    const tokenId = 1001;
    const tokenUri = hashTokenUri('http://ipfs.io/some-file-hash');

    // create two input UTXOs
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(tokenId), tokenUri, salt1, ...sender.pubKey]);

    // create two input nullifiers, corresponding to the input UTXOs
    const nullifier1 = poseidonHash4([BigInt(tokenId), tokenUri, salt1, senderPrivateKey]);

    // calculate the root of the SMT
    await smt.add(input1, input1);

    // generate the merkle proof for the inputs
    const proof1 = await smt.generateCircomVerifierProof(input1, ZERO_HASH);

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const tokenUriBad = hashTokenUri('http://ipfs.io/some-other-file-hash');
    const output1 = poseidonHash([BigInt(tokenId), tokenUriBad, salt3, ...receiver.pubKey]);

    let err;
    try {
      await circuit.calculateWTNSBin(
        {
          tokenIds: [tokenId],
          tokenUris: [tokenUri],
          nullifiers: [nullifier1],
          inputCommitments: [input1 + BigInt(1)],
          inputSalts: [salt1],
          inputOwnerPrivateKey: senderPrivateKey,
          root: proof1.root.bigInt(),
          merkleProof: [proof1.siblings.map((s) => s.bigInt())],
          enabled: [1],
          outputCommitments: [output1],
          outputSalts: [salt3],
          outputOwnerPublicKeys: [receiver.pubKey],
        },
        true
      );
    } catch (e) {
      err = e;
    }
    // console.log(err);
    expect(err).to.match(/Error in template CheckNullifierForTokenIdAndUri_316 line: 130/);
  });

  it('should fail to generate a witness because of invalid output commitments', async () => {
    const tokenId = 1001;
    const tokenUri = hashTokenUri('http://ipfs.io/some-file-hash');

    // create two input UTXOs
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(tokenId), tokenUri, salt1, ...sender.pubKey]);

    // create two input nullifiers, corresponding to the input UTXOs
    const nullifier1 = poseidonHash4([BigInt(tokenId), tokenUri, salt1, senderPrivateKey]);

    // calculate the root of the SMT
    await smt.add(input1, input1);

    // generate the merkle proof for the inputs
    const proof1 = await smt.generateCircomVerifierProof(input1, ZERO_HASH);

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const tokenUriBad = hashTokenUri('http://ipfs.io/some-other-file-hash');
    const output1 = poseidonHash([BigInt(tokenId), tokenUriBad, salt3, ...receiver.pubKey]);

    let err;
    try {
      await circuit.calculateWTNSBin(
        {
          tokenIds: [tokenId],
          tokenUris: [tokenUri],
          nullifiers: [nullifier1],
          inputCommitments: [input1 + BigInt(1)],
          inputSalts: [salt1],
          inputOwnerPrivateKey: senderPrivateKey,
          root: proof1.root.bigInt(),
          merkleProof: [proof1.siblings.map((s) => s.bigInt())],
          enabled: [1],
          outputCommitments: [output1 + BigInt(1)],
          outputSalts: [salt3],
          outputOwnerPublicKeys: [receiver.pubKey],
        },
        true
      );
    } catch (e) {
      err = e;
    }
    // console.log(err);
    expect(err).to.match(/Error in template CheckNullifierForTokenIdAndUri_316 line: 130/);
  });
});

// the circuit is a library, to test it we need a top-level circuit with "main"
// which is placed in the test/circuits directory
async function loadCircuits() {
  const WitnessCalculator = require('../circuits/check-nullifier-tokenid-uri_js/witness_calculator.js');
  const buffer = readFileSync(path.join(__dirname, '../circuits/check-nullifier-tokenid-uri_js/check-nullifier-tokenid-uri.wasm'));
  const circuit = await WitnessCalculator(buffer);
  return circuit;
}
