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

include "./anon_nullifier_base.circom";
include "../lib/kyber/mlkem.circom";
include "../lib/hash_signals.circom";
// include "../lib/sha256_signals.circom";

// This version of the circuit performs the following operations:
// - derive the sender's public key from the sender's private key
// - check the input and output commitments match the expected hashes
// - check the input and output values sum to the same amount
// - check the nullifiers are derived from the input commitments and the sender's private key
// - check the nullifiers are included in the Merkle tree
// - check the cipher texts are properly encrypted
template transfer(nInputs, nOutputs, nSMTLevels) {
  signal input nullifiers[nInputs]; // public signal
  signal input inputCommitments[nInputs];
  signal input inputValues[nInputs];
  signal input inputSalts[nInputs];
  // must be properly hashed and trimmed to be compatible with the BabyJub curve.
  // Reference: https://github.com/iden3/circomlib/blob/master/test/babyjub.js#L103
  signal input inputOwnerPrivateKey;
  signal input root; // public signal
  signal input merkleProof[nInputs][nSMTLevels];
  // allows merkle proof verifications for empty input elements to be skipped
  signal input enabled[nInputs]; // public signal
  signal input outputCommitments[nOutputs]; // public signal
  signal input outputValues[nOutputs];
  signal input outputOwnerPublicKeys[nOutputs][2];
  signal input outputSalts[nOutputs];
  // additional input signals for the cipher texts
  // TODO: add the cipher text inputs
  signal input randomness[256];

  signal output c[25];

  Zeto(nInputs, nOutputs, nSMTLevels)(
    nullifiers <== nullifiers,
    inputCommitments <== inputCommitments,
    inputValues <== inputValues,
    inputSalts <== inputSalts,
    inputOwnerPrivateKey <== inputOwnerPrivateKey,
    smtNodeValues <== inputCommitments,
    root <== root,
    merkleProof <== merkleProof,
    enabled <== enabled,
    outputCommitments <== outputCommitments,
    outputValues <== outputValues,
    outputOwnerPublicKeys <== outputOwnerPublicKeys,
    outputSalts <== outputSalts
  );
  // additional constraints for the cipher texts
  signal K[256];
  component kem = mlkem_encaps();
  kem.m <== randomness;
  K <== kem.K;
  c <== kem.c_short;
}
