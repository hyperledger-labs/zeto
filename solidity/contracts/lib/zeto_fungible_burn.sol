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

import {Groth16Verifier_Burn} from "../verifiers/verifier_burn.sol";
import {Groth16Verifier_BurnBatch} from "../verifiers/verifier_burn_batch.sol";
import {ZetoBase} from "./zeto_base.sol";
import {Commonlib} from "./common.sol";

uint256 constant BURN_INPUT_SIZE = 3;
uint256 constant BATCH_BURN_INPUT_SIZE = 11;

/// @title A feature implementation of a Zeto fungible token burn contract
/// @author Kaleido, Inc.
/// @dev Can be added to a Zeto fungible token contract to allow for burning of tokens.
abstract contract ZetoFungibleBurnable is ZetoBase {
    Groth16Verifier_Burn internal _burnVerifier;
    Groth16Verifier_BurnBatch internal _batchBurnVerifier;

    function __ZetoFungibleBurnable_init(
        Groth16Verifier_Burn burnVerifier,
        Groth16Verifier_BurnBatch batchBurnVerifier
    ) public onlyInitializing {
        _burnVerifier = burnVerifier;
        _batchBurnVerifier = batchBurnVerifier;
    }

    function burn(
        uint256[] memory inputs,
        uint256 output,
        Commonlib.Proof calldata proof,
        bytes calldata data
    ) public virtual {
        // Check the proof
        if (inputs.length > 2) {
            // construct the public inputs for verifier
            uint256[BATCH_BURN_INPUT_SIZE] memory fixedSizeInputs;
            for (uint256 i = 0; i < inputs.length; i++) {
                fixedSizeInputs[i] = inputs[i];
            }
            fixedSizeInputs[BATCH_BURN_INPUT_SIZE - 1] = output;
            // Check the proof
            require(
                _batchBurnVerifier.verifyProof(
                    proof.pA,
                    proof.pB,
                    proof.pC,
                    fixedSizeInputs
                ),
                "Invalid proof"
            );
        } else {
            // construct the public inputs for verifier
            uint256[BURN_INPUT_SIZE] memory fixedSizeInputs;
            for (uint256 i = 0; i < inputs.length; i++) {
                fixedSizeInputs[i] = inputs[i];
            }
            fixedSizeInputs[BURN_INPUT_SIZE - 1] = output;
            // Check the proof
            require(
                _burnVerifier.verifyProof(
                    proof.pA,
                    proof.pB,
                    proof.pC,
                    fixedSizeInputs
                ),
                "Invalid proof"
            );
        }

        _burn(inputs, data);
    }
}
