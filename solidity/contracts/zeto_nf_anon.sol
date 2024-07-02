// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Groth16Verifier_NFAnon} from "./lib/verifier_nf_anon.sol";
import {ZetoBase} from "./lib/zeto_base.sol";
import {Registry} from "./lib/registry.sol";
import {Commonlib} from "./lib/common.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

/// @title A sample on-chain implementation of a ZKP based C-UTXO pattern with confidentiality (but not anonymity)
///        The proof has the following statements:
///        - The sender owns the private key whose public key is part of the pre-image of the input UTXOs commitments
///          (aka the sender is authorized to spend the input UTXOs)
///        - The input UTXOs and output UTXOs are valid in terms of obeying mass conservation rules
/// @author Kaleido, Inc.
/// @dev Implements double-spend protection with zkp
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
     * @param input output of a previous `branch()` function call against this
     *      contract that have not yet been spent, and the owner is authorized to spend.
     * @param output new output to generate, for future transactions to spend.
     * @param proof A zero knowledge proof that the submitter is authorized to spend the inputs, and
     *      that the outputs are valid in terms of obeying mass conservation rules.
     *
     * Emits a {UTXOBranch} event.
     */
    function branch(
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

        emit UTXOBranch(inputArray, outputArray, msg.sender);
        return true;
    }
}
