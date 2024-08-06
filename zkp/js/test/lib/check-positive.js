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

const MAX_VALUE = 2n ** 40n - 1n;

describe('check-positive circuit tests', () => {
  let circuit;

  before(async function () {
    this.timeout(60000);

    circuit = await wasm_tester(join(__dirname, '../circuits/check-positive.circom'));
  });

  it('should succeed to generate a witness using the MAX_VALUE for output', async () => {
    const outputValues = [MAX_VALUE, 100];

    let error;
    try {
      await circuit.calculateWitness(
        {
          outputValues,
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.be.undefined;
  });

  it('should fail to generate a witness because of negative values in output commitments', async () => {
    // in the finite field used in the Poseidion hash implementation, -100n is equivalent to
    // 21888242871839275222246405745257275088548364400416034343698204186575808495517n
    const outputValues = [-100, 225];

    let error;
    try {
      await circuit.calculateWitness(
        {
          outputValues,
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckPositive_3 line: 39/); // positive range check failed
  });

  it('should fail to generate a witness because of using the inverse of a negative value in output commitments', async () => {
    // in the finite field used in the Poseidion hash implementation, -100n is equivalent to
    // 21888242871839275222246405745257275088548364400416034343698204186575808495517n. This number
    // is considered negative by the circuit, because we allow the range of 0 to (2**40 - 1)
    const outputValues = [21888242871839275222246405745257275088548364400416034343698204186575808495518n, 225];

    let error;
    try {
      await circuit.calculateWitness(
        {
          outputValues,
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckPositive_3 line: 39/); // positive range check failed
  });

  it('should fail to generate a witness because a larger than MAX_VALUE is used in output', async () => {
    const outputValues = [MAX_VALUE + 1n, 99];

    let error;
    try {
      await circuit.calculateWitness(
        {
          outputValues,
        },
        true
      );
    } catch (e) {
      error = e;
    }
    // console.log(error);
    expect(error).to.match(/Error in template CheckPositive_3 line: 39/); // positive range check failed
  });
});
