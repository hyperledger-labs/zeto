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

describe('check-sum circuit tests', () => {
  let circuit;

  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(join(__dirname, '../circuits/check-sum.circom'));
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
    expect(witness[0]).to.equal(BigInt(1));
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
