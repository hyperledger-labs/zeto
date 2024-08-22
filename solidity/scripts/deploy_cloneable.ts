import { ethers, ignition } from "hardhat";
import erc20Module from '../ignition/modules/erc20';
import { getLinkedContractFactory, deploy } from "./lib/common";

export async function deployFungible(tokenName: string) {
  const { erc20 } = await ignition.deploy(erc20Module);
  const verifiersDeployer = require(`./tokens/${tokenName}`);
  const { deployer, args, libraries } = await verifiersDeployer.deployDependencies();

  let zetoFactory;
  const opts = {
    kind: 'uups',
    initializer: 'initialize',
    unsafeAllow: ['delegatecall']
  };
  if (libraries) {
    zetoFactory = await getLinkedContractFactory(tokenName, libraries);
    opts.unsafeAllow.push('external-library-linking');
  } else {
    zetoFactory = await ethers.getContractFactory(tokenName)
  }

  const zetoImpl: any = await zetoFactory.deploy();
  await zetoImpl.waitForDeployment();
  await zetoImpl.connect(deployer).initialize(...args);

  console.log(`ERC20 deployed:     ${erc20.target}`);
  console.log(`ZetoToken deployed: ${zetoImpl.target}`);

  return { deployer, zetoImpl, erc20, args };
}

export async function deployNonFungible(tokenName: string) {
  const [deployer] = await ethers.getSigners();
  const verifiersDeployer = require(`./tokens/${tokenName}`);
  const { args, libraries } = await verifiersDeployer.deployDependencies();

  let zetoFactory;
  const opts = {
    kind: 'uups',
    initializer: 'initialize',
    unsafeAllow: ['delegatecall']
  };
  if (libraries) {
    zetoFactory = await getLinkedContractFactory(tokenName, libraries);
    opts.unsafeAllow.push('external-library-linking');
  } else {
    zetoFactory = await ethers.getContractFactory(tokenName)
  }
  const zetoImpl: any = await zetoFactory.deploy();
  await zetoImpl.waitForDeployment();
  await zetoImpl.connect(deployer).initialize(...args);

  console.log(`ZetoToken deployed: ${zetoImpl.target}`);

  return { deployer, zetoImpl, args };
}

deploy(deployFungible, deployNonFungible)
  .then(() => {
    if (process.env.TEST_DEPLOY_SCRIPTS == 'true') {
      return;
    }
    process.exit(0);
  })
  .catch(error => {
    console.error(error);
    process.exit(1);
  });