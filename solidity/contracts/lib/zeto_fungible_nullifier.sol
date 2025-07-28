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

import {Commonlib} from "./common/common.sol";
import {IZeto} from "./interfaces/izeto.sol";
import {MAX_SMT_DEPTH} from "./interfaces/izeto.sol";
import {IZetoLockable} from "./interfaces/izeto_lockable.sol";
import {IZetoInitializable} from "./interfaces/izeto_initializable.sol";
import {ZetoFungible} from "./zeto_fungible.sol";
import {SmtLib} from "@iden3/contracts/lib/SmtLib.sol";
import {IZetoStorage} from "./interfaces/izeto_storage.sol";
import {NullifierStorage} from "./storage/nullifier.sol";

/// @title A sample base implementation of a Zeto based token contract with nullifiers
/// @author Kaleido, Inc.
/// @dev Implements common functionalities of Zeto based tokens using nullifiers
abstract contract ZetoFungibleNullifier is ZetoFungible {
    function __ZetoFungibleNullifier_init(
        string calldata name_,
        string calldata symbol_,
        address initialOwner,
        IZetoInitializable.VerifiersInfo calldata verifiers
    ) internal onlyInitializing {
        IZetoStorage storage_ = new NullifierStorage();
        __ZetoFungible_init(name_, symbol_, initialOwner, verifiers, storage_);
    }

    function constructPublicInputsForWithdraw(
        uint256 amount,
        uint256[] memory nullifiers,
        uint256 output,
        bytes memory proof
    ) internal override returns (uint256[] memory, Commonlib.Proof memory) {
        // Decode the proof to extract root and proof structure
        (uint256 root, Commonlib.Proof memory proofStruct) = abi.decode(
            proof,
            (uint256, Commonlib.Proof)
        );

        // Calculate the total size needed for public inputs
        uint256 size = _calculateWithdrawPublicInputsSize(nullifiers);

        // Create and populate the public inputs array
        uint256[] memory publicInputs = new uint256[](size);
        _fillWithdrawPublicInputs(
            publicInputs,
            amount,
            nullifiers,
            root,
            output
        );

        return (publicInputs, proofStruct);
    }

    /**
     * @dev Calculates the total size needed for withdraw public inputs array
     * @param nullifiers Array of nullifiers
     * @return size The total size needed for public inputs
     */
    function _calculateWithdrawPublicInputsSize(
        uint256[] memory nullifiers
    ) internal pure returns (uint256 size) {
        size = (nullifiers.length * 2) + 3; // nullifiers, enabled flags, amount, root, output
    }

    /**
     * @dev Populates the withdraw public inputs array with all required data
     * @param publicInputs The array to populate
     * @param amount The withdrawal amount
     * @param nullifiers Array of nullifiers
     * @param root The merkle root
     * @param output The output commitment
     */
    function _fillWithdrawPublicInputs(
        uint256[] memory publicInputs,
        uint256 amount,
        uint256[] memory nullifiers,
        uint256 root,
        uint256 output
    ) internal pure {
        uint256 piIndex = 0;

        // Copy withdrawal amount
        piIndex = _fillWithdrawAmount(publicInputs, amount, piIndex);

        // Copy nullifiers
        piIndex = _fillWithdrawNullifiers(publicInputs, nullifiers, piIndex);

        // Copy root
        piIndex = _fillWithdrawRoot(publicInputs, root, piIndex);

        // Populate enabled flags
        piIndex = _fillWithdrawEnabledFlags(publicInputs, nullifiers, piIndex);

        // Copy output commitment
        _fillWithdrawOutput(publicInputs, output, piIndex);
    }

    /**
     * @dev Copies the withdrawal amount to the public inputs array
     * @param publicInputs The array to populate
     * @param amount The withdrawal amount
     * @param startIndex Starting index in publicInputs
     * @return nextIndex The next available index
     */
    function _fillWithdrawAmount(
        uint256[] memory publicInputs,
        uint256 amount,
        uint256 startIndex
    ) internal pure returns (uint256 nextIndex) {
        publicInputs[startIndex] = amount;
        return startIndex + 1;
    }

    /**
     * @dev Copies nullifiers to the withdraw public inputs array
     * @param publicInputs The array to populate
     * @param nullifiers Array of nullifiers to copy
     * @param startIndex Starting index in publicInputs
     * @return nextIndex The next available index
     */
    function _fillWithdrawNullifiers(
        uint256[] memory publicInputs,
        uint256[] memory nullifiers,
        uint256 startIndex
    ) internal pure returns (uint256 nextIndex) {
        uint256 piIndex = startIndex;
        for (uint256 i = 0; i < nullifiers.length; i++) {
            publicInputs[piIndex++] = nullifiers[i];
        }
        return piIndex;
    }

    /**
     * @dev Copies the root to the withdraw public inputs array
     * @param publicInputs The array to populate
     * @param root The merkle root
     * @param startIndex Starting index in publicInputs
     * @return nextIndex The next available index
     */
    function _fillWithdrawRoot(
        uint256[] memory publicInputs,
        uint256 root,
        uint256 startIndex
    ) internal pure returns (uint256 nextIndex) {
        publicInputs[startIndex] = root;
        return startIndex + 1;
    }

    /**
     * @dev Populates enabled flags for withdraw based on nullifier values
     * @param publicInputs The array to populate
     * @param nullifiers Array of nullifiers
     * @param startIndex Starting index in publicInputs
     * @return nextIndex The next available index
     */
    function _fillWithdrawEnabledFlags(
        uint256[] memory publicInputs,
        uint256[] memory nullifiers,
        uint256 startIndex
    ) internal pure returns (uint256 nextIndex) {
        uint256 piIndex = startIndex;
        for (uint256 i = 0; i < nullifiers.length; i++) {
            publicInputs[piIndex++] = (nullifiers[i] == 0) ? 0 : 1;
        }
        return piIndex;
    }

    /**
     * @dev Copies the output commitment to the withdraw public inputs array
     * @param publicInputs The array to populate
     * @param output The output commitment
     * @param startIndex Starting index in publicInputs
     */
    function _fillWithdrawOutput(
        uint256[] memory publicInputs,
        uint256 output,
        uint256 startIndex
    ) internal pure {
        publicInputs[startIndex] = output;
    }

    // This function is used to burn the owner's UTXOs
    function _burn(
        uint256[] memory nullifiers,
        uint256 output,
        uint256 root,
        bytes calldata data
    ) internal virtual {
        validateInputs(nullifiers, false);
        uint256[] memory outputStates = new uint256[](1);
        outputStates[0] = output;
        validateOutputs(outputStates);
        validateRoot(root, false);

        emit UTXOBurn(nullifiers, output, msg.sender, data);
    }
}
