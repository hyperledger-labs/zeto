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

include "./lib/check-nullifier-tokenid-uri.circom";
include "./lib/check-hashes-tokenid-uri.circom";
include "./lib/check-smt-proof.circom";
include "./node_modules/circomlib/circuits/babyjub.circom";

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
  signal input root;
  signal input merkleProof[nSMTLevels];
  signal input outputCommitment;
  signal input outputOwnerPublicKey[2];
  signal input outputSalt;

  var tokenIds[1] = [tokenId];
  var tokenUris[1] = [tokenUri];
  var inputCommitments[1] = [inputCommitment];
  var inputSalts[1] = [inputSalt];
  var nullifiers[1] = [nullifier];
  var outputCommitments[1] = [outputCommitment];
  var outputSalts[1] = [outputSalt];
  var outputOwnerPublicKeys[1][2] = [outputOwnerPublicKey];

  // derive the sender's public key from the secret input
  // for the sender's private key. This step demonstrates
  // the sender really owns the private key for the input
  // UTXOs
  var senderPublicKey[2];
  component pub = BabyPbk();
  pub.in <== inputOwnerPrivateKey;
  senderPublicKey[0] = pub.Ax;
  senderPublicKey[1] = pub.Ay;
  var inputOwnerPublicKeys[1][2] = [senderPublicKey];

  component checkInputHashes = CheckHashesForTokenIdAndUri(1);
  checkInputHashes.tokenIds <== tokenIds;
  checkInputHashes.tokenUris <== tokenUris;
  checkInputHashes.commitments <== inputCommitments;
  checkInputHashes.salts <== inputSalts;
  checkInputHashes.ownerPublicKeys <== inputOwnerPublicKeys;

  component checkOutputHashes = CheckHashesForTokenIdAndUri(1);
  checkOutputHashes.tokenIds <== tokenIds;
  checkOutputHashes.tokenUris <== tokenUris;
  checkOutputHashes.commitments <== outputCommitments;
  checkOutputHashes.salts <== outputSalts;
  checkOutputHashes.ownerPublicKeys <== outputOwnerPublicKeys;  

  component checkHashesSum = CheckNullifierForTokenIdAndUri(1);
  checkHashesSum.nullifiers <== nullifiers;
  checkHashesSum.tokenIds <== tokenIds;
  checkHashesSum.tokenUris <== tokenUris;
  checkHashesSum.salts <== inputSalts;
  checkHashesSum.ownerPrivateKey <== inputOwnerPrivateKey;

  component checkSMTProof = CheckSMTProof(1, nSMTLevels);
  checkSMTProof.root <== root;
  checkSMTProof.merkleProof <== [merkleProof];
  checkSMTProof.enabled <== [1];
  checkSMTProof.leafNodeIndexes <== inputCommitments;
}

component main { public [ nullifier, outputCommitment, root ] } = Zeto(64);