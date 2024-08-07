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

// CheckNullifierHashesAndSum is a circuit that checks the integrity of transactions of Fungible Tokens
//   - check that all output values are positive numbers (within the range of 0 to 2^40)
//   - check that the nullifiers are correctly computed from the input values and salts
//   - check that the input commitments are correctly computed from the input values, salts, and owner public keys
//   - check that the input commitments are included in the Sparse Merkle Tree with the root `root`
//   - check that the output commitments are correctly computed from the output values, salts, and owner public keys
//   - check that the sum of input values equals the sum of output values
//
// nullifiers: array of hashes for the nullifiers corresponding to the input utxos
// inputValues: array of values, as preimages for the input hashes, for the input utxos
// output commitments: array of hashes for the output utxos
// outputValues: array of values, as preimages for the output hashes, for the output utxos
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
  var calculatedNullifierHashes[numInputs];
  for (var i = 0; i < numInputs; i++) {
    nullifierHashes[i] = Poseidon(3);
    nullifierHashes[i].inputs[0] <== values[i];
    nullifierHashes[i].inputs[1] <== salts[i];
    nullifierHashes[i].inputs[2] <== ownerPrivateKey;
    if (nullifiers[i] == 0) {
      calculatedNullifierHashes[i] = 0;
    } else {
      calculatedNullifierHashes[i] = nullifierHashes[i].out;
    }
  }

  // check that the nullifiers match the calculated hashes
  for (var i = 0; i < numInputs; i++) {
    assert(nullifiers[i] == calculatedNullifierHashes[i]);
  }
}
