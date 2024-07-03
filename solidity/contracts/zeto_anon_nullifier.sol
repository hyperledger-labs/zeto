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

import {Groth16Verifier_AnonNullifier} from "./lib/verifier_anon_nullifier.sol";
import {ZetoNullifier} from "./lib/zeto_nullifier.sol";
import {Registry} from "./lib/registry.sol";
import {Commonlib} from "./lib/common.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {SmtLib} from "@iden3/contracts/lib/SmtLib.sol";
import {PoseidonUnit3L} from "@iden3/contracts/lib/Poseidon.sol";
import "hardhat/console.sol";

uint256 constant MAX_SMT_DEPTH = 64;

/// @title A sample implementation of a Zeto based fungible token with anonymity and history masking
/// @author Kaleido, Inc.
/// @dev The proof has the following statements:
///        - each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
///        - the sum of the nullified values match the sum of output values
///        - the hashes in the input and output match the hash(value, salt, owner public key) formula
///        - the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes, which match the corresponding nullifiers
///        - the nullifiers represent input commitments that are included in a Sparse Merkle Tree represented by the root hash
contract Zeto_AnonNullifier is ZetoNullifier {
    Groth16Verifier_AnonNullifier verifier;

    constructor(
        Groth16Verifier_AnonNullifier _verifier,
        Registry _registry
    ) ZetoNullifier(_registry) {
        verifier = _verifier;
    }

    /**
     * @dev the main function of the contract.
     *
     * @param nullifiers Array of nullifiers that are secretly bound to UTXOs to be spent by the transaction.
     * @param outputs Array of new UTXOs to generate, for future transactions to spend.
     * @param root The root hash of the Sparse Merkle Tree that contains the nullifiers.
     * @param proof A zero knowledge proof that the submitter is authorized to spend the inputs, and
     *      that the outputs are valid in terms of obeying mass conservation rules.
     *
     * Emits a {UTXOTransfer} event.
     */
    function transfer(
        uint256[2] memory nullifiers,
        uint256[2] memory outputs,
        uint256 root,
        Commonlib.Proof calldata proof
    ) public returns (bool) {
        require(
            validateTransactionProposal(nullifiers, outputs, root, proof),
            "Invalid transaction proposal"
        );

        // construct the public inputs
        uint256[7] memory publicInputs;
        publicInputs[0] = nullifiers[0];
        publicInputs[1] = nullifiers[1];
        publicInputs[2] = root;
        publicInputs[3] = (nullifiers[0] == 0) ? 0 : 1; // enable MT proof for the first nullifier
        publicInputs[4] = (nullifiers[1] == 0) ? 0 : 1; // enable MT proof for the second nullifier
        publicInputs[5] = outputs[0];
        publicInputs[6] = outputs[1];

        // // Check the proof
        require(
            verifier.verifyProof(proof.pA, proof.pB, proof.pC, publicInputs),
            "Invalid proof"
        );

        processInputsAndOutputs(nullifiers, outputs);

        uint256[] memory nullifierArray = new uint256[](nullifiers.length);
        uint256[] memory outputArray = new uint256[](outputs.length);
        for (uint256 i = 0; i < nullifiers.length; ++i) {
            nullifierArray[i] = nullifiers[i];
            outputArray[i] = outputs[i];
        }
        emit UTXOTransfer(nullifierArray, outputArray, msg.sender);
        return true;
    }
}
