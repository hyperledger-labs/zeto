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
const { Poseidon, newSalt, tokenUriHash } = require('../../index.js');
const { Merkletree, InMemoryDB, str2Bytes, ZERO_HASH } = require('@iden3/js-merkletree');

const SMT_HEIGHT = 64;
const poseidonHash = Poseidon.poseidon5;
const poseidonHash4 = Poseidon.poseidon4;

describe('check-smt-proof circuit tests', () => {
  let circuit, smt;
  const sender = {};
  const receiver = {};
  let senderPrivateKey;

  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(join(__dirname, '../circuits/check-smt-proof.circom'));

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
    const tokenUri = tokenUriHash('http://ipfs.io/some-file-hash');

    // create two input UTXOs
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(tokenId), tokenUri, salt1, ...sender.pubKey]);

    // calculate the root of the SMT
    await smt.add(input1, input1);

    // generate the merkle proof for the inputs
    const proof1 = await smt.generateCircomVerifierProof(input1, ZERO_HASH);

    const witness = await circuit.calculateWitness(
      {
        leafNodeIndexes: [input1],
        root: proof1.root.bigInt(),
        merkleProof: [proof1.siblings.map((s) => s.bigInt())],
        enabled: [1],
      },
      true
    );

    // console.log('inputCommitment', input1);
    // console.log('root', proof1.root.bigInt());
    // console.log(
    //   'merkleProof',
    //   proof1.siblings.map((s) => s.bigInt())
    // );
    // console.log(witness.slice(0, 10));

    expect(witness[1]).to.equal(proof1.root.bigInt());
    expect(witness[2]).to.equal(BigInt(1)); // enabled
    expect(witness[3]).to.equal(BigInt(input1));
  });
});
