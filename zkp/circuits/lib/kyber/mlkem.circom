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

include "../../node_modules/circomlib/circuits/bitify.circom";
include "half_ntt.circom";
include "sha2/sha256/sha256_hash_bytes.circom";
include "sha3/sha3_bits.circom";
include "kyber.circom";

template mlkem_encaps() {
    signal input m[256]; // randomness input, should be random and unique for each encapsulation

    signal output K[256]; // this is the shared secret
    signal output c_short[25]; // this is the ciphertext to send to the receiver to recover the shared secret
    component anon = mlkem_encaps_internal();
    anon.m <== m;
    c_short <== anon.c_short;
    K <== anon.K;
}

template mlkem_encaps_internal() {
    signal input m[256];
    signal output K[256]; // this is the shared secret

    component g = g();
    g.m <== m;
    signal r[256];
    K <== g.K; // K is the first half of the digest
    r <== g.r; // r is the second half of the digest

    // r is the random value used to encrypt the message m
    signal c[768*8] <== kpke_enc()(r, m);

    // Split the ciphertext c into pieces of 248 bits (31 bytes), and fit each
    // piece into a single group element
    signal output c_short[25];
    for (var i = 0; i < 24; i++) {
        var bits[248];
        for (var j = 0; j < 248; j++) {
            bits[j] = c[j + i*248];
        }
        c_short[i] <== Bits2Num(248)(bits);
    }
    var bits[768*8 - 24*248];
    for (var j = 0; j < (768*8 - 24*248); j++) {
        bits[j] = c[j + 24*248];
    }
    c_short[24] <== Bits2Num(768*8 - 24*248)(bits);
}

// G(m || H(ek)) = SHA3_512(m || H(ek))
template g() {
    signal input m[256];

    // This is a precomputed digest of the public key, H(ek) = SHA3-256(ek)
    // Note that the bit order within each byte is reversed compared to the
    // original output from the hashing function. This is because the circuit
    // treats all bit arrays as little-endian, with the least significant bit
    // on the left.
    // Use the script `generateQurrencyKey.js` to generate this value (the "PUBLIC KEY HASH" in the print output).
    signal sha3_256_digest[256] <== [0,0,1,0,0,1,1,0,0,1,1,0,0,1,1,1,0,1,1,1,0,0,0,0,1,1,1,1,0,0,0,1,1,0,1,0,0,0,1,1,0,1,1,0,1,0,0,1,0,0,0,1,0,0,1,0,1,1,1,0,1,0,0,1,1,1,0,0,1,1,1,1,0,0,1,0,1,0,0,1,1,0,0,0,1,0,1,0,1,0,0,1,0,0,1,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,1,0,0,1,1,0,0,1,1,1,1,1,1,0,1,1,0,0,0,1,1,1,0,1,1,1,1,0,1,0,0,1,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,1,1,0,1,0,1,1,1,0,0,1,0,0,0,1,1,1,1,1,1,1,0,0,1,0,1,0,1,0,0,0,1,1,0,0,1,0,1,0,1,1,1,1,0,0,1,1,1,0,0,0,1,0,0,1,0,0,1,1,0,0,1,0,0,1,0,1,0,0,0,0,0,0,1,1,0,1,1,1,0,0,1];

    // Concatenate m and H(ek)
    signal sha3_512_input[512];
    for (var i = 0; i < 256; i++) {
        sha3_512_input[i] <== m[i];
        sha3_512_input[256 + i] <== sha3_256_digest[i];
    }
    
    component sha3_512 = SHA3_512(512);
    sha3_512.inp <== sha3_512_input;
    signal sha_512_digest[512] <== sha3_512.out;

    // K is the first half of the digest
    signal output K[256];
    for (var i = 0; i < 256; i++) {
        K[i] <== sha_512_digest[i];
    }

    // r is the second half
    signal output r[256];
    for (var i = 0; i < 256; i++) {
        r[i] <== sha_512_digest[256 + i];
    }
}