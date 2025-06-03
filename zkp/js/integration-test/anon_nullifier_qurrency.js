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

const { expect } = require("chai");
const { groth16 } = require("snarkjs");
const { genKeypair, formatPrivKeyForBabyJub } = require("maci-crypto");
const {
  Merkletree,
  InMemoryDB,
  str2Bytes,
  ZERO_HASH,
} = require("@iden3/js-merkletree");
const ethers = require("ethers");
const { Poseidon, newSalt, loadCircuit } = require("../index.js");
const { loadProvingKeys } = require("./utils.js");
const { hashCiphertext, CT_INDEX } = require("../lib/util.js");

const SMT_HEIGHT = 64;
const poseidonHash = Poseidon.poseidon4;
const poseidonHash3 = Poseidon.poseidon3;

describe("main circuit tests for Zeto fungible tokens with anonymity using nullifiers with Kyber encryption", () => {
  let circuit, provingKeyFile, verificationKey, smtAlice, smtBob;

  const Alice = {};
  const Bob = {};
  let senderPrivateKey;
  let sk;
  let pk;
  let m;
  let r;
  let ct;

  before(async () => {
    let keypair = genKeypair();
    Alice.privKey = keypair.privKey;
    Alice.pubKey = keypair.pubKey;
    senderPrivateKey = formatPrivKeyForBabyJub(Alice.privKey);

    keypair = genKeypair();
    Bob.privKey = keypair.privKey;
    Bob.pubKey = keypair.pubKey;

    // K-PKE key setup
    sk = new Uint8Array([
      56, 225, 64, 54, 122, 197, 130, 232, 155, 56, 98, 60, 243, 33, 160, 117,
      180, 162, 153, 168, 180, 79, 113, 83, 193, 182, 86, 89, 213, 164, 96, 101,
      163, 118, 202, 60, 6, 144, 51, 3, 56, 64, 226, 87, 111, 85, 230, 91, 155,
      21, 141, 146, 153, 157, 71, 86, 174, 7, 18, 167, 142, 197, 101, 176, 23,
      63, 136, 38, 157, 237, 171, 206, 191, 28, 102, 157, 198, 113, 228, 108,
      83, 125, 140, 16, 60, 161, 43, 52, 8, 47, 35, 172, 57, 140, 39, 4, 4, 23,
      200, 166, 115, 52, 14, 233, 56, 254, 213, 187, 234, 28, 73, 169, 139, 54,
      152, 100, 93, 112, 51, 68, 147, 220, 187, 16, 212, 12, 114, 145, 147, 170,
      154, 59, 146, 101, 5, 151, 215, 99, 55, 88, 109, 253, 210, 132, 32, 201,
      88, 241, 66, 5, 41, 25, 40, 129, 40, 58, 119, 35, 166, 21, 147, 161, 163,
      103, 28, 84, 139, 62, 165, 0, 62, 226, 201, 178, 173, 34, 187, 198, 84,
      170, 80, 128, 77, 112, 213, 74, 197, 203, 32, 135, 242, 13, 105, 165, 99,
      143, 217, 79, 63, 113, 58, 60, 96, 83, 254, 182, 85, 250, 149, 62, 214,
      81, 33, 8, 176, 14, 206, 33, 193, 154, 177, 89, 138, 217, 31, 73, 134,
      136, 9, 6, 70, 206, 182, 128, 35, 4, 67, 225, 118, 29, 253, 147, 155, 107,
      75, 149, 233, 172, 175, 199, 59, 38, 199, 48, 182, 199, 192, 63, 140, 8,
      173, 213, 22, 49, 24, 247, 100, 65, 201, 167, 175, 96, 58, 20, 90, 162,
      184, 176, 22, 217, 85, 196, 234, 55, 194, 240, 123, 4, 165, 102, 206, 78,
      57, 167, 233, 80, 104, 73, 200, 93, 163, 166, 27, 237, 169, 73, 244, 242,
      93, 55, 83, 190, 244, 39, 132, 56, 133, 26, 99, 120, 32, 218, 151, 165,
      180, 102, 168, 118, 114, 82, 14, 211, 12, 94, 218, 166, 51, 161, 80, 231,
      52, 22, 117, 195, 62, 6, 198, 119, 154, 72, 148, 210, 115, 111, 253, 167,
      33, 183, 162, 31, 122, 91, 2, 160, 112, 168, 132, 21, 134, 211, 129, 6,
      85, 72, 83, 117, 213, 87, 93, 137, 34, 193, 35, 1, 195, 60, 31, 144, 103,
      99, 184, 117, 174, 188, 42, 144, 99, 113, 18, 113, 144, 106, 181, 73, 132,
      57, 215, 22, 231, 197, 30, 234, 114, 106, 97, 178, 201, 160, 212, 142,
      193, 64, 106, 82, 68, 165, 252, 25, 27, 254, 41, 50, 125, 166, 146, 57,
      252, 202, 175, 25, 170, 182, 136, 124, 135, 101, 117, 107, 17, 187, 198,
      252, 123, 99, 123, 105, 60, 177, 102, 155, 139, 169, 86, 156, 173, 0, 148,
      3, 139, 135, 182, 157, 138, 13, 243, 124, 21, 234, 165, 50, 147, 99, 94,
      149, 117, 193, 21, 169, 77, 78, 17, 62, 177, 209, 46, 171, 176, 82, 27,
      240, 170, 60, 171, 50, 54, 212, 90, 85, 218, 163, 176, 135, 48, 251, 69,
      56, 4, 26, 188, 175, 132, 46, 176, 134, 81, 157, 53, 77, 70, 28, 5, 240,
      162, 176, 111, 74, 3, 130, 138, 97, 193, 138, 202, 24, 72, 166, 79, 25,
      127, 236, 193, 76, 193, 241, 67, 4, 241, 101, 171, 107, 133, 10, 112, 204,
      243, 25, 97, 184, 224, 183, 252, 24, 133, 98, 70, 153, 239, 245, 130, 42,
      20, 141, 197, 6, 129, 13, 100, 44, 29, 69, 75, 125, 9, 72, 122, 219, 154,
      120, 226, 3, 75, 38, 91, 130, 19, 198, 3, 85, 138, 28, 66, 54, 213, 70,
      163, 202, 150, 58, 247, 12, 3, 186, 134, 47, 88, 117, 34, 170, 119, 18, 9,
      151, 111, 83, 245, 51, 252, 233, 177, 32, 39, 73, 185, 217, 9, 149, 170,
      29, 194, 104, 161, 172, 148, 177, 144, 217, 20, 199, 66, 46, 159, 36, 41,
      195, 66, 195, 93, 144, 64, 82, 98, 154, 207, 40, 136, 70, 225, 51, 173,
      202, 8, 186, 115, 137, 242, 135, 176, 30, 102, 38, 218, 236, 36, 124, 154,
      100, 214, 99, 153, 233, 156, 176, 216, 194, 100, 118, 97, 143, 254, 55,
      93, 128, 121, 191, 156, 12, 47, 196, 22, 114, 84, 164, 205, 107, 135, 128,
      151, 43, 15, 160, 114, 176, 93, 7, 130, 164, 114, 30, 76, 28, 34, 213, 98,
      189, 187, 151, 33, 224, 115, 33, 182, 148, 21, 122, 192, 147, 174, 246,
      35, 39, 166, 111, 122, 103, 182, 239, 108, 136,
    ]);

    pk = new Uint8Array([
      13, 82, 109, 110, 160, 199, 2, 183, 76, 221, 0, 130, 203, 217, 17, 196,
      71, 170, 102, 40, 32, 203, 54, 110, 44, 128, 52, 122, 75, 85, 70, 201, 56,
      36, 104, 30, 206, 51, 50, 127, 185, 158, 51, 21, 207, 198, 124, 57, 15,
      92, 135, 153, 6, 19, 199, 50, 14, 157, 11, 162, 51, 227, 39, 122, 103, 58,
      71, 192, 164, 204, 53, 1, 239, 59, 171, 66, 41, 128, 56, 12, 187, 228,
      231, 201, 183, 187, 120, 168, 162, 163, 45, 129, 153, 31, 185, 32, 14, 37,
      191, 115, 218, 195, 186, 150, 117, 245, 28, 187, 222, 5, 142, 18, 57, 63,
      118, 44, 93, 174, 208, 25, 5, 216, 132, 213, 208, 56, 172, 199, 5, 41,
      231, 132, 239, 182, 130, 236, 59, 75, 212, 133, 105, 8, 171, 207, 139, 22,
      114, 48, 81, 91, 18, 192, 200, 20, 139, 138, 189, 138, 143, 57, 167, 164,
      249, 83, 139, 141, 229, 203, 246, 148, 184, 211, 24, 76, 17, 88, 144, 20,
      8, 158, 253, 6, 46, 157, 32, 37, 228, 148, 27, 46, 103, 130, 244, 57, 192,
      199, 64, 66, 200, 84, 122, 221, 138, 127, 178, 10, 118, 37, 9, 141, 87,
      152, 41, 144, 105, 74, 152, 26, 149, 234, 11, 88, 114, 214, 97, 147, 86,
      179, 193, 49, 157, 31, 172, 183, 149, 247, 73, 242, 163, 176, 220, 153,
      146, 165, 192, 157, 170, 85, 153, 194, 38, 135, 154, 178, 99, 172, 121,
      24, 180, 107, 51, 113, 131, 172, 68, 65, 194, 98, 9, 170, 209, 44, 20,
      164, 67, 60, 33, 43, 30, 161, 3, 13, 176, 48, 178, 243, 81, 30, 145, 193,
      131, 169, 194, 121, 164, 37, 146, 43, 150, 63, 226, 212, 61, 49, 217, 137,
      76, 108, 76, 204, 116, 84, 186, 226, 83, 70, 112, 137, 3, 120, 185, 78,
      97, 153, 76, 228, 89, 81, 67, 102, 183, 247, 189, 27, 180, 137, 65, 170,
      154, 186, 131, 35, 201, 114, 170, 70, 172, 62, 236, 6, 115, 247, 248, 81,
      91, 251, 52, 0, 105, 8, 71, 184, 48, 195, 107, 106, 48, 92, 84, 162, 215,
      124, 250, 129, 99, 0, 211, 122, 1, 64, 41, 134, 8, 85, 44, 108, 205, 156,
      164, 31, 162, 20, 120, 7, 146, 70, 188, 87, 68, 95, 178, 45, 119, 92, 141,
      179, 215, 138, 81, 218, 171, 60, 208, 169, 168, 140, 78, 215, 36, 176,
      247, 131, 113, 36, 102, 107, 231, 186, 86, 186, 131, 48, 23, 201, 112,
      184, 140, 91, 193, 151, 54, 109, 68, 154, 184, 196, 111, 148, 7, 41, 56,
      150, 94, 44, 90, 87, 101, 144, 74, 220, 135, 181, 107, 211, 78, 137, 136,
      139, 24, 2, 133, 216, 33, 139, 114, 215, 146, 37, 168, 123, 193, 25, 134,
      234, 41, 4, 237, 183, 134, 25, 166, 166, 214, 96, 199, 229, 147, 4, 53,
      56, 57, 203, 169, 166, 168, 144, 7, 131, 68, 126, 252, 210, 127, 233, 246,
      16, 206, 177, 133, 7, 60, 189, 14, 163, 163, 17, 55, 137, 23, 118, 92, 23,
      228, 123, 110, 182, 75, 223, 247, 23, 231, 185, 183, 214, 202, 57, 145,
      22, 93, 152, 186, 80, 224, 53, 19, 206, 178, 37, 26, 37, 6, 97, 50, 72,
      238, 194, 145, 172, 137, 85, 41, 232, 181, 207, 88, 35, 226, 10, 111, 171,
      164, 73, 71, 210, 8, 237, 75, 101, 101, 11, 162, 41, 71, 193, 13, 229, 95,
      182, 74, 0, 77, 121, 79, 185, 242, 69, 186, 177, 90, 131, 18, 3, 126, 4,
      174, 97, 176, 53, 24, 43, 206, 8, 244, 97, 85, 103, 59, 226, 10, 170, 219,
      107, 28, 204, 59, 102, 231, 156, 187, 32, 42, 114, 168, 117, 172, 246, 75,
      86, 102, 25, 23, 104, 135, 82, 16, 196, 148, 174, 1, 208, 42, 24, 79, 207,
      187, 34, 150, 92, 4, 184, 103, 48, 13, 148, 156, 185, 75, 35, 128, 166,
      98, 101, 92, 62, 255, 38, 83, 54, 118, 140, 18, 129, 143, 210, 54, 54,
      160, 209, 58, 93, 236, 166, 33, 204, 42, 20, 112, 149, 69, 181, 166, 232,
      113, 88, 135, 184, 72, 74, 193, 159, 220, 201, 140, 102, 170, 89, 155, 23,
      22, 134, 26, 7, 249, 9, 66, 201, 203, 111, 156, 136, 141, 47, 131, 92,
      171, 11, 92, 230, 226, 204, 107, 1, 45, 126, 17, 169, 172, 211, 13, 36,
      168, 67, 106, 97, 128, 119, 105, 164, 206, 142, 115, 52, 244, 188, 130,
      210, 179, 88, 52, 175, 175, 14, 130, 188, 13, 211, 188, 1, 11, 86, 120,
      246, 134, 178, 183, 93, 119, 177, 191, 15,
    ]);

    // Message: a key for an AES-256 based cipher
    m = [
      1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0,
      1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0,
      0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1,
      1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0,
      1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1,
      1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0,
      1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 1,
      0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1,
      0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1,
      0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1,
      1, 0, 1, 0, 0, 1,
    ];

    // Randomness: a 256-bit nonce
    r = [
      0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 1,
      0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0,
      1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0,
      1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0,
      0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1,
      1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1,
      1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0,
      0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0,
      0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0,
      1, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0,
      1, 1, 1, 0, 1, 1,
    ];

    // Ciphertext: expected result of Enc(pk, m, r)
    ct = new Uint8Array([
      232, 72, 215, 40, 200, 26, 124, 17, 161, 10, 29, 77, 34, 214, 29, 217, 72,
      9, 195, 124, 78, 84, 69, 31, 30, 233, 245, 64, 42, 172, 155, 57, 207, 44,
      182, 132, 212, 27, 94, 245, 251, 26, 155, 84, 136, 201, 51, 49, 144, 140,
      236, 182, 120, 249, 224, 210, 232, 45, 142, 66, 104, 254, 84, 36, 29, 66,
      29, 187, 54, 254, 193, 211, 194, 156, 201, 238, 219, 247, 49, 135, 71, 48,
      248, 139, 165, 89, 241, 186, 51, 107, 176, 98, 145, 209, 213, 33, 169, 14,
      243, 182, 202, 107, 13, 247, 71, 204, 101, 103, 222, 30, 214, 173, 187,
      55, 146, 117, 89, 3, 5, 76, 48, 110, 243, 56, 9, 190, 205, 64, 113, 75,
      207, 2, 161, 127, 56, 244, 122, 88, 99, 219, 86, 59, 253, 182, 20, 176,
      67, 0, 89, 90, 89, 115, 233, 204, 40, 130, 44, 97, 67, 116, 201, 35, 72,
      231, 19, 5, 96, 10, 86, 89, 230, 218, 123, 175, 208, 7, 55, 237, 249, 225,
      160, 48, 221, 67, 3, 212, 103, 218, 84, 129, 54, 60, 213, 250, 106, 226,
      234, 188, 128, 117, 129, 163, 42, 223, 179, 107, 113, 151, 96, 22, 154,
      21, 163, 115, 194, 2, 49, 187, 156, 76, 38, 87, 145, 19, 38, 180, 64, 101,
      19, 139, 16, 255, 150, 58, 106, 56, 203, 49, 215, 197, 59, 38, 85, 166,
      21, 120, 211, 88, 219, 125, 42, 253, 205, 151, 233, 184, 35, 239, 189, 64,
      60, 87, 2, 17, 133, 75, 187, 213, 148, 116, 47, 75, 171, 148, 146, 112,
      21, 179, 151, 93, 79, 114, 191, 151, 62, 110, 36, 80, 255, 122, 79, 168,
      179, 46, 234, 29, 206, 176, 241, 137, 219, 168, 22, 233, 218, 93, 22, 6,
      227, 100, 216, 188, 97, 49, 128, 125, 70, 168, 191, 235, 118, 20, 124,
      237, 215, 48, 58, 57, 80, 175, 139, 29, 183, 126, 145, 93, 33, 219, 42,
      229, 80, 218, 23, 69, 52, 206, 55, 45, 143, 50, 108, 127, 128, 176, 15,
      213, 78, 63, 12, 179, 82, 48, 199, 147, 105, 83, 114, 116, 242, 15, 48,
      160, 173, 160, 130, 16, 186, 14, 160, 252, 232, 194, 18, 191, 39, 235,
      117, 211, 237, 250, 198, 187, 180, 191, 167, 29, 204, 0, 36, 126, 188, 79,
      76, 23, 73, 216, 8, 78, 73, 123, 57, 62, 219, 71, 79, 229, 44, 13, 193,
      147, 59, 17, 45, 39, 97, 214, 164, 6, 220, 40, 150, 55, 77, 28, 162, 226,
      27, 41, 32, 17, 202, 162, 199, 196, 130, 79, 227, 231, 160, 131, 72, 210,
      179, 54, 97, 85, 215, 215, 136, 114, 184, 98, 88, 194, 92, 48, 206, 137,
      242, 114, 65, 248, 148, 137, 226, 41, 163, 165, 228, 19, 39, 1, 135, 205,
      73, 221, 100, 45, 84, 37, 30, 219, 107, 175, 126, 150, 245, 83, 191, 7,
      197, 213, 133, 184, 73, 141, 5, 195, 192, 145, 165, 124, 125, 227, 124,
      80, 158, 12, 129, 243, 0, 77, 170, 19, 144, 47, 183, 136, 184, 170, 113,
      217, 198, 103, 22, 9, 81, 29, 19, 122, 58, 19, 141, 82, 57, 234, 29, 206,
      52, 119, 147, 224, 236, 1, 186, 115, 19, 111, 233, 193, 62, 46, 241, 11,
      21, 164, 43, 160, 229, 117, 59, 28, 234, 87, 195, 193, 52, 253, 215, 144,
      233, 28, 187, 12, 200, 33, 64, 173, 103, 214, 226, 173, 189, 200, 196,
      153, 72, 32, 48, 121, 165, 141, 72, 98, 92, 32, 233, 28, 35, 183, 172, 54,
      66, 242, 24, 118, 219, 168, 144, 36, 241, 125, 65, 0, 52, 199, 224, 187,
      117, 109, 74, 129, 237, 64, 203, 67, 26, 18, 230, 198, 48, 3, 195, 178,
      20, 36, 25, 168, 2, 243, 29, 185, 95, 159, 245, 62, 222, 105, 240, 102,
      78, 227, 204, 11, 206, 39, 199, 34, 209, 163, 172, 203, 185, 177, 2, 108,
      140, 14, 224, 202, 97, 147, 240, 89, 227, 198, 56, 212, 184, 254, 143, 84,
      111, 143, 93, 195, 61, 29, 232, 71, 120, 132, 204, 58, 201, 126, 100, 199,
      210, 4, 239, 132, 229, 213, 115, 138, 73, 122, 148, 8, 127, 152, 81, 202,
      151, 238, 207, 222, 83, 127, 82, 128, 125, 147, 106, 225, 85, 210, 86, 86,
      157, 221, 82, 223, 136, 19, 6, 52, 114, 197, 134, 46, 219, 119, 216, 81,
      74, 80, 172, 81, 223, 152, 146, 20, 169, 56, 62, 239,
    ]);
  });

  describe("transfer()", () => {
    before(async () => {
      circuit = await loadCircuit("anon_nullifier_qurrency_transfer");
      ({ provingKeyFile, verificationKey } = loadProvingKeys(
        "anon_nullifier_qurrency_transfer",
      ));

      // initialize the local storage for Alice to manage her UTXOs in the Sparse Merkle Tree
      const storage1 = new InMemoryDB(str2Bytes(""));
      smtAlice = new Merkletree(storage1, true, SMT_HEIGHT);

      // initialize the local storage for Bob to manage his UTXOs in the Sparse Merkle Tree
      const storage2 = new InMemoryDB(str2Bytes(""));
      smtBob = new Merkletree(storage2, true, SMT_HEIGHT);
    });

    it("should generate a valid proof that can be verified successfully and fail when public signals are tampered", async () => {
      const inputValues = [15, 100];
      const outputValues = [80, 35];
      const salt1 = newSalt();
      const input1 = poseidonHash([
        BigInt(inputValues[0]),
        salt1,
        ...Alice.pubKey,
      ]);
      const salt2 = newSalt();
      const input2 = poseidonHash([
        BigInt(inputValues[1]),
        salt2,
        ...Alice.pubKey,
      ]);
      const inputCommitments = [input1, input2];

      // create the nullifiers for the input UTXOs
      const nullifier1 = poseidonHash3([
        BigInt(inputValues[0]),
        salt1,
        senderPrivateKey,
      ]);
      const nullifier2 = poseidonHash3([
        BigInt(inputValues[1]),
        salt2,
        senderPrivateKey,
      ]);
      const nullifiers = [nullifier1, nullifier2];

      // calculate the root of the SMT
      await smtAlice.add(input1, input1);
      await smtAlice.add(input2, input2);

      // generate the merkle proof for the inputs
      const proof1 = await smtAlice.generateCircomVerifierProof(
        input1,
        ZERO_HASH,
      );
      const proof2 = await smtAlice.generateCircomVerifierProof(
        input2,
        ZERO_HASH,
      );

      // create two output UTXOs, they share the same salt, and different owner
      const salt3 = newSalt();
      const output1 = poseidonHash([
        BigInt(outputValues[0]),
        salt3,
        ...Bob.pubKey,
      ]);
      const output2 = poseidonHash([
        BigInt(outputValues[1]),
        salt3,
        ...Alice.pubKey,
      ]);
      const outputCommitments = [output1, output2];

      const startTime = Date.now();
      // TODO: write to file so we don't have to wait so long!
      const witnessBin = await circuit.calculateWTNSBin(
        {
          nullifiers,
          inputCommitments,
          inputValues,
          inputSalts: [salt1, salt2],
          inputOwnerPrivateKey: senderPrivateKey,
          root: proof1.root.bigInt(),
          merkleProof: [
            proof1.siblings.map((s) => s.bigInt()),
            proof2.siblings.map((s) => s.bigInt()),
          ],
          enabled: [1, 1],
          outputCommitments,
          outputValues,
          outputSalts: [salt3, salt3],
          outputOwnerPublicKeys: [Bob.pubKey, Alice.pubKey],
          // Extra inputs for K-PKE encryption.
          // Map "1" bits to "1665" as required by the kyber_enc circuit.
          m: m.map((b) => 1665 * b),
          randomness: r,
        },
        true,
      );

      const witness = await circuit.calculateWitness(
        {
          nullifiers,
          inputCommitments,
          inputValues,
          inputSalts: [salt1, salt2],
          inputOwnerPrivateKey: senderPrivateKey,
          root: proof1.root.bigInt(),
          merkleProof: [
            proof1.siblings.map((s) => s.bigInt()),
            proof2.siblings.map((s) => s.bigInt()),
          ],
          enabled: [1, 1],
          outputCommitments,
          outputValues,
          outputSalts: [salt3, salt3],
          outputOwnerPublicKeys: [Bob.pubKey, Alice.pubKey],
          // Extra inputs for K-PKE encryption.
          // Map "1" bits to "1665" as required by the kyber_enc circuit.
          m: m.map((b) => 1665 * b),
          randomness: r,
        },
        true,
      );

      const { proof, publicSignals } = await groth16.prove(
        provingKeyFile,
        witnessBin,
      );
      console.log("Proving time: ", (Date.now() - startTime) / 1000, "s");

      let verifyResult = await groth16.verify(
        verificationKey,
        publicSignals,
        proof,
      );
      expect(verifyResult).to.be.true;

      // Check that the computed AES and K-PKE ciphertexts are computed correctly
      // TODO: add AES encryption
      const anqIndex = CT_INDEX["anon_nullifier_qurrency"];
      const computedCiphertext = witness.slice(anqIndex, anqIndex + 768);
      expect(computedCiphertext).to.deep.equal(Array.from(ct).map((x) => BigInt(x)));

      // Check that the computed circuit outputs are computed correctly
      const computed_pubSignals = [witness[1], witness[2]];
      const expected_pubSignals = hashCiphertext(ct);
      expect(computed_pubSignals).to.deep.equal(expected_pubSignals);

      // console.log('nullifiers', nullifiers);
      // console.log('inputCommitments', inputCommitments);
      // console.log('outputCommitments', outputCommitments);
      // console.log('root', proof1.root.bigInt());
      // console.log('public signals', publicSignals);
      const tamperedOutputHash = poseidonHash([
        BigInt(100),
        salt3,
        ...Bob.pubKey,
      ]);
      let tamperedPublicSignals = publicSignals.map((ps) =>
        ps.toString() === outputCommitments[0].toString()
          ? tamperedOutputHash
          : ps,
      );
      // console.log("tampered public signals", tamperedPublicSignals);

      verifyResult = await groth16.verify(
        verificationKey,
        tamperedPublicSignals,
        proof,
      );
      expect(verifyResult).to.be.false;
    }).timeout(600000);
  });
});
