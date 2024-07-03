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

    function getProofHash(Proof calldata proof) public pure returns (bytes32) {
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

    // copied from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Arrays.sol
    // until it's available in a new release
    function sort(
        uint256[] memory array
    ) public pure returns (uint256[] memory) {
        bytes32[] memory bytes32Array = _castToBytes32Array(array);
        _quickSort(_begin(bytes32Array), _end(bytes32Array), _defaultComp);
        return array;
    }

    function _castToBytes32Array(
        uint256[] memory input
    ) private pure returns (bytes32[] memory output) {
        assembly {
            output := input
        }
    }

    function _defaultComp(bytes32 a, bytes32 b) private pure returns (bool) {
        return a < b;
    }

    function _begin(bytes32[] memory array) private pure returns (uint256 ptr) {
        /// @solidity memory-safe-assembly
        assembly {
            ptr := add(array, 0x20)
        }
    }

    function _end(bytes32[] memory array) private pure returns (uint256 ptr) {
        unchecked {
            return _begin(array) + array.length * 0x20;
        }
    }

    function _mload(uint256 ptr) private pure returns (bytes32 value) {
        assembly {
            value := mload(ptr)
        }
    }

    function _swap(uint256 ptr1, uint256 ptr2) private pure {
        assembly {
            let value1 := mload(ptr1)
            let value2 := mload(ptr2)
            mstore(ptr1, value2)
            mstore(ptr2, value1)
        }
    }

    function _quickSort(
        uint256 begin,
        uint256 end,
        function(bytes32, bytes32) pure returns (bool) comp
    ) private pure {
        unchecked {
            if (end - begin < 0x40) return;

            // Use first element as pivot
            bytes32 pivot = _mload(begin);
            // Position where the pivot should be at the end of the loop
            uint256 pos = begin;

            for (uint256 it = begin + 0x20; it < end; it += 0x20) {
                if (comp(_mload(it), pivot)) {
                    // If the value stored at the iterator's position comes before the pivot, we increment the
                    // position of the pivot and move the value there.
                    pos += 0x20;
                    _swap(pos, it);
                }
            }

            _swap(begin, pos); // Swap pivot into place
            _quickSort(begin, pos, comp); // Sort the left side of the pivot
            _quickSort(pos + 0x20, end, comp); // Sort the right side of the pivot
        }
    }
}
