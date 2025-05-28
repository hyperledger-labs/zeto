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

import {Groth16Verifier_BurnNullifier} from "../verifiers/verifier_burn_nullifier.sol";
import {Groth16Verifier_BurnNullifierBatch} from "../verifiers/verifier_burn_nullifier_batch.sol";
import {ZetoNullifier} from "./zeto_nullifier.sol";
import {Commonlib} from "./common.sol";

uint256 constant BURN_INPUT_SIZE = 6;
uint256 constant BATCH_BURN_INPUT_SIZE = 22;

/// @title A feature implementation of a Zeto fungible token burn contract
/// @author Kaleido, Inc.
/// @dev Can be added to a Zeto fungible token contract to allow for burning of tokens.
abstract contract ZetoFungibleBurnableWithNullifiers is ZetoNullifier {
    Groth16Verifier_BurnNullifier internal _burnVerifier;
    Groth16Verifier_BurnNullifierBatch internal _batchBurnVerifier;

    function __ZetoFungibleBurnableWithNullifiers_init(
        Groth16Verifier_BurnNullifier burnVerifier,
        Groth16Verifier_BurnNullifierBatch batchBurnVerifier
    ) public onlyInitializing {
        _burnVerifier = burnVerifier;
        _batchBurnVerifier = batchBurnVerifier;
    }

    function constructPublicInputs(
        uint256[] memory nullifiers,
        uint256 output,
        uint256 root
    ) internal pure returns (uint256[] memory publicInputs) {
        publicInputs = new uint256[](nullifiers.length * 2 + 2);
        uint256 piIndex = 0;

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

        publicInputs[piIndex] = output;

        return publicInputs;
    }

    function burn(
        uint256[] memory nullifiers,
        uint256 output,
        uint256 root,
        Commonlib.Proof calldata proof,
        bytes calldata data
    ) public virtual {
        // Check the proof
        if (nullifiers.length > 2) {
            // construct the public inputs for verifier
            uint256[] memory publicInputs = constructPublicInputs(
                nullifiers,
                output,
                root
            );
            // construct the public inputs for verifier
            uint256[BATCH_BURN_INPUT_SIZE] memory fixedSizeInputs;
            for (uint256 i = 0; i < fixedSizeInputs.length; i++) {
                fixedSizeInputs[i] = publicInputs[i];
            }
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
            uint256[] memory publicInputs = constructPublicInputs(
                nullifiers,
                output,
                root
            );
            // construct the public inputs for verifier
            uint256[BURN_INPUT_SIZE] memory fixedSizeInputs;
            for (uint256 i = 0; i < fixedSizeInputs.length; i++) {
                fixedSizeInputs[i] = publicInputs[i];
            }
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

        _burn(nullifiers, output, root, data);
    }
}
