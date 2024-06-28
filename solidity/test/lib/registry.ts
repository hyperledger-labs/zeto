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

import { ethers } from 'hardhat';
import { Signer, BigNumberish } from 'ethers';
import { expect } from 'chai';
import { Registry } from "../../typechain-types";
import { genKeypair, Keypair } from 'maci-crypto';

describe('Registry tests', function () {
  let registry: Registry;
  let owner: Signer;
  let sender: Signer;
  let receiver: Signer;
  let senderKeypair: Keypair;
  let receiverKeypair: Keypair;

  before(async function () {
    [owner, sender, receiver] = await ethers.getSigners();
    const Registry = await ethers.getContractFactory("Registry", owner);
    registry = await Registry.deploy();
    console.log(`Registry deployed to ${registry.target}`);
  });

  it('should register a new user', async function () {
    senderKeypair = genKeypair();
    receiverKeypair = genKeypair();

    const senderAddress = await sender.getAddress();
    const tx1 = await registry.connect(owner).register(senderAddress, senderKeypair.pubKey as [BigNumberish, BigNumberish]);
    const receipt1 = await tx1.wait();
    expect(receipt1!.status).to.equal(1);

    const receiverAddress = await receiver.getAddress();
    const tx2 = await registry.connect(owner).register(receiverAddress, receiverKeypair.pubKey as [BigNumberish, BigNumberish]);
    const receipt2 = await tx2.wait();
    expect(receipt2!.status).to.equal(1);
  });

  it('should return the correct public key', async function () {
    const pubKey = await registry.connect(owner).getPublicKey(await sender.getAddress());
    expect(pubKey).to.deep.equal(senderKeypair.pubKey);
  });

});