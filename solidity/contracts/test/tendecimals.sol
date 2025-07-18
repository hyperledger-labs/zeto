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
pragma solidity ^0.8.27;

import {Zeto_Anon} from "../zeto_anon.sol";
import {IZeto} from "../lib/interfaces/izeto.sol";
import {IZetoInitializable} from "../lib/interfaces/izeto_initializable.sol";
import {ZetoCommon} from "../lib/zeto_common.sol";

contract TenDecimals is Zeto_Anon {
    function decimals()
        public
        pure
        override(IZeto, ZetoCommon)
        returns (uint8)
    {
        return 10;
    }

    function initialize(
        string memory name,
        string memory symbol,
        address initialOwner,
        IZetoInitializable.VerifiersInfo calldata verifiersInfo
    ) public override initializer {
        Zeto_Anon.initialize(name, symbol, initialOwner, verifiersInfo);
    }
}
