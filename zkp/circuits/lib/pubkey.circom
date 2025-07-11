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

include "../node_modules/circomlib/circuits/bitify.circom";
include "../node_modules/circomlib/circuits/babyjub.circom";

template PublicKeyFromSeed() {
    // This template is used to derive the public key from the private key seed,
    // by performing the hashing and trimming required to ensure the private key
    // is compatible with the BabyJub curve.
    signal input seed[256];
    signal output publicKey[2];

    // trim the private key according to the BabyJub curve requirements
    // https://github.com/iden3/circomlibjs/blob/main/src/eddsa.js#L29
    var privateKeyBits[253];
    for (var i = 0; i < 251; i++) {
        privateKeyBits[i] = seed[i + 3];
    }
    privateKeyBits[251] = 1;
    privateKeyBits[252] = 0;

    var privateKey = Bits2Num(253)(privateKeyBits);
    signal pubKeyAx, pubKeyAy;
    (pubKeyAx, pubKeyAy) <== BabyPbk()(in <== privateKey);
    publicKey[0] <== pubKeyAx;
    publicKey[1] <== pubKeyAy;
}