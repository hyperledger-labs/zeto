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

import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";
import {IZetoFungibleInitializable} from "./lib/interfaces/zeto_fungible_initializable.sol";
import {IZetoNonFungibleInitializable} from "./lib/interfaces/zeto_nf_initializable.sol";

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
        address initialOwner,
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
            initialOwner,
            _depositVerifier,
            _withdrawVerifier,
            _verifier
        );
        emit ZetoTokenDeployed(instance);
        return instance;
    }

    function deployZetoNonFungibleToken(
        string memory name,
        address initialOwner,
        address _verifier
    ) public returns (address) {
        address instance = Clones.clone(implementations[name]);
        require(
            instance != address(0),
            "Factory: failed to find implementation"
        );
        (IZetoNonFungibleInitializable(instance)).initialize(
            initialOwner,
            _verifier
        );
        emit ZetoTokenDeployed(instance);
        return instance;
    }
}
