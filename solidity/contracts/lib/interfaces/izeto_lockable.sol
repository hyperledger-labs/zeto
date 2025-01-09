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

import {Commonlib} from "../common.sol";

interface IZetoLockable {
    error UTXOAlreadyLocked(uint256 utxo);
    error NotLockDelegate(uint256 utxo, address delegate, address sender);
    event UTXOsLocked(
        uint256[] inputs,
        uint256[] outputs,
        uint256[] lockedOutputs,
        address indexed delegate,
        address indexed submitter,
        bytes data
    );
    event LockDelegateChanged(
        uint256[] lockedOutputs,
        address indexed oldDelegate,
        address indexed newDelegate,
        bytes data
    );
}

interface ILockVerifier {
    function verifyProof(
        uint[2] calldata _pA,
        uint[2][2] calldata _pB,
        uint[2] calldata _pC,
        uint[2] calldata _pubSignals
    ) external view returns (bool);
}

interface IBatchLockVerifier {
    function verifyProof(
        uint[2] calldata _pA,
        uint[2][2] calldata _pB,
        uint[2] calldata _pC,
        uint[10] calldata _pubSignals
    ) external view returns (bool);
}
