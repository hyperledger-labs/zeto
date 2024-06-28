// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Commonlib} from "./common.sol";
import {Registry} from "./registry.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title A sample base implementation of a ZKP based C-UTXO token contract
/// @author Kaleido, Inc.
/// @dev Implements common functionalities of ZKP based C-UTXO tokens
abstract contract zkConfidentialUTXOBase is Ownable {
    enum UTXOStatus {
        UNKNOWN, // default value for the empty UTXO slots
        UNSPENT,
        SPENT
    }

    event UTXOMint(uint256[] outputs, address indexed submitter);

    event UTXOBranch(
        uint256[] inputs,
        uint256[] outputs,
        address indexed submitter
    );

    event UTXOBranchWithEncryptedValues(
        uint256[] inputs,
        uint256[] outputs,
        uint256 encryptionNonce,
        uint256[] encryptedValues,
        address indexed submitter
    );

    error UTXONotMinted(uint256 utxo);
    error UTXOAlreadyOwned(uint256 utxo);
    error UTXOAlreadySpent(uint256 utxo);
    error UTXODuplicate(uint256 utxo);
    error IdentityNotRegistered(address addr);

    // Registry contract to lookup public keys of the token owners
    // This is a sample onchain KYC solution
    Registry internal registry;

    // maintains all the UTXOs
    mapping(uint256 => UTXOStatus) internal _utxos;

    // used for multi-step transaction flows that require counterparties
    // to upload proofs. To protect the party that uploads their proof first,
    // and prevent the other party from utilizing the uploaded proof to execute
    // a transaction, the proof can be locked and only usable by the same party
    // that did the locking.
    mapping(bytes32 => address) internal lockedProofs;

    constructor(Registry _registry) Ownable(msg.sender) {
        registry = _registry;
    }

    // should be called by escrow contracts that will use uploaded proofs
    // to execute transactions, in order to prevent the proof from being used
    // by parties other than the escrow contract
    function lockProof(Commonlib.Proof calldata proof) public {
        bytes32 proofHash = Commonlib.getProofHash(proof);
        lockedProofs[proofHash] = msg.sender;
    }

    /// @dev query whether a UTXO is currently spent
    /// @return owner the non-zero owner address, or zero if the TXO ID is not in the unspent map
    function spent(uint256 txo) public view returns (bool) {
        return _utxos[txo] == UTXOStatus.SPENT;
    }

    function validateTransactionProposal(
        uint256[2] memory inputs,
        uint256[2] memory outputs,
        Commonlib.Proof calldata proof
    ) internal view returns (bool) {
        // sort the inputs and outputs to detect duplicates
        (
            uint256[] memory sortedInputs,
            uint256[] memory sortedOutputs
        ) = sortInputsAndOutputs(inputs, outputs);

        // Check the inputs are all unspent
        for (uint256 i = 0; i < sortedInputs.length; ++i) {
            if (sortedInputs[i] == 0) {
                // skip the zero inputs
                continue;
            }
            if (i > 0 && sortedInputs[i] == sortedInputs[i - 1]) {
                revert UTXODuplicate(sortedInputs[i]);
            }
            if (_utxos[sortedInputs[i]] == UTXOStatus.UNKNOWN) {
                revert UTXONotMinted(sortedInputs[i]);
            } else if (_utxos[sortedInputs[i]] == UTXOStatus.SPENT) {
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
            if (_utxos[sortedOutputs[i]] == UTXOStatus.SPENT) {
                revert UTXOAlreadySpent(sortedOutputs[i]);
            } else if (_utxos[sortedOutputs[i]] == UTXOStatus.UNSPENT) {
                revert UTXOAlreadyOwned(sortedOutputs[i]);
            }
        }

        // check if the proof has been locked
        bytes32 proofHash = Commonlib.getProofHash(proof);
        if (lockedProofs[proofHash] != address(0)) {
            require(
                lockedProofs[proofHash] == msg.sender,
                "Locked proof can only be submitted by the locker address"
            );
        }
        return true;
    }

    function mint(uint256[] memory utxos) public virtual onlyOwner {
        for (uint256 i = 0; i < utxos.length; ++i) {
            uint256 utxo = utxos[i];
            if (_utxos[utxo] == UTXOStatus.UNSPENT) {
                revert UTXOAlreadyOwned(utxo);
            } else if (_utxos[utxo] == UTXOStatus.SPENT) {
                revert UTXOAlreadySpent(utxo);
            }

            _utxos[utxo] = UTXOStatus.UNSPENT;
        }
        emit UTXOMint(utxos, msg.sender);
    }

    function validateIdentity(address receiver) internal view {
        uint256[2] memory ownerPublicKey = registry.getPublicKey(receiver);
        if (ownerPublicKey[0] == 0 || ownerPublicKey[1] == 0) {
            revert IdentityNotRegistered(receiver);
        }
    }

    function sortInputsAndOutputs(
        uint256[2] memory inputs,
        uint256[2] memory outputs
    ) internal pure returns (uint256[] memory, uint256[] memory) {
        uint256[] memory sortedInputs = new uint256[](inputs.length);
        uint256[] memory sortedOutputs = new uint256[](outputs.length);
        for (uint256 i = 0; i < inputs.length; ++i) {
            sortedInputs[i] = inputs[i];
        }
        for (uint256 i = 0; i < outputs.length; ++i) {
            sortedOutputs[i] = outputs[i];
        }
        sortedInputs = Commonlib.sort(sortedInputs);
        sortedOutputs = Commonlib.sort(sortedOutputs);
        return (sortedInputs, sortedOutputs);
    }
}
