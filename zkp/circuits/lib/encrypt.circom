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

include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/poseidon.circom";

// encrypts a message by appending it to Poseidon hashes 
// that are seeded with the encryption key and nonce
// Based on https://web.archive.org/web/20221114185153/https://dusk.network/uploads/Encryption-with-Poseidon.pdf
template SymmetricEncrypt(length) {
  signal input plainText[length];  // private
  signal input key[2];  // private
  signal input nonce;  // public

  var two128 = 2 ** 128;

  // nonce must be < 2^128
  component lt = LessThan(252);
  lt.in[0] <== nonce;
  lt.in[1] <== two128;
  lt.out === 1;

  // the number of plain text messages must be multiple of 3
  // pad the array with zeros if necessary.
  // e.g. if length == 4, l == 6
  var l = length;
  if (l % 3 != 0) {
    l += (3 - (l % 3));
  }
  var messages[l];
  for (var i = 0; i < l; i++) {
    if (i < length) {
      messages[i] = plainText[i];
    } else {
      messages[i] = 0;
    }
  }

  signal output cipherText[l + 1];

  // calculate the number of iterations needed for the encryption
  // process. "\"" is integer division
  var n = l \ 3;

  // create the initial state: [0, key[0], key[1], nonce + (length * 2^128)]
  component rounds[n + 1];
  rounds[0] = PoseidonEx(4, 4);
  rounds[0].initialState <== 0;
  rounds[0].inputs[0] <== 0;
  rounds[0].inputs[1] <== key[0];
  rounds[0].inputs[2] <== key[1];
  rounds[0].inputs[3] <== nonce + (length * two128);

  for (var i = 0; i < n; i++) {
    rounds[i + 1] = PoseidonEx(4, 4);
    rounds[i + 1].initialState <== 0;
    rounds[i + 1].inputs[0] <== rounds[i].out[0];

    // Absorb three elements of message, setting them to the
    // corresponding inputs of the next round
    rounds[i + 1].inputs[1] <== rounds[i].out[1] + messages[i * 3];
    rounds[i + 1].inputs[2] <== rounds[i].out[2] + messages[i * 3 + 1];
    rounds[i + 1].inputs[3] <== rounds[i].out[3] + messages[i * 3 + 2];

    // release three elements of the ciphertext
    cipherText[i * 3] <== rounds[i + 1].inputs[1];
    cipherText[i * 3 + 1] <== rounds[i + 1].inputs[2];
    cipherText[i * 3 + 2] <== rounds[i + 1].inputs[3];
  }

  // Iterate Poseidon on the state one last time
  cipherText[l] <== rounds[n].out[1];
}
