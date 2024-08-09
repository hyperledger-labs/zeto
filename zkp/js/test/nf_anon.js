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
const { genKeypair, formatPrivKeyForBabyJub, stringifyBigInts } = require('maci-crypto');
const { Poseidon, newSalt, tokenUriHash } = require('../index.js');

const poseidonHash = Poseidon.poseidon5;

describe('main circuit tests for Zeto non-fungible tokens with anonymity without encryption', () => {
  let circuit;

  const sender = {};
  const receiver = {};

  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(join(__dirname, '../../circuits/nf_anon.circom'));

    let keypair = genKeypair();
    sender.privKey = keypair.privKey;
    sender.pubKey = keypair.pubKey;

    keypair = genKeypair();
    receiver.privKey = keypair.privKey;
    receiver.pubKey = keypair.pubKey;
  });

  it('should succeed for valid witness and produce an encypted value', async () => {
    const tokenIds = [1001];
    const tokenUris = [tokenUriHash('http://ipfs.io/some-file-hash')];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(tokenIds[0]), tokenUris[0], salt1, ...sender.pubKey]);
    const inputCommitments = [input1];

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(tokenIds[0]), tokenUris[0], salt3, ...receiver.pubKey]);
    const outputCommitments = [output1];

    const otherInputs = stringifyBigInts({
      inputOwnerPrivateKey: formatPrivKeyForBabyJub(sender.privKey),
    });

    const witness = await circuit.calculateWitness(
      {
        tokenIds,
        tokenUris,
        inputCommitments,
        inputSalts: [salt1],
        outputCommitments,
        outputSalts: [salt3],
        outputOwnerPublicKeys: [receiver.pubKey],
        ...otherInputs,
      },
      true
    );

    // console.log('witness', witness.slice(0, 15));
    // console.log('tokenIds', tokenIds);
    // console.log('tokenUris', tokenUris);
    // console.log('salt1', salt1);
    // console.log('salt3', salt3);
    // console.log('inputCommitments', inputCommitments);
    // console.log('outputCommitments', outputCommitments);
    // console.log('senderPublicKey', sender.pubKey);
    // console.log('receiverPublicKey', receiver.pubKey);

    expect(witness[1]).to.equal(BigInt(inputCommitments[0]));
    expect(witness[2]).to.equal(BigInt(outputCommitments[0]));
    expect(witness[3]).to.equal(BigInt(tokenIds[0]));
    expect(witness[4]).to.equal(tokenUris[0]);
  });

  it('should fail to generate a witness because token Id changed', async () => {
    const inputTokenIds = [1001];
    const outputTokenIds = [1002];
    const tokenUris = [tokenUriHash('http://ipfs.io/some-file-hash')];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(inputTokenIds[0]), tokenUris, salt1, ...sender.pubKey]);
    const inputCommitments = [input1];

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(outputTokenIds[0]), tokenUris, salt3, ...receiver.pubKey]);
    const outputCommitments = [output1];

    const otherInputs = stringifyBigInts({
      inputOwnerPrivateKey: formatPrivKeyForBabyJub(sender.privKey),
    });

    let error;
    try {
      await circuit.calculateWitness(
        {
          tokenIds: inputTokenIds,
          tokenUris,
          inputCommitments,
          inputSalts: [salt1],
          outputCommitments,
          outputSalts: [salt3],
          outputOwnerPublicKeys: [receiver.pubKey],
          ...otherInputs,
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template Zeto_87 line: 66/);
    expect(error).to.match(/Error in template CheckHashesForTokenIdAndUri_86 line: 58/);
  });

  it('should fail to generate a witness because token URI changed', async () => {
    const tokenIds = [1001];
    const inputTokenUris = [tokenUriHash('http://ipfs.io/some-file-hash')];
    const outputTokenUris = [tokenUriHash('http://ipfs.io/some-other-file-hash')];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([BigInt(tokenIds[0]), inputTokenUris, salt1, ...sender.pubKey]);
    const inputCommitments = [input1];

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([BigInt(tokenIds[0]), outputTokenUris, salt3, ...receiver.pubKey]);
    const outputCommitments = [output1];

    const otherInputs = stringifyBigInts({
      inputOwnerPrivateKey: formatPrivKeyForBabyJub(sender.privKey),
    });

    let error;
    try {
      await circuit.calculateWitness(
        {
          tokenIds,
          tokenUris: inputTokenUris,
          inputCommitments,
          inputSalts: [salt1],
          outputCommitments,
          outputSalts: [salt3],
          outputOwnerPublicKeys: [receiver.pubKey],
          ...otherInputs,
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template Zeto_87 line: 66/);
    expect(error).to.match(/Error in template CheckHashesForTokenIdAndUri_86 line: 58/);
  });
});
