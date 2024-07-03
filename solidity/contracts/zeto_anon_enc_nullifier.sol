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

import {Groth16Verifier_AnonEncNullifier} from "./lib/verifier_anon_enc_nullifier.sol";
import {ZetoNullifier} from "./lib/zeto_nullifier.sol";
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
contract Zeto_AnonEncNullifier is ZetoNullifier {
    Groth16Verifier_AnonEncNullifier verifier;

    constructor(
        Groth16Verifier_AnonEncNullifier _verifier,
        Registry _registry
    ) ZetoNullifier(_registry) {
        verifier = _verifier;
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
     * @param proof A zero knowledge proof that the submitter is authorized to spend the inputs, and
     *      that the outputs are valid in terms of obeying mass conservation rules.
     *
     * Emits a {UTXOTransferWithEncryptedValues} event.
     */
    function transfer(
        uint256[2] memory nullifiers,
        uint256[2] memory outputs,
        uint256 root,
        uint256 encryptionNonce,
        uint256[2] memory encryptedValues,
        Commonlib.Proof calldata proof
    ) public returns (bool) {
        require(
            validateTransactionProposal(nullifiers, outputs, root, proof),
            "Invalid transaction proposal"
        );

        // construct the public inputs
        uint256[10] memory publicInputs;
        publicInputs[0] = encryptedValues[0]; // encrypted value for the receiver UTXO
        publicInputs[1] = encryptedValues[1]; // encrypted salt for the receiver UTXO
        publicInputs[2] = nullifiers[0];
        publicInputs[3] = nullifiers[1];
        publicInputs[4] = root;
        publicInputs[5] = (nullifiers[0] == 0) ? 0 : 1; // enable MT proof for the first nullifier
        publicInputs[6] = (nullifiers[1] == 0) ? 0 : 1; // enable MT proof for the second nullifier
        publicInputs[7] = outputs[0];
        publicInputs[8] = outputs[1];
        publicInputs[9] = encryptionNonce;

        // // Check the proof
        require(
            verifier.verifyProof(proof.pA, proof.pB, proof.pC, publicInputs),
            "Invalid proof"
        );

        // accept the transaction to consume the input UTXOs and produce new UTXOs
        processInputsAndOutputs(nullifiers, outputs);

        uint256[] memory nullifierArray = new uint256[](nullifiers.length);
        uint256[] memory outputArray = new uint256[](outputs.length);
        uint256[] memory encryptedValuesArray = new uint256[](
            encryptedValues.length
        );
        for (uint256 i = 0; i < nullifiers.length; ++i) {
            nullifierArray[i] = nullifiers[i];
            outputArray[i] = outputs[i];
            encryptedValuesArray[i] = encryptedValues[i];
        }

        emit UTXOTransferWithEncryptedValues(
            nullifierArray,
            outputArray,
            encryptionNonce,
            encryptedValuesArray,
            msg.sender
        );
        return true;
    }
}
