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

include "./check-positive.circom";
include "./check-hashes.circom";
include "./check-nullifiers.circom";
include "./check-smt-proof.circom";

// CheckNullifiersInputsOutputsValue is a circuit that checks the sum of the input values
// is greater than or equal to the sum of the output values:
//   - check that the private key is the owner of the input UTXOs
//   - check that the input commitments are the hash of the input values, salts and sender public keys
//   - check that the nullifiers are securely bound to the input commitments
//   - check that the output commitments are the hash of the output values, salts and receiver public keys
//   - check that the output values are all positive, assuming the values are in the range [0, 2^100)
//   - check that the sum of input values is greater than or equal to the sum of output values
//
// commitment = hash(value, salt, owner public key)
// nullifier = hash(value, salt, ownerPrivatekey)
//
template CheckNullifiersInputsOutputsValue(numInputs, numOutputs, nSMTLevels) {
  signal input nullifiers[numInputs];
  signal input inputCommitments[numInputs];
  signal input inputValues[numInputs];
  signal input inputSalts[numInputs];
  // must be properly hashed and trimmed to be compatible with the BabyJub curve.
  // Reference: https://github.com/iden3/circomlib/blob/master/test/babyjub.js#L103
  signal input inputOwnerPrivateKey;
  signal input root;
  signal input merkleProof[numInputs][nSMTLevels];
  signal input enabled[numInputs];
  signal input outputCommitments[numOutputs];
  signal input outputValues[numOutputs];
  signal input outputSalts[numOutputs];
  signal input outputOwnerPublicKeys[numOutputs][2];
  signal output out;

  // derive the sender's public key from the secret input
  // for the sender's private key. This step demonstrates
  // the sender really owns the private key for the input
  // UTXOs
  var inputOwnerPublicKey[2];
  component pub = BabyPbk();
  pub.in <== inputOwnerPrivateKey;
  inputOwnerPublicKey[0] = pub.Ax;
  inputOwnerPublicKey[1] = pub.Ay;
  var inputOwnerPublicKeys[numInputs][2];
  for (var i = 0; i < numInputs; i++) {
    inputOwnerPublicKeys[i][0] = inputOwnerPublicKey[0];
    inputOwnerPublicKeys[i][1] = inputOwnerPublicKey[1];
  }

  component checkPositives = CheckPositive(numOutputs);
  checkPositives.outputValues <== outputValues;

  component checkInputHashes = CheckHashes(numInputs);
  checkInputHashes.commitments <== inputCommitments;
  checkInputHashes.values <== inputValues;
  checkInputHashes.salts <== inputSalts;
  checkInputHashes.ownerPublicKeys <== inputOwnerPublicKeys;

  component checkNullifiers = CheckNullifiers(numInputs);
  checkNullifiers.nullifiers <== nullifiers;
  checkNullifiers.values <== inputValues;
  checkNullifiers.salts <== inputSalts;
  checkNullifiers.ownerPrivateKey <== inputOwnerPrivateKey;

  component checkOutputHashes = CheckHashes(numOutputs);
  checkOutputHashes.commitments <== outputCommitments;
  checkOutputHashes.values <== outputValues;
  checkOutputHashes.salts <== outputSalts;
  checkOutputHashes.ownerPublicKeys <== outputOwnerPublicKeys;

  // With the above steps, we demonstrated that the nullifiers
  // are securely bound to the input commitments. Now we need to
  // demonstrate that the input commitments belong to the Sparse
  // Merkle Tree with the root `root`.
  component checkSMTProof = CheckSMTProof(numInputs, nSMTLevels);
  checkSMTProof.root <== root;
  checkSMTProof.merkleProof <== merkleProof;
  checkSMTProof.enabled <== enabled;
  checkSMTProof.leafNodeIndexes <== inputCommitments;

  // check that the sum of input values equals the sum of output values
  var sumInputs = 0;
  for (var i = 0; i < numInputs; i++) {
    sumInputs = sumInputs + inputValues[i];
  }
  var sumOutputs = 0;
  for (var i = 0; i < numOutputs; i++) {
    sumOutputs = sumOutputs + outputValues[i];
  }

  // check that the sum of input values is greater than the sum of output values
  component checkSum = GreaterEqThan(100);
  checkSum.in[0] <== sumInputs;
  checkSum.in[1] <== sumOutputs;
  checkSum.out === 1;

  out <== sumInputs - sumOutputs;
}
