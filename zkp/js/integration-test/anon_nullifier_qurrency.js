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
const { CT_INDEX } = require("../lib/util.js");

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
      70, 89, 16, 100, 42, 70, 214, 197, 79, 159, 47, 70, 2, 222, 148, 153, 52,
      13, 76, 230, 239, 186, 230, 182, 103, 165, 171, 167, 212, 16, 211, 69,
      189, 14, 41, 44, 59, 40, 38, 48, 205, 208, 228, 97, 160, 129, 240, 0, 208,
      210, 42, 142, 232, 148, 175, 133, 70, 60, 231, 103, 26, 52, 80, 74, 69,
      14, 63, 191, 0, 217, 79, 181, 65, 172, 97, 57, 49, 207, 184, 141, 41, 148,
      78, 191, 13, 198, 235, 2, 173, 236, 179, 167, 243, 114, 37, 204, 149, 76,
      152, 141, 153, 218, 0, 192, 153, 69, 203, 245, 181, 18, 137, 147, 197,
      158, 230, 212, 192, 74, 30, 198, 136, 156, 118, 25, 53, 233, 17, 60, 27,
      186, 35, 206, 225, 59, 125, 23, 116, 57, 139, 10, 144, 0, 250, 137, 88,
      156, 122, 93, 56, 39, 65, 108, 81, 116, 164, 44, 54, 37, 196, 65, 141, 78,
      216, 41, 45, 181, 244, 41, 97, 201, 230, 96, 143, 132, 163, 137, 31, 227,
      69, 87, 241, 5, 208, 29, 88, 110, 227, 179, 33, 31, 236, 253, 44, 12, 64,
      199, 29, 36, 240, 47, 115, 251, 52, 181, 50, 110, 233, 24, 248, 190, 14,
      121, 129, 166, 157, 149, 65, 55, 45, 77, 24, 188, 157, 223, 180, 148, 29,
      27, 203, 158, 226, 101, 188, 228, 165, 255, 159, 151, 209, 5, 146, 193,
      40, 189, 103, 18, 134, 216, 170, 23, 181, 179, 154, 142, 228, 58, 152, 70,
      105, 41, 14, 8, 252, 32, 243, 166, 147, 101, 199, 98, 138, 211, 181, 117,
      10, 253, 148, 124, 229, 59, 90, 200, 100, 186, 98, 176, 9, 42, 118, 23,
      169, 2, 3, 77, 59, 119, 119, 41, 120, 88, 209, 54, 139, 254, 208, 159,
      218, 109, 174, 60, 33, 49, 115, 202, 146, 8, 179, 85, 49, 114, 109, 104,
      119, 28, 193, 129, 166, 102, 213, 167, 9, 46, 232, 17, 75, 58, 4, 198,
      197, 113, 76, 0, 71, 252, 149, 201, 183, 85, 167, 196, 86, 162, 19, 87,
      46, 183, 204, 211, 36, 136, 168, 121, 138, 169, 227, 87, 41, 70, 86, 31,
      150, 116, 161, 167, 110, 167, 54, 11, 29, 127, 9, 40, 5, 34, 30, 24, 33,
      122, 79, 49, 60, 222, 182, 20, 223, 141, 92, 6, 8, 177, 76, 47, 253, 28,
      110, 27, 47, 125, 180, 118, 57, 138, 221, 104, 4, 87, 31, 149, 242, 87,
      233, 185, 250, 48, 94, 171, 218, 245, 234, 64, 167, 93, 18, 140, 131, 157,
      112, 36, 66, 12, 227, 174, 190, 162, 36, 50, 225, 34, 46, 162, 59, 97, 55,
      236, 11, 112, 80, 152, 54, 67, 119, 206, 197, 170, 152, 88, 53, 38, 246,
      126, 235, 105, 238, 186, 44, 127, 136, 254, 13, 137, 112, 17, 76, 203, 46,
      139, 33, 224, 11, 131, 175, 236, 47, 140, 48, 177, 47, 230, 250, 186, 195,
      34, 9, 225, 183, 6, 150, 176, 53, 231, 13, 72, 108, 68, 240, 176, 150, 99,
      97, 63, 133, 57, 196, 165, 90, 57, 250, 255, 0, 93, 192, 126, 76, 209, 12,
      124, 194, 242, 73, 195, 170, 15, 59, 237, 218, 236, 171, 226, 124, 158,
      98, 227, 250, 76, 90, 179, 130, 74, 66, 232, 144, 213, 43, 221, 15, 119,
      237, 150, 10, 122, 135, 90, 102, 75, 48, 240, 166, 63, 232, 51, 51, 119,
      227, 47, 226, 133, 215, 20, 46, 129, 244, 9, 15, 178, 203, 102, 69, 224,
      15, 44, 94, 22, 158, 165, 92, 170, 40, 33, 11, 102, 220, 159, 103, 166,
      232, 41, 130, 156, 200, 55, 143, 171, 227, 77, 234, 191, 0, 132, 5, 177,
      115, 130, 131, 80, 230, 145, 111, 110, 19, 79, 65, 113, 109, 170, 210,
      225, 45, 123, 160, 226, 241, 135, 85, 25, 255, 221, 39, 206, 96, 173, 162,
      191, 177, 100, 237, 230, 143, 135, 140, 84, 230, 140, 164, 129, 192, 145,
      16, 155, 168, 168, 206, 84, 99, 89, 73, 178, 167, 65, 85, 111, 150, 138,
      117, 243, 82, 83, 139, 85, 9, 226, 224, 93, 78, 217, 253, 62, 179, 74,
      172, 179, 238, 119, 109, 4, 52, 76, 232, 250, 3, 81, 235, 180, 186, 98,
      150, 151, 72, 37, 194, 187, 171, 122, 171, 166, 123, 71, 26, 113, 114,
      237, 107, 194, 88, 207, 176, 216, 132, 17, 122, 45, 25, 199, 189, 179,
      250, 21, 164, 66, 201, 217, 18, 215, 186, 125, 89, 220, 125, 34,
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
      const witness = await circuit.calculateWTNSBin(
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
        witness,
      );
      console.log("Proving time: ", (Date.now() - startTime) / 1000, "s");

      let verifyResult = await groth16.verify(
        verificationKey,
        publicSignals,
        proof,
      );
      expect(verifyResult).to.be.true;

      // Check that the computed AES and K-PKE ciphertexts are computed correctly
      const anqIndex = CT_INDEX["anon_nullifier_qurrency"];
      const computedCiphertext = witness.slice(anqIndex, anqIndex + 768);
      console.log(computedCiphertext);
      console.log(Array.from(ct).map(x => BigInt(x)));
      expect(computedCiphertext).to.equal(Array.from(ct).map((x) => BigInt(x)));

      // Check that the output of the circuit matches the expected values
      const computed_pubSignals = hashCiphertext(computedCiphertext);
      const expected_pubSignals = hashCiphertext(ct);
      console.log(computed_pubSignals);
      console.log(expected_pubSignals);
      expect(computed_pubSignals).to.equal(expected_pubSignals);
      
      // Check that the witness holds the correct quantities
      expect(witness[1]).to.equal(computed_pubSignals[0]);
      expect(witness[2]).to.equal(computed_pubSignals[1]);
      expect(witness[3]).to.equal(BigInt(nullifiers[0]));
      expect(witness[4]).to.equal(BigInt(nullifiers[1]));

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
