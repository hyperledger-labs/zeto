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

import {IZetoBase} from "./interfaces/izeto_base.sol";
import {IZetoLockable} from "./interfaces/izeto_lockable.sol";
import {Commonlib} from "./common.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @title A sample base implementation of a Zeto based token contract
///        without using nullifiers. Each UTXO's spending status is explicitly tracked.
/// @author Kaleido, Inc.
/// @dev Implements common functionalities of Zeto based tokens without nullifiers
abstract contract ZetoLock is IZetoBase, IZetoLockable {
    // used for multi-step transaction flows that require counterparties
    // to upload proofs. To protect the party that uploads their proof first,
    // and prevent any other party from utilizing the uploaded proof to execute
    // a transaction, the input UTXOs or nullifiers can be locked and only usable
    // by the same party that did the locking.
    mapping(uint256 => address) internal lockedUTXOs;

    // Locks the UTXOs so that they can only be spent by submitting the appropriate
    // proof from the Eth account designated as the "delegate". This function
    // should be called by escrow contracts that will use uploaded proofs
    // to execute transactions, in order to prevent the proof from being used
    // by parties other than the escrow contract.
    function _lock(
        uint256[] memory inputs,
        uint256[] memory outputs,
        uint256[] memory lockedOutputs,
        address delegate,
        bytes calldata data
    ) public {
        for (uint256 i = 0; i < lockedOutputs.length; ++i) {
            if (lockedOutputs[i] == 0) {
                continue;
            }
            if (
                lockedUTXOs[lockedOutputs[i]] != address(0) &&
                lockedUTXOs[lockedOutputs[i]] != msg.sender
            ) {
                revert UTXOAlreadyLocked(lockedOutputs[i]);
            }
            lockedUTXOs[lockedOutputs[i]] = delegate;
        }

        emit UTXOsLocked(
            inputs,
            outputs,
            lockedOutputs,
            delegate,
            msg.sender,
            data
        );
    }

    // move the ability to spend the locked UTXOs to the delegate account.
    // The sender must be the current delegate.
    //
    // Setting the delegate to address(0) will unlock the UTXOs.
    function delegateLock(
        uint256[] memory utxos,
        address delegate,
        bytes calldata data
    ) public {
        for (uint256 i = 0; i < utxos.length; ++i) {
            if (utxos[i] == 0) {
                continue;
            }
            if (lockedUTXOs[utxos[i]] != msg.sender) {
                revert NotLockDelegate(utxos[i], delegate, msg.sender);
            }
            lockedUTXOs[utxos[i]] = delegate;
        }

        emit LockDelegateChanged(utxos, msg.sender, delegate, data);
    }

    function validateLockedStates(
        uint256[] memory utxos
    ) internal returns (bool) {
        for (uint256 i = 0; i < utxos.length; ++i) {
            if (utxos[i] == 0) {
                continue;
            }
            // check if the UTXO has been locked
            if (lockedUTXOs[utxos[i]] != address(0)) {
                if (lockedUTXOs[utxos[i]] != msg.sender) {
                    revert UTXOAlreadyLocked(utxos[i]);
                }
                delete lockedUTXOs[utxos[i]];
            }
        }
        return true;
    }
}
