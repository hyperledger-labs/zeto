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

import {Commonlib} from "./lib/common.sol";
import {Zeto_Anon} from "./zeto_anon.sol";
import {Zeto_NFAnon} from "./zeto_nf_anon.sol";
import "hardhat/console.sol";

/// @title A sample on-chain implementation of a DvP escrow contract using ZKP based C-UTXO tokens
/// @author Kaleido, Inc.
/// @dev Implements escrow based DvP flows with ZKP based C-UTXO tokens
contract zkDvP {
    enum TradeStatus {
        INITIATED,
        ACCEPTED,
        COMPLETED,
        CANCELLED
    }

    struct Trade {
        TradeStatus status;
        // payment counterparty is the party that initiates the payment transaction
        // it does NOT need to be actual owner of the payment UTXOs. The ZK proof of
        // the payment transaction will ensure that the payment counterparty is authorized
        // to spend the payment UTXOs
        address paymentCounterparty;
        // inputs for the payment transaction
        uint256[2] paymentInputs;
        uint256[2] paymentOutputs;
        bytes32 paymentProofHash;
        Commonlib.Proof paymentProof;
        // asset counterparty is the party that initiates the asset transaction
        // it does NOT need to be actual owner of the asset UTXOs. The ZK proof of
        // the asset transaction will ensure that the asset counterparty is authorized
        // to spend the asset UTXOs
        address assetCounterparty;
        // inputs for the delivery transaction
        uint256 assetInput;
        uint256 assetOutput;
        bytes32 assetProofHash;
        Commonlib.Proof assetProof;
    }

    Zeto_Anon paymentToken;
    Zeto_NFAnon assetToken;
    mapping(uint256 => Trade) trades;
    uint256 tradeCount;

    event TradeInitiated(uint256 indexed tradeId, Trade trade);
    event TradeAccepted(uint256 indexed tradeId, Trade trade);
    event TradeCompleted(uint256 indexed tradeId, Trade trade);

    constructor(address paymentTokenAddress, address assetTokenAddress) {
        tradeCount = 0;
        paymentToken = Zeto_Anon(paymentTokenAddress);
        assetToken = Zeto_NFAnon(assetTokenAddress);
    }

    function initiateTrade(
        uint256[2] memory paymentInputs,
        uint256[2] memory paymentOutputs,
        bytes32 paymentProofHash,
        uint256 assetInput,
        uint256 assetOutput,
        bytes32 assetProofHash
    ) public {
        address paymentCounterparty;
        address assetCounterparty;
        require(
            !isEmptyArray(paymentInputs) || assetInput != 0,
            "Payment inputs and asset input cannot be zero at the same time"
        );
        require(
            !(!isEmptyArray(paymentInputs) && assetInput != 0),
            "Payment inputs and asset input cannot be provided at the same time"
        );
        if (!isEmptyArray(paymentInputs)) {
            require(
                !isEmptyArray(paymentOutputs),
                "Payment outputs cannot be zero when payment inputs are non-zero"
            );
            paymentCounterparty = msg.sender;
        }
        if (assetInput != 0) {
            require(
                assetOutput != 0,
                "Asset output cannot be zero when asset input is non-zero"
            );
            assetCounterparty = msg.sender;
        }

        Commonlib.Proof memory emptyProof;
        Trade memory trade = Trade(
            TradeStatus.INITIATED,
            paymentCounterparty,
            paymentInputs,
            paymentOutputs,
            paymentProofHash,
            emptyProof,
            assetCounterparty,
            assetInput,
            assetOutput,
            assetProofHash,
            emptyProof
        );

        trades[tradeCount] = trade;
        emit TradeInitiated(tradeCount, trade);
        tradeCount++;
    }

    function acceptTrade(
        uint256 tradeId,
        uint256[2] memory paymentInputs,
        uint256[2] memory paymentOutputs,
        bytes32 paymentProofHash,
        uint256 assetInput,
        uint256 assetOutput,
        bytes32 assetProofHash
    ) public {
        Trade memory trade = trades[tradeId];
        require(
            trade.paymentCounterparty != address(0) ||
                trade.assetCounterparty != address(0),
            "Trade does not exist"
        );
        require(
            trade.status == TradeStatus.INITIATED,
            "Trade must be in INITIATED state to accept"
        );

        // check that the inputs from the accepting party are complementary
        if (!isEmptyArray(trade.paymentInputs)) {
            require(
                isEmptyArray(paymentInputs),
                "Payment inputs already provided by the trade initiator"
            );
            require(
                isEmptyArray(paymentOutputs),
                "Payment outputs already provided by the trade initiator"
            );
            require(
                assetInput != 0,
                "Asset input must be provided to accept the trade"
            );
            require(
                assetOutput != 0,
                "Asset output must be provided to accept the trade"
            );

            trade.assetInput = assetInput;
            trade.assetOutput = assetOutput;
            trade.assetProofHash = assetProofHash;
            trade.assetCounterparty = msg.sender;
        } else if (trade.assetInput != 0) {
            require(
                assetInput == 0,
                "Asset inputs already provided by the trade initiator"
            );
            require(
                assetOutput == 0,
                "Asset outputs already provided by the trade initiator"
            );
            require(
                !isEmptyArray(paymentInputs),
                "Payment inputs must be provided to accept the trade"
            );
            require(
                !isEmptyArray(paymentOutputs),
                "Payment outputs must be provided to accept the trade"
            );

            trade.paymentInputs = paymentInputs;
            trade.paymentOutputs = paymentOutputs;
            trade.paymentProofHash = paymentProofHash;
            trade.paymentCounterparty = msg.sender;
        }
        trade.status = TradeStatus.ACCEPTED;
        trades[tradeId] = trade;

        emit TradeAccepted(tradeId, trade);
    }

    function completeTrade(
        uint256 tradeId,
        Commonlib.Proof calldata proof
    ) public {
        Trade memory trade = trades[tradeId];
        require(
            trade.status == TradeStatus.ACCEPTED,
            "Trade must be in ACCEPTED state to complete"
        );
        bytes32 proofHash = getProofHash(proof);
        if (trade.paymentProofHash == proofHash) {
            trade.paymentProof = proof;
        } else if (trade.assetProofHash == proofHash) {
            trade.assetProof = proof;
        } else {
            revert("Invalid proof");
        }
        trades[tradeId] = trade;

        if (
            !isEmptyProof(trade.paymentProof) && !isEmptyProof(trade.assetProof)
        ) {
            require(
                paymentToken.transfer(
                    trade.paymentInputs,
                    trade.paymentOutputs,
                    trade.paymentProof
                ),
                "Payment branch of the trade failed"
            );
            require(
                assetToken.transfer(
                    trade.assetInput,
                    trade.assetOutput,
                    trade.assetProof
                ),
                "Asset branch of the trade failed"
            );
            trade.status = TradeStatus.COMPLETED;
            trades[tradeId] = trade;
            emit TradeCompleted(tradeId, trade);
        }
    }

    function isEmptyArray(uint256[2] memory arr) private pure returns (bool) {
        if (arr.length == 0) {
            return true;
        }
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] != 0) {
                return false;
            }
        }
        return true;
    }

    function getProofHash(
        Commonlib.Proof calldata proof
    ) private pure returns (bytes32) {
        uint[8] memory inputs = [
            proof.pA[0],
            proof.pA[1],
            proof.pB[0][0],
            proof.pB[0][1],
            proof.pB[1][0],
            proof.pB[1][1],
            proof.pC[0],
            proof.pC[1]
        ];

        return keccak256(abi.encodePacked(inputs));
    }

    function isEmptyProof(
        Commonlib.Proof memory proof
    ) private pure returns (bool) {
        bool isEmpty = ((proof.pA.length == 0 || proof.pA[0] == 0) &&
            (proof.pB.length == 0 ||
                proof.pB[0].length == 0 ||
                proof.pB[0][0] == 0) &&
            (proof.pC.length == 0 || proof.pC[0] == 0));
        return isEmpty;
    }
}
