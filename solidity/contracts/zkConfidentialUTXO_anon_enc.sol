// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Groth16Verifier_Anonymity_Encryption} from "./lib/verifier_anon_enc.sol";
import {zkConfidentialUTXO} from "./lib/zkConfidentialUTXO.sol";
import {Registry} from "./lib/registry.sol";
import {Commonlib} from "./lib/common.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

/// @title A sample on-chain implementation of a ZKP based C-UTXO pattern with confidentiality (but not anonymity)
///        The proof has the following statements:
///        - each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
///        - the sum of the input values match the sum of output values
///        - the hashes in the input and output match the hash(value, salt, owner public key) formula
///        - the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes
///        - the encrypted value in the input is derived from the receiver's UTXO value and encrypted with a shared secret using
///          the ECDH protocol between the sender and receiver (this guarantees data availability for the receiver)
/// @author Kaleido, Inc.
/// @dev Implements double-spend protection with zkp
contract zkConfidentialUTXO_Anonymity_Encryption is zkConfidentialUTXO {
    Groth16Verifier_Anonymity_Encryption internal verifier;

    constructor(
        Groth16Verifier_Anonymity_Encryption _verifier,
        Registry _registry
    ) zkConfidentialUTXO(_registry) {
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
        uint256 encryptionNonce,
        uint256[2] memory encryptedValues,
        Commonlib.Proof calldata proof
    ) public returns (bool) {
        require(
            validateTransactionProposal(inputs, outputs, proof),
            "Invalid transaction proposal"
        );

        // construct the public inputs
        uint256[7] memory publicInputs;
        publicInputs[0] = encryptedValues[0]; // encrypted value for the receiver UTXO
        publicInputs[1] = encryptedValues[1]; // encrypted salt for the receiver UTXO
        publicInputs[2] = inputs[0];
        publicInputs[3] = inputs[1];
        publicInputs[4] = outputs[0];
        publicInputs[5] = outputs[1];
        publicInputs[6] = encryptionNonce;

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
        uint256[] memory encryptedValuesArray = new uint256[](
            encryptedValues.length
        );
        for (uint256 i = 0; i < inputs.length; ++i) {
            inputArray[i] = inputs[i];
            outputArray[i] = outputs[i];
            encryptedValuesArray[i] = encryptedValues[i];
        }

        emit UTXOBranchWithEncryptedValues(
            inputArray,
            outputArray,
            encryptionNonce,
            encryptedValuesArray,
            msg.sender
        );
        return true;
    }
}
