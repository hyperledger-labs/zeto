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
import {IZeto, MAX_BATCH} from "./interfaces/izeto.sol";
import {IZetoLockable} from "./interfaces/izeto_lockable.sol";
import {IGroth16Verifier} from "./interfaces/izeto_verifier.sol";
import {IZetoInitializable} from "./interfaces/izeto_initializable.sol";
import {Arrays} from "@openzeppelin/contracts/utils/Arrays.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {console} from "hardhat/console.sol";

/// @title A sample base implementation of a Zeto based token contract
/// @author Kaleido, Inc.
/// @dev Implements common functionalities of Zeto based tokens
abstract contract ZetoCommon is IZeto, IZetoLockable, OwnableUpgradeable {
    string private _name;
    string private _symbol;

    IGroth16Verifier internal _verifier;
    IGroth16Verifier internal _batchVerifier;
    IGroth16Verifier internal _lockVerifier;
    IGroth16Verifier internal _batchLockVerifier;

    function __ZetoCommon_init(
        string memory name_,
        string memory symbol_,
        address initialOwner,
        IZetoInitializable.VerifiersInfo calldata verifiers
    ) internal onlyInitializing {
        __Ownable_init(initialOwner);
        _name = name_;
        _symbol = symbol_;
        _verifier = verifiers.verifier;
        _lockVerifier = verifiers.lockVerifier;
        _batchVerifier = verifiers.batchVerifier;
        _batchLockVerifier = verifiers.batchLockVerifier;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. But Zeto uses 4 as the default, based on its target use cases
     * in CBDCs and tokenized commercial money. The default value can be overridden.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, or the ZKP circuits.
     */
    function decimals() public view virtual returns (uint8) {
        return 4;
    }

    /**
     * @dev This function is used to mint new UTXOs, as an example implementation,
     * which is only callable by the owner.
     *
     * @param utxos Array of UTXOs to be minted.
     * @param data Additional data to be passed to the mint function.
     *
     * Emits a {UTXOMint} event.
     */
    function mint(
        uint256[] memory utxos,
        bytes calldata data
    ) public virtual {
        validateOutputs(utxos);
        processOutputs(utxos);
        emit UTXOMint(utxos, msg.sender, data);
    }

    /**
     * @dev the main function of the contract, which transfers values from one account (represented by Babyjubjub public keys)
     *      to one or more receiver accounts (also represented by Babyjubjub public keys). One of the two nullifiers may be zero
     *      if the transaction only needs one UTXO to be spent. Equally one of the two outputs may be zero if the transaction
     *      only needs to create one new UTXO.
     *
     * @param inputs Array of nullifiers that are secretly bound to UTXOs to be spent by the transaction.
     * @param outputs Array of new UTXOs to generate, for future transactions to spend.
     * @param proof A zero knowledge proof that the submitter is authorized to spend the inputs, and
     *      that the outputs are valid in terms of obeying mass conservation rules.
     *
     * Emits a {UTXOTransferNonRepudiation} event.
     */
    function transfer(
        uint256[] memory inputs,
        uint256[] memory outputs,
        bytes calldata proof,
        bytes calldata data
    ) public {
        // Check and pad commitments
        inputs = checkAndPadCommitments(inputs);
        outputs = checkAndPadCommitments(outputs);
        // construct the public inputs for the proof verification
        (uint256[] memory publicInputs, Commonlib.Proof memory proofStruct) = constructPublicInputs(
            inputs,
            outputs,
            proof,
            false
        );
        uint256[] memory lockedOutputs;
        validateTransactionProposal(inputs, outputs, lockedOutputs, proof, false);
        bool isBatch = (inputs.length > 2 || outputs.length > 2);
        verifyProof(proofStruct, publicInputs, isBatch, false);
        processInputsAndOutputs(inputs, outputs, false);
        emit UTXOTransfer(inputs, outputs, msg.sender, data);
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
        bytes calldata proof,
        bytes calldata data
    ) public {
        // Check and pad inputs and outputs based on the max size
        inputs = checkAndPadCommitments(inputs);
        outputs = checkAndPadCommitments(outputs);
        // construct the public inputs for the proof verification
        (uint256[] memory publicInputs, Commonlib.Proof memory proofStruct) = constructPublicInputs(
            inputs,
            outputs,
            proof,
            true
        );

        uint256[] memory lockedOutputs;
        validateTransactionProposal(inputs, outputs, lockedOutputs, proof, true);

        bool isBatch = (inputs.length > 2 || outputs.length > 2);
        verifyProof(proofStruct, publicInputs, isBatch, true);
        console.log("verified");
        processInputsAndOutputs(inputs, outputs, true);
        emit UTXOTransfer(inputs, outputs, msg.sender, data);
    }

    /**
     * @dev lock funds that have been previously unlocked by the sender. The submitted must
     * be the current delegate of the locked UTXOs.
     *
     * @param inputs Array of UTXOs to be spent by the transaction, they must be unlocked.
     * @param outputs Array of new UTXOs to generate, for future transactions to spend. They are locked.
     * @param lockedOutputs Array of UTXOs to be locked by the transaction.
     * @param proof A zero knowledge proof that the submitter is authorized to spend the inputs, and
     *      that the outputs are valid in terms of obeying mass conservation rules.
     * @param delegate The delegate of the locked UTXOs.
     * @param data Additional data to be passed to the lock function.
     *
     * Emits a {UTXOTransfer} event.
     */
    function lock(
        uint256[] memory inputs,
        uint256[] memory outputs,
        uint256[] memory lockedOutputs,
        bytes calldata proof,
        address delegate,
        bytes calldata data
    ) public {
        // Check and pad inputs and outputs based on the max size
        inputs = checkAndPadCommitments(inputs);
        // construct the public inputs for the proof verification
        (uint256[] memory publicInputs, Commonlib.Proof memory proofStruct) = constructPublicInputsForLock(
            inputs,
            outputs,
            lockedOutputs,
            proof
        );

        validateTransactionProposal(inputs, outputs, lockedOutputs, proof, false);
        bool isBatch = (inputs.length > 2 || outputs.length > 2 || lockedOutputs.length > 2);
        verifyProof(proofStruct, publicInputs, isBatch, false);

        processInputsAndOutputs(inputs, outputs, false);
        processLockedOutputs(lockedOutputs, delegate);

        emit UTXOsLocked(
            inputs,
            outputs,
            lockedOutputs,
            delegate,
            msg.sender,
            data
        );
    }

    /**
     * @dev unlock funds that have been previously locked by the sender. The submitted must
     * be the current delegate of the locked UTXOs.
     *
     * @param nullifiers Array of nullifiers that are secretly bound to UTXOs to be spent by the transaction.
     * @param outputs Array of new UTXOs to generate, for future transactions to spend. They are unlocked.
     * @param proof A zero knowledge proof that the submitter is authorized to spend the inputs, and
     *      that the outputs are valid in terms of obeying mass conservation rules.
     * @param data Additional data to be passed to the unlock function.
     *
     * Emits a {UTXOTransfer} event.
     */
    function unlock(
        uint256[] memory nullifiers,
        uint256[] memory outputs,
        bytes calldata proof,
        bytes calldata data
    ) public {
        transferLocked(nullifiers, outputs, proof, data);
    }

    /**
     * @dev construct the public inputs and verify the proof.
     *
     * @param inputs Array of UTXOs to be spent by the transaction.
     * @param outputs Array of new UTXOs to generate, for future transactions to spend.
     * @param proof A zero knowledge proof that the submitter is authorized to spend the inputs, and
     *      that the outputs are valid in terms of obeying mass conservation rules.
     * @param inputsLocked Whether the inputs are locked.
     *
     * @return True if the proof is valid, false otherwise.
     */
    function constructPublicSignalsAndVerifyProof(
        uint256[] memory inputs,
        uint256[] memory outputs,
        bytes memory proof,
        bool inputsLocked
    ) public returns (bool) {
        (uint256[] memory publicInputs, Commonlib.Proof memory proofStruct) = constructPublicInputs(inputs, outputs, proof, inputsLocked);
        bool isBatch = inputs.length > 2 || outputs.length > 2;
        verifyProof(proofStruct, publicInputs, isBatch, false);
        return true;
    }

    function checkAndPadCommitments(
        uint256[] memory commitments
    ) public pure returns (uint256[] memory) {
        uint256 len = commitments.length;

        // Check if inputs or outputs exceed batchMax and revert with custom error if necessary
        if (len > MAX_BATCH) {
            revert UTXOArrayTooLarge(MAX_BATCH);
        }

        // Ensure both arrays are padded to the same length
        uint256 maxLength;

        // By default all tokens supports at least a circuit with 2 inputs and 2 outputs
        // which has a shorter proof generation time and should cover most use cases.
        // In addition, tokens can support circuits with bigger inputs
        if (len > 2) {
            // check whether a batch circuit is required
            maxLength = MAX_BATCH; // Pad both to batchMax if one has more than 2 items
        } else {
            maxLength = 2; // Otherwise, pad both to 2
        }

        // Pad commitments to the determined maxLength
        commitments = Commonlib.padUintArray(commitments, maxLength, 0);

        return commitments;
    }

    function sortCommitments(
        uint256[] memory utxos
    ) internal pure returns (uint256[] memory) {
        uint256[] memory sorted = new uint256[](utxos.length);
        for (uint256 i = 0; i < utxos.length; ++i) {
            sorted[i] = utxos[i];
        }
        sorted = Arrays.sort(sorted);
        return sorted;
    }

    function constructPublicInputs(
        uint256[] memory inputs,
        uint256[] memory outputs,
        bytes memory proof,
        bool inputsLocked
    ) internal virtual returns (uint256[] memory publicInputs, Commonlib.Proof memory proofStruct) {
    }

    function constructPublicInputsForLock(
        uint256[] memory inputs,
        uint256[] memory outputs,
        uint256[] memory lockedOutputs,
        bytes memory proof
    ) internal virtual returns (uint256[] memory publicInputs, Commonlib.Proof memory proofStruct) {
    }

    function validateTransactionProposal(
        uint256[] memory inputs,
        uint256[] memory outputs,
        uint256[] memory lockedOutputs,
        bytes memory proof,
        bool inputsLocked
    ) internal virtual view {
        uint256[] memory allOutputs = new uint256[](
            outputs.length + lockedOutputs.length
        );
        for (uint256 i = 0; i < outputs.length; i++) {
            allOutputs[i] = outputs[i];
        }
        for (uint256 i = 0; i < lockedOutputs.length; i++) {
            allOutputs[outputs.length + i] = lockedOutputs[i];
        }
        validateInputs(inputs, inputsLocked);
        validateOutputs(allOutputs);
    }

    function validateInputs(
        uint256[] memory inputs,
        bool inputsLocked
    ) internal virtual view {
    }

    function validateOutputs(
        uint256[] memory outputs
    ) internal virtual view {
    }

    function processInputsAndOutputs(
        uint256[] memory inputs,
        uint256[] memory outputs,
        bool inputsLocked
    ) internal virtual {
        processInputs(inputs, inputsLocked);
        processOutputs(outputs);
    }

    // Implementation is provided by the derived contracts:
    // - ZetoBase: non-nullifier based tokens
    // - ZetoNullifier: nullifier based tokens
     function processInputs(
        uint256[] memory inputs,
        bool inputsLocked
    ) internal virtual {
    }
    
    // Implementation is provided by the derived contracts:
    // - ZetoBase: non-nullifier based tokens
    // - ZetoNullifier: nullifier based tokens
    function processOutputs(
        uint256[] memory outputs
    ) internal virtual {
    }

    function processLockedOutputs(
        uint256[] memory lockedOutputs,
        address delegate
    ) internal virtual {
    }

    function verifyProof(
        Commonlib.Proof memory proof,
        uint256[] memory publicInputs,
        bool isBatch,
        bool inputsLocked
    ) public view returns (bool) {
        IGroth16Verifier verifier = inputsLocked
            ? (isBatch ? _batchLockVerifier : _lockVerifier)
            : (isBatch ? _batchVerifier : _verifier);
        require(
            verifier.verify(proof.pA, proof.pB, proof.pC, publicInputs),
            "Invalid proof"
        );
        return true;
    }
}
