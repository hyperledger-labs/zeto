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

include "./basetokens/nf_anon_nullifier_base.circom";

// This version of the circuit performs the following operations:
// - derive the sender's public key from the sender's private key
// - check the input and output commitments match the expected hashes
// - check the input and output values sum to the same amount
// - check the nullifiers are derived from the input commitments and the sender's private key
// - check the nullifiers are included in the Merkle tree
template transferLocked(nSMTLevels) {
  signal input tokenId;
  signal input tokenUri;
  signal input nullifier;
  signal input inputCommitment;
  signal input inputSalt;
  // must be properly hashed and trimmed to be compatible with the BabyJub curve.
  // Reference: https://github.com/iden3/circomlib/blob/master/test/babyjub.js#L103
  signal input inputOwnerPrivateKey;
  signal input lockDelegate;
  signal input root;
  signal input merkleProof[nSMTLevels];
  signal input outputCommitment;
  signal input outputOwnerPublicKey[2];
  signal input outputSalt;

  Zeto(nSMTLevels)(
    tokenId <== tokenId,
    tokenUri <== tokenUri,
    nullifier <== nullifier,
    inputCommitment <== inputCommitment,
    inputSalt <== inputSalt,
    inputOwnerPrivateKey <== inputOwnerPrivateKey,
    smtNodeValue <== lockDelegate,
    root <== root,
    merkleProof <== merkleProof,
    outputCommitment <== outputCommitment,
    outputOwnerPublicKey <== outputOwnerPublicKey,
    outputSalt <== outputSalt
  );
}

component main { public [ nullifier, lockDelegate, outputCommitment, root ] } = transferLocked(64);