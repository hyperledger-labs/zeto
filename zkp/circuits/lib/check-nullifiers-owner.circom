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

include "./check-positive.circom";
include "./check-hashes.circom";
include "./check-nullifiers.circom";
include "./check-smt-proof.circom";

// CheckNullifiersOwner is a circuit that checks the ownership of the input UTXOs and nullifiers membership inclusion
//   - check that the private key is the owner of the input UTXOs
//   - check that the input commitments are the hash of the input values, salts and sender public keys
//   - check that the input commitments are included in the Sparse Merkle Tree with the root `root`
//   - check that the nullifiers are securely bound to the input commitments
//
// commitment = hash(value, salt, owner public key)
// nullifier = hash(value, salt, ownerPrivatekey)
//
template CheckNullifiersOwner(numInputs, nSMTLevels) {
  signal input nullifiers[numInputs];
  signal input commitments[numInputs];
  signal input values[numInputs];
  signal input salts[numInputs];
  // must be properly hashed and trimmed to be compatible with the BabyJub curve.
  // Reference: https://github.com/iden3/circomlib/blob/master/test/babyjub.js#L103
  signal input ownerPrivateKey;
  signal input root;
  signal input merkleProof[numInputs][nSMTLevels];
  signal input enabled[numInputs];

  // derive the sender's public key from the secret input
  // for the sender's private key. This step demonstrates
  // the sender really owns the private key for the input
  // UTXOs
  var inputOwnerPubKeyAx, inputOwnerPubKeyAy;
  (inputOwnerPubKeyAx, inputOwnerPubKeyAy) = BabyPbk()(in <== ownerPrivateKey);

  var inputOwnerPublicKeys[numInputs][2];
  for (var i = 0; i < numInputs; i++) {
    inputOwnerPublicKeys[i] = [inputOwnerPubKeyAx, inputOwnerPubKeyAy];
  }

  CheckHashes(numInputs)(commitments <== commitments, values <== values, salts <== salts, ownerPublicKeys <== inputOwnerPublicKeys);

  CheckNullifiers(numInputs)(nullifiers <== nullifiers, values <== values, salts <== salts, ownerPrivateKey <== ownerPrivateKey);

  // With the above steps, we demonstrated that the nullifiers
  // are securely bound to the input commitments. Now we need to
  // demonstrate that the input commitments belong to the Sparse
  // Merkle Tree with the root `root`.
  CheckSMTProof(numInputs, nSMTLevels)(root <== root, merkleProof <== merkleProof, enabled <== enabled, leafNodeIndexes <== commitments, leafNodeValues <== commitments);
}
