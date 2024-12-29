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
const { Poseidon, newSalt, tokenUriHash } = require('../index.js');
const { Merkletree, InMemoryDB, str2Bytes, ZERO_HASH } = require('@iden3/js-merkletree');

const poseidonHash4 = Poseidon.poseidon4;

describe('check_nullifiers_nf_owner circuit tests', () => {
  let circuit;
  const sender = {};
  const receiver = {};
  let senderPrivateKey;

  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(join(__dirname, '../../circuits/check_nullifiers_nf_owner.circom'));

    let keypair = genKeypair();
    sender.privKey = keypair.privKey;
    sender.pubKey = keypair.pubKey;
    senderPrivateKey = formatPrivKeyForBabyJub(sender.privKey);

    keypair = genKeypair();
    receiver.privKey = keypair.privKey;
    receiver.pubKey = keypair.pubKey;
  });

  it('should return true for valid witness', async () => {
    const tokenId = 1001;
    const tokenUri = tokenUriHash('http://ipfs.io/some-file-hash');

    const salt1 = newSalt();
    const nullifier1 = poseidonHash4([BigInt(tokenId), tokenUri, salt1, senderPrivateKey]);

    const witness = await circuit.calculateWitness(
      {
        tokenIds: [tokenId, 0],
        tokenUris: [tokenUri, 0],
        nullifiers: [nullifier1, 0],
        salts: [salt1, 0],
        ownerPrivateKey: senderPrivateKey,
      },
      true
    );

    // console.log('tokenUri', tokenUri);
    // console.log('nullifier1', nullifier1);
    // console.log('salt', salt1);
    // console.log(witness.slice(0, 10));

    expect(witness[1]).to.equal(BigInt(nullifier1));
    expect(witness[3]).to.equal(BigInt(tokenId));
    expect(witness[5]).to.equal(tokenUri);
    expect(witness[7]).to.equal(salt1);
  });

  it('should fail to calculate witness due to invalid nullifier', async () => {
    const tokenId = 1001;
    const tokenUri = tokenUriHash('http://ipfs.io/some-file-hash');

    const salt1 = newSalt();
    const nullifier1 = poseidonHash4([BigInt(tokenId), tokenUri, salt1, senderPrivateKey]);

    let error;
    try {
      const witness = await circuit.calculateWitness(
        {
          tokenIds: [tokenId, 0],
          tokenUris: [tokenUri, 0],
          nullifiers: [nullifier1 + BigInt(1), 0],
          salts: [salt1, 0],
          ownerPrivateKey: senderPrivateKey,
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckNullifiersForTokenIdAndUri_76 line: 52/);
  });
});
