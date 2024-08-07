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

include "../node_modules/circomlib/circuits/smt/smtverifier.circom";

// CheckSMTProof is a general purpose circuit that checks the membership
// inclusion proof of a set of hashes in a Sparse Merkle Tree
//
template CheckSMTProof(numInputs, nSMTLevels) {
  signal input leafNodeIndexes[numInputs];
  signal input root;
  signal input merkleProof[numInputs][nSMTLevels];
  signal input enabled[numInputs];

  component smtVerifier[numInputs];
  for (var i = 0; i < numInputs; i++) {
    smtVerifier[i] = SMTVerifier(nSMTLevels);
    smtVerifier[i].enabled <== enabled[i];
    smtVerifier[i].root <== root;
    for (var j = 0; j < nSMTLevels; j++) {
      smtVerifier[i].siblings[j] <== merkleProof[i][j];
    }
    smtVerifier[i].key <== leafNodeIndexes[i];
    smtVerifier[i].value <== leafNodeIndexes[i];
    // 0: inclusion proof, 1: exclusion proof
    smtVerifier[i].fnc <== 0;
    // these last values are only used in exclusion proofs. 
    // As such they are always 0 for inclusion proofs.
    // TODO: update when exclusion proofs are supported
    smtVerifier[i].oldKey <== 0;
    smtVerifier[i].oldValue <== 0;
    smtVerifier[i].isOld0 <== 0;
  }
}
