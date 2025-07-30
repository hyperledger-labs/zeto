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

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/comparators.circom";
include "./check-smt-proof.circom";

template Kyc(nIdentities, nIdentitiesSMTLevels) {
  signal input publicKeys[nIdentities][2];
  signal input root;
  signal input merkleProof[nIdentities][nIdentitiesSMTLevels];

  var publicKeyHashes[nIdentities];
  var mtpCheckEnabled[nIdentities];
  var isPubKeyZero[nIdentities];
  for (var i = 0; i < nIdentities; i++) {
    publicKeyHashes[i] = Poseidon(2)(inputs <== publicKeys[i]);
    isPubKeyZero[i] = IsZero()(in <== publicKeys[i][0]);
    mtpCheckEnabled[i] = (1 - isPubKeyZero[i]);
  }

  CheckSMTProof(nIdentities, nIdentitiesSMTLevels)(root <== root, merkleProof <== merkleProof, enabled <== mtpCheckEnabled, leafNodeIndexes <== publicKeyHashes, leafNodeValues <== publicKeyHashes);
}