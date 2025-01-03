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
import {IZetoLockable, ILockVerifier, IBatchLockVerifier} from "./interfaces/izeto_lockable.sol";
import {Commonlib} from "./common.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @title A sample base implementation of a Zeto based token contract
///        without using nullifiers. Each UTXO's spending status is explicitly tracked.
/// @author Kaleido, Inc.
/// @dev Implements common functionalities of Zeto based tokens without nullifiers
abstract contract ZetoLock is IZetoBase, IZetoLockable, OwnableUpgradeable {
    // used for multi-step transaction flows that require counterparties
    // to upload proofs. To protect the party that uploads their proof first,
    // and prevent any other party from utilizing the uploaded proof to execute
    // a transaction, the input UTXOs or nullifiers can be locked and only usable
    // by the same party that did the locking.
    mapping(uint256 => address) internal lockedUTXOs;

    ILockVerifier internal _lockVerifier;
    IBatchLockVerifier internal _batchLockVerifier;

    function __ZetoLock_init(
        ILockVerifier lockVerifier,
        IBatchLockVerifier batchLockVerifier
    ) public onlyInitializing {
        _lockVerifier = lockVerifier;
        _batchLockVerifier = batchLockVerifier;
    }

    // should be called by escrow contracts that will use uploaded proofs
    // to execute transactions, in order to prevent the proof from being used
    // by parties other than the escrow contract
    function lockStates(
        uint256[] memory utxos,
        Commonlib.Proof calldata proof,
        address delegate,
        bytes calldata data
    ) public {
        for (uint256 i = 0; i < utxos.length; ++i) {
            if (utxos[i] == 0) {
                continue;
            }
            if (
                lockedUTXOs[utxos[i]] != address(0) &&
                lockedUTXOs[utxos[i]] != msg.sender
            ) {
                revert UTXOAlreadyLocked(utxos[i]);
            }
            lockedUTXOs[utxos[i]] = delegate;
        }
        // verify that the proof is valid
        if (utxos.length <= 2) {
            uint256[2] memory utxosArray;
            for (uint256 i = 0; i < utxos.length; ++i) {
                utxosArray[i] = utxos[i];
            }
            for (uint256 i = utxos.length; i < 2; ++i) {
                utxosArray[i] = 0;
            }

            require(_verifyLockProof(utxosArray, proof), "Invalid proof");
        } else {
            uint256[10] memory utxosArray;
            for (uint256 i = 0; i < utxos.length; ++i) {
                utxosArray[i] = utxos[i];
            }
            for (uint256 i = utxos.length; i < 10; ++i) {
                utxosArray[i] = 0;
            }

            require(_verifyBatchLockProof(utxosArray, proof), "Invalid proof");
        }

        emit UTXOsLocked(utxos, delegate, msg.sender, data);
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

    function _verifyLockProof(
        uint256[2] memory utxos,
        Commonlib.Proof calldata proof
    ) internal view returns (bool) {
        return _lockVerifier.verifyProof(proof.pA, proof.pB, proof.pC, utxos);
    }

    function _verifyBatchLockProof(
        uint256[10] memory utxos,
        Commonlib.Proof calldata proof
    ) internal view returns (bool) {
        return
            _batchLockVerifier.verifyProof(proof.pA, proof.pB, proof.pC, utxos);
    }
}
