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

include "./anon_nullifier_kyc_base.circom";

// This version of the circuit performs the following operations:
// - derive the sender's public key from the sender's private key
// - check the input and output commitments match the expected hashes
// - check the input and output values sum to the same amount
// - check the nullifiers are derived from the input commitments and the sender's private key
// - check the nullifiers are included in the Merkle tree
// - check the owner public keys for inputs and outputs are included in the identities merkle tree
template transferLocked(nInputs, nOutputs, nUTXOSMTLevels, nIdentitiesSMTLevels) {
  signal input nullifiers[nInputs];
  signal input inputCommitments[nInputs];
  signal input inputValues[nInputs];
  signal input inputSalts[nInputs];
  // must be properly hashed and trimmed to be compatible with the BabyJub curve.
  // Reference: https://github.com/iden3/circomlib/blob/master/test/babyjub.js#L103
  signal input inputOwnerPrivateKey;
  signal input lockDelegate;
  signal input utxosRoot;
  signal input utxosMerkleProof[nInputs][nUTXOSMTLevels];
  // allows merkle proof verifications for empty input elements to be skipped
  signal input enabled[nInputs];
  signal input identitiesRoot;
  signal input identitiesMerkleProof[nOutputs + 1][nIdentitiesSMTLevels];
  signal input outputCommitments[nOutputs];
  signal input outputValues[nOutputs];
  signal input outputOwnerPublicKeys[nOutputs][2];
  signal input outputSalts[nOutputs];

  // we assume a single lock delegate for all locked inputs
  var lockDelegates[nInputs];
  for (var i = 0; i < nInputs; i++) {
    lockDelegates[i] = lockDelegate;
  }

  Zeto(nInputs, nOutputs, nUTXOSMTLevels, nIdentitiesSMTLevels)(
    nullifiers <== nullifiers,
    inputCommitments <== inputCommitments,
    inputValues <== inputValues,
    inputSalts <== inputSalts,
    inputOwnerPrivateKey <== inputOwnerPrivateKey,
    smtNodeValues <== lockDelegates,
    utxosRoot <== utxosRoot,
    utxosMerkleProof <== utxosMerkleProof,
    enabled <== enabled,
    identitiesRoot <== identitiesRoot,
    identitiesMerkleProof <== identitiesMerkleProof,
    outputCommitments <== outputCommitments,
    outputValues <== outputValues,
    outputOwnerPublicKeys <== outputOwnerPublicKeys,
    outputSalts <== outputSalts
  );
}