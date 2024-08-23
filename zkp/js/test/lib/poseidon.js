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
const { poseidon3 } = require('poseidon-lite');

describe('Poseidon circuit tests', () => {
  let circuit;
  before(async function () {
    this.timeout(60000);
    circuit = await wasm_tester(join(__dirname, '../circuits/poseidon.circom'));
  });

  it('should generate the states matching JS lib', async () => {
    const messages = [1234567890, 2345678901, 3456789012];

    const circuitInputs = {
      a: messages[0],
      b: messages[1],
      c: messages[2],
    };

    const witness = await circuit.calculateWitness(circuitInputs);

    const state = [messages[0], messages[1], messages[2]];
    const result = poseidon3(state);
    expect(witness[1]).equals(result);
  });
});
