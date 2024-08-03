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

const DepositVerifierModule = buildModule("Groth16Verifier_CheckHashesValue", (m) => {
  const verifier = m.contract('Groth16Verifier_CheckHashesValue', []);
  return { verifier };
});

const WithdrawVerifierModule = buildModule("Groth16Verifier_CheckNullifierValue", (m) => {
  const verifier = m.contract('Groth16Verifier_CheckNullifierValue', []);
  return { verifier };
});

const VerifierModule = buildModule("Groth16Verifier_AnonNullifier", (m) => {
  const verifier = m.contract('Groth16Verifier_AnonNullifier', []);
  return { verifier };
});

export default buildModule("Zeto_AnonNullifier", (m) => {
  const { smtLib, poseidon3 } = m.useModule(SmtLibModule);
  const { verifier } = m.useModule(VerifierModule);
  const { verifier: depositVerifier } = m.useModule(DepositVerifierModule);
  const { verifier: withdrawVerifier } = m.useModule(WithdrawVerifierModule);
  const commonlib = m.library('Commonlib');
  const registryAddress = m.getParameter("registry");
  const registry = m.contractAt('Registry', registryAddress);

  const zeto = m.contract('Zeto_AnonNullifier', [depositVerifier, withdrawVerifier, verifier, registry], {
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