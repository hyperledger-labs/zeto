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
pragma circom 2.1.9;

include "./lib/check-hashes.circom";
include "./lib/check-nullifiers.circom";
include "./node_modules/circomlib/circuits/babyjub.circom";

//
// Verifies that the nullifiers are correctly bound to the input commitments
//
// commitment = hash(value, salt, ownerPublicKey1, ownerPublicKey2)
// nullifier = hash(value, salt, ownerPrivatekey)
//
template Zeto(numInputs) {
  signal input nullifiers[numInputs];
  signal input inputCommitments[numInputs];
  signal input inputValues[numInputs];
  signal input inputSalts[numInputs];
  // must be properly hashed and trimmed to be compatible with the BabyJub curve.
  // Reference: https://github.com/iden3/circomlib/blob/master/test/babyjub.js#L103
  signal input inputOwnerPrivateKey;

  // derive the sender's public key from the secret input
  // for the sender's private key. This step demonstrates
  // the sender really owns the private key for the input
  // UTXOs
  var inputOwnerPubKeyAx, inputOwnerPubKeyAy;
  (inputOwnerPubKeyAx, inputOwnerPubKeyAy) = BabyPbk()(in <== inputOwnerPrivateKey);

  var inputOwnerPublicKeys[numInputs][2];
  for (var i = 0; i < numInputs; i++) {
    inputOwnerPublicKeys[i] = [inputOwnerPubKeyAx, inputOwnerPubKeyAy];
  }

  CheckHashes(numInputs)(commitments <== inputCommitments, values <== inputValues, salts <== inputSalts, ownerPublicKeys <== inputOwnerPublicKeys);

  CheckNullifiers(numInputs)(nullifiers <== nullifiers, values <== inputValues, salts <== inputSalts, ownerPrivateKey <== inputOwnerPrivateKey);
}

component main { public [ nullifiers, inputCommitments ] } = Zeto(2);