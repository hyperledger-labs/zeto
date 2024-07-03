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

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title A sample on-chain implementation of an account mapping between Ethereum addresses and BabyJubjub public keys
/// @author Kaleido, Inc.
contract Registry is Ownable {
    mapping(address => uint256[2]) private publicKeys;

    error AlreadyRegistered(address addr);

    constructor() Ownable(msg.sender) {}

    /// @dev Register a new public key for the calling Ethereum address
    /// @param ethAddress The Ethereum address to register
    /// @param publicKey The public Babyjubjub key to register
    function register(
        address ethAddress,
        uint256[2] memory publicKey
    ) public onlyOwner {
        if (publicKeys[ethAddress][0] != 0 || publicKeys[ethAddress][1] != 0) {
            revert AlreadyRegistered(ethAddress);
        }
        publicKeys[ethAddress] = publicKey;
    }

    /// @dev Query the public key for a given Ethereum address
    /// @param addr The Ethereum address to query
    /// @return publicKey The public key for the given address
    function getPublicKey(
        address addr
    ) public view returns (uint256[2] memory publicKey) {
        return publicKeys[addr];
    }
}
