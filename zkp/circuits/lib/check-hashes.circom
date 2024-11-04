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

// CheckHashes is a circuit that checks the integrity of transactions of Fungible Tokens
//   - check that the commitments are the hash of the values, salts and owner public keys
//
// commitment = hash(value, salt, owner public key)
//
template CheckHashes(numInputs) {
  signal input commitments[numInputs];
  signal input values[numInputs];
  signal input salts[numInputs];
  signal input ownerPublicKeys[numInputs][2];

  // hash the input values
  component inputHashes[numInputs];
  component checkEquals[numInputs];
  component checkZero[numInputs];
  for (var i = 0; i < numInputs; i++) {
    // perform the hash calculation even though they are not needed when the input 
    // commitment at the current index is 0; this is because in zkp circuits we
    // must always perform the same computation (have the the same constraints)
    inputHashes[i] = Poseidon(4);
    inputHashes[i].inputs[0] <== values[i];
    inputHashes[i].inputs[1] <== salts[i];
    inputHashes[i].inputs[2] <== ownerPublicKeys[i][0];
    inputHashes[i].inputs[3] <== ownerPublicKeys[i][1];

    // check that the input commitments match the calculated hashes
    checkZero[i] = IsZero();
    checkZero[i].in <== commitments[i];
    checkEquals[i] = IsEqual();
    checkEquals[i].in[0] <== commitments[i];
    // ensure when commitment is 0, compare with 0
    checkEquals[i].in[1] <== (1 - checkZero[i].out) * inputHashes[i].out;
    checkEquals[i].out === 1;
  }
}
