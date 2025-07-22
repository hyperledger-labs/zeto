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
pragma solidity ^0.8.27;

import {IGroth16Verifier} from "./interfaces/izeto_verifier.sol";
import {IZetoInitializable} from "./interfaces/izeto_initializable.sol";
import {Commonlib} from "./common.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ZetoCommon} from "./zeto_common.sol";

/// @title A sample implementation of a base Zeto fungible token contract
/// @author Kaleido, Inc.
/// @dev Defines the verifier library for checking UTXOs against a claimed value.
abstract contract ZetoFungible is ZetoCommon {
    // _depositVerifier library for checking UTXOs against a claimed value.
    // this can be used in the optional deposit calls to verify that
    // the UTXOs match the deposited value
    IGroth16Verifier internal _depositVerifier;
    // nullifierVerifier library for checking nullifiers against a claimed value.
    // this can be used in the optional withdraw calls to verify that the nullifiers
    // match the withdrawn value
    IGroth16Verifier internal _withdrawVerifier;
    IGroth16Verifier internal _batchWithdrawVerifier;

    IERC20 internal _erc20;

    function __ZetoFungible_init(
        string memory name_,
        string memory symbol_,
        address initialOwner,
        IZetoInitializable.VerifiersInfo calldata verifiers
    ) public onlyInitializing {
        __ZetoCommon_init(name_, symbol_, initialOwner, verifiers);
        _depositVerifier = verifiers.depositVerifier;
        _withdrawVerifier = verifiers.withdrawVerifier;
        _batchWithdrawVerifier = verifiers.batchWithdrawVerifier;
    }

    /**
     * @dev Set the ERC20 token that this Zeto contract will interact with.
     *
     * @param erc20 The ERC20 token to be used.
     */
    function setERC20(IERC20 erc20) public onlyOwner {
        _erc20 = erc20;
    }

    /**
     * @dev Deposit ERC20 tokens into the Zeto contract.
     *
     * @param amount The amount of ERC20 tokens to be deposited.
     * @param outputs The UTXOs to be minted.
     * @param proof The proof of the deposit.
     * @param data Additional data to be passed to the deposit function.
     */
    function deposit(
        uint256 amount,
        uint256[] memory outputs,
        bytes calldata proof,
        bytes calldata data
    ) public {
        // verifies that the output UTXOs match the claimed value
        // to be deposited
        (uint256[] memory publicInputs, Commonlib.Proof memory proofStruct) = constructPublicInputsForDeposit(amount, outputs, proof);
        // Check the proof
        require(
            _depositVerifier.verify(proofStruct.pA, proofStruct.pB, proofStruct.pC, publicInputs),
            "Invalid proof"
        );

        require(
            _erc20.transferFrom(msg.sender, address(this), amount),
            "Failed to transfer ERC20 tokens"
        );
        mint(outputs, data);
    }

    /**
     * @dev Withdraw ERC20 tokens from the Zeto contract.
     *
     * @param amount The amount of ERC20 tokens to be withdrawn.
     * @param inputs The UTXOs to be spent.
     * @param output The UTXO to be minted.
     * @param proof The proof of the withdrawal.
     * @param data Additional data to be passed to the withdrawal function.
     */
    function withdraw(
        uint256 amount,
        uint256[] memory inputs,
        uint256 output,
        bytes calldata proof,
        bytes calldata data
    ) public {
        // Check and pad inputs and outputs based on the max size
        uint256[] memory outputs = new uint256[](inputs.length);
        outputs[0] = output;
        inputs = checkAndPadCommitments(inputs);
        outputs = checkAndPadCommitments(outputs);
        uint256[] memory lockedOutputs;
        validateTransactionProposal(inputs, outputs, lockedOutputs, proof, false);

        _withdraw(amount, inputs, output, proof);
        processInputsAndOutputs(inputs, outputs, false);
        emit UTXOWithdraw(amount, inputs, output, msg.sender, data);
    }

    function constructPublicInputsForDeposit(
        uint256 amount,
        uint256[] memory outputs,
        bytes memory proof
    ) public view virtual returns (uint256[] memory, Commonlib.Proof memory) {
        (Commonlib.Proof memory proofStruct) = abi.decode(proof, (Commonlib.Proof));
        // construct the public inputs
        uint256[] memory extra = extraInputsForDeposit();
        uint256[] memory publicInputs = new uint256[](3 + extra.length);
        publicInputs[0] = amount;
        publicInputs[1] = outputs[0];
        publicInputs[2] = outputs[1];
        for (uint256 i = 0; i < extra.length; i++) {
            publicInputs[3 + i] = extra[i];
        }

        return (publicInputs, proofStruct);
    }

    function extraInputsForDeposit() public view virtual returns (uint256[] memory) {
        return new uint256[](0);
    }

    function constructPublicInputsForWithdraw(
        uint256 amount,
        uint256[] memory inputs,
        uint256 output,
        bytes memory proof
    ) internal virtual pure returns (uint256[] memory, Commonlib.Proof memory) {
        (Commonlib.Proof memory proofStruct) = abi.decode(proof, (Commonlib.Proof));
        uint256 size = (inputs.length + 1 + 1); // inputs, output, and amount

        uint256[] memory publicInputs = new uint256[](size);
        uint256 piIndex = 0;

        // copy output amount
        publicInputs[piIndex++] = amount;

        // copy input commitments
        for (uint256 i = 0; i < inputs.length; i++) {
            publicInputs[piIndex++] = inputs[i];
        }

        // copy output commitment
        publicInputs[piIndex++] = output;

        return (publicInputs, proofStruct);
    }

    function _withdraw(
        uint256 amount,
        uint256[] memory inputs,
        uint256 output,
        bytes memory proof
    ) public virtual {
        (uint256[] memory publicInputs, Commonlib.Proof memory proofStruct) = constructPublicInputsForWithdraw(
            amount,
            inputs,
            output,
            proof
        );
        // Check the proof
        IGroth16Verifier verifier = (inputs.length > 2)
            ? _batchWithdrawVerifier
            : _withdrawVerifier;
        require(
            verifier.verify(proofStruct.pA, proofStruct.pB, proofStruct.pC, publicInputs),
            "Invalid proof"
        );

        require(
            _erc20.transfer(msg.sender, amount),
            "Failed to transfer ERC20 tokens"
        );
    }
}
