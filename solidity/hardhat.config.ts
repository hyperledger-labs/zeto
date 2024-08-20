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

import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@openzeppelin/hardhat-upgrades";

const config: HardhatUserConfig = {
  solidity: "0.8.20",
  paths: {
    sources: "contracts"
  },
  networks: {
    besu: {
      url: "http://localhost:8545",
      accounts: [
        "7bc522e9ba27f118ad4157771bec290f59ffffe45ee66bb81f137043150bd001",
        "7bc522e9ba27f118ad4157771bec290f59ffffe45ee66bb81f137043150bd002",
        "7bc522e9ba27f118ad4157771bec290f59ffffe45ee66bb81f137043150bd003",
        "7bc522e9ba27f118ad4157771bec290f59ffffe45ee66bb81f137043150bd004",
        "7bc522e9ba27f118ad4157771bec290f59ffffe45ee66bb81f137043150bd005",
      ],
      gasPrice: 0,
    }
  }
};

export default config;
