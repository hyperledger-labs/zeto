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

import {Commonlib} from "./common.sol";
import {IZetoCommon} from "./interfaces/izeto_common.sol";
import {Arrays} from "@openzeppelin/contracts/utils/Arrays.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @title A sample base implementation of a Zeto based token contract
/// @author Kaleido, Inc.
/// @dev Implements common functionalities of Zeto based tokens
abstract contract ZetoCommon is IZetoCommon, OwnableUpgradeable {
    function __ZetoCommon_init(address initialOwner) internal onlyInitializing {
        __Ownable_init(initialOwner);
    }
    function checkAndPadCommitments(
        uint256[] memory inputs,
        uint256[] memory outputs,
        uint256 batchMax
    ) internal pure returns (uint256[] memory, uint256[] memory) {
        uint256 inputLen = inputs.length;
        uint256 outputLen = outputs.length;

        // Check if inputs or outputs exceed batchMax and revert with custom error if necessary
        if (inputLen > batchMax || outputLen > batchMax) {
            revert UTXOArrayTooLarge(batchMax);
        }

        // Ensure both arrays are padded to the same length
        uint256 maxLength;

        // By default all tokens supports at least a circuit with 2 inputs and 2 outputs
        // which has a shorter proof generation time and should cover most use cases.
        // In addition, tokens can support circuits with bigger inputs
        if (inputLen > 2 || outputLen > 2) {
            // check whether a batch circuit is required

            maxLength = batchMax; // Pad both to batchMax if one has more than 2 items
        } else {
            maxLength = 2; // Otherwise, pad both to 2
        }

        // Pad both inputs and outputs to the determined maxLength
        inputs = Commonlib.padUintArray(inputs, maxLength, 0);
        outputs = Commonlib.padUintArray(outputs, maxLength, 0);

        return (inputs, outputs);
    }
    function sortInputsAndOutputs(
        uint256[] memory inputs,
        uint256[] memory outputs
    ) internal pure returns (uint256[] memory, uint256[] memory) {
        uint256[] memory sortedInputs = new uint256[](inputs.length);
        uint256[] memory sortedOutputs = new uint256[](outputs.length);
        for (uint256 i = 0; i < inputs.length; ++i) {
            sortedInputs[i] = inputs[i];
        }
        for (uint256 i = 0; i < outputs.length; ++i) {
            sortedOutputs[i] = outputs[i];
        }
        sortedInputs = Arrays.sort(sortedInputs);
        sortedOutputs = Arrays.sort(sortedOutputs);
        return (sortedInputs, sortedOutputs);
    }
}
