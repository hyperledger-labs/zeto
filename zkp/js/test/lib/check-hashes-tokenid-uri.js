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
const { join } = require('path');
const { wasm: wasm_tester } = require('circom_tester');
const { genKeypair } = require('maci-crypto');
const { Poseidon, newSalt, tokenUriHash } = require('../../index.js');

const poseidonHash = Poseidon.poseidon5;

describe('check-hashes-tokenid-uri circuit tests', () => {
  let circuit;
  const sender = {};
  const receiver = {};

  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(join(__dirname, '../circuits/check-hashes-tokenid-uri.circom'));

    let keypair = genKeypair();
    sender.privKey = keypair.privKey;
    sender.pubKey = keypair.pubKey;

    keypair = genKeypair();
    receiver.privKey = keypair.privKey;
    receiver.pubKey = keypair.pubKey;
  });

  it('should return true for valid witness', async () => {
    const tokenIds = [1001];
    const tokenUris = [tokenUriHash('http://ipfs.io/some-file-hash')];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(tokenIds[0]), tokenUris[0], salt1, ...sender.pubKey]);
    const commitments = [input1];

    const witness = await circuit.calculateWitness(
      {
        tokenIds,
        tokenUris,
        commitments,
        salts: [salt1],
        ownerPublicKeys: [sender.pubKey],
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

    expect(witness[1]).to.equal(BigInt(commitments[0]));
    expect(witness[2]).to.equal(BigInt(sender.pubKey[0]));
    expect(witness[3]).to.equal(BigInt(sender.pubKey[1]));
    expect(witness[4]).to.equal(BigInt(tokenIds[0]));
    expect(witness[5]).to.equal(BigInt(tokenUris[0]));
    expect(witness[6]).to.equal(salt1);
  });

  it('should fail to generate a witness because of invalid commitments', async () => {
    const tokenIds = [1001];
    const tokenUris = [tokenUriHash('http://ipfs.io/some-file-hash')];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(tokenIds[0]), tokenUris, salt1, ...sender.pubKey]);
    const commitments = [input1 + BigInt(1)];

    let error;
    try {
      await circuit.calculateWitness(
        {
          tokenIds,
          tokenUris,
          commitments,
          salts: [salt1],
          ownerPublicKeys: [sender.pubKey],
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckHashesForTokenIdAndUri_74 line: 58/);
  });
});
