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

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/babyjub.circom";
include "../node_modules/circomlib/circuits/smt/smtverifier.circom";

// CheckNullifiersForTokenIdAndUri is a circuit that checks the integrity of transactions of Non-Fungible Tokens
//   - check that the nullifiers are correctly computed from the token ids, uris and salts
//   - check that the input commitments match the calculated hashes
//   - check that the input commitments are included in the Sparse Merkle Tree with the root `root`
//
// commitment = hash(tokenId, uri, salt, ownerPublicKey1, ownerPublicKey2)
// nullifier = hash(tokenId, uri, salt, ownerPrivatekey)
//
template CheckNullifiersForTokenIdAndUri(numInputs) {
  signal input tokenIds[numInputs];
  signal input tokenUris[numInputs];
  signal input nullifiers[numInputs];
  signal input salts[numInputs];
  // must be properly hashed and trimmed to be compatible with the BabyJub curve.
  // Reference: https://github.com/iden3/circomlib/blob/master/test/babyjub.js#L103
  signal input ownerPrivateKey;

  // calculate the nullifier values from the input values
  for (var i = 0; i < numInputs; i++) {
    var calculatedHash;
    calculatedHash = Poseidon(4)([tokenIds[i], tokenUris[i], salts[i], ownerPrivateKey]);

    // check that the nullifiers match the calculated hashes
    var isNullifierZero;
    isNullifierZero = IsZero()(in <== nullifiers[i]);

    var isHashEqual;
    isHashEqual = IsEqual()(in <== [nullifiers[i], (1 - isNullifierZero) * calculatedHash /* ensure when nullifier is 0, compare with 0 */]);

    isHashEqual === 1;
  }
}
