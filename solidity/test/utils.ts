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

import { readFileSync } from "fs";
import * as path from "path";
import crypto from "crypto";
import { BigNumberish } from "ethers";
import { groth16 } from "snarkjs";
import { loadCircuit, encodeProof, tokenUriHash } from "zeto-js";
import { User, UTXO } from "./lib/utils";
import { formatPrivKeyForBabyJub, stringifyBigInts } from "maci-crypto";

function provingKeysRoot() {
  const PROVING_KEYS_ROOT = process.env.PROVING_KEYS_ROOT;
  if (!PROVING_KEYS_ROOT) {
    throw new Error("PROVING_KEYS_ROOT env var is not set");
  }
  return PROVING_KEYS_ROOT;
}

export function loadProvingKeys(type: string) {
  const provingKeyFile = path.join(provingKeysRoot(), `${type}.zkey`);
  const verificationKey = JSON.parse(
    new TextDecoder().decode(
      readFileSync(path.join(provingKeysRoot(), `${type}-vkey.json`)),
    ),
  );
  return {
    provingKeyFile,
    verificationKey,
  };
}

export async function prepareDepositProof(signer: User, outputs: [UTXO, UTXO]) {
  const outputCommitments: [BigNumberish, BigNumberish] = [
    outputs[0].hash,
    outputs[1].hash,
  ] as [BigNumberish, BigNumberish];
  const outputValues = [
    BigInt(outputs[0].value || 0n),
    BigInt(outputs[1].value || 0n),
  ];
  const outputOwnerPublicKeys: [
    [BigNumberish, BigNumberish],
    [BigNumberish, BigNumberish],
  ] = [signer.babyJubPublicKey, signer.babyJubPublicKey] as [
    [BigNumberish, BigNumberish],
    [BigNumberish, BigNumberish],
  ];

  const inputObj = {
    outputCommitments,
    outputValues,
    outputSalts: [outputs[0].salt, outputs[1].salt],
    outputOwnerPublicKeys,
  };

  const circuit = await loadCircuit("deposit");
  const { provingKeyFile } = loadProvingKeys("deposit");

  const startWitnessCalculation = Date.now();
  const witness = await circuit.calculateWTNSBin(inputObj, true);
  const timeWithnessCalculation = Date.now() - startWitnessCalculation;

  const startProofGeneration = Date.now();
  const { proof, publicSignals } = (await groth16.prove(
    provingKeyFile,
    witness,
  )) as { proof: BigNumberish[]; publicSignals: BigNumberish[] };
  const timeProofGeneration = Date.now() - startProofGeneration;

  console.log(
    `Witness calculation time: ${timeWithnessCalculation}ms. Proof generation time: ${timeProofGeneration}ms.`,
  );

  const encodedProof = encodeProof(proof);
  return {
    outputCommitments,
    encodedProof,
  };
}

export async function prepareWithdrawProof(
  signer: User,
  inputs: UTXO[],
  output: UTXO,
) {
  const inputCommitments: BigNumberish[] = inputs.map(
    (input) => input.hash,
  ) as BigNumberish[];
  const inputValues = inputs.map((input) => BigInt(input.value || 0n));
  const inputSalts = inputs.map((input) => input.salt || 0n);
  const outputCommitments: [BigNumberish] = [output.hash] as [BigNumberish];
  const outputValues = [BigInt(output.value || 0n)];
  const outputOwnerPublicKeys: [[BigNumberish, BigNumberish]] = [
    signer.babyJubPublicKey,
  ] as [[BigNumberish, BigNumberish]];

  const inputObj = {
    inputCommitments,
    inputValues,
    inputSalts,
    inputOwnerPrivateKey: signer.formattedPrivateKey,
    outputCommitments,
    outputValues,
    outputSalts: [output.salt || 0n],
    outputOwnerPublicKeys,
  };

  let circuit = await loadCircuit("withdraw");
  let { provingKeyFile } = loadProvingKeys("withdraw");
  if (inputCommitments.length > 2) {
    circuit = await loadCircuit("withdraw_batch");
    ({ provingKeyFile } = loadProvingKeys("withdraw_batch"));
  }

  const startWitnessCalculation = Date.now();
  const witness = await circuit.calculateWTNSBin(inputObj, true);
  const timeWithnessCalculation = Date.now() - startWitnessCalculation;

  const startProofGeneration = Date.now();
  const { proof, publicSignals } = (await groth16.prove(
    provingKeyFile,
    witness,
  )) as { proof: BigNumberish[]; publicSignals: BigNumberish[] };
  const timeProofGeneration = Date.now() - startProofGeneration;

  console.log(
    `Witness calculation time: ${timeWithnessCalculation}ms. Proof generation time: ${timeProofGeneration}ms.`,
  );

  const encodedProof = encodeProof(proof);
  return {
    inputCommitments,
    outputCommitments,
    encodedProof,
  };
}

export async function prepareNullifierWithdrawProof(
  signer: User,
  inputs: UTXO[],
  _nullifiers: UTXO[],
  output: UTXO,
  root: BigInt,
  merkleProof: BigInt[][],
) {
  const nullifiers = _nullifiers.map(
    (nullifier) => nullifier.hash,
  ) as BigNumberish[];
  const inputCommitments: BigNumberish[] = inputs.map(
    (input) => input.hash,
  ) as BigNumberish[];
  const inputValues = inputs.map((input) => BigInt(input.value || 0n));
  const inputSalts = inputs.map((input) => input.salt || 0n);
  const outputCommitments: [BigNumberish] = [output.hash] as [BigNumberish];
  const outputValues = [BigInt(output.value || 0n)];
  const outputOwnerPublicKeys: [[BigNumberish, BigNumberish]] = [
    signer.babyJubPublicKey,
  ] as [[BigNumberish, BigNumberish]];

  const inputObj = {
    nullifiers,
    inputCommitments,
    inputValues,
    inputSalts,
    inputOwnerPrivateKey: signer.formattedPrivateKey,
    root,
    enabled: nullifiers.map((n) => (n !== 0n ? 1 : 0)),
    merkleProof,
    outputCommitments,
    outputValues,
    outputSalts: [output.salt || 0n],
    outputOwnerPublicKeys,
  };
  let circuit = await loadCircuit("withdraw_nullifier");
  let { provingKeyFile } = loadProvingKeys("withdraw_nullifier");
  if (inputCommitments.length > 2) {
    circuit = await loadCircuit("withdraw_nullifier_batch");
    ({ provingKeyFile } = loadProvingKeys("withdraw_nullifier_batch"));
  }

  const startWitnessCalculation = Date.now();
  const witness = await circuit.calculateWTNSBin(inputObj, true);
  const timeWithnessCalculation = Date.now() - startWitnessCalculation;

  const startProofGeneration = Date.now();
  const { proof, publicSignals } = (await groth16.prove(
    provingKeyFile,
    witness,
  )) as { proof: BigNumberish[]; publicSignals: BigNumberish[] };
  const timeProofGeneration = Date.now() - startProofGeneration;

  console.log(
    `Witness calculation time: ${timeWithnessCalculation}ms. Proof generation time: ${timeProofGeneration}ms.`,
  );

  const encodedProof = encodeProof(proof);
  return {
    nullifiers,
    outputCommitments,
    encodedProof,
  };
}

export async function prepareBurnProof(
  signer: User,
  inputs: UTXO[],
  output: UTXO,
) {
  const inputCommitments: BigNumberish[] = inputs.map(
    (input) => input.hash,
  ) as BigNumberish[];
  const inputValues = inputs.map((input) => BigInt(input.value || 0n));
  const inputSalts = inputs.map((input) => input.salt || 0n);

  const inputObj = {
    inputCommitments,
    inputValues,
    inputSalts,
    ownerPrivateKey: signer.formattedPrivateKey,
    outputCommitment: [output.hash],
    outputValue: [BigInt(output.value || 0n)],
    outputSalt: [output.salt || 0n],
  };

  let circuit = await loadCircuit("burn");
  let { provingKeyFile } = loadProvingKeys("burn");
  if (inputCommitments.length > 2) {
    circuit = await loadCircuit("burn_batch");
    ({ provingKeyFile } = loadProvingKeys("burn_batch"));
  }

  const startWitnessCalculation = Date.now();
  const witness = await circuit.calculateWTNSBin(inputObj, true);
  const timeWithnessCalculation = Date.now() - startWitnessCalculation;

  const startProofGeneration = Date.now();
  const { proof, publicSignals } = (await groth16.prove(
    provingKeyFile,
    witness,
  )) as { proof: BigNumberish[]; publicSignals: BigNumberish[] };
  const timeProofGeneration = Date.now() - startProofGeneration;

  console.log(
    `Witness calculation time: ${timeWithnessCalculation}ms. Proof generation time: ${timeProofGeneration}ms.`,
  );

  const encodedProof = encodeProof(proof);
  return {
    inputCommitments,
    outputCommitment: output.hash,
    encodedProof,
  };
}

export async function prepareNullifierBurnProof(
  signer: User,
  inputs: UTXO[],
  _nullifiers: UTXO[],
  root: BigInt,
  merkleProof: BigInt[][],
) {
  const nullifiers = _nullifiers.map(
    (nullifier) => nullifier.hash,
  ) as BigNumberish[];
  const commitments: BigNumberish[] = inputs.map(
    (input) => input.hash,
  ) as BigNumberish[];
  const values = inputs.map((input) => BigInt(input.value || 0n));
  const salts = inputs.map((input) => input.salt || 0n);

  const inputObj = {
    nullifiers,
    commitments,
    values,
    salts,
    ownerPrivateKey: signer.formattedPrivateKey,
    root,
    enabled: nullifiers.map((n) => (n !== 0n ? 1 : 0)),
    merkleProof,
  };

  let circuit = await loadCircuit("burn_nullifier");
  let { provingKeyFile } = loadProvingKeys("burn_nullifier");
  if (commitments.length > 2) {
    circuit = await loadCircuit("burn_nullifier_batch");
    ({ provingKeyFile } = loadProvingKeys("burn_nullifier_batch"));
  }

  const startWitnessCalculation = Date.now();
  const witness = await circuit.calculateWTNSBin(inputObj, true);
  const timeWithnessCalculation = Date.now() - startWitnessCalculation;

  const startProofGeneration = Date.now();
  const { proof, publicSignals } = (await groth16.prove(
    provingKeyFile,
    witness,
  )) as { proof: BigNumberish[]; publicSignals: BigNumberish[] };
  const timeProofGeneration = Date.now() - startProofGeneration;

  console.log(
    `Witness calculation time: ${timeWithnessCalculation}ms. Proof generation time: ${timeProofGeneration}ms.`,
  );

  const encodedProof = encodeProof(proof);
  return {
    nullifiers,
    commitments,
    encodedProof,
  };
}

export function randomBytesAsDigitArray(length: number) {
  const bytes = crypto.randomBytes(length);
  let s = "";
  for (let i = 0; i < bytes.length; i++) {
    s += bytes[i].toString(2).padStart(8, "0");
  }
  return s.split('').map(b => parseInt(b));
}