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

const { genRandomSalt } = require('maci-crypto');
const Poseidon = require('poseidon-lite');
const { solidityPackedKeccak256 } = require('ethers');
const { createHash } = require('crypto');

const F = BigInt('21888242871839275222246405745257275088548364400416034343698204186575808495617');

function newSalt() {
  return genRandomSalt();
}

function poseidonDecrypt(cipherText, sharedSecret, nonce) {
  const plainText = [];
  cipherText.forEach((msg, index) => {
    const hash = Poseidon.poseidon4([sharedSecret[0], sharedSecret[1], BigInt(nonce), BigInt(index)]);
    // subtract the hash from the cipherText to get the plainText
    plainText[index] = addMod([BigInt(msg), -hash], F);
    while (plainText[index] < 0n) {
      plainText[index] += F;
    }
  });
  return plainText;
}

function addMod(addMe, m) {
  return addMe.reduce((e, acc) => (((e + m) % m) + acc) % m, BigInt(0));
}

// convert the proof json to the format that the Solidity verifier expects
function encodeProof(proofJson) {
  const proof = {
    pA: [proofJson.pi_a[0], proofJson.pi_a[1]],
    pB: [
      [proofJson.pi_b[0][1], proofJson.pi_b[0][0]],
      [proofJson.pi_b[1][1], proofJson.pi_b[1][0]],
    ],
    pC: [proofJson.pi_c[0], proofJson.pi_c[1]],
  };
  return proof;
}

function getProofHash(encodedProof) {
  const flat = [
    BigInt(encodedProof.pA[0]),
    BigInt(encodedProof.pA[1]),
    BigInt(encodedProof.pB[0][0]),
    BigInt(encodedProof.pB[0][1]),
    BigInt(encodedProof.pB[1][0]),
    BigInt(encodedProof.pB[1][1]),
    BigInt(encodedProof.pC[0]),
    BigInt(encodedProof.pC[1]),
  ];
  const hash = solidityPackedKeccak256(['uint[8]'], [flat]);
  return hash;
}

function tokenUriHash(tokenUri) {
  const hash = createHash('sha256').update(tokenUri).digest('hex');
  // to fit the result within the range of the Finite Field used in the poseidon hash,
  // use 253 bit long numbers. we need to remove the most significant three bits.
  return BigInt.asUintN(253, '0x' + hash);
}

function kycHash(bjjPublicKey) {
  const hash = Poseidon.poseidon2(bjjPublicKey);
  return hash;
}

module.exports = {
  newSalt,
  poseidonDecrypt,
  encodeProof,
  getProofHash,
  tokenUriHash,
  kycHash,
};
