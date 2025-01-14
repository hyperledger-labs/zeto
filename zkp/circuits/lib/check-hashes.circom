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

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/comparators.circom";

bus CommitmentInputs(){
    signal value;
    signal salt;
    signal ownerPublicKey[2];
}

template CheckPositiveValues(numInputs) {
  input CommitmentInputs() commitmentInputs[numInputs];

  // check that the output values are within the expected range. we don't allow negative values
  for (var i = 0; i < numInputs; i++) {
    var greaterEqThanZero;
    greaterEqThanZero = GreaterEqThan(100)(in <== [commitmentInputs[i].value, 0]);
    greaterEqThanZero === 1;
  }
}

// CheckHashes is a circuit that checks the integrity of transactions of Fungible Tokens
//   - check that the commitments are the hash of the values, salts and owner public keys
//
// commitment = hash(value, salt, owner public key)
//
template CheckHashes(numInputs) {
  signal input commitmentHashes[numInputs];
  input CommitmentInputs() commitmentInputs[numInputs];

  // hash the input values
  for (var i = 0; i < numInputs; i++) {
    // perform the hash calculation even though they are not needed when the input 
    // commitment at the current index is 0; this is because in zkp circuits we
    // must always perform the same computation (have the the same constraints)
    var calculatedHash;
    calculatedHash = Poseidon(4)([commitmentInputs[i].value, commitmentInputs[i].salt, commitmentInputs[i].ownerPublicKey[0], commitmentInputs[i].ownerPublicKey[1]]);

    // check that the input commitments match the calculated hashes
    var isCommitmentZero;
    isCommitmentZero = IsZero()(in <== commitmentHashes[i]);

    var isHashEqual;
    isHashEqual = IsEqual()(in <== [commitmentHashes[i], (1 - isCommitmentZero) * calculatedHash /* ensure when commitment is 0, compare with 0 */]);

    isHashEqual === 1;
  }
}
