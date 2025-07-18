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

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {IGroth16Verifier} from "./lib/interfaces/izeto_verifier.sol";
import {ZetoNullifier} from "./lib/zeto_nullifier.sol";
import {ZetoFungibleWithdrawWithNullifiers} from "./lib/zeto_fungible_withdraw_nullifier.sol";
import {Commonlib} from "./lib/common.sol";
import {IZetoInitializable} from "./lib/interfaces/izeto_initializable.sol";

/// @title A sample implementation of a Zeto based fungible token with anonymity, encryption and history masking
/// @author Kaleido, Inc.
/// @dev The proof has the following statements:
///        - each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
///        - the sum of the nullified values match the sum of output values
///        - the hashes in the input and output match the hash(value, salt, owner public key) formula
///        - the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes, which match the corresponding nullifiers
///        - the encrypted value in the input is derived from the receiver's UTXO value and encrypted with a shared secret using the ECDH protocol between the sender and receiver (this guarantees data availability for the receiver)
///        - the nullifiers represent input commitments that are included in a Sparse Merkle Tree represented by the root hash
contract Zeto_AnonEncNullifierNonRepudiation is
    ZetoNullifier,
    ZetoFungibleWithdrawWithNullifiers,
    UUPSUpgradeable
{
    event UTXOTransferNonRepudiation(
        uint256[] inputs,
        uint256[] outputs,
        uint256 encryptionNonce,
        uint256[2] ecdhPublicKey,
        uint256[] encryptedValuesForReceiver,
        uint256[] encryptedValuesForAuthority,
        address indexed submitter,
        bytes data
    );
    // the arbiter public key that must be used to
    // encrypt the secrets of every transaction
    uint256[2] private arbiter;

    function initialize(
        string memory name,
        string memory symbol,
        address initialOwner,
        IZetoInitializable.VerifiersInfo calldata verifiers
    ) public initializer {
        __ZetoNullifier_init(name, symbol, initialOwner, verifiers);
        __ZetoFungibleWithdrawWithNullifiers_init(
            (IGroth16Verifier)(verifiers.depositVerifier),
            (IGroth16Verifier)(verifiers.withdrawVerifier),
            (IGroth16Verifier)(verifiers.batchWithdrawVerifier)
        );
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function setArbiter(uint256[2] memory _arbiter) public onlyOwner {
        arbiter = _arbiter;
    }

    function getArbiter() public view returns (uint256[2] memory) {
        return arbiter;
    }

    function constructPublicInputs(
        uint256[] memory nullifiers,
        uint256[] memory outputs,
        uint256 root,
        uint256 encryptionNonce,
        uint256[2] memory ecdhPublicKey,
        uint256[] memory encryptedValuesForReceiver,
        uint256[] memory encryptedValuesForAuthority
    ) internal view returns (uint256[] memory publicInputs) {
        uint256 size = ecdhPublicKey.length +
            encryptedValuesForReceiver.length +
            encryptedValuesForAuthority.length +
            (nullifiers.length * 2) + // nullifiers and enabled flags
            outputs.length +
            2 + // root and encryptionNonce
            2; // arbiter public key
        publicInputs = new uint256[](size);
        uint256 piIndex = 0;
        // copy the ecdh public key
        for (uint256 i = 0; i < ecdhPublicKey.length; ++i) {
            publicInputs[piIndex++] = ecdhPublicKey[i];
        }
        // copy the encrypted value, salt and parity bit for receiver
        for (uint256 i = 0; i < encryptedValuesForReceiver.length; ++i) {
            publicInputs[piIndex++] = encryptedValuesForReceiver[i];
        }
        // copy the encrypted value, salt and parity bit for authority
        for (uint256 i = 0; i < encryptedValuesForAuthority.length; ++i) {
            publicInputs[piIndex++] = encryptedValuesForAuthority[i];
        }
        // copy input commitments
        for (uint256 i = 0; i < nullifiers.length; i++) {
            publicInputs[piIndex++] = nullifiers[i];
        }

        // copy root
        publicInputs[piIndex++] = root;

        // populate enables
        for (uint256 i = 0; i < nullifiers.length; i++) {
            publicInputs[piIndex++] = (nullifiers[i] == 0) ? 0 : 1;
        }

        // copy output commitments
        for (uint256 i = 0; i < outputs.length; i++) {
            publicInputs[piIndex++] = outputs[i];
        }

        // copy encryption nonce
        publicInputs[piIndex++] = encryptionNonce;

        // copy arbiter pub key
        publicInputs[piIndex++] = arbiter[0];
        publicInputs[piIndex++] = arbiter[1];
        return publicInputs;
    }

    /**
     * @dev the main function of the contract, which transfers values from one account (represented by Babyjubjub public keys)
     *      to one or more receiver accounts (also represented by Babyjubjub public keys). One of the two nullifiers may be zero
     *      if the transaction only needs one UTXO to be spent. Equally one of the two outputs may be zero if the transaction
     *      only needs to create one new UTXO.
     *
     * @param nullifiers Array of nullifiers that are secretly bound to UTXOs to be spent by the transaction.
     * @param outputs Array of new UTXOs to generate, for future transactions to spend.
     * @param root The root hash of the Sparse Merkle Tree that contains the nullifiers.
     * @param encryptionNonce The nonce used to derive the shared secret for encryption by the receiver.
     * @param encryptedValuesForReceiver Array of encrypted values, salts and public keys for the receiver UTXO
     * @param encryptedValuesForAuthority Array of encrypted values, salts and public keys for the input UTXOs and output UTXOs.
     * @param proof A zero knowledge proof that the submitter is authorized to spend the inputs, and
     *      that the outputs are valid in terms of obeying mass conservation rules.
     *
     * Emits a {UTXOTransferNonRepudiation} event.
     */
    function transfer(
        uint256[] memory nullifiers,
        uint256[] memory outputs,
        uint256 root,
        uint256 encryptionNonce,
        uint256[2] memory ecdhPublicKey,
        uint256[] memory encryptedValuesForReceiver,
        uint256[] memory encryptedValuesForAuthority,
        Commonlib.Proof calldata proof,
        bytes calldata data
    ) public returns (bool) {
        // Check and pad commitments
        nullifiers = checkAndPadCommitments(nullifiers);
        outputs = checkAndPadCommitments(outputs);
        validateTransactionProposal(nullifiers, outputs, root, false);

        // Check the proof
        if (nullifiers.length > 2 || outputs.length > 2) {
            require(
                (encryptedValuesForAuthority.length == 64),
                "Cipher Text for Authority must have a length of 64 with input or outputs number more than 2 and less than 10"
            );
        } else {
            require(
                (encryptedValuesForAuthority.length == 16),
                "Cipher Text for Authority must have a length of 16 for no more than 2 inputs or outputs"
            );
        }
        uint256[] memory publicInputs = constructPublicInputs(
            nullifiers,
            outputs,
            root,
            encryptionNonce,
            ecdhPublicKey,
            encryptedValuesForReceiver,
            encryptedValuesForAuthority
        );
        bool isBatch = (nullifiers.length > 2 || outputs.length > 2);
        verifyProof(proof, publicInputs, isBatch, false);

        // accept the transaction to consume the input UTXOs and produce new UTXOs
        uint256[] memory empty;
        processInputsAndOutputs(nullifiers, outputs, empty, address(0));

        uint256[] memory encryptedValuesReceiverArray = new uint256[](
            encryptedValuesForReceiver.length
        );
        uint256[] memory encryptedValuesAuthorityArray = new uint256[](
            encryptedValuesForAuthority.length
        );
        for (uint256 i = 0; i < encryptedValuesForReceiver.length; ++i) {
            encryptedValuesReceiverArray[i] = encryptedValuesForReceiver[i];
        }
        for (uint256 i = 0; i < encryptedValuesForAuthority.length; ++i) {
            encryptedValuesAuthorityArray[i] = encryptedValuesForAuthority[i];
        }

        emit UTXOTransferNonRepudiation(
            nullifiers,
            outputs,
            encryptionNonce,
            ecdhPublicKey,
            encryptedValuesReceiverArray,
            encryptedValuesAuthorityArray,
            msg.sender,
            data
        );
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
        uint256[] memory nullifiers,
        uint256 output,
        uint256 root,
        Commonlib.Proof calldata proof,
        bytes calldata data
    ) public {
        uint256[] memory outputs = new uint256[](nullifiers.length);
        outputs[0] = output;
        // Check and pad commitments
        nullifiers = checkAndPadCommitments(nullifiers);
        outputs = checkAndPadCommitments(outputs);
        validateTransactionProposal(nullifiers, outputs, root, false);

        _withdrawWithNullifiers(amount, nullifiers, output, root, proof);
        uint256[] memory empty;
        processInputsAndOutputs(nullifiers, outputs, empty, address(0));
        emit UTXOWithdraw(amount, nullifiers, output, msg.sender, data);
    }

    function mint(
        uint256[] memory utxos,
        bytes calldata data
    ) public onlyOwner {
        _mint(utxos, data);
    }
}
