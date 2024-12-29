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

import {IZeto} from "./lib/interfaces/izeto.sol";
import {Groth16Verifier_CheckUtxosNfOwner} from "./lib/verifier_check_utxos_nf_owner.sol";
import {ILockVerifier, IBatchLockVerifier} from "./lib/interfaces/izeto_lockable.sol";

import {Groth16Verifier_NfAnon} from "./lib/verifier_nf_anon.sol";
import {ZetoBase} from "./lib/zeto_base.sol";
import {ZetoLock} from "./lib/zeto_lock.sol";
import {Commonlib} from "./lib/common.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/// @title A sample implementation of a Zeto based non-fungible token with anonymity and no encryption
/// @author Kaleido, Inc.
/// @dev The proof has the following statements:
///        - The sender owns the private key whose public key is part of the pre-image of the input UTXOs commitments
///          (aka the sender is authorized to spend the input UTXOs)
///        - The input UTXOs and output UTXOs are valid in terms of obeying mass conservation rules
contract Zeto_NfAnon is IZeto, ZetoBase, ZetoLock, UUPSUpgradeable {
    Groth16Verifier_NfAnon internal _verifier;

    function initialize(
        address initialOwner,
        Groth16Verifier_NfAnon verifier,
        ILockVerifier lockVerifier
    ) public initializer {
        __ZetoBase_init(initialOwner);
        __ZetoLock_init(lockVerifier, IBatchLockVerifier(address(0)));
        _verifier = verifier;
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    /**
     * @dev the main function of the contract.
     *
     * @param input The UTXO to be spent by the transaction.
     * @param output The new UTXO to generate, for future transactions to spend.
     * @param proof A zero knowledge proof that the submitter is authorized to spend the inputs, and
     *      that the outputs are valid in terms of obeying mass conservation rules.
     *
     * Emits a {UTXOTransfer} event.
     */
    function transfer(
        uint256 input,
        uint256 output,
        Commonlib.Proof calldata proof,
        bytes calldata data
    ) public returns (bool) {
        uint256[] memory inputs = new uint256[](1);
        inputs[0] = input;
        uint256[] memory outputs = new uint256[](1);
        outputs[0] = output;
        require(
            validateTransactionProposal(inputs, outputs),
            "Invalid transaction proposal"
        );

        require(
            validateLockedStates(inputs),
            "At least one UTXO in the inputs are locked"
        );

        // construct the public inputs
        uint256[2] memory publicInputs;
        publicInputs[0] = input;
        publicInputs[1] = output;

        // Check the proof
        require(
            _verifier.verifyProof(proof.pA, proof.pB, proof.pC, publicInputs),
            "Invalid proof"
        );

        _utxos[input] = UTXOStatus.SPENT;
        _utxos[output] = UTXOStatus.UNSPENT;

        emit UTXOTransfer(inputs, outputs, msg.sender, data);
        return true;
    }

    function mint(uint256[] memory utxos, bytes calldata data) public {
        _mint(utxos, data);
    }
}
