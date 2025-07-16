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
const {
  Poseidon,
  newSalt,
  loadCircuit,
  newEncryptionNonce,
} = require("../index.js");
const { loadProvingKeys } = require("./utils.js");
const {
  bytesToBits,
  recoverMlKemCiphertextBytes,
  publicKeyFromSeed,
  poseidonDecrypt,
} = require("../lib/util.js");
const { testKeyPair } = require("../test/lib/util.js");
const { randomFill } = require("crypto");
const util = require("util");
const randomFillSync = util.promisify(randomFill);
const { MlKem512 } = require("mlkem");

const SMT_HEIGHT = 64;
const poseidonHash = Poseidon.poseidon4;
const poseidonHash3 = Poseidon.poseidon3;

describe("main circuit tests for Zeto fungible tokens with anonymity using nullifiers with Kyber encryption", () => {
  let circuit, provingKeyFile, verificationKey, smtAlice;

  const Alice = {};
  const Bob = {};
  let senderPrivateKey;
  let pk, sk;
  let r, r_bytes;
  let encNonce;
  let mlkemCiphertext;
  let auditCiphertext;

  before(async () => {
    let keypair = genKeypair();
    Alice.privKey = keypair.privKey;
    Alice.pubKey = keypair.pubKey;
    senderPrivateKey = formatPrivKeyForBabyJub(Alice.privKey);

    keypair = genKeypair();
    Bob.privKey = keypair.privKey;
    Bob.pubKey = keypair.pubKey;

    // we use a fixed keypair for the tests, because the public key is statically
    // configured in the circuit.
    // For deployment, follow the documentation to generate a new keypair
    // and update the circuit accordingly.
    ({ pk, sk } = testKeyPair);

    // Randomness: a 256-bit seed used in the ML-KEM circuit
    r_bytes = new Uint8Array(32);
    await randomFillSync(r_bytes);
    r = bytesToBits(r_bytes);
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
    });

    describe("end-2-end workflow between the sender (Alice) and receiver (Bob) using the Qurrency circuit", () => {
      let inputValues, outputValues, inputSalts, outputSalts;
      let nullifiers, inputCommitments, outputCommitments;
      let root, merkleProof;

      it("Prepare the environment by creating UTXOs and add them to the local SMT", async () => {
        inputValues = [15, 100];
        outputValues = [80, 35];
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
        await smtAlice.add(input1, input1);
        await smtAlice.add(input2, input2);

        inputSalts = [salt1, salt2];
        inputCommitments = [input1, input2];
      });

      it("Alice prepares the inputs and outputs for the transfer", async () => {
        // create the nullifiers for the input UTXOs
        const nullifier1 = poseidonHash3([
          BigInt(inputValues[0]),
          inputSalts[0],
          senderPrivateKey,
        ]);
        const nullifier2 = poseidonHash3([
          BigInt(inputValues[1]),
          inputSalts[1],
          senderPrivateKey,
        ]);
        nullifiers = [nullifier1, nullifier2];

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

        outputSalts = [salt3, salt3];
        outputCommitments = [output1, output2];
      });

      it("Alice generates the merkle proof for the inputs", async () => {
        // generate the merkle proof for the inputs
        const proof1 = await smtAlice.generateCircomVerifierProof(
          inputCommitments[0],
          ZERO_HASH,
        );
        const proof2 = await smtAlice.generateCircomVerifierProof(
          inputCommitments[1],
          ZERO_HASH,
        );
        root = proof1.root;
        merkleProof = [
          proof1.siblings.map((s) => s.bigInt()),
          proof2.siblings.map((s) => s.bigInt()),
        ];
      });

      it("Alice calculates the ZKP witness and verifies the proof", async () => {
        const startTime = Date.now();
        encNonce = newEncryptionNonce();

        // Additionally compute the binary witness, so that we can compute and verify the associated proof
        const witnessBin = await circuit.calculateWTNSBin(
          {
            nullifiers,
            inputCommitments,
            inputValues,
            inputSalts,
            inputOwnerPrivateKey: senderPrivateKey,
            root: root.bigInt(),
            merkleProof,
            enabled: [1, 1],
            outputCommitments,
            outputValues,
            outputSalts,
            outputOwnerPublicKeys: [Bob.pubKey, Alice.pubKey],
            randomness: r,
            encryptionNonce: encNonce,
          },
          true,
        );

        const { proof, publicSignals } = await groth16.prove(
          provingKeyFile,
          witnessBin,
        );
        console.log("Proving time: ", (Date.now() - startTime) / 1000, "s");

        // console.log('Public signals: ', publicSignals);

        let verifyResult = await groth16.verify(
          verificationKey,
          publicSignals,
          proof,
        );
        expect(verifyResult).to.be.true;

        // check that the ZKP verification fails if the public signals are tampered with
        const tamperedOutputHash = poseidonHash([
          BigInt(100),
          outputSalts[0],
          ...Bob.pubKey,
        ]);
        let tamperedPublicSignals = publicSignals.map((ps) =>
          ps.toString() === outputCommitments[0].toString()
            ? tamperedOutputHash
            : ps,
        );
        verifyResult = await groth16.verify(
          verificationKey,
          tamperedPublicSignals,
          proof,
        );
        expect(verifyResult).to.be.false;
      }).timeout(600000);

      it("Alice computes the witness for her encapsulated key", async () => {
        const witness = await circuit.calculateWitness(
          {
            nullifiers,
            inputCommitments,
            inputValues,
            inputSalts,
            inputOwnerPrivateKey: senderPrivateKey,
            root: root.bigInt(),
            merkleProof,
            enabled: [1, 1],
            outputCommitments,
            outputValues,
            outputSalts,
            outputOwnerPublicKeys: [Bob.pubKey, Alice.pubKey],
            randomness: r,
            encryptionNonce: encNonce,
          },
          true,
        );

        // The encapsulated key is stored at indices 1 through 25 in the witness.
        mlkemCiphertext = recoverMlKemCiphertextBytes(witness.slice(1, 26));

        auditCiphertext = witness.slice(26, 42); // The next 16 output signals contain the ciphertext from encryption

        // Alice can verify the mlkem ciphertexts generated by the circuit
        const sender = new MlKem512();
        const [computedCiphertext, _] = await sender.encap(
          new Uint8Array(pk),
          new Uint8Array(r_bytes),
        );
        expect(computedCiphertext).to.deep.equal(mlkemCiphertext);

        // console.log('Ciphertext for encypted outputs: ', eCiphertext);
        // console.log('ML-KEM ciphertext: ', mlkemCiphertext);
        // console.log('nullifiers: ', nullifiers);
        // console.log('inputCommitments: ', inputCommitments);
        // console.log('inputValues: ', inputValues);
        // console.log('inputSalts: ', inputSalts);
        // console.log('outputCommitments: ', outputCommitments);
        // console.log('outputValues: ', outputValues);
        // console.log('outputSalts: ', outputSalts);
        // console.log('encNonce: ', encNonce);
        // console.log('root: ', root.bigInt());
      }).timeout(600000);

      it("The Auditor uses the K-PKE decapsulation key to decrypt the mlkem ciphertext and recover the symmetric encryption key, to then recover the tx secrets", async () => {
        const receiver = new MlKem512();
        const ssReceiver = await receiver.decap(
          new Uint8Array(mlkemCiphertext),
          new Uint8Array(sk),
        );
        // corresponding to the logic in the circuit "pubkey.circom", we derive the symmetric key
        // from the shared secret
        expect(ssReceiver.length).to.equal(32);
        const recoveredKey = publicKeyFromSeed(ssReceiver);

        let plainText = poseidonDecrypt(
          auditCiphertext,
          recoveredKey,
          encNonce,
          14,
        );
        expect(plainText[0]).to.equal(BigInt(Alice.pubKey[0]));
        expect(plainText[1]).to.equal(BigInt(Alice.pubKey[1]));
        expect(plainText[2]).to.equal(BigInt(inputValues[0]));
        expect(plainText[3]).to.equal(BigInt(inputSalts[0]));
      }).timeout(600000);
    });
  });
});
