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
pragma circom 2.2.2;

include "../node_modules/circomlib/circuits/smt/smtverifier.circom";

// CheckSMTProof is a general purpose circuit that checks the membership
// inclusion proof of a set of hashes in a Sparse Merkle Tree
//
template CheckSMTProof(nInputs, nSMTLevels) {
  signal input leafNodeIndexes[nInputs];
  signal input leafNodeValues[nInputs];
  signal input root;
  signal input merkleProof[nInputs][nSMTLevels];
  signal input enabled[nInputs];

  for (var i = 0; i < nInputs; i++) {
    var siblings[nSMTLevels];
    for (var j = 0; j < nSMTLevels; j++) {
      siblings[j] = merkleProof[i][j];
    }
    // The old values are only used in exclusion proofs. 
    // As such they are always 0 for inclusion proofs.
    // TODO: update when exclusion proofs are supported
    SMTVerifier(nSMTLevels)(enabled <== enabled[i], root <== root, siblings <== siblings, key <== leafNodeIndexes[i], value <== leafNodeValues[i], fnc <== 0 /* 0: inclusion proof, 1: exclusion proof */, oldKey <== 0, oldValue <== 0, isOld0 <== 0);
  }
}
