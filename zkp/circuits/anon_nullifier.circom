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

include "./lib/check-nullifier-hashes-sum.circom";
include "./lib/ecdh.circom";
include "./lib/encrypt.circom";
include "./node_modules/circomlib/circuits/babyjub.circom";

// This version of the circuit performs the following operations:
// - derive the sender's public key from the sender's private key
// - check the input and output commitments match the expected hashes
// - check the input and output values sum to the same amount
// - check the nullifiers are derived from the input commitments and the sender's private key
// - check the nullifiers are included in the Merkle tree
template Zeto(nInputs, nOutputs, nSMTLevels) {
  signal input nullifiers[nInputs];
  signal input inputCommitments[nInputs];
  signal input inputValues[nInputs];
  signal input inputSalts[nInputs];
  // must be properly hashed and trimmed to be compatible with the BabyJub curve.
  // Reference: https://github.com/iden3/circomlib/blob/master/test/babyjub.js#L103
  signal input inputOwnerPrivateKey;
  signal input root;
  signal input merkleProof[nInputs][nSMTLevels];
  // allows merkle proof verifications for empty input elements to be skipped
  signal input enabled[nInputs];
  signal input outputCommitments[nOutputs];
  signal input outputValues[nOutputs];
  signal input outputOwnerPublicKeys[nOutputs][2];
  signal input outputSalts[nOutputs];

  component checkHashesSum = CheckNullifierHashesAndSum(nInputs, nOutputs, nSMTLevels);
  checkHashesSum.nullifiers <== nullifiers;
  checkHashesSum.inputCommitments <== inputCommitments;
  checkHashesSum.inputValues <== inputValues;
  checkHashesSum.inputSalts <== inputSalts;
  checkHashesSum.inputOwnerPrivateKey <== inputOwnerPrivateKey;
  checkHashesSum.root <== root;
  checkHashesSum.merkleProof <== merkleProof;
  checkHashesSum.enabled <== enabled;
  checkHashesSum.outputCommitments <== outputCommitments;
  checkHashesSum.outputValues <== outputValues;
  checkHashesSum.outputSalts <== outputSalts;
  checkHashesSum.outputOwnerPublicKeys <== outputOwnerPublicKeys;
  // assert successful output
  checkHashesSum.out === 1;
}

component main { public [ nullifiers, outputCommitments, root, enabled ] } = Zeto(2, 2, 64);