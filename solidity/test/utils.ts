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

  const circuit = await loadCircuit("check_hashes_value");
  const { provingKeyFile } = loadProvingKeys("check_hashes_value");

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
  let circuit = await loadCircuit("check_nullifiers_value");
  let { provingKeyFile } = loadProvingKeys("check_nullifiers_value");
  if (inputCommitments.length > 2) {
    circuit = await loadCircuit("check_nullifiers_value_batch");
    ({ provingKeyFile } = loadProvingKeys("check_nullifiers_value_batch"));
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

  let circuit = await loadCircuit("check_inputs_outputs_value");
  let { provingKeyFile } = loadProvingKeys("check_inputs_outputs_value");
  if (inputCommitments.length > 2) {
    circuit = await loadCircuit("check_inputs_outputs_value_batch");
    ({ provingKeyFile } = loadProvingKeys("check_inputs_outputs_value_batch"));
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

export async function prepareLockProof(
  signer: User,
  inputs: UTXO[],
) {
  const commitments: BigNumberish[] = inputs.map(
    (input) => input.hash || 0n,
  ) as BigNumberish[];
  const values = inputs.map((input) => BigInt(input.value || 0n));
  const salts = inputs.map((input) => input.salt || 0n);
  const otherInputs = stringifyBigInts({
    ownerPrivateKey: formatPrivKeyForBabyJub(signer.babyJubPrivateKey),
  });

  const startWitnessCalculation = Date.now();
  let circuit = await loadCircuit("check_utxos_owner");
  let { provingKeyFile: provingKey } = loadProvingKeys("check_utxos_owner");
  if (commitments.length > 2) {
    circuit = await loadCircuit("check_utxos_owner_batch");
    ({ provingKeyFile: provingKey } = loadProvingKeys("check_utxos_owner_batch"));
  }

  const witness = await circuit.calculateWTNSBin(
    {
      commitments,
      values,
      salts,
      ...otherInputs,
    },
    true,
  );
  const timeWitnessCalculation = Date.now() - startWitnessCalculation;

  const startProofGeneration = Date.now();
  const { proof, publicSignals } = (await groth16.prove(
    provingKey,
    witness,
  )) as { proof: BigNumberish[]; publicSignals: BigNumberish[] };
  const timeProofGeneration = Date.now() - startProofGeneration;
  console.log(
    `Witness calculation time: ${timeWitnessCalculation}ms, Proof generation time: ${timeProofGeneration}ms`,
  );
  const encodedProof = encodeProof(proof);
  return {
    commitments,
    encodedProof,
  };
}

export async function prepareNullifiersLockProof(
  signer: User,
  _nullifiers: UTXO[],
) {
  const nullifiers: BigNumberish[] = _nullifiers.map(
    (input) => input.hash || 0n,
  ) as BigNumberish[];
  const values = _nullifiers.map((input) => BigInt(input.value || 0n));
  const salts = _nullifiers.map((input) => input.salt || 0n);
  const otherInputs = stringifyBigInts({
    ownerPrivateKey: formatPrivKeyForBabyJub(signer.babyJubPrivateKey),
  });

  const startWitnessCalculation = Date.now();
  let circuit = await loadCircuit("check_nullifiers_owner");
  let { provingKeyFile: provingKey } = loadProvingKeys("check_nullifiers_owner");
  if (nullifiers.length > 2) {
    circuit = await loadCircuit("check_nullifiers_owner_batch");
    ({ provingKeyFile: provingKey } = loadProvingKeys("check_nullifiers_owner_batch"));
  }

  const witness = await circuit.calculateWTNSBin(
    {
      nullifiers,
      values,
      salts,
      ...otherInputs,
    },
    true,
  );
  const timeWitnessCalculation = Date.now() - startWitnessCalculation;

  const startProofGeneration = Date.now();
  const { proof, publicSignals } = (await groth16.prove(
    provingKey,
    witness,
  )) as { proof: BigNumberish[]; publicSignals: BigNumberish[] };
  const timeProofGeneration = Date.now() - startProofGeneration;
  console.log(
    `Witness calculation time: ${timeWitnessCalculation}ms, Proof generation time: ${timeProofGeneration}ms`,
  );
  const encodedProof = encodeProof(proof);
  return {
    nullifiers,
    encodedProof,
  };
}

export async function prepareAssetLockProof(
  signer: User,
  inputs: UTXO[],
) {
  const commitments: BigNumberish[] = inputs.map(
    (input) => input.hash || 0n,
  ) as BigNumberish[];
  const tokenIds = inputs.map((input) => BigInt(input.tokenId || 0n));
  const tokenUris = inputs.map((input) => BigInt(input.uri ? tokenUriHash(input.uri) : 0n));
  const salts = inputs.map((input) => input.salt || 0n);
  const otherInputs = stringifyBigInts({
    ownerPrivateKey: formatPrivKeyForBabyJub(signer.babyJubPrivateKey),
  });

  const startWitnessCalculation = Date.now();
  let circuit = await loadCircuit("check_utxos_nf_owner");
  let { provingKeyFile: provingKey } = loadProvingKeys("check_utxos_nf_owner");
  if (commitments.length > 2) {
    circuit = await loadCircuit("check_utxos_owner_batch");
    ({ provingKeyFile: provingKey } = loadProvingKeys("check_utxos_owner_batch"));
  }

  const witness = await circuit.calculateWTNSBin(
    {
      commitments,
      tokenIds,
      tokenUris,
      salts,
      ...otherInputs,
    },
    true,
  );
  const timeWitnessCalculation = Date.now() - startWitnessCalculation;

  const startProofGeneration = Date.now();
  const { proof, publicSignals } = (await groth16.prove(
    provingKey,
    witness,
  )) as { proof: BigNumberish[]; publicSignals: BigNumberish[] };
  const timeProofGeneration = Date.now() - startProofGeneration;
  console.log(
    `Witness calculation time: ${timeWitnessCalculation}ms, Proof generation time: ${timeProofGeneration}ms`,
  );
  const encodedProof = encodeProof(proof);
  return {
    commitments,
    encodedProof,
  };
}
