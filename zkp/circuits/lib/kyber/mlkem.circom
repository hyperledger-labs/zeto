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

include "half_ntt.circom";
include "sha2/sha256/sha256_hash_bytes.circom";
include "sha3/sha3_bits.circom";
include "kyber.circom";

template mlkem_encaps() {
    signal input m[256];

    signal output K[256]; // TODO: this is secret, use in poseidon encryption
    signal output c_short[25];
    component anon = mlkem_encaps_internal();
    anon.m <== m;
    c_short <== anon.c_short;
}

template mlkem_encaps_internal() {
    signal input m[256];

    // This is a precomputed digest of the public key, SHA3-256(ek)
    signal sha_256_digest[256] <== [0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 1];

    // Concatenate m and H(ek)
    signal sha_512_input[512];
    for (var i = 0; i < 256; i++) {
        sha_512_input[i] <== m[i];
        sha_512_input[256 + i] <== sha_256_digest[i];
    }
    
    signal sha_512_digest[512] <== SHA3_512(512)(sha_512_input);

    // K is the first half of the digest
    signal output K[256];
    for (var i = 0; i < 256; i++) {
        K[i] <== sha_512_digest[i];
    }

    // r is the second half
    signal r[256];
    for (var i = 0; i < 256; i++) {
        r[i] <== sha_512_digest[256 + i];
    }

    signal c[768*8] <== kpke_enc()(r, m);

    // Split the ciphertext c into pieces of 254 bits, and fit each
    // piece into a single group element
    signal output c_short[25];

    var sum;
    for (var i = 0; i < 24; i++) {
        sum = 0;
        for (var j = 0; j < 254; j++) {
            sum += c[j + i*254]*(1<<j);
        }
        c_short[i] <== sum;
    }
    sum = 0;
    for (var j = 0; j < (768*8 - 24*254); j++) {
        sum += c[j + 24*254]*(1<<j);
    }
    c_short[24] <== sum;
}