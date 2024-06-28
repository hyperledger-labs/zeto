// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Groth16Verifier_Anonymity_Encryption_Nullifier} from "./lib/verifier_anon_enc_nullifier.sol";
import {zkConfidentialUTXOBase} from "./lib/zkConfidentialUTXOBase.sol";
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
///        - the encrypted value in the input is derived from the receiver's UTXO value and encrypted with a shared secret using the ECDH protocol between the sender and receiver (this guarantees data availability for the receiver)
///        - the nullifiers represent input commitments that are included in a Sparse Merkle Tree represented by the root hash
/// @author Kaleido, Inc.
/// @dev Implements double-spend protection with zkp
contract zkConfidentialUTXO_Anonymity_Encryption_Nullifier is
    zkConfidentialUTXOBase
{
    SmtLib.Data internal _commitmentsTree;
    using SmtLib for SmtLib.Data;
    mapping(uint256 => bool) private _nullifiers;

    Groth16Verifier_Anonymity_Encryption_Nullifier verifier;

    error UTXORootNotFound(uint256 root);

    constructor(
        Groth16Verifier_Anonymity_Encryption_Nullifier _verifier,
        Registry _registry
    ) zkConfidentialUTXOBase(_registry) {
        verifier = _verifier;
        _commitmentsTree.initialize(MAX_SMT_DEPTH);
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
        uint256 encryptionNonce,
        uint256[2] memory encryptedValues,
        Commonlib.Proof calldata proof
    ) public returns (bool) {
        // sort the inputs and outputs to detect duplicates
        (
            uint256[] memory sortedInputs,
            uint256[] memory sortedOutputs
        ) = sortInputsAndOutputs(nullifiers, outputs);

        // Check the inputs are all unspent
        for (uint256 i = 0; i < sortedInputs.length; ++i) {
            if (sortedInputs[i] == 0) {
                // skip the zero inputs
                continue;
            }
            if (i > 0 && sortedInputs[i] == sortedInputs[i - 1]) {
                revert UTXODuplicate(sortedInputs[i]);
            }
            if (_nullifiers[sortedInputs[i]] == true) {
                revert UTXOAlreadySpent(sortedInputs[i]);
            }
        }

        // Check the outputs are all new UTXOs
        for (uint256 i = 0; i < sortedOutputs.length; ++i) {
            if (sortedOutputs[i] == 0) {
                // skip the zero outputs
                continue;
            }
            if (i > 0 && sortedOutputs[i] == sortedOutputs[i - 1]) {
                revert UTXODuplicate(sortedOutputs[i]);
            }
            uint256 nodeHash = _getLeafNodeHash(sortedOutputs[i]);
            SmtLib.Node memory node = _commitmentsTree.getNode(nodeHash);
            if (node.nodeType != SmtLib.NodeType.EMPTY) {
                revert UTXOAlreadyOwned(sortedOutputs[i]);
            }
        }

        // Check if the root has existed before. It does not need to be the latest root.
        // Our SMT is append-only, so if the root has existed before, and the merklet proof
        // is valid, then the leaves still exist in the tree.
        if (!_commitmentsTree.rootExists(root)) {
            revert UTXORootNotFound(root);
        }

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
        for (uint256 i = 0; i < nullifiers.length; ++i) {
            _nullifiers[nullifiers[i]] = true;
        }
        for (uint256 i = 0; i < outputs.length; ++i) {
            _commitmentsTree.addLeaf(outputs[i], outputs[i]);
        }

        uint256[] memory nullifierArray = new uint256[](nullifiers.length);
        uint256[] memory outputArray = new uint256[](outputs.length);
        uint256[] memory encryptedValueArray = new uint256[](
            encryptedValues.length
        );
        for (uint256 i = 0; i < nullifiers.length; ++i) {
            nullifierArray[i] = nullifiers[i];
            outputArray[i] = outputs[i];
            encryptedValueArray[i] = encryptedValues[i];
        }
        emit UTXOBranchWithEncryptedValues(
            nullifierArray,
            outputArray,
            encryptionNonce,
            encryptedValueArray,
            msg.sender
        );
        return true;
    }

    function mint(uint256[] memory utxos) public override onlyOwner {
        for (uint256 i = 0; i < utxos.length; ++i) {
            uint256 utxo = utxos[i];
            uint256 nodeHash = _getLeafNodeHash(utxo);
            SmtLib.Node memory node = _commitmentsTree.getNode(nodeHash);

            if (node.nodeType != SmtLib.NodeType.EMPTY) {
                revert UTXOAlreadyOwned(utxo);
            }

            _commitmentsTree.addLeaf(utxo, utxo);
        }

        emit UTXOMint(utxos, msg.sender);
    }

    function getRoot() public view returns (uint256) {
        return _commitmentsTree.getRoot();
    }

    function _getLeafNodeHash(uint256 utxo) internal pure returns (uint256) {
        uint256[3] memory params = [utxo, utxo, uint256(1)];
        return PoseidonUnit3L.poseidon(params);
    }
}
