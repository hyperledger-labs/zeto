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
pragma circom 2.2.2;

include "./anon_nullifier_base.circom";
include "../lib/kyber/mlkem.circom";
include "../lib/hash_signals.circom";
include "../lib/pubkey.circom";
include "../lib/encrypt.circom";

// This version of the circuit performs the following operations:
// - derive the sender's public key from the sender's private key
// - check the input and output commitments match the expected hashes
// - check the input and output values sum to the same amount
// - check the nullifiers are derived from the input commitments and the sender's private key
// - check the nullifiers are included in the Merkle tree
// - check the cipher texts are properly encrypted
template transfer(nInputs, nOutputs, nSMTLevels) {
  signal input nullifiers[nInputs]; // public signal
  signal input inputCommitments[nInputs];
  signal input inputValues[nInputs];
  signal input inputSalts[nInputs];
  // must be properly hashed and trimmed to be compatible with the BabyJub curve.
  // Reference: https://github.com/iden3/circomlib/blob/master/test/babyjub.js#L103
  signal input inputOwnerPrivateKey;
  signal input root; // public signal
  signal input merkleProof[nInputs][nSMTLevels];
  // allows merkle proof verifications for empty input elements to be skipped
  signal input enabled[nInputs]; // public signal
  signal input outputCommitments[nOutputs]; // public signal
  signal input outputValues[nOutputs];
  signal input outputOwnerPublicKeys[nOutputs][2];
  signal input outputSalts[nOutputs];
  signal input encryptionNonce;
  // the output for the list of encrypted output UTXOs cipher texts
  signal output cipherTexts[nOutputs][7];

  Zeto(nInputs, nOutputs, nSMTLevels)(
    nullifiers <== nullifiers,
    inputCommitments <== inputCommitments,
    inputValues <== inputValues,
    inputSalts <== inputSalts,
    inputOwnerPrivateKey <== inputOwnerPrivateKey,
    smtNodeValues <== inputCommitments,
    root <== root,
    merkleProof <== merkleProof,
    enabled <== enabled,
    outputCommitments <== outputCommitments,
    outputValues <== outputValues,
    outputOwnerPublicKeys <== outputOwnerPublicKeys,
    outputSalts <== outputSalts
  );

  // additional input signals for the cipher texts
  signal input randomness[256];
  // the output cipher texts is sent to the receiver to recover the shared secret
  signal output c[25];

  // additional constraints for the cipher texts
  component kem = mlkem_encaps();
  kem.m <== randomness;
  // the output of the mlkem_encaps is the shared secret K and the ciphertext c_short
  // the ciphertext is split into 25 groups of 256 bits, each group is a single group element
  // the first 24 groups are 248 bits each, and the last group is 192 bits long.
  // we don't need the K because it can be calculated from any standard mlkem implementation
  // using the same randomness and the sender's private key.
  c <== kem.c_short;

  // use the shared key from the mlkem encapsulation to derive the encryption key
  // for the Poseidon encryption
  signal sharedKey[256];
  sharedKey <== kem.K;

  signal encKey[2];
  encKey <== PublicKeyFromSeed()(seed <== sharedKey);
  // encKey is the public key derived from the shared key, which is used to encrypt
  for (var i = 0; i < nOutputs; i++) {
    // encrypt the value for the output UTXOs
    var plainText[4] = [outputValues[i], outputSalts[i], outputOwnerPublicKeys[i][0], outputOwnerPublicKeys[i][1]];
    cipherTexts[i] <== SymmetricEncrypt(4)(plainText <== plainText, key <== encKey, nonce <== encryptionNonce);
  }
}
