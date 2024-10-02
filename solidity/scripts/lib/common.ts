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

import { artifacts, ethers } from "hardhat";
import fungibilities from "../tokens.json";

export async function getLinkedContractFactory(
  contractName: string,
  libraries: any,
) {
  const cArtifact = await artifacts.readArtifact(contractName);
  const linkedBytecode = linkBytecode(cArtifact, libraries);
  const ContractFactory = await ethers.getContractFactory(
    cArtifact.abi,
    linkedBytecode,
  );
  return ContractFactory;
}

export function deploy(deployFungible: Function, deployNonFungible: Function) {
  if (process.env.TEST_DEPLOY_SCRIPTS == "true") {
    console.log("Skipping the deploy command in test environment");
    return Promise.resolve();
  }

  const zeto = process.env.ZETO_NAME;
  if (!zeto) {
    throw new Error(
      "Please provide a Zeto token contract name with the environment variable ZETO_NAME",
    );
  }
  const fungibility = (fungibilities as any)[zeto];
  if (!fungibility) {
    throw new Error("Invalid Zeto token contract name");
  }
  if (fungibility === "fungible") {
    console.log(`Deploying fungible Zeto token: ${zeto}`);
    return deployFungible(zeto);
  } else {
    console.log(`Deploying non-fungible Zeto token: ${zeto}`);
    return deployNonFungible(zeto);
  }
}

// linkBytecode: performs linking by replacing placeholders with deployed addresses
// Recommended workaround from Hardhat team until linking feature is implemented
// https://github.com/nomiclabs/hardhat/issues/611#issuecomment-638891597
function linkBytecode(artifact: any, libraries: any) {
  let bytecode = artifact.bytecode;
  for (const [, fileReferences] of Object.entries(artifact.linkReferences)) {
    for (const [libName, fixups] of Object.entries(fileReferences as any)) {
      const addr = libraries[libName];
      if (addr === undefined) {
        continue;
      }
      for (const fixup of fixups as any) {
        bytecode =
          bytecode.substr(0, 2 + fixup.start * 2) +
          addr.substr(2) +
          bytecode.substr(2 + (fixup.start + fixup.length) * 2);
      }
    }
  }
  return bytecode;
}
