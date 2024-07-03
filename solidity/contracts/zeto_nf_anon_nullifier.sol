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

import {Groth16Verifier_NFAnonNullifier} from "./lib/verifier_nf_anon_nullifier.sol";
import {ZetoNullifier} from "./lib/zeto_nullifier.sol";
import {Registry} from "./lib/registry.sol";
import {Commonlib} from "./lib/common.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {SmtLib} from "@iden3/contracts/lib/SmtLib.sol";
import {PoseidonUnit3L} from "@iden3/contracts/lib/Poseidon.sol";
import "hardhat/console.sol";

uint256 constant MAX_SMT_DEPTH = 64;

/// @title A sample implementation of a Zeto based non-fungible token with anonymity and history masking
/// @author Kaleido, Inc.
/// @dev The proof has the following statements:
///        - each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
///        - the sum of the nullified values match the sum of output values
///        - the hashes in the input and output match the hash(value, salt, owner public key) formula
///        - the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes, which match the corresponding nullifiers
///        - the nullifiers represent input commitments that are included in a Sparse Merkle Tree represented by the root hash
contract Zeto_NFAnonNullifier is ZetoNullifier {
    Groth16Verifier_NFAnonNullifier verifier;

    constructor(
        Groth16Verifier_NFAnonNullifier _verifier,
        Registry _registry
    ) ZetoNullifier(_registry) {
        verifier = _verifier;
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
    function transfer(
        uint256 nullifier,
        uint256 output,
        uint256 root,
        Commonlib.Proof calldata proof
    ) public returns (bool) {
        require(
            validateTransactionProposal(
                [nullifier, 0],
                [output, 0],
                root,
                proof
            ),
            "Invalid transaction proposal"
        );

        // construct the public inputs
        uint256[3] memory publicInputs;
        publicInputs[0] = nullifier;
        publicInputs[1] = root;
        publicInputs[2] = output;

        // // Check the proof
        require(
            verifier.verifyProof(proof.pA, proof.pB, proof.pC, publicInputs),
            "Invalid proof"
        );

        processInputsAndOutputs([nullifier, 0], [output, 0]);

        uint256[] memory nullifierArray = new uint256[](1);
        uint256[] memory outputArray = new uint256[](1);
        nullifierArray[0] = nullifier;
        outputArray[0] = output;

        emit UTXOTransfer(nullifierArray, outputArray, msg.sender);
        return true;
    }
}
