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

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { poseidonContract } from "circomlibjs";
import { Artifact } from "hardhat/types";

const SmtLibModule = buildModule("SmtLib", (m) => {
  const poseidon2 = m.library('Poseidon2', PoseidonArtifact(2));
  const poseidon3 = m.library('Poseidon3', PoseidonArtifact(3));
  const smtLib = m.contract('SmtLib', [], {
    libraries: {
      PoseidonUnit2L: poseidon2,
      PoseidonUnit3L: poseidon3,
    },
  });
  return { smtLib, poseidon3 };
});

const VerifierModule = buildModule("Groth16Verifier_AnonEncNullifier", (m) => {
  const verifier = m.contract('Groth16Verifier_AnonEncNullifier', []);
  return { verifier };
});

export default buildModule("Zeto_AnonEncNullifier", (m) => {
  const { smtLib, poseidon3 } = m.useModule(SmtLibModule);
  const { verifier } = m.useModule(VerifierModule);
  const commonlib = m.library('Commonlib');
  const registryAddress = m.getParameter("registry");
  const registry = m.contractAt('Registry', registryAddress);

  const zeto = m.contract('Zeto_AnonEncNullifier', [verifier, registry], {
    libraries: {
      SmtLib: smtLib,
      PoseidonUnit3L: poseidon3,
      Commonlib: commonlib,
    },
  });

  return { zeto, registry };
});

function PoseidonArtifact(param: number): Artifact {
  const abi = poseidonContract.generateABI(param);
  const bytecode = poseidonContract.createCode(param);
  const artifact: Artifact = {
    _format: "hh-sol-artifact-1",
    contractName: `Poseidon${param}`,
    sourceName: "",
    abi: abi,
    bytecode: bytecode,
    deployedBytecode: "", // "0x"-prefixed hex string
    linkReferences: {},
    deployedLinkReferences: {}
  };
  return artifact;
}