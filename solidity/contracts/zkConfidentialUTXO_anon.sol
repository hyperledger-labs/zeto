// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Groth16Verifier_Anonymity} from "./lib/verifier_anon.sol";
import {Registry} from "./lib/registry.sol";
import {Commonlib} from "./lib/common.sol";
import {zkConfidentialUTXOBase} from "./lib/zkConfidentialUTXOBase.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

/// @title A sample on-chain implementation of a ZKP based C-UTXO pattern with confidentiality and anonymity
///        The proof has the following statements:
///        - each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
///        - the sum of the input values match the sum of output values
///        - the hashes in the input and output match the `hash(value, salt, owner public key)` formula
///        - the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes
/// @author Kaleido, Inc.
/// @dev Implements double-spend protection with zkp
contract zkConfidentialUTXO_Anonymity is zkConfidentialUTXOBase {
    Groth16Verifier_Anonymity internal verifier;

    constructor(
        Groth16Verifier_Anonymity _verifier,
        Registry _registry
    ) zkConfidentialUTXOBase(_registry) {
        verifier = _verifier;
    }

    /**
     * @dev the main function of the contract.
     *
     * @param inputs Array of zero or more outputs of a previous `branch()` function call against this
     *      contract that have not yet been spent, and the owner is authorized to spend.
     * @param outputs Array of zero or more new outputs to generate, for future transactions to spend.
     * @param proof A zero knowledge proof that the submitter is authorized to spend the inputs, and
     *      that the outputs are valid in terms of obeying mass conservation rules.
     *
     * Emits a {UTXOBranch} event.
     */
    function branch(
        uint256[2] memory inputs,
        uint256[2] memory outputs,
        Commonlib.Proof calldata proof
    ) public returns (bool) {
        require(
            validateTransactionProposal(inputs, outputs, proof),
            "Invalid transaction proposal"
        );

        // construct the public inputs
        uint256[4] memory publicInputs;
        publicInputs[0] = inputs[0];
        publicInputs[1] = inputs[1];
        publicInputs[2] = outputs[0];
        publicInputs[3] = outputs[1];

        // Check the proof
        require(
            verifier.verifyProof(proof.pA, proof.pB, proof.pC, publicInputs),
            "Invalid proof"
        );

        // accept the transaction to consume the input UTXOs and produce new UTXOs
        for (uint256 i = 0; i < inputs.length; ++i) {
            _utxos[inputs[i]] = UTXOStatus.SPENT;
        }
        for (uint256 i = 0; i < outputs.length; ++i) {
            _utxos[outputs[i]] = UTXOStatus.UNSPENT;
        }

        uint256[] memory inputArray = new uint256[](inputs.length);
        uint256[] memory outputArray = new uint256[](outputs.length);
        for (uint256 i = 0; i < inputs.length; ++i) {
            inputArray[i] = inputs[i];
            outputArray[i] = outputs[i];
        }
        emit UTXOBranch(inputArray, outputArray, msg.sender);

        return true;
    }
}
