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

include "./check-positive.circom";
include "./check-hashes.circom";
include "./check-nullifiers.circom";
include "./check-smt-proof.circom";

// BurnNullifiers is a circuit that checks the sum of the input values
// is greater than or equal to the sum of the output values:
//   - check that the private key is the owner of the input UTXOs
//   - check that the input commitments are the hash of the input values, salts and sender public keys
//   - check that the nullifiers are securely bound to the input commitments
//   - check that the output commitments are the hash of the output values, salts and the same sender public keys
//   - check that the output values are all positive, assuming the values are in the range [0, 2^100)
//   - check that the sum of input values is greater than or equal to the sum of output values
//
// commitment = hash(value, salt, owner public key)
// nullifier = hash(value, salt, ownerPrivatekey)
//
template BurnNullifiers(numInputs, nSMTLevels) {
  signal input nullifiers[numInputs];
  signal input inputCommitments[numInputs];
  signal input inputValues[numInputs];
  signal input inputSalts[numInputs];
  // must be properly hashed and trimmed to be compatible with the BabyJub curve.
  // Reference: https://github.com/iden3/circomlib/blob/master/test/babyjub.js#L103
  signal input ownerPrivateKey;
  signal input root;
  signal input merkleProof[numInputs][nSMTLevels];
  signal input enabled[numInputs];
  signal input outputCommitment;
  signal input outputValue;
  signal input outputSalt;

  // derive the sender's public key from the secret input
  // for the sender's private key. This step demonstrates
  // the sender really owns the private key for the input
  // UTXOs
  var ownerPubKeyAx, ownerPubKeyAy;
  (ownerPubKeyAx, ownerPubKeyAy) = BabyPbk()(in <== ownerPrivateKey);

  var ownerPublicKeys[numInputs][2];
  for (var i = 0; i < numInputs; i++) {
    ownerPublicKeys[i] = [ownerPubKeyAx, ownerPubKeyAy];
  }

  CheckPositive(1)(outputValues <== [outputValue]);

  CommitmentInputs() inAuxInputs[numInputs];
  for (var i = 0; i < numInputs; i++) {
    inAuxInputs[i].value <== inputValues[i];
    inAuxInputs[i].salt <== inputSalts[i];
    inAuxInputs[i].ownerPublicKey <== [ownerPubKeyAx, ownerPubKeyAy];
  }
  CheckHashes(numInputs)(commitmentHashes <== inputCommitments, commitmentInputs <== inAuxInputs);

  CheckNullifiers(numInputs)(nullifiers <== nullifiers, values <== inputValues, salts <== inputSalts, ownerPrivateKey <== ownerPrivateKey);

  CommitmentInputs() outAuxInputs[1];
  outAuxInputs[0].value <== outputValue;
  outAuxInputs[0].salt <== outputSalt;
  outAuxInputs[0].ownerPublicKey <== [ownerPubKeyAx, ownerPubKeyAy];
  CheckHashes(1)(commitmentHashes <== [outputCommitment], commitmentInputs <== outAuxInputs);

  // With the above steps, we demonstrated that the nullifiers
  // are securely bound to the input commitments. Now we need to
  // demonstrate that the input commitments belong to the Sparse
  // Merkle Tree with the root `root`.
  CheckSMTProof(numInputs, nSMTLevels)(root <== root, merkleProof <== merkleProof, enabled <== enabled, leafNodeIndexes <== inputCommitments, leafNodeValues <== inputCommitments);

  // check that the sum of input values is greater than or equal to the sum of output values
  var sumInputs = 0;
  for (var i = 0; i < numInputs; i++) {
    sumInputs = sumInputs + inputValues[i];
  }
  var greaterEqThan;
  greaterEqThan = GreaterEqThan(100)(in <== [sumInputs, outputValue]);
  greaterEqThan === 1;
}
