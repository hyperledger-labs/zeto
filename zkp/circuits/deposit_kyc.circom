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

include "./lib/deposit.circom";
include "./lib/kyc.circom";
include "./node_modules/circomlib/circuits/comparators.circom";

template DepositKyc(nOutputs, nIdentitiesSMTLevels) {
  signal input outputCommitments[nOutputs];
  signal input outputValues[nOutputs];
  signal input outputSalts[nOutputs];
  signal input outputOwnerPublicKeys[nOutputs][2];
  signal input identitiesRoot;
  signal input identitiesMerkleProof[nOutputs][nIdentitiesSMTLevels];
  signal output out;

  // We need to demonstrate that the owner public keys
  // for the outputs are included in the identities
  // Sparse Merkle Tree with the root `identitiesRoot`.
  var ownerPublicKeys[nOutputs][2];
  var isCommitmentZero[nOutputs];
  for (var i = 0; i < nOutputs; i++) {
    isCommitmentZero[i] = IsZero()(in <== outputCommitments[i]);
    ownerPublicKeys[i][0] = (1 - isCommitmentZero[i]) * outputOwnerPublicKeys[i][0];
    ownerPublicKeys[i][1] = (1 - isCommitmentZero[i]) * outputOwnerPublicKeys[i][1];
  }
  Kyc(nOutputs, nIdentitiesSMTLevels)(publicKeys <== ownerPublicKeys, root <== identitiesRoot, merkleProof <== identitiesMerkleProof);

  out <== Deposit(nOutputs)(outputCommitments <== outputCommitments, outputValues <== outputValues, outputSalts <== outputSalts, outputOwnerPublicKeys <== outputOwnerPublicKeys);
}

component main {public [ outputCommitments, identitiesRoot ]} = DepositKyc(2, 10);
