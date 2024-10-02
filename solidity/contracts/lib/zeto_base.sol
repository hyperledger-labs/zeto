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

import {IZetoBase} from "./interfaces/izeto_base.sol";
import {Commonlib} from "./common.sol";
import {Registry} from "./registry.sol";
import {ZetoCommon} from "./zeto_common.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title A sample base implementation of a Zeto based token contract
///        without using nullifiers. Each UTXO's spending status is explicitly tracked.
/// @author Kaleido, Inc.
/// @dev Implements common functionalities of Zeto based tokens without nullifiers
abstract contract ZetoBase is IZetoBase, ZetoCommon {
    enum UTXOStatus {
        UNKNOWN, // default value for the empty UTXO slots
        UNSPENT,
        SPENT
    }

    // maintains all the UTXOs
    mapping(uint256 => UTXOStatus) internal _utxos;

    function __ZetoBase_init(address initialOwner) internal onlyInitializing {
        __ZetoCommon_init(initialOwner);
    }

    /// @dev query whether a UTXO is currently spent
    /// @return bool whether the UTXO is spent
    function spent(uint256 txo) public view returns (bool) {
        return _utxos[txo] == UTXOStatus.SPENT;
    }

    function validateTransactionProposal(
        uint256[] memory inputs,
        uint256[] memory outputs,
        Commonlib.Proof calldata proof
    ) internal view returns (bool) {
        // sort the inputs and outputs to detect duplicates
        (
            uint256[] memory sortedInputs,
            uint256[] memory sortedOutputs
        ) = sortInputsAndOutputs(inputs, outputs);

        // Check the inputs are all unspent
        for (uint256 i = 0; i < sortedInputs.length; ++i) {
            if (sortedInputs[i] == 0) {
                // skip the zero inputs
                continue;
            }
            if (i > 0 && sortedInputs[i] == sortedInputs[i - 1]) {
                revert UTXODuplicate(sortedInputs[i]);
            }
            if (_utxos[sortedInputs[i]] == UTXOStatus.UNKNOWN) {
                revert UTXONotMinted(sortedInputs[i]);
            } else if (_utxos[sortedInputs[i]] == UTXOStatus.SPENT) {
                revert UTXOAlreadySpent(sortedInputs[i]);
            }
        }

        // Check the outputs are all new UTXOs
        for (uint256 i = 0; i < sortedOutputs.length; ++i) {
            if (sortedOutputs[i] == 0) {
                // skip the zero outputs
                continue;
            }
            if (i > 0 && sortedOutputs[i] == sortedOutputs[i - 1]) {
                revert UTXODuplicate(sortedOutputs[i]);
            }
            if (_utxos[sortedOutputs[i]] == UTXOStatus.SPENT) {
                revert UTXOAlreadySpent(sortedOutputs[i]);
            } else if (_utxos[sortedOutputs[i]] == UTXOStatus.UNSPENT) {
                revert UTXOAlreadyOwned(sortedOutputs[i]);
            }
        }

        // check if the proof has been locked
        bytes32 proofHash = Commonlib.getProofHash(proof);
        if (lockedProofs[proofHash] != address(0)) {
            require(
                lockedProofs[proofHash] == msg.sender,
                "Locked proof can only be submitted by the locker address"
            );
        }
        return true;
    }

    function processInputsAndOutputs(
        uint256[] memory inputs,
        uint256[] memory outputs
    ) internal {
        // accept the transaction to consume the input UTXOs and produce new UTXOs
        for (uint256 i = 0; i < inputs.length; ++i) {
            _utxos[inputs[i]] = UTXOStatus.SPENT;
        }
        for (uint256 i = 0; i < outputs.length; ++i) {
            _utxos[outputs[i]] = UTXOStatus.UNSPENT;
        }
    }

    // This function is used to mint new UTXOs, as an example implementation,
    // which is only callable by the owner.
    function _mint(
        uint256[] memory utxos,
        bytes calldata data
    ) internal virtual {
        for (uint256 i = 0; i < utxos.length; ++i) {
            uint256 utxo = utxos[i];
            if (_utxos[utxo] == UTXOStatus.UNSPENT) {
                revert UTXOAlreadyOwned(utxo);
            } else if (_utxos[utxo] == UTXOStatus.SPENT) {
                revert UTXOAlreadySpent(utxo);
            }

            _utxos[utxo] = UTXOStatus.UNSPENT;
        }
        emit UTXOMint(utxos, msg.sender, data);
    }
}
