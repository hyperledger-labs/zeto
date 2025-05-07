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

include "./anon_nullifier_base.circom";
include "../lib/kyber/kyber.circom";
include "../lib/sha256_signals.circom";
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
  signal input m[256];
  signal input randomness[256];
  // this would be the hash of the following signals:
  // - nullifiers (from inputs)
  // - root (from inputs)
  // - enabled (from inputs)
  // - outputCommitments (from inputs)
  // - ct_h0 (from output of kyber_enc)
  // - ct_h1 (from output of kyber_enc)
  // IMPORTANT: special handling of the hash output,
  // see the comment in the sha256Signals template
  signal output hash_h0;
  signal output hash_h1;

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
  // TODO: kyber encryption constraints

  var ct_h0;
  var ct_h1;
  (ct_h0, ct_h1) = kyber_enc()(randomness, m);

  // calculate the output hash for the signals and their lengths:
  // - nInputs:  nullifiers,
  // - 1:        root,
  // - nInputs:  enabled,
  // - nOutputs: outputCommitments,
  // - 2:        ct_h0, ct_h1

  // consolidate to a single array of signals
  var numElements = nInputs + 1 + nInputs + nOutputs + 2;
  var signals[numElements];
  for (var i = 0; i < nInputs; i++) {
    signals[i] = nullifiers[i];
  }
  signals[nInputs] = root;
  for (var i = 0; i < nInputs; i++) {
    signals[nInputs + 1 + i] = enabled[i];
  }
  for (var i = 0; i < nOutputs; i++) {
    signals[nInputs + 1 + nInputs + i] = outputCommitments[i];
  }
  signals[nInputs + 1 + nInputs + nOutputs] = ct_h0;
  signals[nInputs + 1 + nInputs + nOutputs + 1] = ct_h1;

  component hash9;
  component hash33;
  if (nInputs == 2 && nOutputs == 2) {
    hash9 = sha256Signals(9);
    hash9.signals <== signals;
    hash_h0 <== hash9.h0;
    hash_h1 <== hash9.h1;
  } else if (nInputs == 10 && nOutputs == 10) {
    hash33 = sha256Signals(33);
    hash33.signals <== signals;
    hash_h0 <== hash33.h0;
    hash_h1 <== hash33.h1;
  }
}
