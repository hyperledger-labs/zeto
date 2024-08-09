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
const { genKeypair, formatPrivKeyForBabyJub, stringifyBigInts } = require('maci-crypto');
const { Poseidon, newSalt, loadCircuit, tokenUriHash } = require('../index.js');
const { loadProvingKeys } = require('./utils.js');

const poseidonHash = Poseidon.poseidon5;

describe('main circuit tests for Zeto non-fungible tokens with anonymity without encryption', () => {
  let circuit, provingKeyFile, verificationKey;

  const sender = {};
  const receiver = {};

  before(async () => {
    circuit = await loadCircuit('nf_anon');
    ({ provingKeyFile, verificationKey } = loadProvingKeys('nf_anon'));

    let keypair = genKeypair();
    sender.privKey = keypair.privKey;
    sender.pubKey = keypair.pubKey;

    keypair = genKeypair();
    receiver.privKey = keypair.privKey;
    receiver.pubKey = keypair.pubKey;
  });

  it('should generate a valid proof that can be verified successfully', async () => {
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

    const startTime = Date.now();
    const witness = await circuit.calculateWTNSBin(
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

    const { proof, publicSignals } = await groth16.prove(provingKeyFile, witness);
    console.log('Proving time: ', (Date.now() - startTime) / 1000, 's');

    const success = await groth16.verify(verificationKey, publicSignals, proof);
    // console.log('inputCommitments', inputCommitments);
    // console.log('outputCommitments', outputCommitments);
    // console.log('senderPublicKey', sender.pubKey);
    // console.log('receiverPublicKey', receiver.pubKey);
    // console.log('publicSignals', publicSignals);
    expect(success, true);
  }).timeout(60000);
});
