// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title A sample on-chain implementation of an account mapping between Ethereum addresses and BabyJubjub public keys
/// @author Kaleido, Inc.
contract Registry is Ownable {
    mapping(address => uint256[2]) private publicKeys;

    error AlreadyRegistered(address addr);

    constructor() Ownable(msg.sender) {}

    /// @dev Register a new public key for the calling Ethereum address
    /// @param publicKey The public key to register
    function register(
        address ethAddress,
        uint256[2] memory publicKey
    ) public onlyOwner {
        if (publicKeys[ethAddress][0] != 0 || publicKeys[ethAddress][1] != 0) {
            revert AlreadyRegistered(ethAddress);
        }
        publicKeys[ethAddress] = publicKey;
    }

    /// @dev Query the public key for a given Ethereum address
    /// @param addr The Ethereum address to query
    /// @return publicKey The public key for the given address
    function getPublicKey(
        address addr
    ) public view returns (uint256[2] memory publicKey) {
        return publicKeys[addr];
    }
}
