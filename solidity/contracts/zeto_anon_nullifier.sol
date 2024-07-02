// SPDX-License-Identifier: MIT
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

/// @title A sample on-chain implementation of a ZKP based C-UTXO pattern with confidentiality, anonymity and history masking
///        The proof has the following statements:
///        - each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
///        - the sum of the nullified values match the sum of output values
///        - the hashes in the input and output match the hash(value, salt, owner public key) formula
///        - the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes, which match the corresponding nullifiers
///        - the nullifiers represent input commitments that are included in a Sparse Merkle Tree represented by the root hash
/// @author Kaleido, Inc.
/// @dev Implements double-spend protection with zkp
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
     * @param nullifiers Array of zero or more outputs of a previous `branch()` function call against this
     *      contract that have not yet been spent, and the owner is authorized to spend.
     * @param outputs Array of zero or more new outputs to generate, for future transactions to spend.
     * @param proof A zero knowledge proof that the submitter is authorized to spend the inputs, and
     *      that the outputs are valid in terms of obeying mass conservation rules.
     *
     * Emits a {UTXOBranch} event.
     */
    function branch(
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
        emit UTXOBranch(nullifierArray, outputArray, msg.sender);
        return true;
    }
}
