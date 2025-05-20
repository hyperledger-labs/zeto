pragma circom 2.2.2;

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
include "../scripts/node_modules/circomlib/circuits/bitify.circom";
include "../scripts/node_modules/circomlib/circuits/escalarmulany.circom";

// Use the EC Diffie-Hellman protocol to generate a shared secret using
// the receiver's public key and the sender's private key.
template Ecdh() {
    // Note: The private key needs to be hashed and then pruned first
    signal input privKey;
    signal input pubKey[2];

    signal output sharedKey[2];

    var privBits[253];
    privBits = Num2Bits(253)(in <== privKey);

    // calculate the receiver's public key raised to the power of the sender's private key.
    // - Given the receiver's public key g^r ("r" is the receiver's private key)
    //   the shared secret is (g^r)^s ("s" is the sender's private key).
    // - The receiver can derive the same shared secret by raising the sender's public key
    //   to the power of the receiver's private key: (g^s)^r
    // - The shared secret is the same in both cases: g^(r*s) = g^(s*r)
    sharedKey <== EscalarMulAny(253)(p <== pubKey, e <== privBits);
}