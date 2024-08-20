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
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {IZetoFungible} from "./lib/interfaces/zeto_fungible.sol";
import {IZetoFungibleInitializable} from "./lib/interfaces/zeto_fungible_initializable.sol";
import {IZetoNonFungibleInitializable} from "./lib/interfaces/zeto_nf_initializable.sol";
import {SampleERC20} from "./erc20.sol";

contract ZetoTokenFactory {
    event ZetoTokenDeployed(address indexed zetoToken);

    mapping(string => address) internal implementations;

    constructor() {}

    function registerImplementation(
        string memory name,
        address implementation
    ) public {
        implementations[name] = implementation;
    }

    function deployZetoFungibleToken(
        string memory name,
        address authority,
        address _depositVerifier,
        address _withdrawVerifier,
        address _verifier
    ) public returns (address) {
        address instance = Clones.clone(implementations[name]);
        require(
            instance != address(0),
            "Factory: failed to find implementation"
        );
        (IZetoFungibleInitializable(instance)).initialize(
            authority,
            _depositVerifier,
            _withdrawVerifier,
            _verifier
        );
        emit ZetoTokenDeployed(instance);
        return instance;
    }

    function deployZetoNonFungibleToken(
        string memory name,
        address authority,
        address _verifier
    ) public returns (address) {
        address instance = Clones.clone(implementations[name]);
        require(
            instance != address(0),
            "Factory: failed to find implementation"
        );
        (IZetoNonFungibleInitializable(instance)).initialize(
            authority,
            _verifier
        );
        emit ZetoTokenDeployed(instance);
        return instance;
    }
}
