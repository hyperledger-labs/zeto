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

import {Commonlib} from "./common/common.sol";
import {IZeto} from "./interfaces/izeto.sol";
import {MAX_SMT_DEPTH} from "./interfaces/izeto.sol";
import {IZetoLockable} from "./interfaces/izeto_lockable.sol";
import {IZetoInitializable} from "./interfaces/izeto_initializable.sol";
import {ZetoFungible} from "./zeto_fungible.sol";
import {SmtLib} from "@iden3/contracts/lib/SmtLib.sol";
import {IZetoStorage} from "./interfaces/izeto_storage.sol";
import {NullifierStorage} from "./storage/nullifier.sol";

/// @title A sample base implementation of a Zeto based token contract with nullifiers
/// @author Kaleido, Inc.
/// @dev Implements common functionalities of Zeto based tokens using nullifiers
abstract contract ZetoFungibleNullifier is ZetoFungible {
    function __ZetoFungibleNullifier_init(
        string calldata name_,
        string calldata symbol_,
        address initialOwner,
        IZetoInitializable.VerifiersInfo calldata verifiers
    ) internal onlyInitializing {
        IZetoStorage storage_ = new NullifierStorage();
        __ZetoFungible_init(name_, symbol_, initialOwner, verifiers, storage_);
    }

    function constructPublicInputsForWithdraw(
        uint256 amount,
        uint256[] memory nullifiers,
        uint256 output,
        bytes memory proof
    ) internal override returns (uint256[] memory, Commonlib.Proof memory) {
        (uint256 root, Commonlib.Proof memory proofStruct) = abi.decode(
            proof,
            (uint256, Commonlib.Proof)
        );
        uint256 size = (nullifiers.length * 2) + 3; // nullifiers and the enabled flags, amount, root, output
        // construct the public inputs for verifier
        uint256[] memory publicInputs = new uint256[](size);
        uint256 piIndex = 0;

        // copy output amount
        publicInputs[piIndex++] = amount;

        // copy input commitments
        for (uint256 i = 0; i < nullifiers.length; i++) {
            publicInputs[piIndex++] = nullifiers[i];
        }

        // copy root
        publicInputs[piIndex++] = root;

        // populate enables
        for (uint256 i = 0; i < nullifiers.length; i++) {
            publicInputs[piIndex++] = (nullifiers[i] == 0) ? 0 : 1;
        }

        // copy output commitment
        publicInputs[piIndex++] = output;

        return (publicInputs, proofStruct);
    }

    // This function is used to burn the owner's UTXOs
    function _burn(
        uint256[] memory nullifiers,
        uint256 output,
        uint256 root,
        bytes calldata data
    ) internal virtual {
        validateInputs(nullifiers, false);
        uint256[] memory outputStates = new uint256[](1);
        outputStates[0] = output;
        validateOutputs(outputStates);
        validateRoot(root, false);

        emit UTXOBurn(nullifiers, output, msg.sender, data);
    }
}
