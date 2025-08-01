// Copyright © 2025 Kaleido, Inc.
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

import {IZetoInitializable} from "./lib/interfaces/izeto_initializable.sol";
import {Zeto_AnonNullifier} from "./zeto_anon_nullifier.sol";
import {ZetoFungibleBurnableNullifier} from "./lib/zeto_fungible_burn_nullifier.sol";
import {ZetoCommon} from "./lib/zeto_common.sol";
import {Commonlib} from "./lib/common/common.sol";

/// @title A sample implementation of a Zeto based fungible token with anonymity and no encryption
/// @author Kaleido, Inc.
/// @dev The proof has the following statements:
///        - each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
///        - the sum of the input values match the sum of output values
///        - the hashes in the input and output match the `hash(value, salt, owner public key)` formula
///        - the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes
contract Zeto_AnonNullifierBurnable is
    Zeto_AnonNullifier,
    ZetoFungibleBurnableNullifier
{
    function initialize(
        string calldata name,
        string calldata symbol,
        address initialOwner,
        IZetoInitializable.VerifiersInfo calldata verifiers
    ) public override initializer {
        __ZetoAnonNullifier_init(name, symbol, initialOwner, verifiers);
        __ZetoFungibleBurnableNullifier_init(
            verifiers.burnVerifier,
            verifiers.batchBurnVerifier
        );
    }

    function constructPublicInputs(
        uint256[] memory inputs,
        uint256[] memory outputs,
        bytes memory proof,
        bool inputsLocked
    )
        internal
        override(Zeto_AnonNullifier, ZetoCommon)
        returns (uint256[] memory, Commonlib.Proof memory)
    {
        return
            Zeto_AnonNullifier.constructPublicInputs(
                inputs,
                outputs,
                proof,
                inputsLocked
            );
    }

    function constructPublicInputsForLock(
        uint256[] memory inputs,
        uint256[] memory outputs,
        uint256[] memory lockedOutputs,
        bytes memory proof
    )
        internal
        override(Zeto_AnonNullifier, ZetoCommon)
        returns (uint256[] memory, Commonlib.Proof memory)
    {
        return
            Zeto_AnonNullifier.constructPublicInputsForLock(
                inputs,
                outputs,
                lockedOutputs,
                proof
            );
    }

    function validateTransactionProposal(
        uint256[] memory inputs,
        uint256[] memory outputs,
        uint256[] memory lockedOutputs,
        bytes memory proof,
        bool inputsLocked
    ) internal view override(Zeto_AnonNullifier, ZetoCommon) {
        Zeto_AnonNullifier.validateTransactionProposal(
            inputs,
            outputs,
            lockedOutputs,
            proof,
            inputsLocked
        );
    }
}
