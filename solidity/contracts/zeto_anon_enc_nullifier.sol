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
import {Zeto_AnonNullifier} from "./zeto_anon_nullifier.sol";
import {Commonlib} from "./lib/common/common.sol";
import {IZetoInitializable} from "./lib/interfaces/izeto_initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/// @title A sample implementation of a Zeto based fungible token with anonymity, encryption and history masking
/// @author Kaleido, Inc.
/// @dev The proof has the following statements:
///        - each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
///        - the sum of the nullified values match the sum of output values
///        - the hashes in the input and output match the hash(value, salt, owner public key) formula
///        - the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes, which match the corresponding nullifiers
///        - the encrypted value in the input is derived from the receiver's UTXO value and encrypted with a shared secret using the ECDH protocol between the sender and receiver (this guarantees data availability for the receiver)
///        - the nullifiers represent input commitments that are included in a Sparse Merkle Tree represented by the root hash
contract Zeto_AnonEncNullifier is Zeto_AnonNullifier {
    struct _DecodedProof_EncNullifier {
        uint256 root;
        uint256 encryptionNonce;
        uint256[2] ecdhPublicKey;
        uint256[] encryptedValues;
    }

    function initialize(
        string memory name,
        string memory symbol,
        address initialOwner,
        IZetoInitializable.VerifiersInfo calldata verifiers
    ) public virtual override initializer {
        __ZetoAnonEncNullifier_init(name, symbol, initialOwner, verifiers);
    }

    function __ZetoAnonEncNullifier_init(
        string memory name_,
        string memory symbol_,
        address initialOwner,
        IZetoInitializable.VerifiersInfo calldata verifiers
    ) internal onlyInitializing {
        __ZetoAnonNullifier_init(name_, symbol_, initialOwner, verifiers);
    }

    function constructPublicInputs(
        uint256[] memory nullifiers,
        uint256[] memory outputs,
        bytes memory proof,
        bool inputsLocked
    )
        internal
        view
        virtual
        override
        returns (uint256[] memory, Commonlib.Proof memory)
    {
        (
            _DecodedProof_EncNullifier memory dp,
            Commonlib.Proof memory proofStruct
        ) = decodeProof(proof);
        uint256[] memory extra = extraInputs();
        uint256 size = _calculatePublicInputsSize(
            nullifiers,
            outputs,
            extra,
            dp
        );

        uint256[] memory publicInputs = new uint256[](size);
        _fillPublicInputs(publicInputs, nullifiers, outputs, extra, dp);
        return (publicInputs, proofStruct);
    }

    function decodeProof(
        bytes memory proof
    )
        private
        pure
        returns (_DecodedProof_EncNullifier memory, Commonlib.Proof memory)
    {
        (
            uint256 root,
            uint256 encryptionNonce,
            uint256[2] memory ecdhPublicKey,
            uint256[] memory encryptedValues,
            Commonlib.Proof memory proofStruct
        ) = abi.decode(
                proof,
                (uint256, uint256, uint256[2], uint256[], Commonlib.Proof)
            );
        _DecodedProof_EncNullifier memory dp = _DecodedProof_EncNullifier(
            root,
            encryptionNonce,
            ecdhPublicKey,
            encryptedValues
        );
        return (dp, proofStruct);
    }

    function _calculatePublicInputsSize(
        uint256[] memory nullifiers,
        uint256[] memory outputs,
        uint256[] memory extra,
        _DecodedProof_EncNullifier memory dp
    ) internal pure returns (uint256) {
        return
            (nullifiers.length * 2) + // nullifiers and enabled flags
            2 + // root and encryption nonce
            dp.ecdhPublicKey.length + // ecdh public key
            dp.encryptedValues.length + // encrypted values
            extra.length + // extra inputs
            outputs.length; // outputs
    }

    function _fillPublicInputs(
        uint256[] memory publicInputs,
        uint256[] memory nullifiers,
        uint256[] memory outputs,
        uint256[] memory extra,
        _DecodedProof_EncNullifier memory dp
    ) internal pure {
        uint256 piIndex = 0;

        // Split into smaller functions to reduce stack usage
        piIndex = _fillEcdhAndEncryptedValues(publicInputs, dp, piIndex);
        piIndex = _fillNullifiersAndRoot(publicInputs, nullifiers, dp, piIndex);
        piIndex = _fillEnablesAndExtra(
            publicInputs,
            nullifiers,
            extra,
            piIndex
        );
        _fillOutputsAndNonce(publicInputs, outputs, dp, piIndex);
    }

    function _fillEcdhAndEncryptedValues(
        uint256[] memory publicInputs,
        _DecodedProof_EncNullifier memory dp,
        uint256 piIndex
    ) internal pure returns (uint256) {
        // copy the ecdh public key
        for (uint256 i = 0; i < dp.ecdhPublicKey.length; ++i) {
            publicInputs[piIndex++] = dp.ecdhPublicKey[i];
        }
        // copy the encrypted value, salt and parity bit
        for (uint256 i = 0; i < dp.encryptedValues.length; ++i) {
            publicInputs[piIndex++] = dp.encryptedValues[i];
        }
        return piIndex;
    }

    function _fillNullifiersAndRoot(
        uint256[] memory publicInputs,
        uint256[] memory nullifiers,
        _DecodedProof_EncNullifier memory dp,
        uint256 piIndex
    ) internal pure returns (uint256) {
        // copy input commitments
        for (uint256 i = 0; i < nullifiers.length; i++) {
            publicInputs[piIndex++] = nullifiers[i];
        }
        // copy root
        publicInputs[piIndex++] = dp.root;
        return piIndex;
    }

    function _fillEnablesAndExtra(
        uint256[] memory publicInputs,
        uint256[] memory nullifiers,
        uint256[] memory extra,
        uint256 piIndex
    ) internal pure returns (uint256) {
        // populate enables
        for (uint256 i = 0; i < nullifiers.length; i++) {
            publicInputs[piIndex++] = (nullifiers[i] == 0) ? 0 : 1;
        }
        // insert extra inputs if any
        for (uint256 i = 0; i < extra.length; i++) {
            publicInputs[piIndex++] = extra[i];
        }
        return piIndex;
    }

    function _fillOutputsAndNonce(
        uint256[] memory publicInputs,
        uint256[] memory outputs,
        _DecodedProof_EncNullifier memory dp,
        uint256 piIndex
    ) internal pure {
        // copy output commitments
        for (uint256 i = 0; i < outputs.length; i++) {
            publicInputs[piIndex++] = outputs[i];
        }
        // copy encryption nonce
        publicInputs[piIndex++] = dp.encryptionNonce;
    }

    function extraInputs()
        internal
        view
        virtual
        override
        returns (uint256[] memory)
    {
        // no extra inputs for this contract
        uint256[] memory empty = new uint256[](0);
        return empty;
    }

    /**
     * @dev the main function of the contract, which transfers values from one account (represented by Babyjubjub public keys)
     *      to one or more receiver accounts (also represented by Babyjubjub public keys). One of the two nullifiers may be zero
     *      if the transaction only needs one UTXO to be spent. Equally one of the two outputs may be zero if the transaction
     *      only needs to create one new UTXO.
     *
     * @param nullifiers Array of nullifiers that are secretly bound to UTXOs to be spent by the transaction.
     * @param outputs Array of new UTXOs to generate, for future transactions to spend.
     * @param proof A zero knowledge proof that the submitter is authorized to spend the inputs, and
     *      that the outputs are valid in terms of obeying mass conservation rules.
     *
     * Emits a {UTXOTransferWithEncryptedValues} event.
     */
    function transfer(
        uint256[] memory nullifiers,
        uint256[] memory outputs,
        bytes calldata proof,
        bytes calldata data
    ) public virtual override {
        super.transfer(nullifiers, outputs, proof, data);
        (
            uint256 root,
            uint256 encryptionNonce,
            uint256[2] memory ecdhPublicKey,
            uint256[] memory encryptedValues,
            Commonlib.Proof memory proofStruct
        ) = abi.decode(
                proof,
                (uint256, uint256, uint256[2], uint256[], Commonlib.Proof)
            );

        nullifiers = checkAndPadCommitments(nullifiers);
        outputs = checkAndPadCommitments(outputs);
        emit UTXOTransferWithEncryptedValues(
            nullifiers,
            outputs,
            encryptionNonce,
            ecdhPublicKey,
            encryptedValues,
            msg.sender,
            data
        );
    }
}
