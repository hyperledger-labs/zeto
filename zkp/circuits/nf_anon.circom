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

include "./lib/check-hashes-tokenid-uri.circom";
include "./lib/ecdh.circom";
include "./lib/encrypt.circom";
include "./node_modules/circomlib/circuits/babyjub.circom";

// This version of the circuit performs the following operations:
// - derive the sender's public key from the sender's private key
// - check the input and output commitments match the expected hashes
// - check the token id and URI remain constant across the input and output commitments
template Zeto(nInputs, nOutputs) {
  signal input tokenIds[nInputs];
  signal input tokenUris[nInputs];
  signal input inputCommitments[nInputs];
  signal input inputSalts[nInputs];
  signal input inputOwnerPublicKey[2];
  signal input outputCommitments[nOutputs];
  signal input outputSalts[nOutputs];
  signal input outputOwnerPublicKeys[nOutputs][2];
  // must be properly hashed and trimmed to be compatible with the BabyJub curve.
  // Reference: https://github.com/iden3/circomlib/blob/master/test/babyjub.js#L103
  signal input senderPrivateKey;

  // derive the sender's public key from the secret input
  // for the sender's private key. This step demonstrates
  // the sender really owns the private key for the input
  // UTXOs
  var senderPublicKey[2];
  component pub = BabyPbk();
  pub.in <== senderPrivateKey;
  senderPublicKey[0] = pub.Ax;
  senderPublicKey[1] = pub.Ay;
  assert(senderPublicKey[0] == inputOwnerPublicKey[0]);
  assert(senderPublicKey[1] == inputOwnerPublicKey[1]);

  component CheckHashesForTokenIdAndUri = CheckHashesForTokenIdAndUri(nInputs, nOutputs);
  CheckHashesForTokenIdAndUri.tokenIds <== tokenIds;
  CheckHashesForTokenIdAndUri.tokenUris <== tokenUris;
  CheckHashesForTokenIdAndUri.inputCommitments <== inputCommitments;
  CheckHashesForTokenIdAndUri.inputSalts <== inputSalts;
  CheckHashesForTokenIdAndUri.inputOwnerPublicKey <== senderPublicKey;
  CheckHashesForTokenIdAndUri.outputCommitments <== outputCommitments;
  CheckHashesForTokenIdAndUri.outputSalts <== outputSalts;
  CheckHashesForTokenIdAndUri.outputOwnerPublicKeys <== outputOwnerPublicKeys;
  // assert successful output
  assert(CheckHashesForTokenIdAndUri.out == 1);
}

component main { public [ inputCommitments, outputCommitments ] } = Zeto(1, 1);