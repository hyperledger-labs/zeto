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
const { groth16 } = require("snarkjs");
const { genKeypair, formatPrivKeyForBabyJub } = require("maci-crypto");
const {
  Merkletree,
  InMemoryDB,
  str2Bytes,
  ZERO_HASH,
} = require("@iden3/js-merkletree");
const ethers = require("ethers");
const { Poseidon, newSalt, loadCircuit } = require("../index.js");
const { loadProvingKeys, bytesToBits } = require("./utils.js");
const { promisify } = require("util");
const { generateKey, randomBytes } = require("node:crypto");

const SMT_HEIGHT = 64;
const poseidonHash = Poseidon.poseidon4;
const poseidonHash3 = Poseidon.poseidon3;

// util functions
const generateKeyAsync = promisify(generateKey);
const randomBytesAsync = promisify(randomBytes);

describe("main circuit tests for Zeto fungible tokens with anonymity using nullifiers and without encryption", () => {
  let circuit, provingKeyFile, verificationKey, smtAlice, smtBob;

  const Alice = {};
  const Bob = {};
  let senderPrivateKey;

  before(async () => {
    let keypair = genKeypair();
    Alice.privKey = keypair.privKey;
    Alice.pubKey = keypair.pubKey;
    senderPrivateKey = formatPrivKeyForBabyJub(Alice.privKey);

    keypair = genKeypair();
    Bob.privKey = keypair.privKey;
    Bob.pubKey = keypair.pubKey;

    // K-PKE key setup
    let sk = [84,150,171,241,179,171,42,134,154,178,113,67,64,16,139,67,232,176,215,232,73,109,252,173,67,65,47,60,27,47,150,137,23,97,21,16,203,22,118,58,2,28,130,51,19,175,0,119,109,25,7,41,24,51,253,195,103,41,48,175,57,19,148,29,50,155,77,128,24,8,96,123,55,58,2,187,74,131,161,64,102,77,42,152,249,241,206,215,33,16,135,154,65,243,56,74,8,99,68,239,152,207,89,100,196,148,52,116,33,201,27,246,73,8,65,169,124,162,156,178,116,0,70,175,28,105,250,244,93,146,150,38,65,224,104,161,98,130,214,36,25,86,75,189,23,105,60,66,236,109,60,248,90,62,89,124,173,119,184,69,84,136,110,108,61,164,167,154,94,7,181,210,11,206,182,60,182,184,208,11,233,4,132,0,160,134,245,65,113,109,44,4,219,11,176,46,52,16,252,197,97,222,212,141,164,66,173,213,43,132,119,160,107,226,234,141,163,41,101,83,208,89,168,242,71,97,124,148,136,140,183,152,21,45,118,135,77,128,90,84,33,54,149,159,5,44,159,24,110,52,66,157,95,6,172,167,0,197,118,6,70,200,56,87,228,210,148,3,185,172,114,149,150,97,102,191,238,227,159,61,208,90,238,91,70,108,188,158,110,124,86,129,179,18,164,25,35,241,177,183,0,212,5,176,226,66,29,42,157,130,171,59,14,104,156,6,229,113,167,69,194,241,75,195,197,233,106,121,215,159,139,166,62,165,7,72,207,251,116,14,131,27,169,215,126,225,112,15,57,103,85,93,170,162,161,66,28,26,196,23,87,11,54,17,120,100,64,107,95,92,108,31,76,208,26,12,135,194,170,124,72,54,245,111,194,67,160,1,155,62,180,131,185,65,65,177,63,252,20,82,252,178,227,168,124,143,4,174,193,51,40,26,104,90,190,233,39,28,39,123,12,19,48,82,117,0,39,32,119,235,187,65,26,121,93,139,228,178,19,242,1,172,49,80,163,241,163,68,24,154,208,241,42,71,151,110,54,83,43,6,5,4,238,251,26,225,144,191,136,130,171,208,112,21,214,232,207,220,236,6,9,200,61,192,193,53,183,51,72,127,135,189,21,199,132,249,49,124,179,195,115,226,152,63,231,233,129,160,100,144,112,201,38,182,220,104,208,6,163,88,27,78,173,75,132,74,234,177,162,33,155,250,213,79,83,216,189,197,52,93,147,226,159,255,193,195,237,177,32,152,224,154,177,216,80,93,171,204,58,165,141,253,139,48,92,2,130,94,41,182,126,163,131,212,247,150,200,202,86,54,68,184,125,90,202,157,188,122,122,179,153,6,37,27,110,242,106,16,116,117,212,248,64,119,42,90,150,87,11,233,150,130,39,231,203,112,17,16,1,150,171,205,188,67,167,21,90,72,136,63,180,213,202,87,115,132,100,35,105,107,251,50,195,182,161,172,243,52,111,139,137,110,251,93,197,210,174,237,37,130,203,198,207,3,133,88,46,248,192,40,213,26,61,209,61,108,101,199,9,243,200,162,107,41,121,217,160,165,242,192,238,75,64,151,124,164,177,244,21,37,104,61,156,236,133,247,123,43,86,0,6,4,186,49,80,67,178,173,152,54,97,225,184,221,224,43,36,232,95,133,17,133,7,59,40,85,227,130,87,153,56,167,118,93,65,198,26,192,70,114,101,162,65,60,251,199,16,76,99,19,73,146,187,153,24,184,107,156];
  });

  describe("transfer()", () => {
    before(async () => {
      circuit = await loadCircuit("anon_nullifier_qurrency_transfer");
      ({ provingKeyFile, verificationKey } = loadProvingKeys(
        "anon_nullifier_qurrency_transfer",
      ));

      // initialize the local storage for Alice to manage her UTXOs in the Sparse Merkle Tree
      const storage1 = new InMemoryDB(str2Bytes(""));
      smtAlice = new Merkletree(storage1, true, SMT_HEIGHT);

      // initialize the local storage for Bob to manage his UTXOs in the Sparse Merkle Tree
      const storage2 = new InMemoryDB(str2Bytes(""));
      smtBob = new Merkletree(storage2, true, SMT_HEIGHT);
    });

    it("should generate a valid proof that can be verified successfully and fail when public signals are tampered", async () => {
      const inputValues = [15, 100];
      const outputValues = [80, 35];
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
        ...Bob.pubKey,
      ]);
      const output2 = poseidonHash([
        BigInt(outputValues[1]),
        salt3,
        ...Alice.pubKey,
      ]);
      const outputCommitments = [output1, output2];

      // AES-256 key setup
      // let aesKey = await generateKeyAsync('aes', { length: 256 });
      let aesKey = await randomBytesAsync(32);
      console.log("key", aesKey);
      let aesKeyBits = bytesToBits(aesKey);
      // const cipher = crypto.createCipheriv("aes-256-cbc", aesKey, null);
      let r = await randomBytesAsync(32);
      console.log("r:", r);
      let rBits = bytesToBits(r);

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
          outputSalts: [salt3, salt3],
          outputOwnerPublicKeys: [Bob.pubKey, Alice.pubKey],
          // Extra inputs for K-PKE encryption
          m: aesKeyBits.map((b) => 1665*b),
          randomness: rBits,
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
      // console.log('public signals', publicSignals);
      const tamperedOutputHash = poseidonHash([
        BigInt(100),
        salt3,
        ...Bob.pubKey,
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
});
