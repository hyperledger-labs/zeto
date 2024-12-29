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
const { genKeypair, formatPrivKeyForBabyJub } = require("maci-crypto");
const {
  Merkletree,
  InMemoryDB,
  str2Bytes,
  ZERO_HASH,
} = require("@iden3/js-merkletree");
const { Poseidon, newSalt, loadCircuit } = require("../index.js");
const { loadProvingKeys } = require("./utils.js");

const SMT_HEIGHT = 64;
const poseidonHash = Poseidon.poseidon4;
const poseidonHash3 = Poseidon.poseidon3;

describe("check_nullifiers_value circuit tests", () => {
  let circuit, provingKeyFile, verificationKey, smtAlice;

  const Alice = {};
  let senderPrivateKey;

  before(async () => {
    circuit = await loadCircuit("check_nullifiers_value");
    ({ provingKeyFile, verificationKey } = loadProvingKeys(
      "check_nullifiers_value",
    ));

    let keypair = genKeypair();
    Alice.privKey = keypair.privKey;
    Alice.pubKey = keypair.pubKey;
    senderPrivateKey = formatPrivKeyForBabyJub(Alice.privKey);

    // initialize the local storage for Alice to manage her UTXOs in the Spart Merkle Tree
    const storage1 = new InMemoryDB(str2Bytes(""));
    smtAlice = new Merkletree(storage1, true, SMT_HEIGHT);
  });

  it("should generate a valid proof that can be verified successfully and fail when public signals are tampered", async () => {
    const inputValues = [15, 100];
    const outputValues = [35];

    // create two input UTXOs, each has their own salt, but same owner
    const senderPrivateKey = formatPrivKeyForBabyJub(Alice.privKey);
    const salt1 = newSalt();
    const input1 = poseidonHash([
      BigInt(inputValues[0]),
      salt1,
      ...Alice.pubKey,
    ]);
    const salt2 = newSalt();
    const input2 = poseidonHash([
      BigInt(inputValues[1]),
      salt2,
      ...Alice.pubKey,
    ]);
    const inputCommitments = [input1, input2];

    // create the nullifiers for the input UTXOs
    const nullifier1 = poseidonHash3([
      BigInt(inputValues[0]),
      salt1,
      senderPrivateKey,
    ]);
    const nullifier2 = poseidonHash3([
      BigInt(inputValues[1]),
      salt2,
      senderPrivateKey,
    ]);
    const nullifiers = [nullifier1, nullifier2];

    // calculate the root of the SMT
    await smtAlice.add(input1, input1);
    await smtAlice.add(input2, input2);

    // generate the merkle proof for the inputs
    const proof1 = await smtAlice.generateCircomVerifierProof(
      input1,
      ZERO_HASH,
    );
    const proof2 = await smtAlice.generateCircomVerifierProof(
      input2,
      ZERO_HASH,
    );

    // create two output UTXOs, they share the same salt, and different owner
    const salt3 = newSalt();
    const output1 = poseidonHash([
      BigInt(outputValues[0]),
      salt3,
      ...Alice.pubKey,
    ]);
    const outputCommitments = [output1];

    const startTime = Date.now();
    const witness = await circuit.calculateWTNSBin(
      {
        nullifiers,
        inputCommitments,
        inputValues,
        inputSalts: [salt1, salt2],
        inputOwnerPrivateKey: senderPrivateKey,
        root: proof1.root.bigInt(),
        merkleProof: [
          proof1.siblings.map((s) => s.bigInt()),
          proof2.siblings.map((s) => s.bigInt()),
        ],
        enabled: [1, 1],
        outputCommitments,
        outputValues,
        outputSalts: [salt3],
        outputOwnerPublicKeys: [Alice.pubKey],
      },
      true,
    );

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
    // console.log('nullifiers', nullifiers);
    // console.log('inputCommitments', inputCommitments);
    // console.log('outputCommitments', outputCommitments);
    // console.log('root', proof1.root.bigInt());
    // console.log("public signals", publicSignals);
    const tamperedOutputHash = poseidonHash([
      BigInt(100),
      salt3,
      ...Alice.pubKey,
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
  }).timeout(600000);
});
