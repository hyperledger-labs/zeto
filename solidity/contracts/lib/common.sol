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

/// @title A core library for Zeto based token contracts
/// @author Kaleido, Inc.
/// @dev Implements common utility functions, such as proofs hashing and sorting
library Commonlib {
    struct Proof {
        uint[2] pA;
        uint[2][2] pB;
        uint[2] pC;
    }

    function padUintArray(
        uint256[] memory arr,
        uint256 targetLength,
        uint256 padValue
    ) internal pure returns (uint256[] memory) {
        if (arr.length == targetLength) {
            return arr;
        }
        uint256[] memory paddedArray = new uint256[](targetLength);
        for (uint256 i = 0; i < arr.length; i++) {
            paddedArray[i] = arr[i];
        }
        for (uint256 i = arr.length; i < targetLength; i++) {
            paddedArray[i] = padValue;
        }
        return paddedArray;
    }

    function getProofHash(
        Proof calldata proof
    ) internal pure returns (bytes32) {
        uint[8] memory inputs = [
            proof.pA[0],
            proof.pA[1],
            proof.pB[0][0],
            proof.pB[0][1],
            proof.pB[1][0],
            proof.pB[1][1],
            proof.pC[0],
            proof.pC[1]
        ];

        return keccak256(abi.encodePacked(inputs));
    }
}
