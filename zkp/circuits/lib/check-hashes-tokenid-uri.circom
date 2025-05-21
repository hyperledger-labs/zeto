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

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/comparators.circom";

// CheckHashesForTokenIdAndUri is a circuit that checks the integrity of transactions of Non-Fungible Tokens (NFTs)
//   - check that the commitments match the calculated hashes
//
// commitment = hash(tokenId, uri, salt, ownerAddress)
//
// tokenIds: array of token ids, as preimages for the input hashes and output hashes
// tokenUris: array of token uris, as preimages for the input hashes and output hashes
//
template CheckHashesForTokenIdAndUri(numInputs) {
  signal input tokenIds[numInputs];
  signal input tokenUris[numInputs];
  signal input commitments[numInputs];
  signal input salts[numInputs];
  signal input ownerPublicKeys[numInputs][2];

  // hash the input values
  for (var i = 0; i < numInputs; i++) {
    // perform the hash calculation even though they are not needed when the input 
    // commitment at the current index is 0; this is because in zkp circuits we
    // must always perform the same computation (have the the same constraints)
    var calculatedHash;
    calculatedHash = Poseidon(5)([tokenIds[i], tokenUris[i], salts[i], ownerPublicKeys[i][0], ownerPublicKeys[i][1]]);

    // check that the input commitments match the calculated hashes
    var isCommitmentZero;
    isCommitmentZero = IsZero()(in <== commitments[i]);

    var isHashEqual;
    isHashEqual = IsEqual()(in <== [commitments[i], (1 - isCommitmentZero) * calculatedHash /* ensure when commitment is 0, compare with 0 */]);

    isHashEqual === 1;
  }
}
