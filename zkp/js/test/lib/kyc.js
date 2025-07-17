// Copyright © 2025 Kaleido, Inc.
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
const { Poseidon } = require("../../index.js");
const {
  Merkletree,
  InMemoryDB,
  str2Bytes,
} = require("@iden3/js-merkletree");

const SMT_HEIGHT = 64;
const poseidonHash2 = Poseidon.poseidon2;

describe("kyc circuit tests", () => {
  let circuit, smt;
  const sender = {};
  const receiver = {};
  let senderPrivateKey;

  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(
      join(__dirname, "../circuits/kyc.circom"),
    );

    let keypair = genKeypair();
    sender.privKey = keypair.privKey;
    sender.pubKey = keypair.pubKey;
    senderPrivateKey = formatPrivKeyForBabyJub(sender.privKey);

    keypair = genKeypair();
    receiver.privKey = keypair.privKey;
    receiver.pubKey = keypair.pubKey;

    const storage = new InMemoryDB(str2Bytes(""));
    smt = new Merkletree(storage, true, SMT_HEIGHT);
  });

  it("should return true for valid witness", async () => {
    const identity1 = poseidonHash2(sender.pubKey);
    await smt.add(identity1, identity1);
    const identity2 = poseidonHash2(receiver.pubKey);
    await smt.add(identity2, identity2);

    // generate the merkle proof for the inputs
    const root = await smt.root();
    const proof1 = await smt.generateCircomVerifierProof(identity1, root);
    const proof2 = await smt.generateCircomVerifierProof(identity2, root);

    const witness = await circuit.calculateWitness(
      {
        publicKeys: [sender.pubKey, receiver.pubKey],
        root: root.bigInt(),
        merkleProof: [
          proof1.siblings.map((s) => s.bigInt()),
          proof2.siblings.map((s) => s.bigInt()),
        ],
      },
      true,
    );

    // console.log('sender public key', sender.pubKey);
    // console.log('root', proof1.root.bigInt());
    // console.log(
    //   'merkleProof',
    //   proof1.siblings.map((s) => s.bigInt())
    // );
    // console.log(witness.slice(0, 10));

    expect(witness[1]).to.equal(proof1.root.bigInt());
    expect(witness[2]).to.equal(sender.pubKey[0]); // enabled
    expect(witness[3]).to.equal(sender.pubKey[1]);
  });
});
