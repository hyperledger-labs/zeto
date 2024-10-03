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
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IZetoFungibleInitializable} from "./lib/interfaces/zeto_fungible_initializable.sol";
import {IZetoNonFungibleInitializable} from "./lib/interfaces/zeto_nf_initializable.sol";

contract ZetoTokenFactory is Ownable {
    // all the addresses needed by the factory to
    // clone a Zeto token and initialize it. The
    // "implementation" is used to clone the token,
    // the rest of the addresses are used to initialize
    struct ImplementationInfo {
        address implementation;
        address depositVerifier;
        address withdrawVerifier;
        address verifier;
        address batchVerifier;
        address batchWithdrawVerifier;
    }

    event ZetoTokenDeployed(address indexed zetoToken);

    mapping(string => ImplementationInfo) internal implementations;

    constructor() Ownable(msg.sender) {}

    function registerImplementation(
        string memory name,
        ImplementationInfo memory implementation
    ) public onlyOwner {
        require(
            implementation.implementation != address(0),
            "Factory: implementation address is required"
        );
        require(
            implementation.verifier != address(0),
            "Factory: verifier address is required"
        );
        // the depositVerifier and withdrawVerifier are optional
        // for the non-fungible token implementations
        implementations[name] = implementation;
    }

    function deployZetoFungibleToken(
        string memory name,
        address initialOwner
    ) public returns (address) {
        ImplementationInfo memory args = implementations[name];
        require(
            args.implementation != address(0),
            "Factory: failed to find implementation"
        );
        // check that the registered implementation is for a fungible token
        // and has the required verifier addresses
        require(
            args.depositVerifier != address(0),
            "Factory: depositVerifier address is required"
        );
        require(
            args.withdrawVerifier != address(0),
            "Factory: withdrawVerifier address is required"
        );
        require(
            args.batchVerifier != address(0),
            "Factory: batchVerifier address is required"
        );
        require(
            args.batchWithdrawVerifier != address(0),
            "Factory: batchWithdrawVerifier address is required"
        );
        address instance = Clones.clone(args.implementation);
        require(
            instance != address(0),
            "Factory: failed to clone implementation"
        );
        (IZetoFungibleInitializable(instance)).initialize(
            initialOwner,
            args.verifier,
            args.depositVerifier,
            args.withdrawVerifier,
            args.batchVerifier,
            args.batchWithdrawVerifier
        );
        emit ZetoTokenDeployed(instance);
        return instance;
    }

    function deployZetoNonFungibleToken(
        string memory name,
        address initialOwner
    ) public returns (address) {
        ImplementationInfo memory args = implementations[name];
        require(
            args.implementation != address(0),
            "Factory: failed to find implementation"
        );
        address instance = Clones.clone(args.implementation);
        require(
            instance != address(0),
            "Factory: failed to clone implementation"
        );
        (IZetoNonFungibleInitializable(instance)).initialize(
            initialOwner,
            args.verifier
        );
        emit ZetoTokenDeployed(instance);
        return instance;
    }
}
