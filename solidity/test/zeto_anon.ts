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

import { ethers, network } from "hardhat";
import { Signer, BigNumberish, AddressLike, ZeroAddress } from "ethers";
import { expect } from "chai";
import { loadCircuit, encodeProof, Poseidon } from "zeto-js";
import { groth16 } from "snarkjs";
import { formatPrivKeyForBabyJub, stringifyBigInts } from "maci-crypto";
import {
  User,
  UTXO,
  newUser,
  newUTXO,
  doMint,
  parseUTXOEvents,
  ZERO_UTXO,
} from "./lib/utils";
import {
  loadProvingKeys,
  prepareDepositProof,
  prepareWithdrawProof,
} from "./utils";
import { Zeto_Anon } from "../typechain-types";
import { deployZeto } from "./lib/deploy";

const ZERO_PUBKEY = [0, 0];
const poseidonHash = Poseidon.poseidon4;

describe("Zeto based fungible token with anonymity without encryption or nullifier", function () {
  let deployer: Signer;
  let Alice: User;
  let Bob: User;
  let Charlie: User;
  let erc20: any;
  let zeto: Zeto_Anon;
  let utxo100: UTXO;
  let utxo1: UTXO;
  let utxo2: UTXO;
  let utxo3: UTXO;
  let utxo4: UTXO;
  let utxo7: UTXO;
  let circuit: any, provingKey: any;
  let batchCircuit: any, batchProvingKey: any;

  before(async function () {
    if (network.name !== "hardhat") {
      // accommodate for longer block times on public networks
      this.timeout(120000);
    }
    let [d, a, b, c] = await ethers.getSigners();
    deployer = d;
    Alice = await newUser(a);
    Bob = await newUser(b);
    Charlie = await newUser(c);

    ({ deployer, zeto, erc20 } = await deployZeto("Zeto_Anon"));

    circuit = await loadCircuit("anon");
    ({ provingKeyFile: provingKey } = loadProvingKeys("anon"));

    batchCircuit = await loadCircuit("anon_batch");
    ({ provingKeyFile: batchProvingKey } = loadProvingKeys("anon_batch"));
  });

  it("(batch) mint to Alice and batch transfer 10 UTXOs honestly to Bob & Charlie then withdraw should succeed", async function () {
    // first mint the tokens for batch testing
    const inputUtxos = [];
    for (let i = 0; i < 10; i++) {
      // mint 10 utxos
      inputUtxos.push(newUTXO(1, Alice));
    }
    await doMint(zeto, deployer, inputUtxos);

    const aliceUTXOsToBeWithdrawn = [
      newUTXO(1, Alice),
      newUTXO(1, Alice),
      newUTXO(1, Alice),
    ];
    // Alice proposes the output UTXOs, 1 utxo to bob, 1 utxo to charlie and 3 utxos to alice
    const _bOut1 = newUTXO(6, Bob);
    const _bOut2 = newUTXO(1, Charlie);

    const outputUtxos = [_bOut1, _bOut2, ...aliceUTXOsToBeWithdrawn];
    const outputOwners = [Bob, Charlie, Alice, Alice, Alice];
    const inflatedOutputUtxos = [...outputUtxos];
    const inflatedOutputOwners = [...outputOwners];
    for (let i = 0; i < 10 - outputUtxos.length; i++) {
      inflatedOutputUtxos.push(ZERO_UTXO);
      inflatedOutputOwners.push(Bob);
    }

    // Alice transfers UTXOs to Bob and Charlie
    const result = await doTransfer(
      Alice,
      inputUtxos,
      inflatedOutputUtxos,
      inflatedOutputOwners,
    );

    const events = parseUTXOEvents(zeto, result);
    const incomingUTXOs: any = events[0].outputs;
    // check the non-empty output hashes are correct
    for (let i = 0; i < outputUtxos.length; i++) {
      // Bob uses the information received from Alice to reconstruct the UTXO sent to him
      const receivedValue = outputUtxos[i].value;
      const receivedSalt = outputUtxos[i].salt;
      const hash = poseidonHash([
        BigInt(receivedValue),
        receivedSalt,
        outputOwners[i].babyJubPublicKey[0],
        outputOwners[i].babyJubPublicKey[1],
      ]);
      expect(incomingUTXOs[i]).to.equal(hash);
    }

    // check empty hashes are empty
    for (let i = outputUtxos.length; i < 10; i++) {
      expect(incomingUTXOs[i]).to.equal(0);
    }

    // mint sufficient balance in Zeto contract address for Alice to withdraw
    const mintTx = await erc20.connect(deployer).mint(zeto, 3);
    await mintTx.wait();
    const startingBalance = await erc20.balanceOf(Alice.ethAddress);

    // Alice generates the nullifiers for the UTXOs to be spent
    const inflatedWithdrawInputs = [...aliceUTXOsToBeWithdrawn];

    // Alice generates inclusion proofs for the UTXOs to be spent

    for (let i = aliceUTXOsToBeWithdrawn.length; i < 10; i++) {
      inflatedWithdrawInputs.push(ZERO_UTXO);
    }
    const { inputCommitments, outputCommitments, encodedProof } =
      await prepareWithdrawProof(Alice, inflatedWithdrawInputs, ZERO_UTXO);

    // Alice withdraws her UTXOs to ERC20 tokens
    const tx = await zeto
      .connect(Alice.signer)
      .withdraw(3, inputCommitments, outputCommitments[0], encodedProof);
    await tx.wait();

    // Alice checks her ERC20 balance
    const endingBalance = await erc20.balanceOf(Alice.ethAddress);
    expect(endingBalance - startingBalance).to.be.equal(3);
  });

  it("mint ERC20 tokens to Alice to deposit to Zeto should succeed", async function () {
    const startingBalance = await erc20.balanceOf(Alice.ethAddress);
    const tx = await erc20.connect(deployer).mint(Alice.ethAddress, 100);
    await tx.wait();
    const endingBalance = await erc20.balanceOf(Alice.ethAddress);
    expect(endingBalance - startingBalance).to.be.equal(100);

    const tx1 = await erc20.connect(Alice.signer).approve(zeto.target, 100);
    await tx1.wait();

    utxo100 = newUTXO(100, Alice);
    const { outputCommitments, encodedProof } = await prepareDepositProof(
      Alice,
      utxo100,
    );
    const tx2 = await zeto
      .connect(Alice.signer)
      .deposit(100, outputCommitments[0], encodedProof, "0x");
    await tx2.wait();
  });

  it("mint to Alice and transfer UTXOs honestly to Bob should succeed", async function () {
    const startingBalance = await erc20.balanceOf(Alice.ethAddress);
    // first the authority mints UTXOs to Alice
    utxo1 = newUTXO(10, Alice);
    utxo2 = newUTXO(20, Alice);
    await doMint(zeto, deployer, [utxo1, utxo2]);

    // check the private mint activity is not exposed in the ERC20 contract
    const afterMintBalance = await erc20.balanceOf(Alice.ethAddress);
    expect(afterMintBalance).to.equal(startingBalance);

    // Alice proposes the output UTXOs
    const _txo3 = newUTXO(25, Bob);
    utxo4 = newUTXO(5, Alice, _txo3.salt);

    // Alice transfers UTXOs to Bob
    const result = await doTransfer(
      Alice,
      [utxo1, utxo2],
      [_txo3, utxo4],
      [Bob, Alice],
    );

    // check the private transfer activity is not exposed in the ERC20 contract
    const afterTransferBalance = await erc20.balanceOf(Alice.ethAddress);
    expect(afterTransferBalance).to.equal(startingBalance);

    // Bob reconstructs the UTXO from off-chain secure message channels with Alice
    // first obtain the UTXOs from the transaction event
    const events = parseUTXOEvents(zeto, result);
    const incomingUTXOs: any = events[0].outputs;

    // Bob uses the information received from Alice to reconstruct the UTXO sent to him
    const receivedValue = 25;
    const receivedSalt = _txo3.salt;
    const hash = poseidonHash([
      BigInt(receivedValue),
      receivedSalt,
      Bob.babyJubPublicKey[0],
      Bob.babyJubPublicKey[1],
    ]);
    expect(incomingUTXOs[0]).to.equal(hash);

    // now Bob can reconstruct the UTXO using the information received from Alice
    utxo3 = newUTXO(receivedValue, Bob, receivedSalt);
  });

  it("Bob transfers UTXOs, previously received from Alice, honestly to Charlie should succeed", async function () {
    const startingBalance = await erc20.balanceOf(Alice.ethAddress);
    // give Bob another UTXO to be able to spend
    const _utxo1 = newUTXO(20, Bob);
    await doMint(zeto, deployer, [_utxo1]);

    // check the private mint activity is not exposed in the ERC20 contract
    const afterMintBalance = await erc20.balanceOf(Alice.ethAddress);
    expect(afterMintBalance).to.equal(startingBalance);

    // propose the output UTXOs
    const _utxo2 = newUTXO(30, Charlie);
    utxo7 = newUTXO(15, Bob);

    // Bob should be able to spend the UTXO that was reconstructed from the previous transaction
    await doTransfer(Bob, [utxo3, _utxo1], [_utxo2, utxo7], [Charlie, Bob]);

    // check the private transfer activity is not exposed in the ERC20 contract
    const afterTransferBalance = await erc20.balanceOf(Alice.ethAddress);
    expect(afterTransferBalance).to.equal(startingBalance);
  });

  it("Alice withdraws her UTXOs to ERC20 tokens should succeed", async function () {
    const startingBalance = await erc20.balanceOf(Alice.ethAddress);

    // Alice proposes the output ERC20 tokens
    const outputCommitment = newUTXO(20, Alice);

    const { inputCommitments, outputCommitments, encodedProof } =
      await prepareWithdrawProof(Alice, [utxo100, ZERO_UTXO], outputCommitment);

    // Alice withdraws her UTXOs to ERC20 tokens
    const tx = await zeto
      .connect(Alice.signer)
      .withdraw(80, inputCommitments, outputCommitments[0], encodedProof);
    await tx.wait();

    // Alice checks her ERC20 balance
    const endingBalance = await erc20.balanceOf(Alice.ethAddress);
    expect(endingBalance - startingBalance).to.be.equal(80);
  });

  it("Test support for large values, such as when using 18 decimals", async function () {
    const EighteenDecimals = 10 ** 18;

    // first the authority mints UTXOs to Alice
    const utxo1 = newUTXO(10 * EighteenDecimals, Alice);
    const utxo2 = newUTXO(20 * EighteenDecimals, Alice);
    await doMint(zeto, deployer, [utxo1, utxo2]);

    // Alice proposes the output UTXOs
    const utxo3 = newUTXO(25 * EighteenDecimals, Bob);
    const utxo4 = newUTXO(5 * EighteenDecimals, Alice);

    // Alice transfers UTXOs to Bob
    const result = await doTransfer(
      Alice,
      [utxo1, utxo2],
      [utxo3, utxo4],
      [Bob, Alice],
    );

    // Bob reconstructs the UTXO from off-chain secure message channels with Alice
    // first obtain the UTXOs from the transaction event
    const events = parseUTXOEvents(zeto, result);
    const incomingUTXOs: any = events[0].outputs;

    // Bob uses the information received from Alice to reconstruct the UTXO sent to him
    const receivedValue = 25 * EighteenDecimals;
    const receivedSalt = utxo3.salt;
    const hash = poseidonHash([
      BigInt(receivedValue),
      receivedSalt,
      Bob.babyJubPublicKey[0],
      Bob.babyJubPublicKey[1],
    ]);
    expect(incomingUTXOs[0]).to.equal(hash);
  });

  describe("failure cases", function () {
    // the following failure cases rely on the hardhat network
    // to return the details of the errors. This is not possible
    // on non-hardhat networks
    if (network.name !== "hardhat") {
      return;
    }

    it("Alice attempting to withdraw spent UTXOs should fail", async function () {
      // Alice proposes the output ERC20 tokens
      const outputCommitment = newUTXO(90, Alice);

      const { inputCommitments, outputCommitments, encodedProof } =
        await prepareWithdrawProof(
          Alice,
          [utxo100, ZERO_UTXO],
          outputCommitment,
        );

      await expect(
        zeto
          .connect(Alice.signer)
          .withdraw(10, inputCommitments, outputCommitments[0], encodedProof),
      ).rejectedWith("UTXOAlreadySpent");
    });

    it("mint existing unspent UTXOs should fail", async function () {
      await expect(doMint(zeto, deployer, [utxo4])).rejectedWith(
        "UTXOAlreadyOwned",
      );
    });

    it("mint existing spent UTXOs should fail", async function () {
      await expect(doMint(zeto, deployer, [utxo1])).rejectedWith(
        "UTXOAlreadySpent",
      );
    });

    it("transfer non-existing UTXOs should fail", async function () {
      const nonExisting1 = newUTXO(10, Alice);
      const nonExisting2 = newUTXO(20, Alice, nonExisting1.salt);
      await expect(
        doTransfer(
          Alice,
          [nonExisting1, nonExisting2],
          [nonExisting1, nonExisting2],
          [Alice, Alice],
        ),
      ).rejectedWith("UTXONotMinted");
    });

    it("transfer spent UTXOs should fail (double spend protection)", async function () {
      // create outputs
      const utxo5 = newUTXO(25, Bob);
      const utxo6 = newUTXO(5, Alice, utxo5.salt);
      await expect(
        doTransfer(Alice, [utxo1, utxo2], [utxo5, utxo6], [Bob, Alice]),
      ).rejectedWith("UTXOAlreadySpent");
    });

    it("spend by using the same UTXO as both inputs should fail", async function () {
      const utxo5 = newUTXO(20, Alice);
      const utxo6 = newUTXO(10, Bob, utxo5.salt);
      await expect(
        doTransfer(Bob, [utxo7, utxo7], [utxo5, utxo6], [Alice, Bob]),
      ).rejectedWith(`UTXODuplicate(${utxo7.hash.toString()}`);
    });
  });

  async function doTransfer(
    signer: User,
    inputs: UTXO[],
    outputs: UTXO[],
    owners: User[],
  ) {
    let inputCommitments: BigNumberish[];
    let outputCommitments: BigNumberish[];
    let outputOwnerAddresses: AddressLike[];
    let encodedProof: any;
    let circuitToUse = circuit;
    let provingKeyToUse = provingKey;
    if (inputs.length > 2 || outputs.length > 2) {
      circuitToUse = batchCircuit;
      provingKeyToUse = batchProvingKey;
    }
    const result = await prepareProof(
      circuitToUse,
      provingKeyToUse,
      signer,
      inputs,
      outputs,
      owners,
    );
    inputCommitments = result.inputCommitments;
    outputCommitments = result.outputCommitments;
    outputOwnerAddresses = owners.map(
      (owner) => owner.ethAddress || ZeroAddress,
    ) as [AddressLike, AddressLike];
    encodedProof = result.encodedProof;

    return await sendTx(
      signer,
      inputCommitments,
      outputCommitments,
      outputOwnerAddresses,
      encodedProof,
    );
  }

  async function sendTx(
    signer: User,
    inputCommitments: BigNumberish[],
    outputCommitments: BigNumberish[],
    outputOwnerAddresses: AddressLike[],
    encodedProof: any,
  ) {
    const signerAddress = await signer.signer.getAddress();
    const tx = await zeto.connect(signer.signer).transfer(
      inputCommitments.filter((ic) => ic !== 0n), // trim off empty utxo hashes to check padding logic for batching works
      outputCommitments.filter((oc) => oc !== 0n), // trim off empty utxo hashes to check padding logic for batching works
      encodedProof,
      "0x",
    );
    const results = await tx.wait();
    console.log(`Method transfer() complete. Gas used: ${results?.gasUsed}`);

    for (const input of inputCommitments) {
      const owner = await zeto.spent(input);
      expect(owner).to.equal(true);
    }
    for (let i = 0; i < outputCommitments.length; i++) {
      expect(await zeto.spent(outputCommitments[i])).to.equal(false);
    }

    return results;
  }
});

async function prepareProof(
  circuit: any,
  provingKey: any,
  signer: User,
  inputs: UTXO[],
  outputs: UTXO[],
  owners: User[],
) {
  const inputCommitments: BigNumberish[] = inputs.map(
    (input) => input.hash,
  ) as BigNumberish[];
  const inputValues = inputs.map((input) => BigInt(input.value || 0n));
  const inputSalts = inputs.map((input) => input.salt || 0n);
  const outputCommitments: BigNumberish[] = outputs.map(
    (output) => output.hash,
  ) as BigNumberish[];
  const outputValues = outputs.map((output) => BigInt(output.value || 0n));
  const outputSalts = outputs.map((o) => o.salt || 0n);
  const outputOwnerPublicKeys: BigNumberish[][] = owners.map(
    (owner) => owner.babyJubPublicKey || ZERO_PUBKEY,
  ) as BigNumberish[][];
  const otherInputs = stringifyBigInts({
    inputOwnerPrivateKey: formatPrivKeyForBabyJub(signer.babyJubPrivateKey),
  });

  const startWitnessCalculation = Date.now();
  const witness = await circuit.calculateWTNSBin(
    {
      inputCommitments,
      inputValues,
      inputSalts,
      outputCommitments,
      outputValues,
      outputSalts,
      outputOwnerPublicKeys,
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
    inputCommitments,
    outputCommitments,
    encodedProof,
  };
}

module.exports = {
  prepareProof,
};
