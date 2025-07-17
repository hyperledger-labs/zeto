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

import {IGroth16Verifier} from "./interfaces/izeto_verifier.sol";
import {ZetoFungible} from "./zeto_fungible.sol";
import {Commonlib} from "./common.sol";

/// @title A sample implementation of a base Zeto fungible token contract
/// @author Kaleido, Inc.
/// @dev Defines the verifier library for checking UTXOs against a claimed value.
abstract contract ZetoFungibleWithdraw is ZetoFungible {
    // nullifierVerifier library for checking nullifiers against a claimed value.
    // this can be used in the optional withdraw calls to verify that the nullifiers
    // match the withdrawn value
    IGroth16Verifier internal _withdrawVerifier;
    IGroth16Verifier internal _batchWithdrawVerifier;

    function __ZetoFungibleWithdraw_init(
        IGroth16Verifier depositVerifier,
        IGroth16Verifier withdrawVerifier,
        IGroth16Verifier batchWithdrawVerifier
    ) public onlyInitializing {
        __ZetoFungible_init(depositVerifier);
        _withdrawVerifier = withdrawVerifier;
        _batchWithdrawVerifier = batchWithdrawVerifier;
    }

    function constructPublicInputs(
        uint256 amount,
        uint256[] memory inputs,
        uint256 output
    ) internal pure returns (uint256[] memory publicInputs) {
        uint256 size = (inputs.length + 1 + 1); // inputs, output, and amount

        publicInputs = new uint256[](size);
        uint256 piIndex = 0;

        // copy output amount
        publicInputs[piIndex++] = amount;

        // copy input commitments
        for (uint256 i = 0; i < inputs.length; i++) {
            publicInputs[piIndex++] = inputs[i];
        }

        // copy output commitment
        publicInputs[piIndex++] = output;

        return publicInputs;
    }

    function _withdraw(
        uint256 amount,
        uint256[] memory inputs,
        uint256 output,
        Commonlib.Proof calldata proof
    ) public virtual {
        uint256[] memory publicInputs = constructPublicInputs(
            amount,
            inputs,
            output
        );
        // Check the proof
        IGroth16Verifier verifier = (inputs.length > 2)
            ? _batchWithdrawVerifier
            : _withdrawVerifier;
        require(
            verifier.verify(proof.pA, proof.pB, proof.pC, publicInputs),
            "Invalid proof"
        );

        require(
            _erc20.transfer(msg.sender, amount),
            "Failed to transfer ERC20 tokens"
        );
    }
}
