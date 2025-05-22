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

include "./check-hashes.circom";
include "../node_modules/circomlib/circuits/babyjub.circom";

// This version of the circuit performs the following operations:
// - derive the sender's public key from the sender's private key
// - check the commitments match the calculated hashes
template CheckUTXOsOwner(nInputs) {
  signal input commitments[nInputs];
  signal input values[nInputs];
  signal input salts[nInputs];
  // must be properly hashed and trimmed to be compatible with the BabyJub curve.
  // Reference: https://github.com/iden3/circomlib/blob/master/test/babyjub.js#L103
  signal input ownerPrivateKey;

  // derive the sender's public key from the secret input
  // for the sender's private key. This step demonstrates
  // the sender really owns the private key for the input
  // UTXOs
  var ownerPubKeyAx, ownerPubKeyAy;
  (ownerPubKeyAx, ownerPubKeyAy) = BabyPbk()(in <== ownerPrivateKey);

  CommitmentInputs() auxInputs[nInputs];
  for (var i = 0; i < nInputs; i++) {
    auxInputs[i].value <== inputValues[i];
    auxInputs[i].salt <== inputSalts[i];
    auxInputs[i].ownerPublicKey <== [ownerPubKeyAx, ownerPubKeyAy];
  }
  CheckHashes(nInputs)(commitmentHashes <== commitments, commitmentInputs <== auxInputs);
}
