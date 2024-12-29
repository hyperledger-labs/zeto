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

const { expect } = require("chai");
const { join } = require("path");
const { wasm: wasm_tester } = require("circom_tester");
const { genKeypair, formatPrivKeyForBabyJub } = require("maci-crypto");
const { Poseidon, newSalt, tokenUriHash } = require("../index.js");

const poseidonHash = Poseidon.poseidon5;

describe("check_utxos_nf_owner circuit tests", () => {
  let circuit;
  const sender = {};
  let senderPrivateKey;

  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(
      join(__dirname, "../../circuits/check_utxos_nf_owner.circom"),
    );

    let keypair = genKeypair();
    sender.privKey = keypair.privKey;
    sender.pubKey = keypair.pubKey;
    senderPrivateKey = formatPrivKeyForBabyJub(sender.privKey);
  });

  it("should return true for valid witness", async () => {
    const tokenIds = [1001, 0];
    const tokenUris = [tokenUriHash("http://ipfs.io/some-file-hash"), 0];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([
      BigInt(tokenIds[0]),
      tokenUris[0],
      salt1,
      ...sender.pubKey,
    ]);
    const commitments = [input1, 0];

    const witness = await circuit.calculateWitness(
      {
        commitments,
        tokenIds,
        tokenUris,
        salts: [salt1, 0],
        ownerPrivateKey: senderPrivateKey,
      },
      true,
    );

    // console.log(witness.slice(0, 10));
    // console.log('commitments', commitments);
    // console.log('sender public key', sender.pubKey);
    // console.log('sender private key', senderPrivateKey);
    expect(witness[1]).to.equal(BigInt(commitments[0]));
    expect(witness[9]).to.equal(BigInt(senderPrivateKey));
    expect(witness[10]).to.equal(BigInt(sender.pubKey[0]));
    expect(witness[11]).to.equal(BigInt(sender.pubKey[1]));
  });

  it("should fail to generate a witness because of invalid owner private key", async () => {
    const tokenIds = [1001, 0];
    const tokenUris = [tokenUriHash("http://ipfs.io/some-file-hash"), 0];

    // create two input UTXOs, each has their own salt, but same owner
    const salt1 = newSalt();
    const input1 = poseidonHash([
      BigInt(tokenIds[0]),
      tokenUris[0],
      salt1,
      ...sender.pubKey,
    ]);
    const commitments = [input1, 0];

    let error;
    try {
      await circuit.calculateWitness(
        {
          commitments,
          tokenIds,
          tokenUris,
          salts: [salt1, 0],
          ownerPrivateKey: senderPrivateKey + BigInt(1),
        },
        true,
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(
      /Error in template CheckHashesForTokenIdAndUri_88 line: 51/,
    ); // hash check failed
  });
});
