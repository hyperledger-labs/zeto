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
pragma circom 2.2.1;

include "../lib/check-positive.circom";
include "../lib/check-hashes.circom";
include "../lib/check-sum.circom";
include "../lib/check-nullifiers.circom";
include "../lib/check-smt-proof.circom";
include "../lib/encrypt-outputs.circom";
include "../node_modules/circomlib/circuits/babyjub.circom";

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
  // an ephemeral private key that is used to generated the shared ECDH key for encryption
  signal input ecdhPrivateKey;
  signal input root;
  signal input merkleProof[nInputs][nSMTLevels];
  signal input enabled[nInputs];
  signal input outputCommitments[nOutputs];
  signal input outputValues[nOutputs];
  signal input outputSalts[nOutputs];
  signal input outputOwnerPublicKeys[nOutputs][2];
  signal input encryptionNonce;
  signal input authorityPublicKey[2];

  // the output for the public key of the ephemeral private key used in generating ECDH shared key
  signal output ecdhPublicKey[2];

  // the output for the list of encrypted output UTXOs cipher texts
  signal output cipherTexts[nOutputs][4];
  
  // the number of cipher text messages returned by
  // the encryption template will be 3n+1
  // input length: 
  //   - input owner public key (x, y): 2
  //   - secrets (value and salt) for each input UTXOs: 2 * nInputs
  //   - output owner public keys (x, y): 2 * nOutputs
  //   - secrets (value and salt) for each output UTXOs: 2 * nOutputs
  var outputElementsLength = 2 + 2 * nInputs + 2 * nOutputs + 2 * nOutputs;
  var l = outputElementsLength;
  if (l % 3 != 0) {
    l += (3 - (l % 3));
  }
  signal output cipherTextAuthority[l+1];

  // derive the sender's public key from the secret input
  // for the sender's private key. This step demonstrates
  // the sender really owns the private key for the input
  // UTXOs
  var inputOwnerPubKeyAx, inputOwnerPubKeyAy;
  (inputOwnerPubKeyAx, inputOwnerPubKeyAy) = BabyPbk()(in <== inputOwnerPrivateKey);

  var inputOwnerPublicKeys[nInputs][2];
  for (var i = 0; i < nInputs; i++) {
    inputOwnerPublicKeys[i] = [inputOwnerPubKeyAx, inputOwnerPubKeyAy];
  }

  CheckPositive(nOutputs)(outputValues <== outputValues);

  CheckHashes(nInputs)(commitments <== inputCommitments, values <== inputValues, salts <== inputSalts, ownerPublicKeys <== inputOwnerPublicKeys);

  CheckHashes(nOutputs)(commitments <== outputCommitments, values <== outputValues, salts <== outputSalts, ownerPublicKeys <== outputOwnerPublicKeys);

  CheckNullifiers(nInputs)(nullifiers <== nullifiers, values <== inputValues, salts <== inputSalts, ownerPrivateKey <== inputOwnerPrivateKey);

  CheckSum(nInputs, nOutputs)(inputValues <== inputValues, outputValues <== outputValues);

  // With the above steps, we demonstrated that the nullifiers
  // are securely bound to the input commitments. Now we need to
  // demonstrate that the input commitments belong to the Sparse
  // Merkle Tree with the root `root`.
  CheckSMTProof(nInputs, nSMTLevels)(root <== root, merkleProof <== merkleProof, enabled <== enabled, leafNodeIndexes <== inputCommitments, leafNodeValues <== inputCommitments);

  // Generate cipher text for output utxos
  (ecdhPublicKey, cipherTexts) <== EncryptOutputs(nOutputs)(ecdhPrivateKey <== ecdhPrivateKey, outputValues <== outputValues, outputSalts <== outputSalts, outputOwnerPublicKeys <== outputOwnerPublicKeys, encryptionNonce <== encryptionNonce);

  // generate shared secret for the authority
  var sharedSecretAuthority[2];
  (sharedSecretAuthority) = Ecdh()(privKey <== ecdhPrivateKey, pubKey <== authorityPublicKey);

  // prepare text to be created for the authority
  var plainText[2 + 2 * nInputs + 4 * nOutputs];
  plainText[0] = inputOwnerPubKeyAx;
  plainText[1] = inputOwnerPubKeyAy;
  var idx1 = 2;
  for (var i = 0; i < nInputs; i++) {
    plainText[idx1] = inputValues[i];
    idx1++;
    plainText[idx1] = inputSalts[i];
    idx1++;
  }
  for (var i = 0; i < nOutputs; i++) {
    plainText[idx1] = outputOwnerPublicKeys[i][0];
    idx1++;
    plainText[idx1] = outputOwnerPublicKeys[i][1];
    idx1++;
  }
  for (var i = 0; i < nOutputs; i++) {
    plainText[idx1] = outputValues[i];
    idx1++;
    plainText[idx1] = outputSalts[i];
    idx1++;
  }

  // encrypt the values for the authority
  cipherTextAuthority <== SymmetricEncrypt(2 + 2 * nInputs + 4 * nOutputs)(plainText <== plainText, key <== sharedSecretAuthority, nonce <== encryptionNonce);
}