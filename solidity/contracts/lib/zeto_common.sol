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

import {Commonlib} from "./common.sol";
import {Registry} from "./registry.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title A sample base implementation of a Zeto based token contract
/// @author Kaleido, Inc.
/// @dev Implements common functionalities of Zeto based tokens
abstract contract ZetoCommon is Ownable {
    event UTXOMint(uint256[] outputs, address indexed submitter);

    event UTXOTransfer(
        uint256[] inputs,
        uint256[] outputs,
        address indexed submitter
    );

    event UTXOTransferWithEncryptedValues(
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
