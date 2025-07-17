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
import {IGroth16Verifier} from "./lib/interfaces/izeto_verifier.sol";
import {Commonlib} from "./lib/common.sol";
import {ZetoBase} from "./lib/zeto_base.sol";
import {IZetoInitializable} from "./lib/interfaces/izeto_initializable.sol";
import {ZetoFungibleWithdraw} from "./lib/zeto_fungible_withdraw.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/// @title A sample implementation of a Zeto based fungible token with anonymity and no encryption
/// @author Kaleido, Inc.
/// @dev The proof has the following statements:
///        - each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
///        - the sum of the input values match the sum of output values
///        - the hashes in the input and output match the `hash(value, salt, owner public key)` formula
///        - the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes
contract Zeto_Anon is IZeto, ZetoBase, ZetoFungibleWithdraw, UUPSUpgradeable {
    function initialize(
        string memory name,
        string memory symbol,
        address initialOwner,
        IZetoInitializable.VerifiersInfo calldata verifiers
    ) public virtual initializer {
        __ZetoAnon_init(name, symbol, initialOwner, verifiers);
    }

    function __ZetoAnon_init(
        string memory name_,
        string memory symbol_,
        address initialOwner,
        IZetoInitializable.VerifiersInfo calldata verifiers
    ) internal onlyInitializing {
        __ZetoBase_init(name_, symbol_, initialOwner, verifiers);
        __ZetoFungibleWithdraw_init(
            (IGroth16Verifier)(verifiers.depositVerifier),
            (IGroth16Verifier)(verifiers.withdrawVerifier),
            (IGroth16Verifier)(verifiers.batchWithdrawVerifier)
        );
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    /**
     * @dev transfer funds by spending the input UTXOs (owned by the sender) and creating
     * output UTXOs (owned by the receiver). Some of the output UTXOs may be owned by the
     * sender, to return the change.
     *
     * @param inputs Array of UTXOs to be spent by the transaction. They must be unlocked.
     * @param outputs Array of new UTXOs to generate, for future transactions to spend.
     * @param proof A zero knowledge proof that the submitter is authorized to spend the inputs, and
     *      that the outputs are valid in terms of obeying mass conservation rules.
     *
     * Emits a {UTXOTransfer} event.
     */
    function transfer(
        uint256[] memory inputs,
        uint256[] memory outputs,
        Commonlib.Proof calldata proof,
        bytes calldata data
    ) public returns (bool) {
        // Check and pad inputs and outputs based on the max size
        inputs = checkAndPadCommitments(inputs);
        outputs = checkAndPadCommitments(outputs);

        uint256[] memory lockedOutputs;
        validateTransactionProposal(inputs, outputs, lockedOutputs, false);
        verifyProof(inputs, outputs, proof);

        processInputsAndOutputs(inputs, outputs, lockedOutputs, false);
        emit UTXOTransfer(inputs, outputs, msg.sender, data);

        return true;
    }

    /**
     * @dev transfer funds that have been previously locked by the sender. The submitted must
     * be the current delegate of the locked UTXOs.
     *
     * @param inputs Array of UTXOs to be spent by the transaction, they must be locked.
     * @param outputs Array of new UTXOs to generate, for future transactions to spend. They are unlocked.
     * @param proof A zero knowledge proof that the submitter is authorized to spend the inputs, and
     *      that the outputs are valid in terms of obeying mass conservation rules.
     *
     * Emits a {UTXOTransfer} event.
     */
    function transferLocked(
        uint256[] memory inputs,
        uint256[] memory outputs,
        Commonlib.Proof calldata proof,
        bytes calldata data
    ) public returns (bool) {
        // Check and pad inputs and outputs based on the max size
        inputs = checkAndPadCommitments(inputs);
        outputs = checkAndPadCommitments(outputs);

        uint256[] memory lockedOutputs;
        validateTransactionProposal(inputs, outputs, lockedOutputs, true);

        // Check the proof
        verifyProof(inputs, outputs, proof);

        processInputsAndOutputs(inputs, outputs, lockedOutputs, false);
        emit UTXOTransfer(inputs, outputs, msg.sender, data);

        return true;
    }

    function deposit(
        uint256 amount,
        uint256[] memory outputs,
        Commonlib.Proof calldata proof,
        bytes calldata data
    ) public {
        _deposit(amount, outputs, proof);
        _mint(outputs, data);
    }

    function withdraw(
        uint256 amount,
        uint256[] memory inputs,
        uint256 output,
        Commonlib.Proof calldata proof,
        bytes calldata data
    ) public {
        // Check and pad inputs and outputs based on the max size
        uint256[] memory outputs = new uint256[](inputs.length);
        outputs[0] = output;
        inputs = checkAndPadCommitments(inputs);
        outputs = checkAndPadCommitments(outputs);
        uint256[] memory lockedOutputs;
        validateTransactionProposal(inputs, outputs, lockedOutputs, false);

        _withdraw(amount, inputs, output, proof);
        processInputsAndOutputs(inputs, outputs, lockedOutputs, false);
        emit UTXOWithdraw(amount, inputs, output, msg.sender, data);
    }

    function mint(
        uint256[] memory utxos,
        bytes calldata data
    ) public onlyOwner {
        _mint(utxos, data);
    }

    function lock(
        uint256[] memory inputs,
        uint256[] memory outputs,
        uint256[] memory lockedOutputs,
        Commonlib.Proof calldata proof,
        address delegate,
        bytes calldata data
    ) public {
        validateTransactionProposal(inputs, outputs, lockedOutputs, false);

        // Check the proof
        // merge the outputs and lockedOutputs and do a regular transfer
        uint256[] memory allOutputs = new uint256[](
            outputs.length + lockedOutputs.length
        );
        for (uint256 i = 0; i < outputs.length; i++) {
            allOutputs[i] = outputs[i];
        }
        for (uint256 i = 0; i < lockedOutputs.length; i++) {
            allOutputs[outputs.length + i] = lockedOutputs[i];
        }
        verifyProof(inputs, allOutputs, proof);

        processInputsAndOutputs(inputs, outputs, lockedOutputs, false);

        // lock the intended outputs
        _lock(inputs, outputs, lockedOutputs, delegate, data);
    }

    function unlock(
        uint256[] memory inputs,
        uint256[] memory outputs,
        Commonlib.Proof calldata proof,
        bytes calldata data
    ) public {
        transferLocked(inputs, outputs, proof, data);
    }

    function verifyProof(
        uint256[] memory inputs,
        uint256[] memory outputs,
        Commonlib.Proof calldata proof
    ) public view returns (bool) {
        uint256[] memory publicInputs = constructPublicInputs(inputs, outputs);
        bool isBatch = inputs.length > 2 || outputs.length > 2;
        verifyProof(proof, publicInputs, isBatch, false);
        return true;
    }

    function constructPublicInputs(
        uint256[] memory inputs,
        uint256[] memory outputs
    ) internal pure returns (uint256[] memory publicInputs) {
        uint256 size = inputs.length + outputs.length;
        publicInputs = new uint256[](size);
        uint256 piIndex = 0;
        // copy input commitments
        for (uint256 i = 0; i < inputs.length; i++) {
            publicInputs[piIndex++] = inputs[i];
        }

        // copy output commitments
        for (uint256 i = 0; i < outputs.length; i++) {
            publicInputs[piIndex++] = outputs[i];
        }

        return publicInputs;
    }
}
