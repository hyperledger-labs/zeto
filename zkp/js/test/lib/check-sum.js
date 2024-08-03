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
const { readFileSync } = require('fs');
const path = require('path');

describe('check-sum circuit tests', () => {
  let circuit;
  const sender = {};
  const receiver = {};
  before(async () => {
    circuit = await loadCircuits();
  });

  it('should return true for valid witness', async () => {
    const inputValues = [32, 40];
    const outputValues = [20, 52];

    const witness = await circuit.calculateWitness(
      {
        inputValues,
        outputValues,
      },
      true
    );
    // console.log(witness.slice(0, 5));
  });

  it('should fail if sums are not equal', async () => {
    const inputValues = [32, 40];
    const outputValues = [20, 50];

    let error;
    try {
      const witness = await circuit.calculateWitness(
        {
          inputValues,
          outputValues,
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckSum_0 line: 44/);
  });
});

// the circuit is a library, to test it we need a top-level circuit with "main"
// which is placed in the test/circuits directory
async function loadCircuits() {
  const WitnessCalculator = require('../circuits/check-sum_js/witness_calculator.js');
  const buffer = readFileSync(path.join(__dirname, '../circuits/check-sum_js/check-sum.wasm'));
  const circuit = await WitnessCalculator(buffer);
  return circuit;
}
