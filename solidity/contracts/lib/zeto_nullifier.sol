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
import {IZetoBase} from "./interfaces/izeto_base.sol";
import {MAX_SMT_DEPTH} from "./interfaces/izeto_nullifier.sol";
import {IZetoLockable} from "./interfaces/izeto_lockable.sol";
import {ZetoCommon} from "./zeto_common.sol";
import {SmtLib} from "@iden3/contracts/lib/SmtLib.sol";
// import {console} from "hardhat/console.sol";

/// @title A sample base implementation of a Zeto based token contract with nullifiers
/// @author Kaleido, Inc.
/// @dev Implements common functionalities of Zeto based tokens using nullifiers
abstract contract ZetoNullifier is IZetoBase, IZetoLockable, ZetoCommon {
    // used for tracking regular (unlocked) UTXOs
    SmtLib.Data internal _commitmentsTree;
    // used for locked UTXOs tracking. multi-step transaction flows that require counterparties
    // to upload proofs. To protect the party that uploads their proof first,
    // and prevent any other party from utilizing the uploaded proof to execute
    // a transaction, the input UTXOs or nullifiers can be locked and only usable
    // by the same party that did the locking.
    SmtLib.Data internal _lockedCommitmentsTree;
    using SmtLib for SmtLib.Data;
    mapping(uint256 => bool) private _nullifiers;

    error UTXORootNotFound(uint256 root);

    function __ZetoNullifier_init(
        address initialOwner
    ) internal onlyInitializing {
        __ZetoCommon_init(initialOwner);
        _commitmentsTree.initialize(MAX_SMT_DEPTH);
        _lockedCommitmentsTree.initialize(MAX_SMT_DEPTH);
    }

    function validateTransactionProposal(
        uint256[] memory nullifiers,
        uint256[] memory outputs,
        uint256 root,
        bool isLocked
    ) internal view returns (bool) {
        // sort the inputs and outputs to detect duplicates
        uint256[] memory sortedInputs = sortCommitments(nullifiers);
        uint256[] memory sortedOutputs = sortCommitments(outputs);

        // Check the inputs are all unspent
        for (uint256 i = 0; i < sortedInputs.length; ++i) {
            if (sortedInputs[i] == 0) {
                // skip the zero inputs
                continue;
            }
            if (i > 0 && sortedInputs[i] == sortedInputs[i - 1]) {
                revert UTXODuplicate(sortedInputs[i]);
            }
            if (_nullifiers[sortedInputs[i]] == true) {
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
            SmtLib.Node memory node;
            if (isLocked) {
                uint256 nodeHash = Commonlib.getLeafNodeHash(
                    sortedOutputs[i],
                    uint256(uint160(msg.sender))
                );
                node = _lockedCommitmentsTree.getNode(nodeHash);
            } else {
                uint256 nodeHash = Commonlib.getLeafNodeHash(
                    sortedOutputs[i],
                    sortedOutputs[i]
                );
                node = _commitmentsTree.getNode(nodeHash);
            }

            if (node.nodeType != SmtLib.NodeType.EMPTY) {
                revert UTXOAlreadyOwned(sortedOutputs[i]);
            }
        }

        // Check if the root has existed before. It does not need to be the latest root.
        // Our SMT is append-only, so if the root has existed before, and the merklet proof
        // is valid, then the leaves still exist in the tree.
        if (isLocked && !_lockedCommitmentsTree.rootExists(root)) {
            revert UTXORootNotFound(root);
        } else if (!isLocked && !_commitmentsTree.rootExists(root)) {
            revert UTXORootNotFound(root);
        }

        return true;
    }

    function processInputsAndOutputs(
        uint256[] memory nullifiers,
        uint256[] memory outputs,
        uint256[] memory lockedOutputs,
        address delegate
    ) internal {
        spendNullifiers(nullifiers);
        for (uint256 i = 0; i < outputs.length; ++i) {
            if (outputs[i] != 0) {
                _commitmentsTree.addLeaf(outputs[i], outputs[i]);
            }
        }
        for (uint256 i = 0; i < lockedOutputs.length; ++i) {
            if (lockedOutputs[i] != 0) {
                _lockedCommitmentsTree.addLeaf(
                    lockedOutputs[i],
                    uint256(uint160(delegate))
                );
            }
        }
    }

    function spendNullifiers(uint256[] memory nullifiers) internal {
        for (uint256 i = 0; i < nullifiers.length; ++i) {
            if (nullifiers[i] != 0) {
                _nullifiers[nullifiers[i]] = true;
            }
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
            if (utxo == 0) {
                continue;
            }
            uint256 nodeHash = Commonlib.getLeafNodeHash(utxo, utxo);
            SmtLib.Node memory node = _commitmentsTree.getNode(nodeHash);

            if (node.nodeType != SmtLib.NodeType.EMPTY) {
                revert UTXOAlreadyOwned(utxo);
            }

            _commitmentsTree.addLeaf(utxo, utxo);
        }

        emit UTXOMint(utxos, msg.sender, data);
    }

    function getRoot() public view returns (uint256) {
        return _commitmentsTree.getRoot();
    }

    function getRootForLocked() public view returns (uint256) {
        return _lockedCommitmentsTree.getRoot();
    }

    // Locks the UTXOs so that they can only be spent by submitting the appropriate
    // proof from the Eth account designated as the "delegate". This function
    // should be called by escrow contracts that will use uploaded proofs
    // to execute transactions, in order to prevent the proof from being used
    // by parties other than the escrow contract.
    function _lock(
        uint256[] memory nullifiers,
        uint256[] memory outputs,
        uint256[] memory lockedOutputs,
        address delegate,
        bytes calldata data
    ) public {
        // Check the outputs are all new UTXOs
        for (uint256 i = 0; i < outputs.length; ++i) {
            if (outputs[i] == 0) {
                // skip the zero outputs
                continue;
            }
            uint256 nodeHash = Commonlib.getLeafNodeHash(
                outputs[i],
                outputs[i]
            );
            SmtLib.Node memory node = _commitmentsTree.getNode(nodeHash);
            if (node.nodeType != SmtLib.NodeType.EMPTY) {
                revert UTXOAlreadyOwned(outputs[i]);
            }
            _commitmentsTree.addLeaf(outputs[i], outputs[i]);
        }

        // Check the locked outputs are all new UTXOs
        for (uint256 i = 0; i < lockedOutputs.length; ++i) {
            if (lockedOutputs[i] == 0) {
                // skip the zero outputs
                continue;
            }
            uint256 nodeHash = Commonlib.getLeafNodeHash(
                lockedOutputs[i],
                uint256(uint160(delegate))
            );
            SmtLib.Node memory node = _lockedCommitmentsTree.getNode(nodeHash);
            if (node.nodeType != SmtLib.NodeType.EMPTY) {
                revert UTXOAlreadyLocked(lockedOutputs[i]);
            }
            _lockedCommitmentsTree.addLeaf(
                lockedOutputs[i],
                uint256(uint160(delegate))
            );
        }

        emit UTXOsLocked(
            nullifiers,
            outputs,
            lockedOutputs,
            delegate,
            msg.sender,
            data
        );
    }

    // move the ability to spend the locked UTXOs to the delegate account.
    // The sender must be the current delegate.
    function delegateLock(
        uint256[] memory utxos,
        address delegate,
        bytes calldata data
    ) public {
        for (uint256 i = 0; i < utxos.length; ++i) {
            if (utxos[i] == 0) {
                continue;
            }
            uint256 nodeHash = Commonlib.getLeafNodeHash(
                utxos[i],
                uint256(uint160(msg.sender))
            );
            SmtLib.Node memory node = _lockedCommitmentsTree.getNode(nodeHash);
            if (node.nodeType == SmtLib.NodeType.EMPTY) {
                revert UTXONotLocked(utxos[i]);
            }
            if (node.value != uint256(uint160(msg.sender))) {
                revert NotLockDelegate(utxos[i], delegate, msg.sender);
            }
            _lockedCommitmentsTree.addLeaf(
                utxos[i],
                uint256(uint160(delegate))
            );
        }

        emit LockDelegateChanged(utxos, msg.sender, delegate, data);
    }
}
