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
const { join } = require("path");
const crypto = require("crypto");
const { wasm: wasm_tester } = require("circom_tester");
const { genKeypair, formatPrivKeyForBabyJub } = require("maci-crypto");
const {
  Merkletree,
  InMemoryDB,
  str2Bytes,
  ZERO_HASH,
} = require("@iden3/js-merkletree");
const { Poseidon, newSalt } = require("../index.js");
const { hashCiphertext } = require("../lib/util.js");

const SMT_HEIGHT = 64;
const poseidonHash = Poseidon.poseidon4;
const poseidonHash3 = Poseidon.poseidon3;

// K-PKE key setup
sk = new Uint8Array([
  56, 225, 64, 54, 122, 197, 130, 232, 155, 56, 98, 60, 243, 33, 160, 117, 180,
  162, 153, 168, 180, 79, 113, 83, 193, 182, 86, 89, 213, 164, 96, 101, 163,
  118, 202, 60, 6, 144, 51, 3, 56, 64, 226, 87, 111, 85, 230, 91, 155, 21, 141,
  146, 153, 157, 71, 86, 174, 7, 18, 167, 142, 197, 101, 176, 23, 63, 136, 38,
  157, 237, 171, 206, 191, 28, 102, 157, 198, 113, 228, 108, 83, 125, 140, 16,
  60, 161, 43, 52, 8, 47, 35, 172, 57, 140, 39, 4, 4, 23, 200, 166, 115, 52, 14,
  233, 56, 254, 213, 187, 234, 28, 73, 169, 139, 54, 152, 100, 93, 112, 51, 68,
  147, 220, 187, 16, 212, 12, 114, 145, 147, 170, 154, 59, 146, 101, 5, 151,
  215, 99, 55, 88, 109, 253, 210, 132, 32, 201, 88, 241, 66, 5, 41, 25, 40, 129,
  40, 58, 119, 35, 166, 21, 147, 161, 163, 103, 28, 84, 139, 62, 165, 0, 62,
  226, 201, 178, 173, 34, 187, 198, 84, 170, 80, 128, 77, 112, 213, 74, 197,
  203, 32, 135, 242, 13, 105, 165, 99, 143, 217, 79, 63, 113, 58, 60, 96, 83,
  254, 182, 85, 250, 149, 62, 214, 81, 33, 8, 176, 14, 206, 33, 193, 154, 177,
  89, 138, 217, 31, 73, 134, 136, 9, 6, 70, 206, 182, 128, 35, 4, 67, 225, 118,
  29, 253, 147, 155, 107, 75, 149, 233, 172, 175, 199, 59, 38, 199, 48, 182,
  199, 192, 63, 140, 8, 173, 213, 22, 49, 24, 247, 100, 65, 201, 167, 175, 96,
  58, 20, 90, 162, 184, 176, 22, 217, 85, 196, 234, 55, 194, 240, 123, 4, 165,
  102, 206, 78, 57, 167, 233, 80, 104, 73, 200, 93, 163, 166, 27, 237, 169, 73,
  244, 242, 93, 55, 83, 190, 244, 39, 132, 56, 133, 26, 99, 120, 32, 218, 151,
  165, 180, 102, 168, 118, 114, 82, 14, 211, 12, 94, 218, 166, 51, 161, 80, 231,
  52, 22, 117, 195, 62, 6, 198, 119, 154, 72, 148, 210, 115, 111, 253, 167, 33,
  183, 162, 31, 122, 91, 2, 160, 112, 168, 132, 21, 134, 211, 129, 6, 85, 72,
  83, 117, 213, 87, 93, 137, 34, 193, 35, 1, 195, 60, 31, 144, 103, 99, 184,
  117, 174, 188, 42, 144, 99, 113, 18, 113, 144, 106, 181, 73, 132, 57, 215, 22,
  231, 197, 30, 234, 114, 106, 97, 178, 201, 160, 212, 142, 193, 64, 106, 82,
  68, 165, 252, 25, 27, 254, 41, 50, 125, 166, 146, 57, 252, 202, 175, 25, 170,
  182, 136, 124, 135, 101, 117, 107, 17, 187, 198, 252, 123, 99, 123, 105, 60,
  177, 102, 155, 139, 169, 86, 156, 173, 0, 148, 3, 139, 135, 182, 157, 138, 13,
  243, 124, 21, 234, 165, 50, 147, 99, 94, 149, 117, 193, 21, 169, 77, 78, 17,
  62, 177, 209, 46, 171, 176, 82, 27, 240, 170, 60, 171, 50, 54, 212, 90, 85,
  218, 163, 176, 135, 48, 251, 69, 56, 4, 26, 188, 175, 132, 46, 176, 134, 81,
  157, 53, 77, 70, 28, 5, 240, 162, 176, 111, 74, 3, 130, 138, 97, 193, 138,
  202, 24, 72, 166, 79, 25, 127, 236, 193, 76, 193, 241, 67, 4, 241, 101, 171,
  107, 133, 10, 112, 204, 243, 25, 97, 184, 224, 183, 252, 24, 133, 98, 70, 153,
  239, 245, 130, 42, 20, 141, 197, 6, 129, 13, 100, 44, 29, 69, 75, 125, 9, 72,
  122, 219, 154, 120, 226, 3, 75, 38, 91, 130, 19, 198, 3, 85, 138, 28, 66, 54,
  213, 70, 163, 202, 150, 58, 247, 12, 3, 186, 134, 47, 88, 117, 34, 170, 119,
  18, 9, 151, 111, 83, 245, 51, 252, 233, 177, 32, 39, 73, 185, 217, 9, 149,
  170, 29, 194, 104, 161, 172, 148, 177, 144, 217, 20, 199, 66, 46, 159, 36, 41,
  195, 66, 195, 93, 144, 64, 82, 98, 154, 207, 40, 136, 70, 225, 51, 173, 202,
  8, 186, 115, 137, 242, 135, 176, 30, 102, 38, 218, 236, 36, 124, 154, 100,
  214, 99, 153, 233, 156, 176, 216, 194, 100, 118, 97, 143, 254, 55, 93, 128,
  121, 191, 156, 12, 47, 196, 22, 114, 84, 164, 205, 107, 135, 128, 151, 43, 15,
  160, 114, 176, 93, 7, 130, 164, 114, 30, 76, 28, 34, 213, 98, 189, 187, 151,
  33, 224, 115, 33, 182, 148, 21, 122, 192, 147, 174, 246, 35, 39, 166, 111,
  122, 103, 182, 239, 108, 136,
]);

pk = new Uint8Array([
  13, 82, 109, 110, 160, 199, 2, 183, 76, 221, 0, 130, 203, 217, 17, 196, 71,
  170, 102, 40, 32, 203, 54, 110, 44, 128, 52, 122, 75, 85, 70, 201, 56, 36,
  104, 30, 206, 51, 50, 127, 185, 158, 51, 21, 207, 198, 124, 57, 15, 92, 135,
  153, 6, 19, 199, 50, 14, 157, 11, 162, 51, 227, 39, 122, 103, 58, 71, 192,
  164, 204, 53, 1, 239, 59, 171, 66, 41, 128, 56, 12, 187, 228, 231, 201, 183,
  187, 120, 168, 162, 163, 45, 129, 153, 31, 185, 32, 14, 37, 191, 115, 218,
  195, 186, 150, 117, 245, 28, 187, 222, 5, 142, 18, 57, 63, 118, 44, 93, 174,
  208, 25, 5, 216, 132, 213, 208, 56, 172, 199, 5, 41, 231, 132, 239, 182, 130,
  236, 59, 75, 212, 133, 105, 8, 171, 207, 139, 22, 114, 48, 81, 91, 18, 192,
  200, 20, 139, 138, 189, 138, 143, 57, 167, 164, 249, 83, 139, 141, 229, 203,
  246, 148, 184, 211, 24, 76, 17, 88, 144, 20, 8, 158, 253, 6, 46, 157, 32, 37,
  228, 148, 27, 46, 103, 130, 244, 57, 192, 199, 64, 66, 200, 84, 122, 221, 138,
  127, 178, 10, 118, 37, 9, 141, 87, 152, 41, 144, 105, 74, 152, 26, 149, 234,
  11, 88, 114, 214, 97, 147, 86, 179, 193, 49, 157, 31, 172, 183, 149, 247, 73,
  242, 163, 176, 220, 153, 146, 165, 192, 157, 170, 85, 153, 194, 38, 135, 154,
  178, 99, 172, 121, 24, 180, 107, 51, 113, 131, 172, 68, 65, 194, 98, 9, 170,
  209, 44, 20, 164, 67, 60, 33, 43, 30, 161, 3, 13, 176, 48, 178, 243, 81, 30,
  145, 193, 131, 169, 194, 121, 164, 37, 146, 43, 150, 63, 226, 212, 61, 49,
  217, 137, 76, 108, 76, 204, 116, 84, 186, 226, 83, 70, 112, 137, 3, 120, 185,
  78, 97, 153, 76, 228, 89, 81, 67, 102, 183, 247, 189, 27, 180, 137, 65, 170,
  154, 186, 131, 35, 201, 114, 170, 70, 172, 62, 236, 6, 115, 247, 248, 81, 91,
  251, 52, 0, 105, 8, 71, 184, 48, 195, 107, 106, 48, 92, 84, 162, 215, 124,
  250, 129, 99, 0, 211, 122, 1, 64, 41, 134, 8, 85, 44, 108, 205, 156, 164, 31,
  162, 20, 120, 7, 146, 70, 188, 87, 68, 95, 178, 45, 119, 92, 141, 179, 215,
  138, 81, 218, 171, 60, 208, 169, 168, 140, 78, 215, 36, 176, 247, 131, 113,
  36, 102, 107, 231, 186, 86, 186, 131, 48, 23, 201, 112, 184, 140, 91, 193,
  151, 54, 109, 68, 154, 184, 196, 111, 148, 7, 41, 56, 150, 94, 44, 90, 87,
  101, 144, 74, 220, 135, 181, 107, 211, 78, 137, 136, 139, 24, 2, 133, 216, 33,
  139, 114, 215, 146, 37, 168, 123, 193, 25, 134, 234, 41, 4, 237, 183, 134, 25,
  166, 166, 214, 96, 199, 229, 147, 4, 53, 56, 57, 203, 169, 166, 168, 144, 7,
  131, 68, 126, 252, 210, 127, 233, 246, 16, 206, 177, 133, 7, 60, 189, 14, 163,
  163, 17, 55, 137, 23, 118, 92, 23, 228, 123, 110, 182, 75, 223, 247, 23, 231,
  185, 183, 214, 202, 57, 145, 22, 93, 152, 186, 80, 224, 53, 19, 206, 178, 37,
  26, 37, 6, 97, 50, 72, 238, 194, 145, 172, 137, 85, 41, 232, 181, 207, 88, 35,
  226, 10, 111, 171, 164, 73, 71, 210, 8, 237, 75, 101, 101, 11, 162, 41, 71,
  193, 13, 229, 95, 182, 74, 0, 77, 121, 79, 185, 242, 69, 186, 177, 90, 131,
  18, 3, 126, 4, 174, 97, 176, 53, 24, 43, 206, 8, 244, 97, 85, 103, 59, 226,
  10, 170, 219, 107, 28, 204, 59, 102, 231, 156, 187, 32, 42, 114, 168, 117,
  172, 246, 75, 86, 102, 25, 23, 104, 135, 82, 16, 196, 148, 174, 1, 208, 42,
  24, 79, 207, 187, 34, 150, 92, 4, 184, 103, 48, 13, 148, 156, 185, 75, 35,
  128, 166, 98, 101, 92, 62, 255, 38, 83, 54, 118, 140, 18, 129, 143, 210, 54,
  54, 160, 209, 58, 93, 236, 166, 33, 204, 42, 20, 112, 149, 69, 181, 166, 232,
  113, 88, 135, 184, 72, 74, 193, 159, 220, 201, 140, 102, 170, 89, 155, 23, 22,
  134, 26, 7, 249, 9, 66, 201, 203, 111, 156, 136, 141, 47, 131, 92, 171, 11,
  92, 230, 226, 204, 107, 1, 45, 126, 17, 169, 172, 211, 13, 36, 168, 67, 106,
  97, 128, 119, 105, 164, 206, 142, 115, 52, 244, 188, 130, 210, 179, 88, 52,
  175, 175, 14, 130, 188, 13, 211, 188, 1, 11, 86, 120, 246, 134, 178, 183, 93,
  119, 177, 191, 15,
]);

// a message is a 256-bit number, each as a separate signal
// using 1665 instead of 1 as this is the constant used by Kyber
const m = [
  1665, 1665, 0, 1665, 0, 1665, 1665, 0, 1665, 0, 0, 1665, 1665, 1665, 1665, 0,
  0, 1665, 0, 0, 0, 1665, 1665, 0, 1665, 0, 1665, 0, 0, 1665, 1665, 0, 0, 1665,
  0, 0, 1665, 1665, 1665, 0, 0, 0, 0, 0, 0, 1665, 0, 0, 1665, 0, 0, 1665, 0,
  1665, 1665, 0, 1665, 1665, 0, 0, 1665, 1665, 1665, 0, 0, 0, 0, 0, 0, 1665, 0,
  0, 1665, 1665, 0, 0, 0, 1665, 1665, 0, 1665, 1665, 1665, 1665, 0, 1665, 1665,
  0, 1665, 1665, 1665, 1665, 0, 1665, 1665, 0, 0, 0, 1665, 1665, 0, 1665, 1665,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
];

// dummy randomness. keep this as is so that the circuit will generate the same
// ciphertext as the one listed below. it's used as a tool to find the index of the
// ciphertext in the witness array. For real world usage, this should be replaced with
// a random number generated by a proper random number generator.
const randomness = [
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
];

// this is the encrypted result from the message above, using the dummy randomness
// and the built-in Kyber public key inside the circuit (lib/kyber/kyber.circom)
const hack = [
  153, 180, 68, 235, 189, 233, 191, 4, 236, 89, 22, 35, 178, 239, 102, 163, 71,
  123, 55, 19, 165, 82, 197, 168, 222, 159, 54, 198, 122, 202, 46, 61, 71, 249,
  202, 155, 165, 186, 117, 41, 235, 141, 35, 149, 53, 129, 42, 95, 212, 128,
  192, 80, 112, 120, 127, 192, 205, 189, 251, 33, 173, 173, 209, 111, 0, 208,
  195, 74, 118, 98, 48, 178, 40, 203, 127, 185, 133, 93, 106, 112, 154, 50, 56,
  184, 51, 20, 48, 2, 153, 106, 230, 56, 31, 252, 43, 23, 133, 140, 101, 183,
  92, 250, 234, 28, 192, 208, 54, 250, 254, 120, 214, 74, 140, 53, 236, 105, 36,
  182, 61, 100, 161, 226, 69, 83, 148, 134, 252, 102, 226, 97, 203, 135, 10,
  211, 251, 52, 154, 236, 218, 31, 236, 237, 252, 36, 25, 28, 150, 249, 52, 121,
  152, 78, 9, 180, 23, 211, 126, 133, 153, 69, 197, 208, 190, 241, 118, 207,
  183, 27, 127, 51, 78, 77, 203, 153, 57, 21, 165, 163, 218, 41, 72, 219, 42,
  130, 246, 112, 178, 196, 125, 46, 249, 103, 12, 28, 209, 111, 134, 22, 178,
  180, 248, 88, 239, 238, 183, 191, 191, 235, 219, 239, 102, 91, 90, 37, 218,
  170, 234, 76, 91, 208, 38, 23, 74, 215, 14, 49, 149, 60, 145, 150, 3, 11, 251,
  182, 73, 231, 14, 95, 217, 195, 182, 171, 2, 171, 19, 234, 75, 157, 205, 141,
  181, 171, 227, 213, 212, 44, 159, 98, 183, 226, 99, 144, 219, 130, 92, 110,
  65, 184, 4, 2, 228, 3, 159, 193, 180, 197, 79, 248, 55, 139, 73, 238, 189, 48,
  102, 251, 155, 199, 19, 14, 205, 136, 186, 253, 214, 230, 253, 171, 217, 157,
  23, 191, 73, 242, 132, 144, 134, 38, 255, 202, 79, 191, 124, 17, 103, 7, 55,
  166, 5, 16, 82, 103, 169, 250, 141, 231, 235, 218, 185, 26, 125, 37, 95, 68,
  72, 248, 78, 214, 49, 88, 204, 17, 106, 221, 149, 143, 225, 254, 230, 120, 5,
  166, 34, 200, 9, 60, 204, 9, 72, 205, 85, 231, 104, 186, 17, 172, 183, 67,
  222, 23, 184, 112, 235, 253, 54, 150, 70, 42, 73, 68, 233, 174, 108, 200, 42,
  240, 108, 88, 54, 31, 217, 176, 29, 139, 231, 201, 132, 118, 104, 205, 47,
  226, 184, 119, 199, 152, 49, 164, 123, 255, 16, 176, 83, 10, 140, 215, 228,
  222, 202, 64, 88, 213, 123, 106, 246, 53, 208, 42, 2, 43, 80, 203, 8, 155, 12,
  216, 15, 221, 82, 20, 137, 22, 99, 66, 254, 146, 238, 82, 139, 25, 202, 33,
  89, 156, 30, 48, 226, 103, 130, 148, 197, 126, 23, 131, 211, 75, 155, 62, 231,
  73, 32, 151, 196, 231, 226, 0, 249, 180, 140, 111, 18, 4, 60, 240, 76, 199,
  81, 248, 84, 10, 117, 15, 191, 189, 209, 163, 146, 37, 185, 128, 54, 214, 175,
  96, 215, 150, 138, 140, 228, 102, 60, 133, 11, 185, 130, 110, 160, 121, 197,
  129, 57, 150, 43, 222, 191, 64, 80, 107, 122, 33, 132, 67, 85, 141, 97, 124,
  82, 173, 216, 224, 102, 220, 210, 24, 51, 192, 167, 135, 19, 212, 218, 170,
  74, 105, 104, 58, 237, 203, 181, 197, 77, 23, 92, 210, 143, 195, 129, 37, 205,
  61, 98, 61, 112, 36, 245, 192, 225, 83, 81, 159, 134, 235, 86, 221, 172, 191,
  213, 5, 131, 183, 118, 196, 78, 206, 255, 9, 32, 58, 10, 189, 63, 95, 45, 85,
  106, 74, 115, 51, 112, 123, 59, 45, 148, 13, 237, 84, 223, 249, 210, 176, 16,
  228, 207, 248, 180, 91, 210, 71, 150, 167, 205, 123, 140, 39, 66, 3, 110, 249,
  38, 86, 41, 181, 163, 96, 211, 181, 98, 58, 133, 136, 250, 23, 117, 4, 207,
  219, 168, 118, 85, 200, 123, 30, 143, 56, 117, 197, 242, 205, 130, 45, 200,
  77, 51, 56, 31, 41, 151, 118, 118, 162, 204, 65, 112, 243, 109, 142, 224, 81,
  250, 103, 25, 91, 9, 189, 105, 23, 75, 95, 167, 149, 49, 103, 76, 105, 74, 67,
  75, 3, 43, 103, 30, 157, 71, 34, 103, 136, 198, 229, 206, 182, 11, 255, 246,
  247, 16, 221, 142, 40, 137, 89, 63, 23, 151, 111, 31, 74, 70, 38, 210, 240,
  18, 209, 62, 111, 84, 203, 151, 195, 212, 18, 203, 83, 2, 98, 120, 73, 251, 3,
  220, 241, 162, 8, 76, 55, 163, 201, 118, 42,
];

describe("main circuit tests for Zeto fungible tokens with anonymity using nullifiers and Kyber encryption for auditability", () => {
  let circuit, smtAlice, smtBob;

  const Alice = {};
  const Bob = {};
  let senderPrivateKey;

  before(async function () {
    this.timeout(120000);

    circuit = await wasm_tester(
      join(__dirname, "../../circuits/anon_nullifier_qurrency_transfer.circom"),
    );

    let keypair = genKeypair();
    Alice.privKey = keypair.privKey;
    Alice.pubKey = keypair.pubKey;
    senderPrivateKey = formatPrivKeyForBabyJub(Alice.privKey);

    keypair = genKeypair();
    Bob.privKey = keypair.privKey;
    Bob.pubKey = keypair.pubKey;

    // initialize the local storage for Alice to manage her UTXOs in the Spart Merkle Tree
    const storage1 = new InMemoryDB(str2Bytes(""));
    smtAlice = new Merkletree(storage1, true, SMT_HEIGHT);

    // initialize the local storage for Bob to manage his UTXOs in the Spart Merkle Tree
    const storage2 = new InMemoryDB(str2Bytes(""));
    smtBob = new Merkletree(storage2, true, SMT_HEIGHT);
  });

  it("should succeed for valid witness - input size = 2", async function () {
    this.timeout(120000);

    const inputValues = [32, 40];
    const outputValues = [20, 52];

    // create two input UTXOs, each has their own salt, but same owner
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
    const inputSalts = [salt1, salt2];

    // create the nullifiers for the inputs
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
    const salt4 = newSalt();
    const output2 = poseidonHash([
      BigInt(outputValues[1]),
      salt4,
      ...Alice.pubKey,
    ]);
    const outputCommitments = [output1, output2];
    const outputSalts = [salt3, salt4];
    const enabled = [1, 1];

    const witness = await circuit.calculateWitness(
      {
        nullifiers,
        inputCommitments,
        inputValues,
        inputSalts: inputSalts,
        inputOwnerPrivateKey: senderPrivateKey,
        root: proof1.root.bigInt(),
        merkleProof: [
          proof1.siblings.map((s) => s.bigInt()),
          proof2.siblings.map((s) => s.bigInt()),
        ],
        enabled,
        outputCommitments,
        outputValues,
        outputSalts: outputSalts,
        outputOwnerPublicKeys: [Bob.pubKey, Alice.pubKey],
        randomness,
        m,
      },
      true,
    );

    await circuit.checkConstraints(witness);

    // console.log('witness[1-11]', witness.slice(1, 12));
    // console.log('witness[12-75]', witness.slice(12, 76));
    // console.log('witness[76-139]', witness.slice(76, 140));
    // console.log('witness[140-200]', witness.slice(140, 201));
    // console.log('nullifiers', nullifiers);
    // console.log('inputCommitments', inputCommitments);
    // console.log('inputValues', inputValues);
    // console.log('root', proof1.root.bigInt());
    // console.log('inputSalts', [salt1, salt2]);
    // console.log('inputOwnerPrivateKey', senderPrivateKey);
    // console.log('inputOwnerPublicKey', Alice.pubKey);
    // console.log('outputCommitments', outputCommitments);
    // console.log('outputValues', outputValues);
    // console.log('outputSalts', [salt3, salt4]);
    // console.log('outputOwnerPublicKeys', [Bob.pubKey, Alice.pubKey]);

    //////
    // the pre-defined ciphertext is used to find the intermediate witness signals
    // for the cipher texts. run the following once whenever the circuit changes
    //////
    // const bits = hack.map((x) => BigInt(x));
    // for (let i = 0; i < witness.length; i++) {
    //   if (witness[i] === bits[0] && witness[i + 1] === bits[1] && witness[i + 2] === bits[2]) {
    //     console.log(`ciphertext starts at index ${i}: ${witness.slice(i, i + 768)}`);
    //     break;
    //   }
    // }
    ////// end of logic to locate ciphertext witness index

    // the index of the ciphertext in the witness array is dependent on the circuit.
    // every time the circuit changes, this index must be re-discovered using the code
    // snippet above.
    const CT_INDEX = 100975;
    const cipherTexts = witness.slice(CT_INDEX, CT_INDEX + 768);
    const computed_pubSignals = hashCiphertext(cipherTexts);

    expect(witness[1]).to.equal(computed_pubSignals[0]);
    expect(witness[2]).to.equal(computed_pubSignals[1]);

    // const expectedCiphertext = kpke._encap(
    //   new Uint8Array(pk),
    //   bitsToBytes(m.map((x) => Math.floor(x / 1665))),
    //   bitsToBytes(randomness),
    // );
    // console.log(expectedCiphertext);
    // const expectedPubSignals = hashCiphertext(expectedCiphertext);
    // console.log(expectedPubSignals);

    // expect(expectedPubSignals[0]).to.equal(computed_pubSignals[0]);
    // expect(expectedPubSignals[1]).to.equal(computed_pubSignals[1]);
  });
});

describe("batch circuit tests for Zeto fungible tokens with anonymity using nullifiers and Kyber encryption for auditability", () => {
  let circuit, smtAlice, smtBob;

  const Alice = {};
  const Bob = {};
  let senderPrivateKey;

  before(async function () {
    this.timeout(120000);

    circuit = await wasm_tester(
      join(
        __dirname,
        "../../circuits/anon_nullifier_qurrency_transfer_batch.circom",
      ),
    );

    let keypair = genKeypair();
    Alice.privKey = keypair.privKey;
    Alice.pubKey = keypair.pubKey;
    senderPrivateKey = formatPrivKeyForBabyJub(Alice.privKey);

    keypair = genKeypair();
    Bob.privKey = keypair.privKey;
    Bob.pubKey = keypair.pubKey;

    // initialize the local storage for Alice to manage her UTXOs in the Spart Merkle Tree
    const storage1 = new InMemoryDB(str2Bytes(""));
    smtAlice = new Merkletree(storage1, true, SMT_HEIGHT);

    // initialize the local storage for Bob to manage his UTXOs in the Spart Merkle Tree
    const storage2 = new InMemoryDB(str2Bytes(""));
    smtBob = new Merkletree(storage2, true, SMT_HEIGHT);
  });

  it("should succeed for valid witness - input size = 10", async function () {
    this.timeout(120000);

    const inputValues = [32, 40, 0, 0, 0, 0, 0, 0, 0, 0];
    const outputValues = [20, 52, 0, 0, 0, 0, 0, 0, 0, 0];

    // create two input UTXOs, each has their own salt, but same owner
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
    const inputCommitments = [input1, input2, 0, 0, 0, 0, 0, 0, 0, 0];
    const inputSalts = [salt1, salt2, 0, 0, 0, 0, 0, 0, 0, 0];

    // create the nullifiers for the inputs
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
    const nullifiers = [nullifier1, nullifier2, 0, 0, 0, 0, 0, 0, 0, 0];

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
    const salt4 = newSalt();
    const output2 = poseidonHash([
      BigInt(outputValues[1]),
      salt4,
      ...Alice.pubKey,
    ]);
    const outputCommitments = [output1, output2, 0, 0, 0, 0, 0, 0, 0, 0];
    const outputSalts = [salt3, salt4, 0, 0, 0, 0, 0, 0, 0, 0];
    const enabled = [1, 1, 0, 0, 0, 0, 0, 0, 0, 0];

    const mp1 = proof1.siblings.map((s) => s.bigInt());
    const mp2 = proof2.siblings.map((s) => s.bigInt());
    const witness = await circuit.calculateWitness(
      {
        nullifiers,
        inputCommitments,
        inputValues,
        inputSalts: inputSalts,
        inputOwnerPrivateKey: senderPrivateKey,
        root: proof1.root.bigInt(),
        merkleProof: [mp1, mp2, mp2, mp2, mp2, mp2, mp2, mp2, mp2, mp2],
        enabled,
        outputCommitments,
        outputValues,
        outputSalts: outputSalts,
        outputOwnerPublicKeys: [
          Bob.pubKey,
          Alice.pubKey,
          Alice.pubKey,
          Alice.pubKey,
          Alice.pubKey,
          Alice.pubKey,
          Alice.pubKey,
          Alice.pubKey,
          Alice.pubKey,
          Alice.pubKey,
        ],
        randomness,
        m,
      },
      true,
    );

    await circuit.checkConstraints(witness);

    //////
    // the pre-defined ciphertext is used to find the intermediate witness signals
    // for the cipher texts. run the following once whenever the circuit changes
    //////
    // const bits = hack.map((x) => BigInt(x));
    // for (let i = 0; i < witness.length; i++) {
    //   if (witness[i] === bits[0] && witness[i + 1] === bits[1] && witness[i + 2] === bits[2]) {
    //     console.log(`ciphertext starts at index ${i}: ${witness.slice(i, i + 768)}`);
    //     break;
    //   }
    // }
    ////// end of logic to locate ciphertext witness index

    const CT_INDEX = 410535;
    const cipherTexts = witness.slice(CT_INDEX, CT_INDEX + 768);
    const computed_pubSignals = hashCiphertext(cipherTexts);

    expect(witness[1]).to.equal(computed_pubSignals[0]);
    expect(witness[2]).to.equal(computed_pubSignals[1]);
    expect(witness[3]).to.equal(BigInt(nullifiers[0]));
    expect(witness[4]).to.equal(BigInt(nullifiers[1]));
  });
});
