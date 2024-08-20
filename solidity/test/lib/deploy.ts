// set this to turn off paramters checking in the deployment scripts
process.env.TEST_DEPLOY_SCRIPTS = 'true';

import { deployFungible as deployFungibleUpgradeable, deployNonFungible as deployNonFungibleUpgradeable } from '../../scripts/deploy_upgradeable';
import { deployFungible as deployFungibleCloneable, deployNonFungible as deployNonFungibleCloneable } from '../../scripts/deploy_cloneable';
import fungibilities from '../../scripts/tokens.json';
import { ethers } from 'hardhat';

export async function deployZeto(tokenName: string) {
  let zeto, erc20, deployer;

  let isFungible = false;
  const fungibility = (fungibilities as any)[tokenName];
  if (fungibility === 'fungible') {
    isFungible = true;
  }

  if (process.env.USE_FACTORY !== 'true') {
    // setup via the deployment scripts
    const deployFunc = isFungible ? deployFungibleUpgradeable : deployNonFungibleUpgradeable;
    const result = await deployFunc(tokenName);
    ({ deployer, zeto, erc20 } = result as any);
  } else {
    let args, zetoImpl;
    const deployFunc = isFungible ? deployFungibleCloneable : deployNonFungibleCloneable;
    const result = await deployFunc(tokenName);
    ({ deployer, zetoImpl, erc20, args } = result as any);

    const Factory = await ethers.getContractFactory("ZetoTokenFactory");
    const factory = await Factory.deploy();
    await factory.waitForDeployment();
    const tx1 = await factory.connect(deployer).registerImplementation(tokenName, zetoImpl.target);
    await tx1.wait();
    let tx2;
    if (isFungible) {
      tx2 = await factory.connect(deployer).deployZetoFungibleToken(tokenName, ...args);
    } else {
      tx2 = await factory.connect(deployer).deployZetoNonFungibleToken(tokenName, ...args);
    }
    const result1 = await tx2.wait();

    let zetoAddress;
    for (const log of result1!.logs) {
      const event = factory.interface.parseLog(log as any);
      if (event?.name === 'ZetoTokenDeployed') {
        zetoAddress = event!.args!.zetoToken;
      }
    }
    zeto = await ethers.getContractAt(tokenName, zetoAddress);
  }

  return { deployer, zeto, erc20 };
}