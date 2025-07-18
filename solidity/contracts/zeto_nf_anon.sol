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

import {IZeto} from "./lib/interfaces/izeto.sol";
import {ZetoBase} from "./lib/zeto_base.sol";
import {Commonlib} from "./lib/common.sol";
import {IZetoInitializable} from "./lib/interfaces/izeto_initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/// @title A sample implementation of a Zeto based non-fungible token with anonymity and no encryption
/// @author Kaleido, Inc.
/// @dev The proof has the following statements:
///        - The sender owns the private key whose public key is part of the pre-image of the input UTXOs commitments
///          (aka the sender is authorized to spend the input UTXOs)
///        - The input UTXOs and output UTXOs are valid in terms of obeying mass conservation rules
contract Zeto_NfAnon is IZeto, ZetoBase, UUPSUpgradeable {
    function initialize(
        string memory name,
        string memory symbol,
        address initialOwner,
        IZetoInitializable.VerifiersInfo calldata verifiers
    ) public initializer {
        __ZetoBase_init(name, symbol, initialOwner, verifiers);
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
        uint256[] memory lockedOutputs;
        validateTransactionProposal(inputs, outputs, lockedOutputs, false);

        // construct the public inputs
        uint256[] memory publicInputs = new uint256[](2);
        publicInputs[0] = input;
        publicInputs[1] = output;

        // Check the proof
        require(
            _verifier.verify(proof.pA, proof.pB, proof.pC, publicInputs),
            "Invalid proof"
        );

        processInputsAndOutputs(inputs, outputs, lockedOutputs, false);

        emit UTXOTransfer(inputs, outputs, msg.sender, data);
        return true;
    }

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
    function transferLocked(
        uint256 input,
        uint256 output,
        Commonlib.Proof calldata proof,
        bytes calldata data
    ) public returns (bool) {
        uint256[] memory inputs = new uint256[](1);
        inputs[0] = input;
        uint256[] memory outputs = new uint256[](1);
        outputs[0] = output;
        uint256[] memory lockedOutputs;
        validateTransactionProposal(inputs, outputs, lockedOutputs, true);

        // construct the public inputs
        uint256[] memory publicInputs = new uint256[](2);
        publicInputs[0] = input;
        publicInputs[1] = output;

        // Check the proof
        require(
            _verifier.verify(proof.pA, proof.pB, proof.pC, publicInputs),
            "Invalid proof"
        );

        processInputsAndOutputs(inputs, outputs, lockedOutputs, true);

        emit UTXOTransfer(inputs, outputs, msg.sender, data);
        return true;
    }

    function mint(uint256[] memory utxos, bytes calldata data) public {
        _mint(utxos, data);
    }

    function lock(
        uint256 input,
        uint256 lockedOutput,
        Commonlib.Proof calldata proof,
        address delegate,
        bytes calldata data
    ) public {
        uint256[] memory inputs = new uint256[](1);
        inputs[0] = input;
        uint256[] memory outputs;
        uint256[] memory lockedOutputs = new uint256[](1);
        lockedOutputs[0] = lockedOutput;
        validateTransactionProposal(inputs, outputs, lockedOutputs, false);

        // construct the public inputs
        uint256[] memory publicInputs = new uint256[](2);
        publicInputs[0] = input;
        publicInputs[1] = lockedOutput;

        // Check the proof
        require(
            _verifier.verify(proof.pA, proof.pB, proof.pC, publicInputs),
            "Invalid proof"
        );

        processInputsAndOutputs(inputs, outputs, lockedOutputs, false);

        // lock the intended outputs
        _lock(inputs, outputs, lockedOutputs, delegate, data);
    }

    function unlock(
        uint256 input,
        uint256 output,
        Commonlib.Proof calldata proof,
        bytes calldata data
    ) public {
        transferLocked(input, output, proof, data);
    }
}
