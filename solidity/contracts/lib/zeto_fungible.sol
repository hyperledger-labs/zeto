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

import {Groth16Verifier_CheckHashesValue} from "./verifier_check_hashes_value.sol";
import {Groth16Verifier_CheckNullifierValue} from "./verifier_check_nullifier_value.sol";
import {Commonlib} from "./common.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @title A sample implementation of a base Zeto fungible token contract
/// @author Kaleido, Inc.
/// @dev Defines the verifier library for checking UTXOs against a claimed value.
abstract contract ZetoFungible is OwnableUpgradeable {
    // _depositVerifier library for checking UTXOs against a claimed value.
    // this can be used in the optional deposit calls to verify that
    // the UTXOs match the deposited value
    Groth16Verifier_CheckHashesValue internal _depositVerifier;

    error WithdrawArrayTooLarge(uint256 maxAllowed);

    IERC20 internal _erc20;

    function __ZetoFungible_init(
        Groth16Verifier_CheckHashesValue depositVerifier
    ) public onlyInitializing {
        _depositVerifier = depositVerifier;
    }

    function setERC20(IERC20 erc20) public onlyOwner {
        _erc20 = erc20;
    }

    function _deposit(
        uint256 amount,
        uint256[] memory outputs,
        Commonlib.Proof calldata proof
    ) public virtual {
        // verifies that the output UTXOs match the claimed value
        // to be deposited
        // construct the public inputs
        uint256[3] memory publicInputs;
        publicInputs[0] = amount;
        publicInputs[1] = outputs[0];
        publicInputs[2] = outputs[1];

        // Check the proof
        require(
            _depositVerifier.verifyProof(
                proof.pA,
                proof.pB,
                proof.pC,
                publicInputs
            ),
            "Invalid proof"
        );

        require(
            _erc20.transferFrom(msg.sender, address(this), amount),
            "Failed to transfer ERC20 tokens"
        );
    }
}
