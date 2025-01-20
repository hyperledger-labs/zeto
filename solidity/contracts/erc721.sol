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

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Burnable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "hardhat/console.sol";

/// @title A sample implementation of a Zeto-based non-fungible token with custom ownership
/// @dev This contract provides an example of how to use ERC721 tokens
contract SampleERC721 is ERC721, ERC721Burnable, Ownable {
    uint256 private _currentTokenId;

    constructor(address initialOwner)
        ERC721("Sample ERC721 token", "SampleERC721")
        Ownable(initialOwner)
    {}

    /// @notice Mint a new token
    /// @param to The address to which the token will be minted
    function mint(address to) public onlyOwner {
        _currentTokenId++;
        _mint(to, _currentTokenId);
    }

    /// @notice Get the ID of the most recently minted token
    /// @return The current token ID
    function currentTokenId() public view returns (uint256) {
        return _currentTokenId;
    }
}
