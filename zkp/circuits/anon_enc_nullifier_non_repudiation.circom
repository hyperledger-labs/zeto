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
pragma circom 2.1.4;

include "./lib/check-positive.circom";
include "./lib/check-hashes.circom";
include "./lib/check-sum.circom";
include "./lib/check-nullifiers.circom";
include "./lib/check-smt-proof.circom";
include "./lib/ecdh.circom";
include "./lib/encrypt.circom";
include "./node_modules/circomlib/circuits/babyjub.circom";

// This version of the circuit performs the following operations:
// - derive the sender's public key from the sender's private key
// - check the input and output commitments match the expected hashes
// - check the input and output values sum to the same amount
// - perform encryption of the receiver's output UTXO value and salt
// - check the nullifiers are derived from the input commitments and the sender's private key
// - check the nullifiers are included in the Merkle tree
// - encrypt all secrets with an authority's public key (for non-repudiation purposes)
template Zeto(nInputs, nOutputs, nSMTLevels) {
  signal input nullifiers[nInputs];
  signal input inputCommitments[nInputs];
  signal input inputValues[nInputs];
  signal input inputSalts[nInputs];
  // must be properly hashed and trimmed to be compatible with the BabyJub curve.
  // Reference: https://github.com/iden3/circomlib/blob/master/test/babyjub.js#L103
  signal input inputOwnerPrivateKey;
  signal input root;
  signal input merkleProof[nInputs][nSMTLevels];
  signal input enabled[nInputs];
  signal input outputCommitments[nOutputs];
  signal input outputValues[nOutputs];
  signal input outputSalts[nOutputs];
  signal input outputOwnerPublicKeys[nOutputs][2];
  signal input encryptionNonce;
  signal input authorityPublicKey[2];

  signal output cipherText[2];
  signal output authorityCipherText_inputOwner[2];
  // two encrypted values for each input: value and salt
  signal output authorityCipherText_inputs[2 * nInputs];
  signal output authorityCipherText_outputOwner[2 * nOutputs];
  // two encrypted values for each input: value and salt
  signal output authorityCipherText_outputs[2 * nOutputs];

  // derive the sender's public key from the secret input
  // for the sender's private key. This step demonstrates
  // the sender really owns the private key for the input
  // UTXOs
  var inputOwnerPublicKey[2];
  component pub = BabyPbk();
  pub.in <== inputOwnerPrivateKey;
  inputOwnerPublicKey[0] = pub.Ax;
  inputOwnerPublicKey[1] = pub.Ay;
  var inputOwnerPublicKeys[nInputs][2];
  for (var i = 0; i < nInputs; i++) {
    inputOwnerPublicKeys[i][0] = inputOwnerPublicKey[0];
    inputOwnerPublicKeys[i][1] = inputOwnerPublicKey[1];
  }

  component checkPositives = CheckPositive(nOutputs);
  checkPositives.outputValues <== outputValues;

  component checkInputHashes = CheckHashes(nInputs);
  checkInputHashes.commitments <== inputCommitments;
  checkInputHashes.values <== inputValues;
  checkInputHashes.salts <== inputSalts;
  checkInputHashes.ownerPublicKeys <== inputOwnerPublicKeys;

  component checkOutputHashes = CheckHashes(nOutputs);
  checkOutputHashes.commitments <== outputCommitments;
  checkOutputHashes.values <== outputValues;
  checkOutputHashes.salts <== outputSalts;
  checkOutputHashes.ownerPublicKeys <== outputOwnerPublicKeys;

  component checkNullifiers = CheckNullifiers(nInputs);
  checkNullifiers.nullifiers <== nullifiers;
  checkNullifiers.values <== inputValues;
  checkNullifiers.salts <== inputSalts;
  checkNullifiers.ownerPrivateKey <== inputOwnerPrivateKey;

  component checkSum = CheckSum(nInputs, nOutputs);
  checkSum.inputValues <== inputValues;
  checkSum.outputValues <== outputValues;

  // With the above steps, we demonstrated that the nullifiers
  // are securely bound to the input commitments. Now we need to
  // demonstrate that the input commitments belong to the Sparse
  // Merkle Tree with the root `root`.
  component checkSMTProof = CheckSMTProof(nInputs, nSMTLevels);
  checkSMTProof.root <== root;
  checkSMTProof.merkleProof <== merkleProof;
  checkSMTProof.enabled <== enabled;
  checkSMTProof.leafNodeIndexes <== inputCommitments;

  // generate shared secret for the receiver
  var sharedSecretReceiver[2];
  component ecdh1 = Ecdh();
  ecdh1.privKey <== inputOwnerPrivateKey;
  // our circuit requires that the output UTXO for the receiver must be the first in the array
  ecdh1.pubKey[0] <== outputOwnerPublicKeys[0][0];
  ecdh1.pubKey[1] <== outputOwnerPublicKeys[0][1];
  sharedSecretReceiver[0] = ecdh1.sharedKey[0];
  sharedSecretReceiver[1] = ecdh1.sharedKey[1];

  // encrypt the value for the receiver
  component encrypt1 = SymmetricEncrypt(2);
  // our circuit requires that the output UTXO for the receiver must be the first in the array
  encrypt1.plainText[0] <== outputValues[0];
  encrypt1.plainText[1] <== outputSalts[0];
  encrypt1.key <== sharedSecretReceiver;
  encrypt1.nonce <== encryptionNonce;
  encrypt1.cipherText[0] --> cipherText[0];
  encrypt1.cipherText[1] --> cipherText[1];

  // generate shared secret for the authority
  var sharedSecretAuthority[2];
  component ecdh2 = Ecdh();
  ecdh2.privKey <== inputOwnerPrivateKey;
  // our circuit requires that the output UTXO for the receiver must be the first in the array
  ecdh2.pubKey[0] <== authorityPublicKey[0];
  ecdh2.pubKey[1] <== authorityPublicKey[1];
  sharedSecretAuthority[0] = ecdh2.sharedKey[0];
  sharedSecretAuthority[1] = ecdh2.sharedKey[1];

  // encrypt the values for the authority
  component encrypt2 = SymmetricEncrypt(2 + 2 * nInputs + 4 * nOutputs);
  encrypt2.plainText[0] <== inputOwnerPublicKey[0];
  encrypt2.plainText[1] <== inputOwnerPublicKey[1];
  var idx1 = 2;
  for (var i = 0; i < nInputs; i++) {
    encrypt2.plainText[idx1] <== inputValues[i];
    idx1++;
    encrypt2.plainText[idx1] <== inputSalts[i];
    idx1++;
  }
  for (var i = 0; i < nOutputs; i++) {
    encrypt2.plainText[idx1] <== outputOwnerPublicKeys[i][0];
    idx1++;
    encrypt2.plainText[idx1] <== outputOwnerPublicKeys[i][1];
    idx1++;
  }
  for (var i = 0; i < nOutputs; i++) {
    encrypt2.plainText[idx1] <== outputValues[i];
    idx1++;
    encrypt2.plainText[idx1] <== outputSalts[i];
    idx1++;
  }
  encrypt2.key <== sharedSecretAuthority;
  encrypt2.nonce <== encryptionNonce;
  encrypt2.cipherText[0] --> authorityCipherText_inputOwner[0];
  encrypt2.cipherText[1] --> authorityCipherText_inputOwner[1];
  var idx2 = 2;
  var j1 = 0;
  for (var i = 0; i < nInputs; i++) {
    encrypt2.cipherText[idx2] --> authorityCipherText_inputs[j1];
    idx2++;
    j1++;
    encrypt2.cipherText[idx2] --> authorityCipherText_inputs[j1];
    idx2++;
    j1++;
  }
  var j2 = 0;
  for (var i = 0; i < nOutputs; i++) {
    encrypt2.cipherText[idx2] --> authorityCipherText_outputOwner[j2];
    idx2++;
    j2++;
    encrypt2.cipherText[idx2] --> authorityCipherText_outputOwner[j2];
    idx2++;
    j2++;
  }
  var j3 = 0;
  for (var i = 0; i < nOutputs; i++) {
    encrypt2.cipherText[idx2] --> authorityCipherText_outputs[j3];
    idx2++;
    j3++;
    encrypt2.cipherText[idx2] --> authorityCipherText_outputs[j3];
    idx2++;
    j3++;
  }
}

component main { public [ nullifiers, outputCommitments, encryptionNonce, root, enabled, authorityPublicKey ] } = Zeto(2, 2, 64);