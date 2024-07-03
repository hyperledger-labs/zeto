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

// encrypts a message by appending it to Poseidon hashes 
// that are seeded with the encryption key and nonce
// Based on https://web.archive.org/web/20221114185153/https://dusk.network/uploads/Encryption-with-Poseidon.pdf
template SymmetricEncrypt(length) {
  signal input plainText[length];  // private
  signal input key[2];  // private
  signal input nonce;  // public
  signal output cipherText[length];

  component hashers[length];
  for (var i = 0; i < length; i++) {
    hashers[i] = Poseidon(4);
    hashers[i].inputs[0] <== key[0];
    hashers[i].inputs[1] <== key[1];
    hashers[i].inputs[2] <== nonce;
    hashers[i].inputs[3] <== i;

    cipherText[i] <== hashers[i].out + plainText[i];
  }
}
