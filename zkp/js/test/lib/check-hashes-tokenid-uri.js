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
const { Poseidon, newSalt, hashTokenUri } = require('../../index.js');

const poseidonHash = Poseidon.poseidon5;

describe('check-hashes-tokenid-uri circuit tests', () => {
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
    const tokenIds = [1001];
    const tokenUris = [hashTokenUri('http://ipfs.io/some-file-hash')];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(tokenIds[0]), tokenUris[0], salt1, ...sender.pubKey]);
    const inputCommitments = [input1];

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(tokenIds[0]), tokenUris[0], salt3, ...receiver.pubKey]);
    const outputCommitments = [output1];

    const witness = await circuit.calculateWitness(
      {
        tokenIds,
        tokenUris,
        inputCommitments,
        inputSalts: [salt1],
        inputOwnerPublicKey: sender.pubKey,
        outputCommitments,
        outputSalts: [salt3],
        outputOwnerPublicKeys: [receiver.pubKey],
      },
      true
    );

    // console.log(witness.slice(0, 20));
    // console.log(tokenIds);
    // console.log(tokenUris);
    // console.log(inputCommitments);
    // console.log(sender.pubKey);
    // console.log(salt1);
    // console.log(outputCommitments);
    // console.log(salt3);
    // console.log(receiver.pubKey);

    expect(witness[1]).to.equal(BigInt(1)); // index 1 is the output, value of 1 means valid proof
    expect(witness[2]).to.equal(BigInt(inputCommitments[0]));
    expect(witness[3]).to.equal(BigInt(sender.pubKey[0]));
    expect(witness[4]).to.equal(BigInt(sender.pubKey[1]));
    expect(witness[5]).to.equal(BigInt(outputCommitments[0]));
    expect(witness[6]).to.equal(BigInt(receiver.pubKey[0]));
    expect(witness[7]).to.equal(BigInt(receiver.pubKey[1]));
    expect(witness[8]).to.equal(BigInt(tokenIds[0]));
    expect(witness[9]).to.equal(BigInt(tokenUris[0]));
    expect(witness[10]).to.equal(salt1);
    expect(witness[11]).to.equal(salt3);
  });

  it('should fail to generate a witness because token Id changed', async () => {
    const inputTokenIds = [1001];
    const outputTokenIds = [1002];
    const tokenUris = [hashTokenUri('http://ipfs.io/some-file-hash')];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(inputTokenIds[0]), tokenUris, salt1, ...sender.pubKey]);
    const inputCommitments = [input1];

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(outputTokenIds[0]), tokenUris, salt3, ...receiver.pubKey]);
    const outputCommitments = [output1];

    let error;
    try {
      await circuit.calculateWTNSBin(
        {
          tokenIds: inputTokenIds,
          tokenUris,
          inputCommitments,
          inputSalts: [salt1],
          inputOwnerPublicKey: sender.pubKey,
          outputCommitments,
          outputSalts: [salt3],
          outputOwnerPublicKeys: [receiver.pubKey],
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckHashesForTokenIdAndUri_74 line: 73/);
  });

  it('should fail to generate a witness because token URI changed', async () => {
    const tokenIds = [1001];
    const inputTokenUris = [hashTokenUri('http://ipfs.io/some-file-hash')];
    const outputTokenUris = [hashTokenUri('http://ipfs.io/some-other-file-hash')];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(tokenIds[0]), inputTokenUris, salt1, ...sender.pubKey]);
    const inputCommitments = [input1];

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(tokenIds[0]), outputTokenUris, salt3, ...receiver.pubKey]);
    const outputCommitments = [output1];

    let error;
    try {
      await circuit.calculateWTNSBin(
        {
          tokenIds,
          tokenUris: inputTokenUris,
          inputCommitments,
          inputSalts: [salt1],
          inputOwnerPublicKey: sender.pubKey,
          outputCommitments,
          outputSalts: [salt3],
          outputOwnerPublicKeys: [receiver.pubKey],
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckHashesForTokenIdAndUri_74 line: 73/);
  });

  it('should fail to generate a witness because of invalid input commitments', async () => {
    const tokenIds = [1001];
    const tokenUris = [hashTokenUri('http://ipfs.io/some-file-hash')];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(tokenIds[0]), tokenUris, salt1, ...sender.pubKey]);
    const inputCommitments = [input1 + BigInt(1)];

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(tokenIds[0]), tokenUris, salt3, ...receiver.pubKey]);
    const outputCommitments = [output1];

    let error;
    try {
      await circuit.calculateWTNSBin(
        {
          tokenIds,
          tokenUris,
          inputCommitments,
          inputSalts: [salt1],
          inputOwnerPublicKey: sender.pubKey,
          outputCommitments,
          outputSalts: [salt3],
          outputOwnerPublicKeys: [receiver.pubKey],
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckHashesForTokenIdAndUri_74 line: 51/);
  });

  it('should fail to generate a witness because of invalid output commitments', async () => {
    const tokenIds = [1001];
    const tokenUris = [hashTokenUri('http://ipfs.io/some-file-hash')];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(tokenIds[0]), tokenUris, salt1, ...sender.pubKey]);
    const inputCommitments = [input1];

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(tokenIds[0]), tokenUris, salt3, ...receiver.pubKey]);
    const outputCommitments = [output1 + BigInt(1)];

    let error;
    try {
      await circuit.calculateWTNSBin(
        {
          tokenIds,
          tokenUris,
          inputCommitments,
          inputSalts: [salt1],
          inputOwnerPublicKey: sender.pubKey,
          outputCommitments,
          outputSalts: [salt3],
          outputOwnerPublicKeys: [receiver.pubKey],
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckHashesForTokenIdAndUri_74 line: 51/);
  });
});

// the circuit is a library, to test it we need a top-level circuit with "main"
// which is placed in the test/circuits directory
async function loadCircuits() {
  const WitnessCalculator = require('../circuits/check-hashes-tokenid-uri_js/witness_calculator.js');
  const buffer = readFileSync(path.join(__dirname, '../circuits/check-hashes-tokenid-uri_js/check-hashes-tokenid-uri.wasm'));
  const circuit = await WitnessCalculator(buffer);
  return circuit;
}
