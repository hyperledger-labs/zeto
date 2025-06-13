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
const { bitsToBytes, bytesToBits } = require('../lib/util.js');
const { testKeyPair } = require('../test/lib/util.js');
const { randomFill, createCipheriv, createDecipheriv } = require('crypto');
const { mlkem } = require('mlkem');

const util = require('util');
const { MlKem512 } = require('mlkem');
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
  let r;
  let ssS; // Shared secret (sender)
  let computedCiphertext;

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
    let r_bytes = new Uint8Array(32);
    await randomFillSync(r_bytes);
    r = bytesToBits(r_bytes);

    // Generate the encapsulated key using r_bytes
    const sender = new MlKem512();
    [computedCiphertext, ssS] = await sender.encap(pk, r_bytes);
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
        aesKey = ssS;
        const aesCipher = createCipheriv(aesAlg, aesKey, aesIV);
        aesCiphertext = aesCipher.update(aesPlaintext, 'utf8', 'hex');
        aesCiphertext += aesCipher.final('hex');
      });

      it('Alice calculates the ZKP witness and verifies the proof', async () => {
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
            randomness: r,
          },
          true
        );

        const { proof, publicSignals } = await groth16.prove(provingKeyFile, witnessBin);
        console.log('Proving time: ', (Date.now() - startTime) / 1000, 's');

        let verifyResult = await groth16.verify(verificationKey, publicSignals, proof);
        expect(verifyResult).to.be.true;

        // check that the ZKP verification fails if the public signals are tampered with
        const tamperedOutputHash = poseidonHash([BigInt(100), outputSalts[0], ...Bob.pubKey]);
        let tamperedPublicSignals = publicSignals.map((ps) => (ps.toString() === outputCommitments[0].toString() ? tamperedOutputHash : ps));
        verifyResult = await groth16.verify(verificationKey, tamperedPublicSignals, proof);
        expect(verifyResult).to.be.false;
      }).timeout(600000);

      it('Alice computes the witness for her encapsulated key', async () => {
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
            randomness: r,
          },
          true
        );

        // The encapsulated key is stored at indices 1 through 25 in the witness.
        const resultCiphertext = qurrencyCtToBytes(witness.slice(1, 26));

        const auditor = new MlKem512();
        const ssR = await auditor.decap(resultCiphertext, sk); // Shared secret (recipient)

        // Check that the computed key was computed correctly
        expect(ssR).to.deep.equal(ssS);

        expect(resultKey).to.deep.equal(ssS);

        // // Check that the computed circuit outputs are computed correctly
        // const computed_pubSignals = [witness[1], witness[2]];
        // const expected_pubSignals = hashCiphertextAsFieldSignals(ct);
        // expect(computed_pubSignals).to.deep.equal(expected_pubSignals);
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

function qurrencyCtToBytes(ct) {
  let bits = [];
  for (var i = 0; i < 25; i++) {
    let size;
    // The first 24 output elements store 254 bits
    if (i < 24) {
      size = 254;
    } else {
      // The last element stores the last 48 bits
      size = 48;
    }
    let elt = ct[i].toString(2);
    while (elt.length < size) {
      elt = '0' + elt;
    }
    bits.push(...elt.split('').map(Number));
  }

  return bitsToBytes(bits);
}
