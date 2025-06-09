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

const { expect } = require('chai');
const { groth16 } = require('snarkjs');
const { genKeypair, formatPrivKeyForBabyJub } = require('maci-crypto');
const { Merkletree, InMemoryDB, str2Bytes, ZERO_HASH } = require('@iden3/js-merkletree');
const ethers = require('ethers');
const { Poseidon, newSalt, loadCircuit } = require('../index.js');
const { loadProvingKeys } = require('./utils.js');
const { bitsToBytes, hashCiphertextAsFieldSignals, CT_INDEX } = require('../lib/util.js');
const { testKeyPair } = require('../test/lib/util.js');
const { randomFill, createCipheriv, createDecipheriv } = require('crypto');

const util = require('util');
const randomFillSync = util.promisify(randomFill);

const SMT_HEIGHT = 64;
const poseidonHash = Poseidon.poseidon4;
const poseidonHash3 = Poseidon.poseidon3;

describe('main circuit tests for Zeto fungible tokens with anonymity using nullifiers with Kyber encryption', () => {
  let circuit, provingKeyFile, verificationKey, smtAlice, smtBob;

  const Alice = {};
  const Bob = {};
  let senderPrivateKey;
  let sk;
  let m;
  let r;
  let ct;

  before(async () => {
    let keypair = genKeypair();
    Alice.privKey = keypair.privKey;
    Alice.pubKey = keypair.pubKey;
    senderPrivateKey = formatPrivKeyForBabyJub(Alice.privKey);

    keypair = genKeypair();
    Bob.privKey = keypair.privKey;
    Bob.pubKey = keypair.pubKey;

    // we use a fixed keypair for the tests, because the public key is statically
    // configured in the circuit. Follow the documentation to generate a new keypair
    // and update the circuit accordingly.
    ({ sk } = testKeyPair);

    // Message: a key for an AES-256 based cipher
    m = [
      1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1,
      1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 0,
      0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0,
      0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1,
    ];

    // Randomness: a 256-bit nonce
    r = [
      0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0,
      0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1,
      1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 1, 1,
      0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 1, 1,
    ];

    // Ciphertext: expected result of Enc(pk, m, r)
    // This is used to validate the output of this test
    ct = new Uint8Array([
      232, 72, 215, 40, 200, 26, 124, 17, 161, 10, 29, 77, 34, 214, 29, 217, 72, 9, 195, 124, 78, 84, 69, 31, 30, 233, 245, 64, 42, 172, 155, 57, 207, 44, 182, 132, 212, 27, 94, 245, 251, 26, 155, 84,
      136, 201, 51, 49, 144, 140, 236, 182, 120, 249, 224, 210, 232, 45, 142, 66, 104, 254, 84, 36, 29, 66, 29, 187, 54, 254, 193, 211, 194, 156, 201, 238, 219, 247, 49, 135, 71, 48, 248, 139, 165,
      89, 241, 186, 51, 107, 176, 98, 145, 209, 213, 33, 169, 14, 243, 182, 202, 107, 13, 247, 71, 204, 101, 103, 222, 30, 214, 173, 187, 55, 146, 117, 89, 3, 5, 76, 48, 110, 243, 56, 9, 190, 205, 64,
      113, 75, 207, 2, 161, 127, 56, 244, 122, 88, 99, 219, 86, 59, 253, 182, 20, 176, 67, 0, 89, 90, 89, 115, 233, 204, 40, 130, 44, 97, 67, 116, 201, 35, 72, 231, 19, 5, 96, 10, 86, 89, 230, 218,
      123, 175, 208, 7, 55, 237, 249, 225, 160, 48, 221, 67, 3, 212, 103, 218, 84, 129, 54, 60, 213, 250, 106, 226, 234, 188, 128, 117, 129, 163, 42, 223, 179, 107, 113, 151, 96, 22, 154, 21, 163,
      115, 194, 2, 49, 187, 156, 76, 38, 87, 145, 19, 38, 180, 64, 101, 19, 139, 16, 255, 150, 58, 106, 56, 203, 49, 215, 197, 59, 38, 85, 166, 21, 120, 211, 88, 219, 125, 42, 253, 205, 151, 233, 184,
      35, 239, 189, 64, 60, 87, 2, 17, 133, 75, 187, 213, 148, 116, 47, 75, 171, 148, 146, 112, 21, 179, 151, 93, 79, 114, 191, 151, 62, 110, 36, 80, 255, 122, 79, 168, 179, 46, 234, 29, 206, 176,
      241, 137, 219, 168, 22, 233, 218, 93, 22, 6, 227, 100, 216, 188, 97, 49, 128, 125, 70, 168, 191, 235, 118, 20, 124, 237, 215, 48, 58, 57, 80, 175, 139, 29, 183, 126, 145, 93, 33, 219, 42, 229,
      80, 218, 23, 69, 52, 206, 55, 45, 143, 50, 108, 127, 128, 176, 15, 213, 78, 63, 12, 179, 82, 48, 199, 147, 105, 83, 114, 116, 242, 15, 48, 160, 173, 160, 130, 16, 186, 14, 160, 252, 232, 194,
      18, 191, 39, 235, 117, 211, 237, 250, 198, 187, 180, 191, 167, 29, 204, 0, 36, 126, 188, 79, 76, 23, 73, 216, 8, 78, 73, 123, 57, 62, 219, 71, 79, 229, 44, 13, 193, 147, 59, 17, 45, 39, 97, 214,
      164, 6, 220, 40, 150, 55, 77, 28, 162, 226, 27, 41, 32, 17, 202, 162, 199, 196, 130, 79, 227, 231, 160, 131, 72, 210, 179, 54, 97, 85, 215, 215, 136, 114, 184, 98, 88, 194, 92, 48, 206, 137,
      242, 114, 65, 248, 148, 137, 226, 41, 163, 165, 228, 19, 39, 1, 135, 205, 73, 221, 100, 45, 84, 37, 30, 219, 107, 175, 126, 150, 245, 83, 191, 7, 197, 213, 133, 184, 73, 141, 5, 195, 192, 145,
      165, 124, 125, 227, 124, 80, 158, 12, 129, 243, 0, 77, 170, 19, 144, 47, 183, 136, 184, 170, 113, 217, 198, 103, 22, 9, 81, 29, 19, 122, 58, 19, 141, 82, 57, 234, 29, 206, 52, 119, 147, 224,
      236, 1, 186, 115, 19, 111, 233, 193, 62, 46, 241, 11, 21, 164, 43, 160, 229, 117, 59, 28, 234, 87, 195, 193, 52, 253, 215, 144, 233, 28, 187, 12, 200, 33, 64, 173, 103, 214, 226, 173, 189, 200,
      196, 153, 72, 32, 48, 121, 165, 141, 72, 98, 92, 32, 233, 28, 35, 183, 172, 54, 66, 242, 24, 118, 219, 168, 144, 36, 241, 125, 65, 0, 52, 199, 224, 187, 117, 109, 74, 129, 237, 64, 203, 67, 26,
      18, 230, 198, 48, 3, 195, 178, 20, 36, 25, 168, 2, 243, 29, 185, 95, 159, 245, 62, 222, 105, 240, 102, 78, 227, 204, 11, 206, 39, 199, 34, 209, 163, 172, 203, 185, 177, 2, 108, 140, 14, 224,
      202, 97, 147, 240, 89, 227, 198, 56, 212, 184, 254, 143, 84, 111, 143, 93, 195, 61, 29, 232, 71, 120, 132, 204, 58, 201, 126, 100, 199, 210, 4, 239, 132, 229, 213, 115, 138, 73, 122, 148, 8,
      127, 152, 81, 202, 151, 238, 207, 222, 83, 127, 82, 128, 125, 147, 106, 225, 85, 210, 86, 86, 157, 221, 82, 223, 136, 19, 6, 52, 114, 197, 134, 46, 219, 119, 216, 81, 74, 80, 172, 81, 223, 152,
      146, 20, 169, 56, 62, 239,
    ]);
  });

  describe('transfer()', () => {
    before(async () => {
      circuit = await loadCircuit('anon_nullifier_qurrency_transfer');
      ({ provingKeyFile, verificationKey } = loadProvingKeys('anon_nullifier_qurrency_transfer'));

      // initialize the local storage for Alice to manage her UTXOs in the Sparse Merkle Tree
      const storage1 = new InMemoryDB(str2Bytes(''));
      smtAlice = new Merkletree(storage1, true, SMT_HEIGHT);

      // initialize the local storage for Bob to manage his UTXOs in the Sparse Merkle Tree
      const storage2 = new InMemoryDB(str2Bytes(''));
      smtBob = new Merkletree(storage2, true, SMT_HEIGHT);
    });

    describe('end-2-end workflow between the sender (Alice) and receiver (Bob) using the Qurrency circuit', () => {
      let inputValues, outputValues, inputSalts, outputSalts;
      let nullifiers, inputCommitments, outputCommitments;
      let root, merkleProof;
      let aesKey, aesIV, aesCiphertext, aesPlaintext;
      const aesAlg = 'aes-256-cbc';

      it('Prepare the environment by creating UTXOs and add them to the local SMT', async () => {
        inputValues = [15, 100];
        outputValues = [80, 35];
        const salt1 = newSalt();
        const input1 = poseidonHash([BigInt(inputValues[0]), salt1, ...Alice.pubKey]);
        const salt2 = newSalt();
        const input2 = poseidonHash([BigInt(inputValues[1]), salt2, ...Alice.pubKey]);
        await smtAlice.add(input1, input1);
        await smtAlice.add(input2, input2);

        inputSalts = [salt1, salt2];
        inputCommitments = [input1, input2];
      });

      it('Alice prepares the inputs and outputs for the transfer', async () => {
        // create the nullifiers for the input UTXOs
        const nullifier1 = poseidonHash3([BigInt(inputValues[0]), inputSalts[0], senderPrivateKey]);
        const nullifier2 = poseidonHash3([BigInt(inputValues[1]), inputSalts[1], senderPrivateKey]);
        nullifiers = [nullifier1, nullifier2];

        // create two output UTXOs, they share the same salt, and different owner
        const salt3 = newSalt();
        const output1 = poseidonHash([BigInt(outputValues[0]), salt3, ...Bob.pubKey]);
        const output2 = poseidonHash([BigInt(outputValues[1]), salt3, ...Alice.pubKey]);

        outputSalts = [salt3, salt3];
        outputCommitments = [output1, output2];
      });

      it('Alice generates the merkle proof for the inputs', async () => {
        // generate the merkle proof for the inputs
        const proof1 = await smtAlice.generateCircomVerifierProof(inputCommitments[0], ZERO_HASH);
        const proof2 = await smtAlice.generateCircomVerifierProof(inputCommitments[1], ZERO_HASH);
        root = proof1.root;
        merkleProof = [proof1.siblings.map((s) => s.bigInt()), proof2.siblings.map((s) => s.bigInt())];
      });

      it('Alice generates the ciphertext for the auditor', async () => {
        // Generate ciphertext intended for the auditor
        aesPlaintext = JSON.stringify([
          inputCommitments.map((x) => x.toString(16)),
          inputValues,
          inputSalts.map((x) => x.toString(16)),
          Alice.pubKey.toString(16),
          outputValues.map((x) => x.toString(16)),
          outputSalts.map((x) => x.toString(16)),
          [Bob.pubKey, Alice.pubKey].map((x) => x.toString(16)),
        ]);

        // Encrypt data for the auditor
        aesIV = await randomFillSync(new Uint8Array(16));
        aesKey = bitsToBytes(m);
        const aesCipher = createCipheriv(aesAlg, aesKey, aesIV);
        aesCiphertext = aesCipher.update(aesPlaintext, 'utf8', 'hex');
        aesCiphertext += aesCipher.final('hex');
      });

      it('Alice calculates the ZKP witness and generates the proof', async () => {
        const startTime = Date.now();

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
            // Extra inputs for K-PKE encryption.
            // Map "1" bits to "1665" as required by the kyber_enc circuit.
            m: m.map((b) => 1665 * b),
            randomness: r,
          },
          true
        );

        const { proof, publicSignals } = await groth16.prove(provingKeyFile, witnessBin);
        console.log('Proving time: ', (Date.now() - startTime) / 1000, 's');

        let verifyResult = await groth16.verify(verificationKey, publicSignals, proof);
        expect(verifyResult).to.be.true;

        // check that the ZKP verification fails if the public signals are tampered with
        const tamperedOutputHash = poseidonHash([BigInt(100), salt3, ...Bob.pubKey]);
        let tamperedPublicSignals = publicSignals.map((ps) => (ps.toString() === outputCommitments[0].toString() ? tamperedOutputHash : ps));
        verifyResult = await groth16.verify(verificationKey, tamperedPublicSignals, proof);
        expect(verifyResult).to.be.false;
      }).timeout(600000);

      it('Alice extracts the K-PKE ciphertext from the witness and verify the hash', async () => {
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
            // Extra inputs for K-PKE encryption.
            // Map "1" bits to "1665" as required by the kyber_enc circuit.
            m: m.map((b) => 1665 * b),
            randomness: r,
          },
          true
        );

        // Check that the computed AES and K-PKE ciphertexts are computed correctly
        const anqIndex = CT_INDEX['anon_nullifier_qurrency'];
        const computedCiphertext = witness.slice(anqIndex, anqIndex + 768);
        expect(computedCiphertext).to.deep.equal(Array.from(ct).map((x) => BigInt(x)));

        // Check that the computed circuit outputs are computed correctly
        const computed_pubSignals = [witness[1], witness[2]];
        const expected_pubSignals = hashCiphertextAsFieldSignals(ct);
        expect(computed_pubSignals).to.deep.equal(expected_pubSignals);
      }).timeout(600000);

      it('Bob uses the K-PKE decapsulation key to decrypt the ciphertext and recover the AES encryption key, to then recover the tx secrets', async () => {
        // TODO: Implement the decryption logic for Bob using the K-PKE decapsulation key.
        // for now cheat by using the same key as Alice
        const recoveredAesKey = aesKey;

        // Check that the AES ciphertext for the auditor decrypts correctly
        const aesDecipher = createDecipheriv(aesAlg, recoveredAesKey, aesIV);
        let aesDecrypted = aesDecipher.update(aesCiphertext, 'hex', 'utf8');
        aesDecrypted += aesDecipher.final('utf8');
        expect(aesDecrypted).to.deep.equal(aesPlaintext);
      }).timeout(600000);
    });
  });
});
