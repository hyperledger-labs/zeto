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

import { ethers, network } from 'hardhat';
import { Signer } from 'ethers';
import { expect } from 'chai';

describe("Zeto based fungible token with anonymity without encryption or nullifier", function () {
  let deployer: Signer;
  let nonOwner: Signer;

  before(async function () {
    if (network.name !== 'hardhat') {
      // accommodate for longer block times on public networks
      this.timeout(120000);
    }
    [deployer, nonOwner] = await ethers.getSigners();
  });

  it("attempting to register an implementation as a non-owner should fail", async function () {
    const Factory = await ethers.getContractFactory("ZetoTokenFactory");
    const factory = await Factory.deploy();
    await factory.waitForDeployment();

    const implInfo = {
      implementation: "0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1",
      verifier: "0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1",
      depositVerifier: "0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1",
      withdrawVerifier: "0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1",
    };
    await expect(factory.connect(nonOwner).registerImplementation("test", implInfo as any)).rejectedWith(`reverted with custom error 'OwnableUnauthorizedAccount(`);
  });

  it("attempting to register an implementation without the required implementation value should fail", async function () {
    // we want to test the effectiveness of the factory contract
    // to create clones of the Zeto implementation contract
    const Factory = await ethers.getContractFactory("ZetoTokenFactory");
    const factory = await Factory.deploy();
    await factory.waitForDeployment();

    const implInfo = {
      implementation: "0x0000000000000000000000000000000000000000",
      verifier: "0x0000000000000000000000000000000000000000",
      depositVerifier: "0x0000000000000000000000000000000000000000",
      withdrawVerifier: "0x0000000000000000000000000000000000000000",
    };
    await expect(factory.connect(deployer).registerImplementation("test", implInfo as any)).rejectedWith("Factory: implementation address is required");
  });

  it("attempting to register an implementation without the required verifier value should fail", async function () {
    // we want to test the effectiveness of the factory contract
    // to create clones of the Zeto implementation contract
    const Factory = await ethers.getContractFactory("ZetoTokenFactory");
    const factory = await Factory.deploy();
    await factory.waitForDeployment();

    const implInfo = {
      implementation: "0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1",
      verifier: "0x0000000000000000000000000000000000000000",
      depositVerifier: "0x0000000000000000000000000000000000000000",
      withdrawVerifier: "0x0000000000000000000000000000000000000000",
    };
    await expect(factory.connect(deployer).registerImplementation("test", implInfo as any)).rejectedWith("Factory: verifier address is required");
  });

  it("attempting to register an implementation with the required values should succeed", async function () {
    // we want to test the effectiveness of the factory contract
    // to create clones of the Zeto implementation contract
    const Factory = await ethers.getContractFactory("ZetoTokenFactory");
    const factory = await Factory.deploy();
    await factory.waitForDeployment();

    const implInfo = {
      implementation: "0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1",
      verifier: "0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1",
      depositVerifier: "0x0000000000000000000000000000000000000000",
      withdrawVerifier: "0x0000000000000000000000000000000000000000",
    };
    await expect(factory.connect(deployer).registerImplementation("test", implInfo as any)).fulfilled;
  });

  it("attempting to deploy a fungible token but with a registered implementation that misses required depositVerifier should fail", async function () {
    // we want to test the effectiveness of the factory contract
    // to create clones of the Zeto implementation contract
    const Factory = await ethers.getContractFactory("ZetoTokenFactory");
    const factory = await Factory.deploy();
    await factory.waitForDeployment();

    const implInfo = {
      implementation: "0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1",
      verifier: "0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1",
      depositVerifier: "0x0000000000000000000000000000000000000000",
      withdrawVerifier: "0x0000000000000000000000000000000000000000",
    };
    const tx1 = await factory.connect(deployer).registerImplementation("test", implInfo as any);
    await tx1.wait();

    await expect(factory.connect(deployer).deployZetoFungibleToken("test", await deployer.getAddress())).rejectedWith("Factory: depositVerifier address is required");
  });

  it("attempting to deploy a fungible token but with a registered implementation that misses required withdrawVerifier should fail", async function () {
    // we want to test the effectiveness of the factory contract
    // to create clones of the Zeto implementation contract
    const Factory = await ethers.getContractFactory("ZetoTokenFactory");
    const factory = await Factory.deploy();
    await factory.waitForDeployment();

    const implInfo = {
      implementation: "0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1",
      verifier: "0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1",
      depositVerifier: "0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1",
      withdrawVerifier: "0x0000000000000000000000000000000000000000",
    };
    const tx1 = await factory.connect(deployer).registerImplementation("test", implInfo as any);
    await tx1.wait();

    await expect(factory.connect(deployer).deployZetoFungibleToken("test", await deployer.getAddress())).rejectedWith("Factory: withdrawVerifier address is required");
  });

  it("attempting to deploy a fungible token with a properly registered implementation should succeed", async function () {
    // we want to test the effectiveness of the factory contract
    // to create clones of the Zeto implementation contract
    const Factory = await ethers.getContractFactory("ZetoTokenFactory");
    const factory = await Factory.deploy();
    await factory.waitForDeployment();

    const implInfo = {
      implementation: "0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1",
      verifier: "0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1",
      depositVerifier: "0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1",
      withdrawVerifier: "0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1",
    };
    const tx1 = await factory.connect(deployer).registerImplementation("test", implInfo as any);
    await tx1.wait();

    await expect(factory.connect(deployer).deployZetoFungibleToken("test", await deployer.getAddress())).fulfilled;
  });
});