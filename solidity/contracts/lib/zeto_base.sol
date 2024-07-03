// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {Commonlib} from "./common.sol";
import {Registry} from "./registry.sol";
import {ZetoCommon} from "./zeto_common.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title A sample base implementation of a Zeto based token contract
///        without using nullifiers. Each UTXO's spending status is explicitly tracked.
/// @author Kaleido, Inc.
/// @dev Implements common functionalities of Zeto based tokens without nullifiers
abstract contract ZetoBase is ZetoCommon {
    enum UTXOStatus {
        UNKNOWN, // default value for the empty UTXO slots
        UNSPENT,
        SPENT
    }

    // maintains all the UTXOs
    mapping(uint256 => UTXOStatus) internal _utxos;

    constructor(Registry _registry) ZetoCommon(_registry) {}

    /// @dev query whether a UTXO is currently spent
    /// @return bool whether the UTXO is spent
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

    // This function is used to mint new UTXOs, as an example implementation,
    // which is only callable by the owner.
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
}
