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
import {Groth16Verifier_NfAnonNullifierTransfer} from "./verifiers/verifier_nf_anon_nullifier_transfer.sol";
import {Groth16Verifier_NfAnonNullifierTransferLocked} from "./verifiers/verifier_nf_anon_nullifier_transferLocked.sol";
import {ZetoNullifier} from "./lib/zeto_nullifier.sol";
import {Commonlib} from "./lib/common.sol";
import {IZetoInitializable} from "./lib/interfaces/izeto_initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/// @title A sample implementation of a Zeto based non-fungible token with anonymity and history masking
/// @author Kaleido, Inc.
/// @dev The proof has the following statements:
///        - each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
///        - the sum of the nullified values match the sum of output values
///        - the hashes in the input and output match the hash(value, salt, owner public key) formula
///        - the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes, which match the corresponding nullifiers
///        - the nullifiers represent input commitments that are included in a Sparse Merkle Tree represented by the root hash
contract Zeto_NfAnonNullifier is
    IZeto,
    IZetoInitializable,
    ZetoNullifier,
    UUPSUpgradeable
{
    Groth16Verifier_NfAnonNullifierTransfer _verifier;
    Groth16Verifier_NfAnonNullifierTransferLocked _lockVerifier;

    function initialize(
        address initialOwner,
        IZetoInitializable.VerifiersInfo calldata verifiers
    ) public initializer {
        __ZetoNullifier_init(initialOwner);
        _verifier = (Groth16Verifier_NfAnonNullifierTransfer)(
            verifiers.verifier
        );
        _lockVerifier = (Groth16Verifier_NfAnonNullifierTransferLocked)(
            verifiers.lockVerifier
        );
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    /**
     * @dev the main function of the contract.
     *
     * @param nullifier A nullifier that are secretly bound to the UTXO to be spent by the transaction.
     * @param output new UTXO to generate, for future transactions to spend.
     * @param root The root hash of the Sparse Merkle Tree that contains the nullifier.
     * @param proof A zero knowledge proof that the submitter is authorized to spend the inputs, and
     *      that the outputs are valid in terms of obeying mass conservation rules.
     *
     * Emits a {UTXOTransfer} event.
     */
    function transfer(
        uint256 nullifier,
        uint256 output,
        uint256 root,
        Commonlib.Proof calldata proof,
        bytes calldata data
    ) public returns (bool) {
        uint256[] memory nullifiers = new uint256[](1);
        nullifiers[0] = nullifier;
        uint256[] memory outputs = new uint256[](1);
        outputs[0] = output;
        validateTransactionProposal(nullifiers, outputs, root, false);
        checkProof(nullifiers, outputs, root, proof);
        uint256[] memory empty;
        processInputsAndOutputs(nullifiers, outputs, empty, address(0));

        emit UTXOTransfer(nullifiers, outputs, msg.sender, data);
        return true;
    }

    /**
     * @dev the main function of the contract.
     *
     * @param nullifier A nullifier that are secretly bound to the UTXO to be spent by the transaction.
     * @param output new UTXO to generate, for future transactions to spend.
     * @param root The root hash of the Sparse Merkle Tree that contains the nullifier.
     * @param proof A zero knowledge proof that the submitter is authorized to spend the inputs, and
     *      that the outputs are valid in terms of obeying mass conservation rules.
     *
     * Emits a {UTXOTransfer} event.
     */
    function transferLocked(
        uint256 nullifier,
        uint256 output,
        uint256 root,
        Commonlib.Proof calldata proof,
        bytes calldata data
    ) public returns (bool) {
        uint256[] memory nullifiers = new uint256[](1);
        nullifiers[0] = nullifier;
        uint256[] memory outputs = new uint256[](1);
        outputs[0] = output;
        validateTransactionProposal(nullifiers, outputs, root, true);
        checkProofLocked(nullifiers, outputs, root, proof);
        uint256[] memory empty;
        processInputsAndOutputs(nullifiers, outputs, empty, address(0));

        emit UTXOTransfer(nullifiers, outputs, msg.sender, data);
        return true;
    }

    function mint(uint256[] memory utxos, bytes calldata data) public {
        _mint(utxos, data);
    }

    function lock(
        uint256 nullifier,
        uint256 lockedOutput,
        uint256 root,
        Commonlib.Proof calldata proof,
        address delegate,
        bytes calldata data
    ) public {
        uint256[] memory nullifiers = new uint256[](1);
        nullifiers[0] = nullifier;
        uint256[] memory lockedOutputs = new uint256[](1);
        lockedOutputs[0] = lockedOutput;
        validateTransactionProposal(nullifiers, lockedOutputs, root, false);
        checkProof(nullifiers, lockedOutputs, root, proof);

        processNullifiers(nullifiers);

        // lock the intended outputs
        uint256[] memory outputs;
        _lock(nullifiers, outputs, lockedOutputs, delegate, data);
    }

    function checkProof(
        uint256[] memory nullifiers,
        uint256[] memory outputs,
        uint256 root,
        Commonlib.Proof calldata proof
    ) internal view {
        // construct the public inputs
        uint256[3] memory publicInputs;
        publicInputs[0] = nullifiers[0];
        publicInputs[1] = root;
        publicInputs[2] = outputs[0];

        // Check the proof
        require(
            _verifier.verifyProof(proof.pA, proof.pB, proof.pC, publicInputs),
            "Invalid proof"
        );
    }

    function checkProofLocked(
        uint256[] memory nullifiers,
        uint256[] memory outputs,
        uint256 root,
        Commonlib.Proof calldata proof
    ) internal view {
        // construct the public inputs
        uint256[4] memory publicInputs;
        publicInputs[0] = nullifiers[0];
        publicInputs[1] = uint256(uint160(msg.sender));
        publicInputs[2] = root;
        publicInputs[3] = outputs[0];

        // Check the proof
        require(
            _lockVerifier.verifyProof(
                proof.pA,
                proof.pB,
                proof.pC,
                publicInputs
            ),
            "Invalid proof"
        );
    }
}
