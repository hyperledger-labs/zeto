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

const path = require('path');
const { readFileSync } = require('fs');
const Poseidon = require('poseidon-lite');
const { newSalt, poseidonDecrypt, encodeProof, getProofHash, hashTokenUri } = require('./lib/util.js');

async function loadCircuits(type) {
  if (!type) {
    type = '3';
  }
  const WitnessCalculator = require(`./lib/${type}_js/witness_calculator.js`);
  const buffer = readFileSync(path.join(__dirname, `./lib/${type}_js/${type}.wasm`));
  const circuit = await WitnessCalculator(buffer);
  const PROVING_KEYS_ROOT = process.env.PROVING_KEYS_ROOT;
  if (!PROVING_KEYS_ROOT) {
    throw new Error('PROVING_KEYS_ROOT env var is not set');
  }
  const provingKeyFile = path.join(PROVING_KEYS_ROOT, `${type}.zkey`);
  const verificationKey = JSON.parse(new TextDecoder().decode(readFileSync(path.join(PROVING_KEYS_ROOT, `${type}-vkey.json`))));
  return {
    circuit,
    provingKeyFile,
    verificationKey,
  };
}

module.exports = {
  loadCircuits,
  Poseidon,
  newSalt,
  hashTokenUri,
  poseidonDecrypt,
  encodeProof,
  getProofHash,
};
