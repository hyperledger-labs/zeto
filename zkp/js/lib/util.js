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
const { buildPoseidon } = require('circomlibjs');
const { solidityPackedKeccak256 } = require('ethers');
const { createHash } = require('crypto');

function newSalt() {
  return genRandomSalt();
}

// Implements the encryption and decryption functions using Poseidon hash
// as described: https://drive.google.com/file/d/1EVrP3DzoGbmzkRmYnyEDcIQcXVU7GlOd/view
// The encryption and decryption functions are compatible with the circom implementations,
// meaning the cipher texts encrypted by the circuit in circuits/lib/encrypt.circom can
// be decrypted by the poseidonDecrypt function. And vice versa.
class PoseidonCipher {
  constructor() {}

  async init() {
    this.poseidon = await buildPoseidon();
    this.Fr = this.poseidon.F;
    this.two128 = this.Fr.e(BigInt('340282366920938463463374607431768211456'));
  }

  async encrypt(msg, key, nonce) {
    validateInputs(msg, key, nonce);

    const Fr = this.Fr;
    msg = msg.map((x) => Fr.e(x));

    // the size of the message array must be a multiple of 3
    const message = [...msg];
    while (message.length % 3 > 0) {
      // pad with zeros if necessary
      message.push(Fr.zero);
    }

    // Create the initial state
    // S = (0, kS[0], kS[1], N + l * 2^128)
    let state = [Fr.zero, Fr.e(key[0]), Fr.e(key[1]), Fr.add(Fr.e(BigInt(nonce)), Fr.mul(Fr.e(BigInt(msg.length)), this.two128))];

    const ciphertext = [];

    const n = Math.floor(message.length / 3);
    for (let i = 0; i < n; i += 1) {
      // Iterate Poseidon on the state
      state = this.poseidon(state, 0, 4);

      // Modify the state for the next round
      state[1] = Fr.add(message[i * 3], state[1]);
      state[2] = Fr.add(message[i * 3 + 1], state[2]);
      state[3] = Fr.add(message[i * 3 + 2], state[3]);

      // Record the three elements of the encrypted message
      ciphertext.push(state[1]);
      ciphertext.push(state[2]);
      ciphertext.push(state[3]);
    }

    // Iterate Poseidon on the state one last time
    state = this.poseidon(state, 0, 4);

    // Record the last ciphertext element
    ciphertext.push(Fr.add(Fr.zero, state[1]));

    return ciphertext.map((t) => Fr.toObject(t));
  }

  async decrypt(ciphertext, key, nonce, length) {
    validateInputs(ciphertext, key, nonce, length);

    const Fr = this.Fr;

    // Create the initial state
    // S = (0, kS[0], kS[1], N + l ∗ 2^128).
    let state = [Fr.zero, Fr.e(key[0]), Fr.e(key[1]), Fr.add(Fr.e(BigInt(nonce)), Fr.mul(Fr.e(BigInt(length)), this.two128))];

    const message = [];

    const n = Math.floor(ciphertext.length / 3);
    for (let i = 0; i < n; i += 1) {
      // Iterate Poseidon on the state
      state = this.poseidon(state, 0, 4);

      // Release three elements of the decrypted message
      message.push(Fr.sub(Fr.e(ciphertext[i * 3]), state[1]));
      message.push(Fr.sub(Fr.e(ciphertext[i * 3 + 1]), state[2]));
      message.push(Fr.sub(Fr.e(ciphertext[i * 3 + 2]), state[3]));

      // Modify the state for the next round
      state[1] = ciphertext[i * 3];
      state[2] = ciphertext[i * 3 + 1];
      state[3] = ciphertext[i * 3 + 2];
    }

    // If length > 3, check if the last (3 - (l mod 3)) elements of the message are 0
    if (length > 3) {
      if (length % 3 === 2) {
        this.checkEqual(message[message.length - 1], Fr.zero, 'The last element of the message must be 0');
      } else if (length % 3 === 1) {
        this.checkEqual(message[message.length - 1], Fr.zero, 'The last element of the message must be 0');
        this.checkEqual(message[message.length - 2], Fr.zero, 'The second to last element of the message must be 0');
      }
    }

    // Iterate Poseidon on the state one last time
    state = this.poseidon(state, 0, 4);

    // Check the last ciphertext element
    this.checkEqual(Fr.e(ciphertext[ciphertext.length - 1]), Fr.e(state[1]), 'The last ciphertext element must match the second item of the permuted state');

    return message.slice(0, length).map((t) => Fr.toObject(t));
  }

  checkEqual(a, b, error) {
    if (!this.Fr.eq(a, b)) {
      throw new Error(error);
    }
  }
}

function validateInputs(msg, key, nonce, length) {
  if (!Array.isArray(msg)) {
    throw new Error('The message must be an array');
  }
  for (let i = 0; i < msg.length; i += 1) {
    if (typeof msg[i] !== 'bigint') {
      throw new Error('Each message element must be a BigInt');
    }
  }
  if (key.length !== 2) {
    throw new Error('The key must be an array of two elements');
  }
  if (typeof key[0] !== 'bigint' || typeof key[1] !== 'bigint') {
    throw new Error('The key must be an array of two BigInts');
  }
  if (typeof nonce !== 'bigint') {
    throw new Error('The nonce must be a BigInt');
  }
  if (length && length < 1) {
    throw new Error('The length must be at least 1');
  }
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
  PoseidonCipher,
  encodeProof,
  getProofHash,
  tokenUriHash,
  kycHash,
};
