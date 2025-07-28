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

import {IZeto} from "./lib/interfaces/izeto.sol";
import {ZetoNonFungibleBase} from "./lib/zeto_non_fungible_base.sol";
import {Commonlib} from "./lib/common/common.sol";
import {IZetoInitializable} from "./lib/interfaces/izeto_initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/// @title A sample implementation of a Zeto based non-fungible token with anonymity and no encryption
/// @author Kaleido, Inc.
/// @dev The proof has the following statements:
///        - The sender owns the private key whose public key is part of the pre-image of the input UTXOs commitments
///          (aka the sender is authorized to spend the input UTXOs)
///        - The input UTXOs and output UTXOs are valid in terms of obeying mass conservation rules
contract Zeto_NfAnon is ZetoNonFungibleBase, UUPSUpgradeable {
    function initialize(
        string calldata name,
        string calldata symbol,
        address initialOwner,
        IZetoInitializable.VerifiersInfo calldata verifiers
    ) public initializer {
        __ZetoNonFungibleBase_init(name, symbol, initialOwner, verifiers);
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function constructPublicInputs(
        uint256[] memory inputs,
        uint256[] memory outputs,
        bytes memory proof,
        bool inputsLocked
    )
        internal
        view
        override
        returns (uint256[] memory, Commonlib.Proof memory)
    {
        // construct the public inputs
        Commonlib.Proof memory proofStruct = abi.decode(
            proof,
            (Commonlib.Proof)
        );
        uint256[] memory publicInputs = new uint256[](2);
        publicInputs[0] = inputs[0];
        publicInputs[1] = outputs[0];

        return (publicInputs, proofStruct);
    }

    function constructPublicInputsForLock(
        uint256[] memory inputs,
        uint256[] memory outputs,
        uint256[] memory lockedOutputs,
        bytes memory proof
    )
        internal
        view
        override
        returns (uint256[] memory, Commonlib.Proof memory)
    {
        // construct the public inputs
        Commonlib.Proof memory proofStruct = abi.decode(
            proof,
            (Commonlib.Proof)
        );
        uint256[] memory publicInputs = new uint256[](2);
        publicInputs[0] = inputs[0];
        publicInputs[1] = lockedOutputs[0];

        return (publicInputs, proofStruct);
    }
}
