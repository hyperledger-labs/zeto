// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Groth16Verifier_AnonNullifierQurrencyTransfer} from "../verifiers/verifier_anon_nullifier_qurrency_transfer.sol";
import {Commonlib} from "../lib/common.sol";

contract TestVerifierQurrency {
    Groth16Verifier_AnonNullifierQurrencyTransfer verifier;

    bool public lastSuccess = false;

    constructor() {
        verifier = new Groth16Verifier_AnonNullifierQurrencyTransfer();
    }

    function verifyProof(
        Commonlib.Proof memory proof,
        uint256[1] memory publicInputs
    ) public returns (bool) {
        bool result = verifier.verifyProof(
            proof.pA,
            proof.pB,
            proof.pC,
            publicInputs
        );
        lastSuccess = result;
        require(result, "Verification failed");
        return result;
    }
}
