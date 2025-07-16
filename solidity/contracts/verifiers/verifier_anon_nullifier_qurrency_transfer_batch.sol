// SPDX-License-Identifier: GPL-3.0
/*
    Copyright 2021 0KIMS association.

    This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

    snarkJS is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    snarkJS is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with snarkJS. If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity >=0.7.0 <0.9.0;

import {Verifier_AnonNullifierQurrencyTransferBatch} from "./impl/anon_nullifier_qurrency_transfer_batch.sol";

contract Groth16Verifier_AnonNullifierQurrencyTransferBatch is
    Verifier_AnonNullifierQurrencyTransferBatch
{
    function verify(
        uint[2] calldata _pA,
        uint[2][2] calldata _pB,
        uint[2] calldata _pC,
        uint[] calldata _pubSignals
    ) public view returns (bool) {
        uint256[120] memory fixedSizeInputs;
        for (uint256 i = 0; i < fixedSizeInputs.length; i++) {
            fixedSizeInputs[i] = _pubSignals[i];
        }
        return this.verifyProof(_pA, _pB, _pC, fixedSizeInputs);
    }
}
