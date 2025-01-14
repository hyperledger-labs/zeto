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

export const SmtLibModule = buildModule("SmtLib", (m) => {
  const poseidon2 = m.library("Poseidon2", PoseidonArtifact(2));
  const poseidon3 = m.library("Poseidon3", PoseidonArtifact(3));
  const smtLib = m.contract("SmtLib", [], {
    libraries: {
      PoseidonUnit2L: poseidon2,
      PoseidonUnit3L: poseidon3,
    },
  });
  return { smtLib, poseidon2, poseidon3 };
});

export const DepositVerifierModule = buildModule(
  "Groth16Verifier_CheckHashesValue",
  (m) => {
    const verifier = m.contract("Groth16Verifier_CheckHashesValue", []);
    return { verifier };
  },
);

export const WithdrawNullifierVerifierModule = buildModule(
  "Groth16Verifier_CheckNullifierValue",
  (m) => {
    const verifier = m.contract("Groth16Verifier_CheckNullifierValue", []);
    return { verifier };
  },
);
export const BatchWithdrawNullifierVerifierModule = buildModule(
  "Groth16Verifier_CheckNullifierValueBatch",
  (m) => {
    const verifier = m.contract("Groth16Verifier_CheckNullifierValueBatch", []);
    return { verifier };
  },
);

export const WithdrawVerifierModule = buildModule(
  "Groth16Verifier_CheckInputsOutputsValue",
  (m) => {
    const verifier = m.contract("Groth16Verifier_CheckInputsOutputsValue", []);
    return { verifier };
  },
);
export const BatchWithdrawVerifierModule = buildModule(
  "Groth16Verifier_CheckInputsOutputsValueBatch",
  (m) => {
    const verifier = m.contract(
      "Groth16Verifier_CheckInputsOutputsValueBatch",
      [],
    );
    return { verifier };
  },
);

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
    deployedLinkReferences: {},
  };
  return artifact;
}
