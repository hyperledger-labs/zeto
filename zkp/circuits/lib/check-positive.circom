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

// CheckPositive is a circuit that checks the integrity of transactions of Fungible Tokens
//   - check that all output values are positive numbers (within the range of 0 to 2^40)
//
// outputValues: array of values, as preimages for the output hashes, for the output utxos
//
template CheckPositive(numOutputs) {
  signal input outputValues[numOutputs];

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
}