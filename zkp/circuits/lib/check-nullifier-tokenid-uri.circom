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
include "../node_modules/circomlib/circuits/babyjub.circom";
include "../node_modules/circomlib/circuits/smt/smtverifier.circom";

// CheckNullifierForTokenIdAndUri is a circuit that checks the integrity of transactions of Non-Fungible Tokens
//   - check that the nullifiers are correctly computed from the token ids, uris and salts
//   - check that the input commitments match the calculated hashes
//   - check that the input commitments are included in the Sparse Merkle Tree with the root `root`
//   - check that the output commitments match the calculated hashes
//   - check that the same tokenId and URI are used for the input and output commitments
//
// commitment = hash(tokenId, uri, salt, ownerPublicKey1, ownerPublicKey2)
// nullifier = hash(tokenId, uri, salt, ownerPrivatekey)
//
template CheckNullifierForTokenIdAndUri(numInputs, numOutputs, nSMTLevels) {
  signal input tokenIds[numInputs];
  signal input tokenUris[numInputs];
  signal input nullifiers[numInputs];
  signal input inputCommitments[numInputs];
  signal input inputSalts[numInputs];
  // must be properly hashed and trimmed to be compatible with the BabyJub curve.
  // Reference: https://github.com/iden3/circomlib/blob/master/test/babyjub.js#L103
  signal input inputOwnerPrivateKey;
  signal input root;
  signal input merkleProof[numInputs][nSMTLevels];
  signal input enabled[numInputs];
  signal input outputCommitments[numOutputs];
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
    inputHashes[i].inputs[2] <== inputSalts[i];
    inputHashes[i].inputs[3] <== inputOwnerPublicKey[0];
    inputHashes[i].inputs[4] <== inputOwnerPublicKey[1];
    if (inputCommitments[i] == 0) {
      calculatedInputHashes[i] = 0;
    } else {
      calculatedInputHashes[i] = inputHashes[i].out;
    }
  }

  // check that the input commitments match the calculated hashes
  for (var i = 0; i < numInputs; i++) {
    assert(inputCommitments[i] == calculatedInputHashes[i]);
  }

  // calculate the nullifier values from the input values
  component nullifierHashes[numInputs];
  var calculatedNullifierHashes[numInputs];
  for (var i = 0; i < numInputs; i++) {
    nullifierHashes[i] = Poseidon(4);
    nullifierHashes[i].inputs[0] <== tokenIds[i];
    nullifierHashes[i].inputs[1] <== tokenUris[i];
    nullifierHashes[i].inputs[2] <== inputSalts[i];
    nullifierHashes[i].inputs[3] <== inputOwnerPrivateKey;
    if (nullifiers[i] == 0) {
      calculatedNullifierHashes[i] = 0;
    } else {
      calculatedNullifierHashes[i] = nullifierHashes[i].out;
    }
  }

  // check that the nullifiers match the calculated hashes
  for (var i = 0; i < numInputs; i++) {
    assert(nullifiers[i] == calculatedNullifierHashes[i]);
  }

  // With the above steps, we demonstrated that the nullifiers
  // are securely bound to the input commitments. Now we need to
  // demonstrate that the input commitments belong to the Sparse
  // Merkle Tree with the root `root`.
  component smtVerifier[numInputs];
  for (var i = 0; i < numInputs; i++) {
    smtVerifier[i] = SMTVerifier(nSMTLevels);
    smtVerifier[i].enabled <== enabled[i];
    smtVerifier[i].root <== root;
    for (var j = 0; j < nSMTLevels; j++) {
      smtVerifier[i].siblings[j] <== merkleProof[i][j];
    }
    smtVerifier[i].oldKey <== 0;
    smtVerifier[i].oldValue <== 0;
    smtVerifier[i].isOld0 <== 0;
    smtVerifier[i].key <== inputCommitments[i];
    smtVerifier[i].value <== inputCommitments[i];
    smtVerifier[i].fnc <== 0;
  }

  // hash the output values
  component outputHashes[numOutputs];
  var calculatedOutputHashes[numOutputs];
  for (var i = 0; i < numOutputs; i++) {
    outputHashes[i] = Poseidon(5);
    outputHashes[i].inputs[0] <== tokenIds[i];
    outputHashes[i].inputs[1] <== tokenUris[i];
    outputHashes[i].inputs[2] <== outputSalts[i];
    outputHashes[i].inputs[3] <== outputOwnerPublicKeys[i][0];
    outputHashes[i].inputs[4] <== outputOwnerPublicKeys[i][1];
    if (outputCommitments[i] == 0) {
      calculatedOutputHashes[i] = 0;
    } else {
      calculatedOutputHashes[i] = outputHashes[i].out;
    }
  }

  // check that the output commitments match the calculated hashes
  for (var i = 0; i < numOutputs; i++) {
    assert(outputCommitments[i] == calculatedOutputHashes[i]);
  }

  out <-- 1;
}
