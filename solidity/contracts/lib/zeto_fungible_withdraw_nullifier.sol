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

import {Groth16Verifier_CheckHashesValue} from "./verifier_check_hashes_value.sol";
import {Groth16Verifier_CheckNullifierValue} from "./verifier_check_nullifier_value.sol";
import {Groth16Verifier_CheckNullifierValueBatch} from "./verifier_check_nullifier_value_batch.sol";
import {ZetoFungible} from "./zeto_fungible.sol";
import {Commonlib} from "./common.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

uint256 constant WITHDRAW_INPUT_SIZE = 7;
uint256 constant BATCH_WITHDRAW_INPUT_SIZE = 23;

/// @title A sample implementation of a base Zeto fungible token contract
/// @author Kaleido, Inc.
/// @dev Defines the verifier library for checking UTXOs against a claimed value.
abstract contract ZetoFungibleWithdrawWithNullifiers is ZetoFungible {
    // nullifierVerifier library for checking nullifiers against a claimed value.
    // this can be used in the optional withdraw calls to verify that the nullifiers
    // match the withdrawn value
    Groth16Verifier_CheckNullifierValue internal withdrawVerifier;
    Groth16Verifier_CheckNullifierValueBatch internal batchWithdrawVerifier;

    function __ZetoFungibleWithdrawWithNullifiers_init(
        Groth16Verifier_CheckHashesValue _depositVerifier,
        Groth16Verifier_CheckNullifierValue _withdrawVerifier,
        Groth16Verifier_CheckNullifierValueBatch _batchWithdrawVerifier
    ) internal onlyInitializing {
        __ZetoFungible_init(_depositVerifier);
        withdrawVerifier = _withdrawVerifier;
        batchWithdrawVerifier = _batchWithdrawVerifier;
    }

    function constructPublicInputs(
        uint256 amount,
        uint256[] memory nullifiers,
        uint256 output,
        uint256 root,
        uint256 size
    ) internal pure returns (uint256[] memory publicInputs) {
        publicInputs = new uint256[](size);
        uint256 piIndex = 0;

        // copy output amount
        publicInputs[piIndex++] = amount;

        // copy input commitments
        for (uint256 i = 0; i < nullifiers.length; i++) {
            publicInputs[piIndex++] = nullifiers[i];
        }

        // copy root
        publicInputs[piIndex++] = root;

        // populate enables
        for (uint256 i = 0; i < nullifiers.length; i++) {
            publicInputs[piIndex++] = (nullifiers[i] == 0) ? 0 : 1;
        }

        // copy output commitment
        publicInputs[piIndex++] = output;

        return publicInputs;
    }

    function _withdrawWithNullifiers(
        uint256 amount,
        uint256[] memory nullifiers,
        uint256 output,
        uint256 root,
        Commonlib.Proof calldata proof
    ) public virtual {
        // Check the proof
        if (nullifiers.length > 2) {
            // Check if inputs or outputs exceed batchMax and revert with custom error if necessary
            if (nullifiers.length > BATCH_WITHDRAW_INPUT_SIZE) {
                revert WithdrawArrayTooLarge(BATCH_WITHDRAW_INPUT_SIZE);
            }
            uint256[] memory publicInputs = constructPublicInputs(
                amount,
                nullifiers,
                output,
                root,
                BATCH_WITHDRAW_INPUT_SIZE
            );
            // construct the public inputs for verifier
            uint256[BATCH_WITHDRAW_INPUT_SIZE] memory fixedSizeInputs;
            for (uint256 i = 0; i < fixedSizeInputs.length; i++) {
                fixedSizeInputs[i] = publicInputs[i];
            }
            // Check the proof
            require(
                batchWithdrawVerifier.verifyProof(
                    proof.pA,
                    proof.pB,
                    proof.pC,
                    fixedSizeInputs
                ),
                "Invalid proof"
            );
        } else {
            uint256[] memory publicInputs = constructPublicInputs(
                amount,
                nullifiers,
                output,
                root,
                WITHDRAW_INPUT_SIZE
            );
            // construct the public inputs for verifier
            uint256[WITHDRAW_INPUT_SIZE] memory fixedSizeInputs;
            for (uint256 i = 0; i < fixedSizeInputs.length; i++) {
                fixedSizeInputs[i] = publicInputs[i];
            }
            // Check the proof
            require(
                withdrawVerifier.verifyProof(
                    proof.pA,
                    proof.pB,
                    proof.pC,
                    fixedSizeInputs
                ),
                "Invalid proof"
            );
        }

        require(
            erc20.transfer(msg.sender, amount),
            "Failed to transfer ERC20 tokens"
        );
    }
}
