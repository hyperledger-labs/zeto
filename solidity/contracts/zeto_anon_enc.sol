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

import {IZetoEncrypted} from "./lib/interfaces/izeto_encrypted.sol";
import {Groth16Verifier_CheckHashesValue} from "./lib/verifier_check_hashes_value.sol";
import {Groth16Verifier_CheckInputsOutputsValue} from "./lib/verifier_check_inputs_outputs_value.sol";
import {Groth16Verifier_CheckInputsOutputsValueBatch} from "./lib/verifier_check_inputs_outputs_value_batch.sol";
import {Groth16Verifier_AnonEnc} from "./lib/verifier_anon_enc.sol";
import {Groth16Verifier_AnonEncBatch} from "./lib/verifier_anon_enc_batch.sol";
import {ZetoFungibleWithdraw} from "./lib/zeto_fungible_withdraw.sol";
import {ZetoBase} from "./lib/zeto_base.sol";
import {ZetoFungible} from "./lib/zeto_fungible.sol";
import {Registry} from "./lib/registry.sol";
import {Commonlib} from "./lib/common.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

uint256 constant MAX_BATCH = 10;
uint256 constant INPUT_SIZE = 15;
uint256 constant BATCH_INPUT_SIZE = 63;

/// @title A sample implementation of a Zeto based fungible token with anonymity, and encryption
/// @author Kaleido, Inc.
/// @dev The proof has the following statements:
///        - each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
///        - the sum of the input values match the sum of output values
///        - the hashes in the input and output match the hash(value, salt, owner public key) formula
///        - the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes
///        - the encrypted value in the input is derived from the receiver's UTXO value and encrypted with a shared secret using
///          the ECDH protocol between the sender and receiver (this guarantees data availability for the receiver)
contract Zeto_AnonEnc is
    IZetoEncrypted,
    ZetoBase,
    ZetoFungibleWithdraw,
    UUPSUpgradeable
{
    Groth16Verifier_AnonEnc internal verifier;
    Groth16Verifier_AnonEncBatch internal batchVerifier;

    function initialize(
        address initialOwner,
        Groth16Verifier_AnonEnc _verifier,
        Groth16Verifier_CheckHashesValue _depositVerifier,
        Groth16Verifier_CheckInputsOutputsValue _withdrawVerifier,
        Groth16Verifier_AnonEncBatch _batchVerifier,
        Groth16Verifier_CheckInputsOutputsValueBatch _batchWithdrawVerifier
    ) public initializer {
        __ZetoBase_init(initialOwner);
        __ZetoFungibleWithdraw_init(
            _depositVerifier,
            _withdrawVerifier,
            _batchWithdrawVerifier
        );
        verifier = _verifier;
        batchVerifier = _batchVerifier;
        batchVerifier = _batchVerifier;
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function constructPublicInputs(
        uint256[] memory inputs,
        uint256[] memory outputs,
        uint256 encryptionNonce,
        uint256[2] memory ecdhPublicKey,
        uint256[] memory encryptedValues,
        uint256 size
    ) internal pure returns (uint256[] memory publicInputs) {
        publicInputs = new uint256[](size);
        uint256 piIndex = 0;
        // copy the ecdh public key
        for (uint256 i = 0; i < ecdhPublicKey.length; ++i) {
            publicInputs[piIndex++] = ecdhPublicKey[i];
        }

        // copy the encrypted value, salt and parity bit
        for (uint256 i = 0; i < encryptedValues.length; ++i) {
            publicInputs[piIndex++] = encryptedValues[i];
        }
        // copy input commitments
        for (uint256 i = 0; i < inputs.length; i++) {
            publicInputs[piIndex++] = inputs[i];
        }

        // copy output commitments
        for (uint256 i = 0; i < outputs.length; i++) {
            publicInputs[piIndex++] = outputs[i];
        }

        // copy encryption nonce
        publicInputs[piIndex++] = encryptionNonce;

        return publicInputs;
    }

    /**
     * @dev the main function of the contract.
     *
     * @param inputs Array of UTXOs to be spent by the transaction.
     * @param outputs Array of new UTXOs to generate, for future transactions to spend.
     * @param proof A zero knowledge proof that the submitter is authorized to spend the inputs, and
     *      that the outputs are valid in terms of obeying mass conservation rules.
     *
     * Emits a {UTXOTransferWithEncryptedValues} event.
     */
    function transfer(
        uint256[] memory inputs,
        uint256[] memory outputs,
        uint256 encryptionNonce,
        uint256[2] memory ecdhPublicKey,
        uint256[] memory encryptedValues,
        Commonlib.Proof calldata proof,
        bytes calldata data
    ) public returns (bool) {
        // Check and pad commitments
        (inputs, outputs) = checkAndPadCommitments(inputs, outputs, MAX_BATCH);
        require(
            validateTransactionProposal(inputs, outputs, proof),
            "Invalid transaction proposal"
        );

        // Check the proof
        if (inputs.length > 2 || outputs.length > 2) {
            uint256[] memory publicInputs = constructPublicInputs(
                inputs,
                outputs,
                encryptionNonce,
                ecdhPublicKey,
                encryptedValues,
                BATCH_INPUT_SIZE
            );
            // construct the public inputs for batchVerifier
            uint256[BATCH_INPUT_SIZE] memory fixedSizeInputs;
            for (uint256 i = 0; i < fixedSizeInputs.length; i++) {
                fixedSizeInputs[i] = publicInputs[i];
            }

            // Check the proof using batchVerifier
            require(
                batchVerifier.verifyProof(
                    proof.pA,
                    proof.pB,
                    proof.pC,
                    fixedSizeInputs
                ),
                "Invalid proof"
            );
        } else {
            uint256[] memory publicInputs = constructPublicInputs(
                inputs,
                outputs,
                encryptionNonce,
                ecdhPublicKey,
                encryptedValues,
                INPUT_SIZE
            );
            // construct the public inputs for verifier
            uint256[INPUT_SIZE] memory fixedSizeInputs;
            for (uint256 i = 0; i < fixedSizeInputs.length; i++) {
                fixedSizeInputs[i] = publicInputs[i];
            }
            // Check the proof
            require(
                verifier.verifyProof(
                    proof.pA,
                    proof.pB,
                    proof.pC,
                    fixedSizeInputs
                ),
                "Invalid proof"
            );
        }

        processInputsAndOutputs(inputs, outputs);

        uint256[] memory encryptedValuesArray = new uint256[](
            encryptedValues.length
        );
        for (uint256 i = 0; i < encryptedValues.length; ++i) {
            encryptedValuesArray[i] = encryptedValues[i];
        }

        emit UTXOTransferWithEncryptedValues(
            inputs,
            outputs,
            encryptionNonce,
            ecdhPublicKey,
            encryptedValuesArray,
            msg.sender,
            data
        );
        return true;
    }

    function deposit(
        uint256 amount,
        uint256 utxo,
        Commonlib.Proof calldata proof,
        bytes calldata data
    ) public {
        _deposit(amount, utxo, proof);
        uint256[] memory utxos = new uint256[](1);
        utxos[0] = utxo;
        _mint(utxos, data);
    }

    function withdraw(
        uint256 amount,
        uint256[] memory inputs,
        uint256 output,
        Commonlib.Proof calldata proof
    ) public {
        uint256[] memory outputs = new uint256[](inputs.length);
        outputs[0] = output;
        // Check and pad commitments
        (inputs, outputs) = checkAndPadCommitments(inputs, outputs, MAX_BATCH);
        validateTransactionProposal(inputs, outputs, proof);
        _withdraw(amount, inputs, output, proof);
        processInputsAndOutputs(inputs, outputs);
    }

    function mint(
        uint256[] memory utxos,
        bytes calldata data
    ) public onlyOwner {
        _mint(utxos, data);
    }
}
