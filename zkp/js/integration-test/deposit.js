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

const poseidonHash = Poseidon.poseidon4;

describe("deposit circuit tests", () => {
  let circuit;
  const sender = {};
  before(async () => {
    circuit = await loadCircuit("deposit");
    let keypair = genKeypair();
    sender.privKey = keypair.privKey;
    sender.pubKey = keypair.pubKey;
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

    let witness = await circuit.calculateWitness(
      {
        outputCommitments,
        outputValues,
        outputSalts: [salt1, salt1],
        outputOwnerPublicKeys: [sender.pubKey, sender.pubKey],
      },
      true,
    );

    expect(witness[1]).to.equal(BigInt(200)); // index 1 is the output, for the calculated value

    witness = await circuit.calculateWTNSBin(
      {
        outputCommitments,
        outputValues,
        outputSalts: [salt1, salt1],
        outputOwnerPublicKeys: [sender.pubKey, sender.pubKey],
      },
      true,
    );
    const { provingKeyFile, verificationKey } = loadProvingKeys("deposit");
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
    // console.log('output commitments', outputCommitments);
    // console.log('output values', outputValues);
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
