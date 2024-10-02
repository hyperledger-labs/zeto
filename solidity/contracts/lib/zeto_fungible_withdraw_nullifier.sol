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
import {ZetoFungible} from "./zeto_fungible.sol";
import {Commonlib} from "./common.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title A sample implementation of a base Zeto fungible token contract
/// @author Kaleido, Inc.
/// @dev Defines the verifier library for checking UTXOs against a claimed value.
abstract contract ZetoFungibleWithdrawWithNullifiers is ZetoFungible {
    // nullifierVerifier library for checking nullifiers against a claimed value.
    // this can be used in the optional withdraw calls to verify that the nullifiers
    // match the withdrawn value
    Groth16Verifier_CheckNullifierValue internal withdrawVerifier;

    function __ZetoFungibleWithdrawWithNullifiers_init(
        Groth16Verifier_CheckHashesValue _depositVerifier,
        Groth16Verifier_CheckNullifierValue _withdrawVerifier
    ) internal onlyInitializing {
        __ZetoFungible_init(_depositVerifier);
        withdrawVerifier = _withdrawVerifier;
    }

    function _withdrawWithNullifiers(
        uint256 amount,
        uint256[] memory nullifiers,
        uint256 output,
        uint256 root,
        Commonlib.Proof calldata proof
    ) public virtual {
        require((nullifiers.length == 2), "Withdraw must have 2 nullifiers");
        // construct the public inputs
        uint256[7] memory publicInputs;
        publicInputs[0] = amount;
        publicInputs[1] = nullifiers[0];
        publicInputs[2] = nullifiers[1];
        publicInputs[3] = root;
        publicInputs[4] = (nullifiers[0] == 0) ? 0 : 1; // enable MT proof for the first nullifier
        publicInputs[5] = (nullifiers[1] == 0) ? 0 : 1; // enable MT proof for the second nullifier
        publicInputs[6] = output;

        // Check the proof
        require(
            withdrawVerifier.verifyProof(
                proof.pA,
                proof.pB,
                proof.pC,
                publicInputs
            ),
            "Invalid proof"
        );

        require(
            erc20.transfer(msg.sender, amount),
            "Failed to transfer ERC20 tokens"
        );
    }
}
