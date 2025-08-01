// Copyright © 2025 Kaleido, Inc.
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
pragma circom 2.2.2;

include "./check-positive.circom";
include "./check-hashes.circom";

template Deposit(nOutputs) {
  signal input outputCommitments[nOutputs];
  signal input outputValues[nOutputs];
  signal input outputSalts[nOutputs];
  signal input outputOwnerPublicKeys[nOutputs][2];
  signal output out;

  CheckPositive(nOutputs)(outputValues <== outputValues);

  CommitmentInputs() auxInputs[nOutputs];
  for (var i = 0; i < nOutputs; i++) {
    auxInputs[i].value <== outputValues[i];
    auxInputs[i].salt <== outputSalts[i];
    auxInputs[i].ownerPublicKey <== outputOwnerPublicKeys[i];
  }

  CheckHashes(nOutputs)(commitmentHashes <== outputCommitments, commitmentInputs <== auxInputs);

  // calculate the sum of output values and set to the output
  var sumOutputs = 0;
  for (var i = 0; i < nOutputs; i++) {
    sumOutputs = sumOutputs + outputValues[i];
  }
  out <== sumOutputs;
}
