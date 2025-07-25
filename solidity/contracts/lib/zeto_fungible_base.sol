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

import {IZeto} from "./interfaces/izeto.sol";
import {IZetoLockable} from "./interfaces/izeto_lockable.sol";
import {IZetoInitializable} from "./interfaces/izeto_initializable.sol";
import {Commonlib} from "./common/common.sol";
import {ZetoCommon} from "./zeto_common.sol";
import {ZetoFungible} from "./zeto_fungible.sol";
import {IZetoStorage} from "./interfaces/izeto_storage.sol";
import {BaseStorage} from "./storage/base.sol";

/// @title A sample base implementation of a Zeto based token contract
///        without using nullifiers. Each UTXO's spending status is explicitly tracked.
/// @author Kaleido, Inc.
/// @dev Implements common functionalities of Zeto based tokens without nullifiers
abstract contract ZetoFungibleBase is ZetoFungible {
    function __ZetoFungibleBase_init(
        string memory name_,
        string memory symbol_,
        address initialOwner,
        IZetoInitializable.VerifiersInfo calldata verifiers
    ) internal onlyInitializing {
        IZetoStorage storage_ = new BaseStorage();
        __ZetoFungible_init(name_, symbol_, initialOwner, verifiers, storage_);
    }

    // For the base fungible contract, we have the ability to validate the inputs
    // against the locked status of the UTXOs, and the delegate of the UTXOs directly
    // in the contract. (this is different from the nullifier contract, where the
    // validation is done in the ZKP circuit)
    function validateInputs(
        uint256[] memory inputs,
        bool inputsLocked
    ) internal view virtual override {
        super.validateInputs(inputs, inputsLocked);
        if (inputsLocked) {
            for (uint256 i = 0; i < inputs.length; ++i) {
                if (inputs[i] == 0) {
                    continue;
                }
                (bool isLocked, address currentDelegate) = locked(inputs[i]);
                if (!isLocked) {
                    revert UTXONotLocked(inputs[i]);
                }
                if (currentDelegate != msg.sender) {
                    revert NotLockDelegate(
                        inputs[i],
                        currentDelegate,
                        msg.sender
                    );
                }
            }
        }
    }

    // The caller function must perform the proof verification
    function _burn(
        uint256[] memory inputs,
        uint256 output,
        bytes calldata data
    ) internal virtual {
        validateInputs(inputs, false);
        uint256[] memory outputStates = new uint256[](1);
        outputStates[0] = output;
        validateOutputs(outputStates);
        processInputs(inputs, false);
        processOutputs(outputStates);
        emit UTXOBurn(inputs, output, msg.sender, data);
    }
}
