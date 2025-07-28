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
import {ZetoNonFungibleNullifier} from "./lib/zeto_non_fungible_nullifier.sol";
import {Commonlib} from "./lib/common/common.sol";
import {IZetoInitializable} from "./lib/interfaces/izeto_initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "hardhat/console.sol";

/// @title A sample implementation of a Zeto based non-fungible token with anonymity and history masking
/// @author Kaleido, Inc.
/// @dev The proof has the following statements:
///        - each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
///        - the sum of the nullified values match the sum of output values
///        - the hashes in the input and output match the hash(value, salt, owner public key) formula
///        - the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes, which match the corresponding nullifiers
///        - the nullifiers represent input commitments that are included in a Sparse Merkle Tree represented by the root hash
contract Zeto_NfAnonNullifier is
    IZeto,
    ZetoNonFungibleNullifier,
    UUPSUpgradeable
{
    function initialize(
        string calldata name,
        string calldata symbol,
        address initialOwner,
        IZetoInitializable.VerifiersInfo calldata verifiers
    ) public initializer {
        __ZetoNonFungibleNullifier_init(name, symbol, initialOwner, verifiers);
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function constructPublicInputs(
        uint256[] memory nullifiers,
        uint256[] memory outputs,
        bytes memory proof,
        bool inputsLocked
    )
        internal
        view
        override
        returns (uint256[] memory, Commonlib.Proof memory)
    {
        (uint256 root, Commonlib.Proof memory proofStruct) = abi.decode(
            proof,
            (uint256, Commonlib.Proof)
        );
        // construct the public inputs
        uint size = inputsLocked ? 4 : 3;
        uint256[] memory publicInputs = new uint256[](size);
        uint idx = 0;
        publicInputs[idx++] = nullifiers[0];
        if (inputsLocked) {
            publicInputs[idx++] = uint256(uint160(msg.sender));
        }
        publicInputs[idx++] = root;
        publicInputs[idx++] = outputs[0];
        return (publicInputs, proofStruct);
    }

    function constructPublicInputsForLock(
        uint256[] memory nullifiers,
        uint256[] memory outputs,
        uint256[] memory lockedOutputs,
        bytes memory proof
    )
        internal
        view
        virtual
        override
        returns (uint256[] memory, Commonlib.Proof memory)
    {
        (uint256 root, Commonlib.Proof memory proofStruct) = abi.decode(
            proof,
            (uint256, Commonlib.Proof)
        );
        // construct the public inputs
        uint256[] memory publicInputs = new uint256[](3);
        publicInputs[0] = nullifiers[0];
        publicInputs[1] = root;
        publicInputs[2] = lockedOutputs[0];
        return (publicInputs, proofStruct);
    }

    function validateTransactionProposal(
        uint256[] memory inputs,
        uint256[] memory outputs,
        uint256[] memory lockedOutputs,
        bytes memory proof,
        bool inputsLocked
    ) internal view virtual override {
        super.validateTransactionProposal(
            inputs,
            outputs,
            lockedOutputs,
            proof,
            inputsLocked
        );
        (uint256 root, Commonlib.Proof memory proofStruct) = abi.decode(
            proof,
            (uint256, Commonlib.Proof)
        );
        validateRoot(root, inputsLocked);
    }
}
