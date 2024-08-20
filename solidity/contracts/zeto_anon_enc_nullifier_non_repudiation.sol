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

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Groth16Verifier_CheckHashesValue} from "./lib/verifier_check_hashes_value.sol";
import {Groth16Verifier_CheckNullifierValue} from "./lib/verifier_check_nullifier_value.sol";
import {Groth16Verifier_AnonEncNullifierNonRepudiation} from "./lib/verifier_anon_enc_nullifier_non_repudiation.sol";
import {ZetoNullifier} from "./lib/zeto_nullifier.sol";
import {ZetoFungibleWithdrawWithNullifiers} from "./lib/zeto_fungible_withdraw_nullifier.sol";
import {Registry} from "./lib/registry.sol";
import {Commonlib} from "./lib/common.sol";
import "hardhat/console.sol";

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
        uint256[] encryptedValuesForReceiver,
        uint256[] encryptedValuesForAuthority,
        address indexed submitter
    );

    Groth16Verifier_AnonEncNullifierNonRepudiation verifier;
    // the arbiter public key that must be used to
    // encrypt the secrets of every transaction
    uint256[2] private arbiter;

    function initialize(
        address authority,
        Groth16Verifier_CheckHashesValue _depositVerifier,
        Groth16Verifier_CheckNullifierValue _withdrawVerifier,
        Groth16Verifier_AnonEncNullifierNonRepudiation _verifier
    ) public initializer {
        __ZetoNullifier_init(authority);
        __ZetoFungibleWithdrawWithNullifiers_init(
            _depositVerifier,
            _withdrawVerifier
        );
        verifier = _verifier;
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function setArbiter(uint256[2] memory _arbiter) public onlyOwner {
        arbiter = _arbiter;
    }

    function getArbiter() public view returns (uint256[2] memory) {
        return arbiter;
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
        uint256[2] memory nullifiers,
        uint256[2] memory outputs,
        uint256 root,
        uint256 encryptionNonce,
        uint256[2] memory encryptedValuesForReceiver,
        uint256[14] memory encryptedValuesForAuthority,
        Commonlib.Proof calldata proof
    ) public returns (bool) {
        require(
            validateTransactionProposal(nullifiers, outputs, root),
            "Invalid transaction proposal"
        );

        // construct the public inputs
        uint256[26] memory publicInputs;
        publicInputs[0] = encryptedValuesForReceiver[0]; // encrypted value for the receiver UTXO
        publicInputs[1] = encryptedValuesForReceiver[1]; // encrypted salt for the receiver UTXO
        publicInputs[2] = encryptedValuesForAuthority[0]; // encrypted input owner public key[0]
        publicInputs[3] = encryptedValuesForAuthority[1]; // encrypted input owner public key[1]
        publicInputs[4] = encryptedValuesForAuthority[2]; // encrypted input value[0]
        publicInputs[5] = encryptedValuesForAuthority[3]; // encrypted input salt[0]
        publicInputs[6] = encryptedValuesForAuthority[4]; // encrypted input value[1]
        publicInputs[7] = encryptedValuesForAuthority[5]; // encrypted input salt[1]
        publicInputs[8] = encryptedValuesForAuthority[6]; // encrypted first output owner public key[0]
        publicInputs[9] = encryptedValuesForAuthority[7]; // encrypted first output owner public key[1]
        publicInputs[10] = encryptedValuesForAuthority[8]; // encrypted second output owner public key[0]
        publicInputs[11] = encryptedValuesForAuthority[9]; // encrypted second output owner public key[1]
        publicInputs[12] = encryptedValuesForAuthority[10]; // encrypted output value[0]
        publicInputs[13] = encryptedValuesForAuthority[11]; // encrypted output salt[0]
        publicInputs[14] = encryptedValuesForAuthority[12]; // encrypted output value[1]
        publicInputs[15] = encryptedValuesForAuthority[13]; // encrypted output salt[1]
        publicInputs[16] = nullifiers[0];
        publicInputs[17] = nullifiers[1];
        publicInputs[18] = root;
        publicInputs[19] = (nullifiers[0] == 0) ? 0 : 1; // if the first nullifier is empty, disable its MT proof verification
        publicInputs[20] = (nullifiers[1] == 0) ? 0 : 1; // if the second nullifier is empty, disable its MT proof verification
        publicInputs[21] = outputs[0];
        publicInputs[22] = outputs[1];
        publicInputs[23] = encryptionNonce;
        publicInputs[24] = arbiter[0];
        publicInputs[25] = arbiter[1];

        // // Check the proof
        require(
            verifier.verifyProof(proof.pA, proof.pB, proof.pC, publicInputs),
            "Invalid proof"
        );

        // accept the transaction to consume the input UTXOs and produce new UTXOs
        processInputsAndOutputs(nullifiers, outputs);

        uint256[] memory nullifierArray = new uint256[](nullifiers.length);
        uint256[] memory outputArray = new uint256[](outputs.length);
        uint256[] memory encryptedValuesReceiverArray = new uint256[](
            encryptedValuesForReceiver.length
        );
        uint256[] memory encryptedValuesAuthorityArray = new uint256[](
            encryptedValuesForAuthority.length
        );
        for (uint256 i = 0; i < nullifiers.length; ++i) {
            nullifierArray[i] = nullifiers[i];
            outputArray[i] = outputs[i];
        }
        for (uint256 i = 0; i < encryptedValuesForReceiver.length; ++i) {
            encryptedValuesReceiverArray[i] = encryptedValuesForReceiver[i];
        }
        for (uint256 i = 0; i < encryptedValuesForAuthority.length; ++i) {
            encryptedValuesAuthorityArray[i] = encryptedValuesForAuthority[i];
        }

        emit UTXOTransferNonRepudiation(
            nullifierArray,
            outputArray,
            encryptionNonce,
            encryptedValuesReceiverArray,
            encryptedValuesAuthorityArray,
            msg.sender
        );
        return true;
    }

    function deposit(
        uint256 amount,
        uint256 utxo,
        Commonlib.Proof calldata proof
    ) public {
        _deposit(amount, utxo, proof);
        uint256[] memory utxos = new uint256[](1);
        utxos[0] = utxo;
        _mint(utxos);
    }

    function withdraw(
        uint256 amount,
        uint256[2] memory nullifiers,
        uint256 output,
        uint256 root,
        Commonlib.Proof calldata proof
    ) public {
        validateTransactionProposal(nullifiers, [output, 0], root);
        _withdrawWithNullifiers(amount, nullifiers, output, root, proof);
        processInputsAndOutputs(nullifiers, [output, 0]);
    }

    function mint(uint256[] memory utxos) public onlyOwner {
        _mint(utxos);
    }
}
