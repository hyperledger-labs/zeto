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
pragma solidity ^0.8.27;

import {Zeto_AnonNullifier} from "./zeto_anon_nullifier.sol";
import {Registry} from "./lib/registry.sol";
import {Commonlib} from "./lib/common/common.sol";
import {IZetoInitializable} from "./lib/interfaces/izeto_initializable.sol";
import {console} from "hardhat/console.sol";

/// @title A sample implementation of a Zeto based fungible token with anonymity, history masking and KYC
/// @author Kaleido, Inc.
/// @dev The proof has the following statements:
///        - each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
///        - the sum of the nullified values match the sum of output values
///        - the hashes in the input and output match the hash(value, salt, owner public key) formula
///        - the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes, which match the corresponding nullifiers
///        - the nullifiers represent input commitments that are included in a Sparse Merkle Tree represented by the root hash
contract Zeto_AnonNullifierKyc is Zeto_AnonNullifier, Registry {
    function initialize(
        string calldata name,
        string calldata symbol,
        address initialOwner,
        IZetoInitializable.VerifiersInfo calldata verifiers
    ) public override initializer {
        __Registry_init();
        __ZetoAnonNullifier_init(name, symbol, initialOwner, verifiers);
    }

    function extraInputs() internal view override returns (uint256[] memory) {
        uint256[] memory extras = new uint256[](1);

        extras[0] = getIdentitiesRoot();
        return extras;
    }

    function extraInputsForDeposit()
        internal
        view
        override
        returns (uint256[] memory)
    {
        uint256[] memory extras = new uint256[](1);

        extras[0] = getIdentitiesRoot();
        return extras;
    }
}
