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

import { ignition, network } from "hardhat";
import { expect } from "chai";
import tendecimalsModule from "../../ignition/modules/test/tendecimals";

describe("Test token implementations with decimals override", function () {
  let tendecimals: any;

  before(async function () {
    if (network.name !== "hardhat") {
      // accommodate for longer block times on public networks
      this.timeout(120000);
    }
    ({ tendecimals } = await ignition.deploy(tendecimalsModule));
    console.log(`TenDecimals test contract deployed at ${tendecimals.target}`);
  });

  it("test prepared inputs", async function () {
    const decimals = await tendecimals.decimals();
    expect(decimals).to.equal(10, "Decimals should be 10");
  });
});
