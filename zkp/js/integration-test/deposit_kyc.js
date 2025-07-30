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
const { groth16 } = require("snarkjs");
const { genKeypair } = require("maci-crypto");
const { Poseidon, newSalt, loadCircuit } = require("../index.js");
const { loadProvingKeys } = require("./utils.js");
const {
  Merkletree,
  InMemoryDB,
  str2Bytes,
} = require("@iden3/js-merkletree");

const poseidonHash = Poseidon.poseidon4;
const poseidonHash2 = Poseidon.poseidon2;

describe("deposit_kyc circuit tests", () => {
  let circuit, smtKYC, root, proof1;
  const sender = {};
  before(async () => {
    circuit = await loadCircuit("deposit_kyc");
    let keypair = genKeypair();
    sender.privKey = keypair.privKey;
    sender.pubKey = keypair.pubKey;

    const storage = new InMemoryDB(str2Bytes("kyc"));
    smtKYC = new Merkletree(storage, true, 10);

    const identity1 = poseidonHash2(sender.pubKey);
    await smtKYC.add(identity1, identity1);
    root = await smtKYC.root();
    proof1 = await smtKYC.generateCircomVerifierProof(identity1, root);
  });

  it("should return true for valid witness and false when public signals are tampered", async () => {
    const outputValues = [200, 0];

    // create the output UTXO
    const salt1 = newSalt();
    const output1 = poseidonHash([
      BigInt(outputValues[0]),
      salt1,
      ...sender.pubKey,
    ]);
    const output2 = poseidonHash([
      BigInt(outputValues[1]),
      salt1,
      ...sender.pubKey,
    ]);
    const outputCommitments = [output1, output2];

    witness = await circuit.calculateWTNSBin(
      {
        outputCommitments,
        outputValues,
        outputSalts: [salt1, salt1],
        outputOwnerPublicKeys: [sender.pubKey, sender.pubKey],
        identitiesRoot: root.bigInt(),
        identitiesMerkleProof: [
          proof1.siblings.map((s) => s.bigInt()),
          proof1.siblings.map((s) => s.bigInt()),
        ],
      },
      true,
    );
    const { provingKeyFile, verificationKey } = loadProvingKeys("deposit_kyc");
    const startTime = Date.now();
    const { proof, publicSignals } = await groth16.prove(
      provingKeyFile,
      witness,
    );
    console.log("Proving time: ", (Date.now() - startTime) / 1000, "s");
    let verifyResult = await groth16.verify(
      verificationKey,
      publicSignals,
      proof,
    );
    expect(verifyResult).to.be.true;
    expect(publicSignals[0]).to.equal('200');

    // console.log('output commitments', outputCommitments);
    // console.log('output values', outputValues);
    // console.log('identities root', root.bigInt());
    // console.log("public signals", publicSignals);

    const tamperedOutputHash = poseidonHash([
      BigInt(100),
      salt1,
      ...sender.pubKey,
    ]);
    let tamperedPublicSignals = publicSignals.map((ps) =>
      ps.toString() === outputCommitments[0].toString()
        ? tamperedOutputHash
        : ps,
    );
    // console.log("tampered public signals", tamperedPublicSignals);

    verifyResult = await groth16.verify(
      verificationKey,
      tamperedPublicSignals,
      proof,
    );
    expect(verifyResult).to.be.false;
  }).timeout(20000);
});
