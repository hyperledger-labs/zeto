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

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/babyjub.circom";
include "../node_modules/circomlib/circuits/smt/smtverifier.circom";

// CheckNullifiers is a circuit that checks the nullifiers are correctly computed
// from the input values, salts and the owner private key.
//   - check that the nullifiers are correctly computed from the input values and salts
//
// commitment = hash(value, salt, ownerPublicKey1, ownerPublicKey2)
// nullifier = hash(value, salt, ownerPrivatekey)
//
template CheckNullifiers(numInputs) {
  signal input nullifiers[numInputs];
  signal input values[numInputs];
  signal input salts[numInputs];
  // must be properly hashed and trimmed to be compatible with the BabyJub curve.
  // Reference: https://github.com/iden3/circomlib/blob/master/test/babyjub.js#L103
  signal input ownerPrivateKey;

  // calculate the nullifier values from the input values
  component nullifierHashes[numInputs];
  component checkEquals[numInputs];
  component checkZero[numInputs];
  for (var i = 0; i < numInputs; i++) {
    nullifierHashes[i] = Poseidon(3);
    nullifierHashes[i].inputs[0] <== values[i];
    nullifierHashes[i].inputs[1] <== salts[i];
    nullifierHashes[i].inputs[2] <== ownerPrivateKey;

    // check that the nullifiers match the calculated hashes
    checkZero[i] = IsZero();
    checkZero[i].in <== nullifiers[i];
    checkEquals[i] = IsEqual();
    checkEquals[i].in[0] <== nullifiers[i];
    // ensure when nullifier is 0, compare with 0
    checkEquals[i].in[1] <== (1 - checkZero[i].out) * nullifierHashes[i].out;
    checkEquals[i].out === 1;
  }
}
