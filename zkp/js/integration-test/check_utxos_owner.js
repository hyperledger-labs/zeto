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
const { Poseidon, newSalt, loadCircuit } = require("../index.js");
const { loadProvingKeys } = require("./utils.js");

const poseidonHash = Poseidon.poseidon4;
const poseidonHash3 = Poseidon.poseidon3;

describe("check_utxos_owner circuit tests", () => {
  let circuit, provingKeyFile, verificationKey, smtAlice;

  const Alice = {};
  let senderPrivateKey;

  before(async () => {
    circuit = await loadCircuit("check_utxos_owner");
    ({ provingKeyFile, verificationKey } = loadProvingKeys(
      "check_utxos_owner",
    ));

    let keypair = genKeypair();
    Alice.privKey = keypair.privKey;
    Alice.pubKey = keypair.pubKey;
    senderPrivateKey = formatPrivKeyForBabyJub(Alice.privKey);
  });

  it("should generate a valid proof that can be verified successfully and fail when public signals are tampered", async () => {
    const values = [15, 100];

    // create two input UTXOs, each has their own salt, but same owner
    const senderPrivateKey = formatPrivKeyForBabyJub(Alice.privKey);
    const salt1 = newSalt();
    const input1 = poseidonHash([
      BigInt(values[0]),
      salt1,
      ...Alice.pubKey,
    ]);
    const salt2 = newSalt();
    const input2 = poseidonHash([
      BigInt(values[1]),
      salt2,
      ...Alice.pubKey,
    ]);
    const commitments = [input1, input2];

    const startTime = Date.now();
    const witness = await circuit.calculateWTNSBin(
      {
        commitments,
        values,
        salts: [salt1, salt2],
        ownerPrivateKey: senderPrivateKey,
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
    const tamperedCommitment = poseidonHash([
      BigInt(values[0] + 1),
      salt1,
      ...Alice.pubKey,
    ]);
    let tamperedPublicSignals = publicSignals.map((ps) =>
      ps.toString() === commitments[0].toString()
        ? tamperedCommitment
        : ps,
    );

    verifyResult = await groth16.verify(
      verificationKey,
      tamperedPublicSignals,
      proof,
    );
    expect(verifyResult).to.be.false;
  }).timeout(600000);
});
