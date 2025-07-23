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

import {IGroth16Verifier} from "./interfaces/izeto_verifier.sol";
import {ZetoFungibleBase} from "./zeto_fungible_base.sol";
import {Commonlib} from "./common/common.sol";

/// @title A feature implementation of a Zeto fungible token burn contract
/// @author Kaleido, Inc.
/// @dev Can be added to a Zeto fungible token contract to allow for burning of tokens.
abstract contract ZetoFungibleBurnable is ZetoFungibleBase {
    IGroth16Verifier internal _burnVerifier;
    IGroth16Verifier internal _batchBurnVerifier;

    function __ZetoFungibleBurnable_init(
        IGroth16Verifier burnVerifier,
        IGroth16Verifier batchBurnVerifier
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
        // construct the public inputs for verifier
        uint256[] memory publicInputs = new uint256[](inputs.length + 1);
        for (uint256 i = 0; i < inputs.length; i++) {
            publicInputs[i] = inputs[i];
        }
        publicInputs[inputs.length] = output;

        IGroth16Verifier verifier = (inputs.length > 2)
            ? _batchBurnVerifier
            : _burnVerifier;
        require(
            verifier.verify(proof.pA, proof.pB, proof.pC, publicInputs),
            "Invalid proof"
        );

        _burn(inputs, output, data);
    }
}
