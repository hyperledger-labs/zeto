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
import {IZeto, MAX_BATCH} from "./interfaces/izeto.sol";
import {Arrays} from "@openzeppelin/contracts/utils/Arrays.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @title A sample base implementation of a Zeto based token contract
/// @author Kaleido, Inc.
/// @dev Implements common functionalities of Zeto based tokens
abstract contract ZetoCommon is IZeto, OwnableUpgradeable {
    function __ZetoCommon_init(address initialOwner) internal onlyInitializing {
        __Ownable_init(initialOwner);
    }
    function checkAndPadCommitments(
        uint256[] memory commitments
    ) public pure returns (uint256[] memory) {
        uint256 len = commitments.length;

        // Check if inputs or outputs exceed batchMax and revert with custom error if necessary
        if (len > MAX_BATCH) {
            revert UTXOArrayTooLarge(MAX_BATCH);
        }

        // Ensure both arrays are padded to the same length
        uint256 maxLength;

        // By default all tokens supports at least a circuit with 2 inputs and 2 outputs
        // which has a shorter proof generation time and should cover most use cases.
        // In addition, tokens can support circuits with bigger inputs
        if (len > 2) {
            // check whether a batch circuit is required
            maxLength = MAX_BATCH; // Pad both to batchMax if one has more than 2 items
        } else {
            maxLength = 2; // Otherwise, pad both to 2
        }

        // Pad commitments to the determined maxLength
        commitments = Commonlib.padUintArray(commitments, maxLength, 0);

        return commitments;
    }
    function sortCommitments(
        uint256[] memory utxos
    ) internal pure returns (uint256[] memory) {
        uint256[] memory sorted = new uint256[](utxos.length);
        for (uint256 i = 0; i < utxos.length; ++i) {
            sorted[i] = utxos[i];
        }
        sorted = Arrays.sort(sorted);
        return sorted;
    }
}
