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

import { ethers, ignition } from "hardhat";
import zetoModule from "../../ignition/modules/zeto_nf_anon_nullifier";

export async function deployDependencies() {
  const [deployer] = await ethers.getSigners();

  const { verifier, lockVerifier, smtLib, poseidon3 } = await ignition.deploy(zetoModule);
  return {
    deployer,
    args: [
      await deployer.getAddress(),
      verifier.target,
      lockVerifier.target,
    ],
    libraries: {
      SmtLib: smtLib.target,
      PoseidonUnit3L: poseidon3.target,
    },
  };
}
