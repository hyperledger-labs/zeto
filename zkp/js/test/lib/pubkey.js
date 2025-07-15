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

const { expect } = require("chai");
const { join } = require("path");
const crypto = require("crypto");
const { wasm: wasm_tester } = require("circom_tester");
const { bytesToBits, publicKeyFromSeed } = require("../../lib/util");

describe("PublicKeyFromSeed circuit tests", () => {
  let circuit;
  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(join(__dirname, "../circuits/pubkey.circom"));
  });

  it("should generate a public key", async () => {
    const randomness = crypto.randomBytes(32); // 32 bytes for randomness
    const seed = bytesToBits(randomness);

    const circuitInputs = {
      seed,
    };
    const witness = await circuit.calculateWitness(circuitInputs);
    const pubKey = witness.slice(1, 3);

    const recoveredKey = publicKeyFromSeed(randomness);
    expect(pubKey).to.deep.equal(recoveredKey);
  });
});
