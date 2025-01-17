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
import {ZetoCommon} from "./zeto_common.sol";

/// @title A sample base implementation of a Zeto based token contract
///        without using nullifiers. Each UTXO's spending status is explicitly tracked.
/// @author Kaleido, Inc.
/// @dev Implements common functionalities of Zeto based tokens without nullifiers
abstract contract ZetoBase is IZetoBase, IZetoLockable, ZetoCommon {
    enum UTXOStatus {
        UNKNOWN, // default value for the empty UTXO slots
        UNSPENT,
        SPENT
    }

    // tracks all the regular (unlocked) UTXOs
    mapping(uint256 => UTXOStatus) internal _utxos;
    // used for tracking locked UTXOs. multi-step transaction flows that require counterparties
    // to upload proofs. To protect the party that uploads their proof first,
    // and prevent any other party from utilizing the uploaded proof to execute
    // a transaction, the input UTXOs or nullifiers can be locked and only usable
    // by the same party that did the locking.
    mapping(uint256 => UTXOStatus) internal _lockedUtxos;
    mapping(uint256 => address) internal delegates;

    function __ZetoBase_init(address initialOwner) internal onlyInitializing {
        __ZetoCommon_init(initialOwner);
    }

    /// @dev query whether a UTXO is currently spent
    /// @return bool whether the UTXO is spent
    function spent(uint256 txo) public view returns (bool) {
        return
            _utxos[txo] == UTXOStatus.SPENT ||
            _lockedUtxos[txo] == UTXOStatus.SPENT;
    }

    function validateTransactionProposal(
        uint256[] memory inputs,
        uint256[] memory outputs,
        uint256[] memory lockedOutputs,
        bool inputsLocked
    ) internal view returns (bool) {
        uint256[] memory allOutputs = new uint256[](
            outputs.length + lockedOutputs.length
        );
        for (uint256 i = 0; i < outputs.length; i++) {
            allOutputs[i] = outputs[i];
        }
        for (uint256 i = 0; i < lockedOutputs.length; i++) {
            allOutputs[outputs.length + i] = lockedOutputs[i];
        }
        // sort the inputs and outputs to detect duplicates
        uint256[] memory sortedInputs = sortCommitments(inputs);
        uint256[] memory sortedOutputs = sortCommitments(allOutputs);

        // Check the inputs are all unspent
        for (uint256 i = 0; i < sortedInputs.length; ++i) {
            if (sortedInputs[i] == 0) {
                // skip the zero inputs
                continue;
            }
            if (i > 0 && sortedInputs[i] == sortedInputs[i - 1]) {
                revert UTXODuplicate(sortedInputs[i]);
            }
            if (
                _lockedUtxos[sortedInputs[i]] == UTXOStatus.UNKNOWN &&
                _utxos[sortedInputs[i]] == UTXOStatus.UNKNOWN
            ) {
                revert UTXONotMinted(sortedInputs[i]);
            }
            if (
                (inputsLocked &&
                    _lockedUtxos[sortedInputs[i]] == UTXOStatus.SPENT) ||
                (!inputsLocked && _utxos[sortedInputs[i]] == UTXOStatus.SPENT)
            ) {
                revert UTXOAlreadySpent(sortedInputs[i]);
            }
            if (
                !inputsLocked &&
                _lockedUtxos[sortedInputs[i]] == UTXOStatus.UNSPENT
            ) {
                revert UTXOAlreadyLocked(sortedInputs[i]);
            }
            if (
                inputsLocked &&
                delegates[sortedInputs[i]] != msg.sender &&
                delegates[sortedInputs[i]] != address(0)
            ) {
                revert NotLockDelegate(
                    sortedInputs[i],
                    delegates[sortedInputs[i]],
                    msg.sender
                );
            }
        }

        // Check for duplicate outputs
        for (uint256 i = 0; i < sortedOutputs.length; ++i) {
            if (sortedOutputs[i] == 0) {
                // skip the zero outputs
                continue;
            }
            if (i > 0 && sortedOutputs[i] == sortedOutputs[i - 1]) {
                revert UTXODuplicate(sortedOutputs[i]);
            }
        }

        for (uint256 i = 0; i < outputs.length; ++i) {
            if (_utxos[outputs[i]] == UTXOStatus.SPENT) {
                revert UTXOAlreadySpent(outputs[i]);
            } else if (_utxos[outputs[i]] == UTXOStatus.UNSPENT) {
                revert UTXOAlreadyOwned(outputs[i]);
            }
        }

        for (uint256 i = 0; i < lockedOutputs.length; ++i) {
            if (_lockedUtxos[lockedOutputs[i]] == UTXOStatus.SPENT) {
                revert UTXOAlreadySpent(lockedOutputs[i]);
            } else if (_lockedUtxos[lockedOutputs[i]] == UTXOStatus.UNSPENT) {
                revert UTXOAlreadyOwned(lockedOutputs[i]);
            }
        }
        return true;
    }

    function processInputsAndOutputs(
        uint256[] memory inputs,
        uint256[] memory outputs,
        uint256[] memory lockedOutputs,
        bool inputsLocked
    ) internal {
        mapping(uint256 => UTXOStatus) storage utxos = inputsLocked
            ? _lockedUtxos
            : _utxos;
        // accept the transaction to consume the input UTXOs and produce new UTXOs
        for (uint256 i = 0; i < inputs.length; ++i) {
            if (inputs[i] == 0) {
                continue;
            }
            utxos[inputs[i]] = UTXOStatus.SPENT;
        }
        for (uint256 i = 0; i < outputs.length; ++i) {
            if (outputs[i] == 0) {
                continue;
            }
            _utxos[outputs[i]] = UTXOStatus.UNSPENT;
        }
        for (uint256 i = 0; i < lockedOutputs.length; ++i) {
            if (lockedOutputs[i] == 0) {
                continue;
            }
            _lockedUtxos[lockedOutputs[i]] = UTXOStatus.UNSPENT;
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
                delegates[lockedOutputs[i]] != address(0) &&
                delegates[lockedOutputs[i]] != msg.sender
            ) {
                revert UTXOAlreadyLocked(lockedOutputs[i]);
            }
            delegates[lockedOutputs[i]] = delegate;
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
            if (delegates[utxos[i]] != msg.sender) {
                revert NotLockDelegate(utxos[i], delegate, msg.sender);
            }
            delegates[utxos[i]] = delegate;
        }

        emit LockDelegateChanged(utxos, msg.sender, delegate, data);
    }

    function locked(uint256 utxo) public view returns (bool, address) {
        if (_lockedUtxos[utxo] == UTXOStatus.UNSPENT) {
            return (true, delegates[utxo]);
        }
        return (false, address(0));
    }
}
