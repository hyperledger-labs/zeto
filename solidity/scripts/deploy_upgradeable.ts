import { ethers, ignition, upgrades } from "hardhat";
import erc20Module from "../ignition/modules/erc20";
import { getLinkedContractFactory, deploy } from "./lib/common";

export async function deployFungible(tokenName: string) {
  const { erc20 } = await ignition.deploy(erc20Module);
  const verifiersDeployer = require(`./tokens/${tokenName}`);
  const { deployer, args, libraries } =
    await verifiersDeployer.deployDependencies();

  let zetoFactory;
  const opts = {
    kind: "uups",
    initializer: "initialize",
    unsafeAllow: ["delegatecall"],
  };
  if (libraries) {
    zetoFactory = await getLinkedContractFactory(tokenName, libraries);
    opts.unsafeAllow.push("external-library-linking");
  } else {
    zetoFactory = await ethers.getContractFactory(tokenName);
  }

  const proxy = await upgrades.deployProxy(zetoFactory, args, opts as any);
  await proxy.waitForDeployment();
  const zetoAddress = await proxy.getAddress();
  const zeto: any = await ethers.getContractAt(tokenName, zetoAddress);

  const tx3 = await zeto.connect(deployer).setERC20(erc20.target);
  await tx3.wait();

  console.log(`ZetoToken deployed: ${zeto.target}`);
  console.log(`ERC20 deployed:     ${erc20.target}`);

  return { deployer, zeto, erc20 };
}

export async function deployNonFungible(tokenName: string) {
  const verifiersDeployer = require(`./tokens/${tokenName}`);
  const { deployer, args, libraries } =
    await verifiersDeployer.deployDependencies();

  let zetoFactory;
  const opts = {
    kind: "uups",
    initializer: "initialize",
    unsafeAllow: ["delegatecall"],
  };
  if (libraries) {
    zetoFactory = await getLinkedContractFactory(tokenName, libraries);
    opts.unsafeAllow.push("external-library-linking");
  } else {
    zetoFactory = await ethers.getContractFactory(tokenName);
  }

  const proxy = await upgrades.deployProxy(zetoFactory, args, opts as any);
  await proxy.waitForDeployment();
  const zetoAddress = await proxy.getAddress();
  const zeto: any = await ethers.getContractAt(tokenName, zetoAddress);

  console.log(`ZetoToken deployed: ${zeto.target}`);

  return { deployer, zeto };
}

deploy(deployFungible, deployNonFungible)
  .then(() => {
    if (process.env.TEST_DEPLOY_SCRIPTS == "true") {
      return;
    }
    process.exit(0);
  })
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
