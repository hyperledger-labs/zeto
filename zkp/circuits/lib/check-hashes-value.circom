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

// CheckHashesValue is a circuit that checks the integrity of transactions of Fungible Tokens
//   - check that all output values are positive numbers (within the range of 0 to 2^40)
//   - check that the output commitments are the hash of the output values
//   - check that the sum of output values equals a total value in the output
//
// output commitments: array of hashes for the output utxos
// outputValues: array of values, as preimages for the output hashes, for the output utxos
//
// commitment = hash(value, salt, ownerAddress)
//
template CheckHashesValue(numOutputs) {
  signal input outputCommitments[numOutputs];
  signal input outputValues[numOutputs];
  signal input outputSalts[numOutputs];
  signal input outputOwnerPublicKeys[numOutputs][2];
  signal output out;

  // check that the output values are within the expected range. we don't allow negative values
  component positive[numOutputs];
  var isPositive[numOutputs];
  for (var i = 0; i < numOutputs; i++) {
    positive[i] = GreaterEqThan(40);
    positive[i].in[0] <== outputValues[i];
    positive[i].in[1] <== 0;
    isPositive[i] = positive[i].out;
    assert(isPositive[i] == 1);
  }

  // hash the output values
  component outputHashes[numOutputs];
  var calculatedOutputHashes[numOutputs];
  for (var i = 0; i < numOutputs; i++) {
    outputHashes[i] = Poseidon(4);
    outputHashes[i].inputs[0] <== outputValues[i];
    outputHashes[i].inputs[1] <== outputSalts[i];
    outputHashes[i].inputs[2] <== outputOwnerPublicKeys[i][0];
    outputHashes[i].inputs[3] <== outputOwnerPublicKeys[i][1];
    if (outputCommitments[i] == 0) {
      calculatedOutputHashes[i] = 0;
    } else {
      calculatedOutputHashes[i] = outputHashes[i].out;
    }
  }

  // check that the output commitments match the calculated hashes
  for (var i = 0; i < numOutputs; i++) {
    assert(outputCommitments[i] == calculatedOutputHashes[i]);
  }

  // calculate the sum of output values and set to the output
  var sumOutputs = 0;
  for (var i = 0; i < numOutputs; i++) {
    sumOutputs = sumOutputs + outputValues[i];
  }
  out <== sumOutputs;
}
