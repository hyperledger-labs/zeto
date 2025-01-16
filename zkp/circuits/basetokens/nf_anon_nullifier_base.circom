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

include "../lib/check-nullifiers-tokenid-uri.circom";
include "../lib/check-hashes-tokenid-uri.circom";
include "../lib/check-smt-proof.circom";
include "../node_modules/circomlib/circuits/babyjub.circom";

// This version of the circuit performs the following operations:
// - derive the sender's public key from the sender's private key
// - check the input and output commitments match the expected hashes
// - check the input and output values sum to the same amount
// - check the nullifiers are derived from the input commitments and the sender's private key
// - check the nullifiers are included in the Merkle tree
template Zeto(nSMTLevels) {
  signal input tokenId;
  signal input tokenUri;
  signal input nullifier;
  signal input inputCommitment;
  signal input inputSalt;
  // must be properly hashed and trimmed to be compatible with the BabyJub curve.
  // Reference: https://github.com/iden3/circomlib/blob/master/test/babyjub.js#L103
  signal input inputOwnerPrivateKey;
  signal input smtNodeValue;
  signal input root;
  signal input merkleProof[nSMTLevels];
  signal input outputCommitment;
  signal input outputOwnerPublicKey[2];
  signal input outputSalt;

  // derive the sender's public key from the secret input
  // for the sender's private key. This step demonstrates
  // the sender really owns the private key for the input
  // UTXOs
  var inputOwnerPubKeyAx, inputOwnerPubKeyAy;
  (inputOwnerPubKeyAx, inputOwnerPubKeyAy) = BabyPbk()(in <== inputOwnerPrivateKey);

  var inputOwnerPublicKeys[1][2] = [[inputOwnerPubKeyAx, inputOwnerPubKeyAy]];

  CheckHashesForTokenIdAndUri(1)(tokenIds <== [tokenId], tokenUris <== [tokenUri], commitments <== [inputCommitment], salts <== [inputSalt], ownerPublicKeys <== inputOwnerPublicKeys);

  CheckHashesForTokenIdAndUri(1)(tokenIds <== [tokenId], tokenUris <== [tokenUri], commitments <== [outputCommitment], salts <== [outputSalt], ownerPublicKeys <== [outputOwnerPublicKey]);

  CheckNullifiersForTokenIdAndUri(1)(nullifiers <== [nullifier], tokenIds <== [tokenId], tokenUris <== [tokenUri], salts <== [inputSalt], ownerPrivateKey <== inputOwnerPrivateKey);

  CheckSMTProof(1, nSMTLevels)(root <== root, merkleProof <== [merkleProof], enabled <== [1], leafNodeIndexes <== [inputCommitment], leafNodeValues <== [smtNodeValue]);
}
