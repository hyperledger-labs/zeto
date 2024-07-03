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

import {Groth16Verifier_NFAnon} from "./lib/verifier_nf_anon.sol";
import {ZetoBase} from "./lib/zeto_base.sol";
import {Registry} from "./lib/registry.sol";
import {Commonlib} from "./lib/common.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

/// @title A sample implementation of a Zeto based non-fungible token with anonymity and no encryption
/// @author Kaleido, Inc.
/// @dev The proof has the following statements:
///        - The sender owns the private key whose public key is part of the pre-image of the input UTXOs commitments
///          (aka the sender is authorized to spend the input UTXOs)
///        - The input UTXOs and output UTXOs are valid in terms of obeying mass conservation rules
contract Zeto_NFAnon is ZetoBase {
    Groth16Verifier_NFAnon internal verifier;

    constructor(
        Groth16Verifier_NFAnon _verifier,
        Registry _registry
    ) ZetoBase(_registry) {
        verifier = _verifier;
    }

    /**
     * @dev the main function of the contract.
     *
     * @param input The UTXO to be spent by the transaction.
     * @param output The new UTXO to generate, for future transactions to spend.
     * @param proof A zero knowledge proof that the submitter is authorized to spend the inputs, and
     *      that the outputs are valid in terms of obeying mass conservation rules.
     *
     * Emits a {UTXOTransfer} event.
     */
    function transfer(
        uint256 input,
        uint256 output,
        Commonlib.Proof calldata proof
    ) public returns (bool) {
        require(
            validateTransactionProposal([input, 0], [output, 0], proof),
            "Invalid transaction proposal"
        );

        // construct the public inputs
        uint256[2] memory publicInputs;
        publicInputs[0] = input;
        publicInputs[1] = output;

        // Check the proof
        require(
            verifier.verifyProof(proof.pA, proof.pB, proof.pC, publicInputs),
            "Invalid proof"
        );

        _utxos[input] = UTXOStatus.SPENT;
        _utxos[output] = UTXOStatus.UNSPENT;

        uint256[] memory inputArray = new uint256[](1);
        uint256[] memory outputArray = new uint256[](1);
        inputArray[0] = input;
        outputArray[0] = output;

        emit UTXOTransfer(inputArray, outputArray, msg.sender);
        return true;
    }
}
