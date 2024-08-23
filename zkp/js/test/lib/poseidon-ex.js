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

const { expect } = require('chai');
const { join } = require('path');
const { wasm: wasm_tester } = require('circom_tester');
const { poseidon4 } = require('poseidon-lite');

describe('PoseidonEx circuit tests', () => {
  let circuit;
  before(async function () {
    this.timeout(60000);
    circuit = await wasm_tester(join(__dirname, '../circuits/poseidon-ex.circom'));
  });

  it('should generate the states matching JS lib', async () => {
    const inputs = [1234567890, 2345678901, 3456789012, 4567890123];
    const witness = await circuit.calculateWitness({ inputs });

    const state = inputs;
    const result = poseidon4(state, 4);
    expect(witness.slice(1, 5)).deep.equals(result);
  });
});
