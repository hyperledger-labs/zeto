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

import {IZeto} from "./lib/interfaces/izeto.sol";
import {Groth16Verifier_CheckHashesValue} from "./lib/verifier_check_hashes_value.sol";
import {Groth16Verifier_CheckNullifierValue} from "./lib/verifier_check_nullifier_value.sol";
import {Groth16Verifier_AnonNullifierKyc} from "./lib/verifier_anon_nullifier_kyc.sol";
import {Groth16Verifier_AnonNullifierKycBatch} from "./lib/verifier_anon_nullifier_kyc_batch.sol";
import {ZetoNullifier} from "./lib/zeto_nullifier.sol";
import {ZetoFungibleWithdrawWithNullifiers} from "./lib/zeto_fungible_withdraw_nullifier.sol";
import {Registry} from "./lib/registry.sol";
import {Commonlib} from "./lib/common.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {SmtLib} from "@iden3/contracts/lib/SmtLib.sol";
import {PoseidonUnit3L} from "@iden3/contracts/lib/Poseidon.sol";

uint256 constant MAX_SMT_DEPTH = 64;

/// @title A sample implementation of a Zeto based fungible token with anonymity and history masking
/// @author Kaleido, Inc.
/// @dev The proof has the following statements:
///        - each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
///        - the sum of the nullified values match the sum of output values
///        - the hashes in the input and output match the hash(value, salt, owner public key) formula
///        - the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes, which match the corresponding nullifiers
///        - the nullifiers represent input commitments that are included in a Sparse Merkle Tree represented by the root hash
contract Zeto_AnonNullifierKyc is
    IZeto,
    ZetoNullifier,
    ZetoFungibleWithdrawWithNullifiers,
    Registry,
    UUPSUpgradeable
{
    Groth16Verifier_AnonNullifierKyc internal verifier;
    Groth16Verifier_AnonNullifierKycBatch internal batchVerifier;

    function initialize(
        address initialOwner,
        Groth16Verifier_AnonNullifierKyc _verifier,
        Groth16Verifier_CheckHashesValue _depositVerifier,
        Groth16Verifier_CheckNullifierValue _withdrawVerifier,
        Groth16Verifier_AnonNullifierKycBatch _batchVerifier
    ) public initializer {
        __Registry_init();
        __ZetoNullifier_init(initialOwner);
        __ZetoFungibleWithdrawWithNullifiers_init(
            _depositVerifier,
            _withdrawVerifier
        );
        verifier = _verifier;
        batchVerifier = _batchVerifier;
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function register(uint256[2] memory publicKey) public onlyOwner {
        _register(publicKey);
    }

    /**
     * @dev the main function of the contract.
     *
     * @param nullifiers Array of nullifiers that are secretly bound to UTXOs to be spent by the transaction.
     * @param outputs Array of new UTXOs to generate, for future transactions to spend.
     * @param root The root hash of the Sparse Merkle Tree that contains the nullifiers.
     * @param proof A zero knowledge proof that the submitter is authorized to spend the inputs, and
     *      that the outputs are valid in terms of obeying mass conservation rules.
     *
     * Emits a {UTXOTransfer} event.
     */
    function transfer(
        uint256[2] memory nullifiers,
        uint256[2] memory outputs,
        uint256 root,
        Commonlib.Proof calldata proof,
        bytes calldata data
    ) public returns (bool) {
        require(
            validateTransactionProposal(nullifiers, outputs, root),
            "Invalid transaction proposal"
        );

        // construct the public inputs
        uint256[8] memory publicInputs;
        publicInputs[0] = nullifiers[0];
        publicInputs[1] = nullifiers[1];
        publicInputs[2] = root;
        publicInputs[3] = (nullifiers[0] == 0) ? 0 : 1; // if the first nullifier is empty, disable its MT proof verification
        publicInputs[4] = (nullifiers[1] == 0) ? 0 : 1; // if the second nullifier is empty, disable its MT proof verification
        publicInputs[5] = getIdentitiesRoot();
        publicInputs[6] = outputs[0];
        publicInputs[7] = outputs[1];

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
        emit UTXOTransfer(nullifierArray, outputArray, msg.sender, data);
        return true;
    }

    function deposit(
        uint256 amount,
        uint256 utxo,
        Commonlib.Proof calldata proof,
        bytes calldata data
    ) public {
        _deposit(amount, utxo, proof);
        uint256[] memory utxos = new uint256[](1);
        utxos[0] = utxo;
        _mint(utxos, data);
    }

    function withdraw(
        uint256 amount,
        uint256[2] memory nullifiers,
        uint256 output,
        uint256 root,
        Commonlib.Proof calldata proof
    ) public {
        validateTransactionProposal(nullifiers, [output, 0], root);
        _withdrawWithNullifiers(amount, nullifiers, output, root, proof);
        processInputsAndOutputs(nullifiers, [output, 0]);
    }

    function mint(
        uint256[] memory utxos,
        bytes calldata data
    ) public onlyOwner {
        _mint(utxos, data);
    }
}
