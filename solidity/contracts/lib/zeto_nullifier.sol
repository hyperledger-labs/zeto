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

import {Commonlib} from "./common.sol";
import {Registry} from "./registry.sol";
import {ZetoCommon} from "./zeto_common.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {SmtLib} from "@iden3/contracts/lib/SmtLib.sol";
import {PoseidonUnit3L} from "@iden3/contracts/lib/Poseidon.sol";

uint256 constant MAX_SMT_DEPTH = 64;

/// @title A sample base implementation of a Zeto based token contract with nullifiers
/// @author Kaleido, Inc.
/// @dev Implements common functionalities of Zeto based tokens using nullifiers
abstract contract ZetoNullifier is ZetoCommon {
    SmtLib.Data internal _commitmentsTree;
    using SmtLib for SmtLib.Data;
    mapping(uint256 => bool) private _nullifiers;

    error UTXORootNotFound(uint256 root);

    function __ZetoNullifier_init(
        address initialOwner
    ) internal onlyInitializing {
        __ZetoCommon_init(initialOwner);
        _commitmentsTree.initialize(MAX_SMT_DEPTH);
    }

    function validateTransactionProposal(
        uint256[2] memory nullifiers,
        uint256[2] memory outputs,
        uint256 root
    ) internal view returns (bool) {
        // sort the inputs and outputs to detect duplicates
        (
            uint256[] memory sortedInputs,
            uint256[] memory sortedOutputs
        ) = sortInputsAndOutputs(nullifiers, outputs);

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
            uint256 nodeHash = _getLeafNodeHash(sortedOutputs[i]);
            SmtLib.Node memory node = _commitmentsTree.getNode(nodeHash);
            if (node.nodeType != SmtLib.NodeType.EMPTY) {
                revert UTXOAlreadyOwned(sortedOutputs[i]);
            }
        }

        // Check if the root has existed before. It does not need to be the latest root.
        // Our SMT is append-only, so if the root has existed before, and the merklet proof
        // is valid, then the leaves still exist in the tree.
        if (!_commitmentsTree.rootExists(root)) {
            revert UTXORootNotFound(root);
        }

        return true;
    }

    function processInputsAndOutputs(
        uint256[2] memory nullifiers,
        uint256[2] memory outputs
    ) internal {
        for (uint256 i = 0; i < nullifiers.length; ++i) {
            if (nullifiers[i] != 0) {
                _nullifiers[nullifiers[i]] = true;
            }
        }
        for (uint256 i = 0; i < outputs.length; ++i) {
            if (outputs[i] != 0) {
                _commitmentsTree.addLeaf(outputs[i], outputs[i]);
            }
        }
    }

    // This function is used to mint new UTXOs, as an example implementation,
    // which is only callable by the owner.
    function _mint(uint256[] memory utxos) internal virtual {
        for (uint256 i = 0; i < utxos.length; ++i) {
            uint256 utxo = utxos[i];
            if (utxo == 0) {
                continue;
            }
            uint256 nodeHash = _getLeafNodeHash(utxo);
            SmtLib.Node memory node = _commitmentsTree.getNode(nodeHash);

            if (node.nodeType != SmtLib.NodeType.EMPTY) {
                revert UTXOAlreadyOwned(utxo);
            }

            _commitmentsTree.addLeaf(utxo, utxo);
        }

        emit UTXOMint(utxos, msg.sender);
    }

    function getRoot() public view returns (uint256) {
        return _commitmentsTree.getRoot();
    }

    function _getLeafNodeHash(uint256 utxo) internal pure returns (uint256) {
        uint256[3] memory params = [utxo, utxo, uint256(1)];
        return PoseidonUnit3L.poseidon(params);
    }
}
