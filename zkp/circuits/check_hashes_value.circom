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

include "./lib/check-hashes.circom";

template checkHashesValue(nOutputs) {
  signal input outputCommitments[nOutputs];
  input CommitmentInputs() outputCommitmentInputs[nOutputs];
  signal output out;

  CheckPositiveValues(nOutputs)(commitmentInputs <== outputCommitmentInputs);
  CheckHashes(nOutputs)(commitmentHashes <== outputCommitments, commitmentInputs <== outputCommitmentInputs);

  // calculate the sum of output values and set to the output
  var sumOutputs = 0;
  for (var i = 0; i < nOutputs; i++) {
    sumOutputs = sumOutputs + outputCommitmentInputs[i].value;
  }
  out <== sumOutputs;
}

component main {public [ outputCommitments ]} = checkHashesValue(2);
