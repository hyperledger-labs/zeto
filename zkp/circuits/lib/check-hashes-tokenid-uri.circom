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
  component inputHashes[numInputs];
  var calculatedInputHashes[numInputs];
  for (var i = 0; i < numInputs; i++) {
    // perform the hash calculation even though they are not needed when the input 
    // commitment at the current index is 0; this is because in zkp circuits we
    // must always perform the same computation (have the the same constraints)
    inputHashes[i] = Poseidon(5);
    inputHashes[i].inputs[0] <== tokenIds[i];
    inputHashes[i].inputs[1] <== tokenUris[i];
    inputHashes[i].inputs[2] <== salts[i];
    inputHashes[i].inputs[3] <== ownerPublicKeys[i][0];
    inputHashes[i].inputs[4] <== ownerPublicKeys[i][1];
    if (commitments[i] == 0) {
      calculatedInputHashes[i] = 0;
    } else {
      calculatedInputHashes[i] = inputHashes[i].out;
    }
  }

  // check that the input commitments match the calculated hashes
  for (var i = 0; i < numInputs; i++) {
    assert(commitments[i] == calculatedInputHashes[i]);
  }
}
