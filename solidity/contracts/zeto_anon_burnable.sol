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

import {IZeto} from "./lib/interfaces/izeto.sol";
import {Groth16Verifier_Deposit} from "./verifiers/verifier_deposit.sol";
import {Groth16Verifier_Withdraw} from "./verifiers/verifier_withdraw.sol";
import {Groth16Verifier_WithdrawBatch} from "./verifiers/verifier_withdraw_batch.sol";
import {Groth16Verifier_Anon} from "./verifiers/verifier_anon.sol";
import {Groth16Verifier_AnonBatch} from "./verifiers/verifier_anon_batch.sol";
import {Groth16Verifier_Burn} from "./verifiers/verifier_burn.sol";
import {Groth16Verifier_BurnBatch} from "./verifiers/verifier_burn_batch.sol";
import {Zeto_Anon} from "./zeto_anon.sol";
import {Commonlib} from "./lib/common.sol";
import {ZetoBase} from "./lib/zeto_base.sol";
import {IZetoInitializable} from "./lib/interfaces/izeto_initializable.sol";
import {ZetoFungibleWithdraw} from "./lib/zeto_fungible_withdraw.sol";
import {ZetoFungibleBurnable} from "./lib/zeto_fungible_burn.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

uint256 constant INPUT_SIZE = 4;
uint256 constant BATCH_INPUT_SIZE = 20;

/// @title A sample implementation of a Zeto based fungible token with anonymity and no encryption
/// @author Kaleido, Inc.
/// @dev The proof has the following statements:
///        - each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
///        - the sum of the input values match the sum of output values
///        - the hashes in the input and output match the `hash(value, salt, owner public key)` formula
///        - the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes
contract Zeto_AnonBurnable is Zeto_Anon, ZetoFungibleBurnable {
    function initialize(
        address initialOwner,
        VerifiersInfo calldata verifiers
    ) public override initializer {
        __ZetoAnon_init(initialOwner, verifiers);
        __ZetoFungibleBurnable_init(
            (Groth16Verifier_Burn)(verifiers.burnVerifier),
            (Groth16Verifier_BurnBatch)(verifiers.batchBurnVerifier)
        );
    }
}
