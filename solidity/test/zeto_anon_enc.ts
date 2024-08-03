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

import { ethers, ignition } from 'hardhat';
import { ContractTransactionReceipt, Signer, BigNumberish, AddressLike } from 'ethers';
import { expect } from 'chai';
import { loadCircuit, poseidonDecrypt, encodeProof, Poseidon } from "zeto-js";
import { groth16 } from 'snarkjs';
import { genRandomSalt, formatPrivKeyForBabyJub, genEcdhSharedKey, stringifyBigInts } from 'maci-crypto';
import zetoModule from '../ignition/modules/zeto_anon_enc';
import erc20Module from '../ignition/modules/erc20';
import { User, UTXO, newUser, newUTXO, doMint, ZERO_UTXO, parseUTXOEvents } from './lib/utils';
import { loadProvingKeys, prepareDepositProof, prepareWithdrawProof } from './utils';

const poseidonHash = Poseidon.poseidon4;

describe("Zeto based fungible token with anonymity and encryption", function () {
  let deployer: Signer;
  let Alice: User;
  let Bob: User;
  let Charlie: User;
  let erc20: any;
  let zeto: any;
  let utxo100: UTXO;
  let utxo1: UTXO;
  let utxo2: UTXO;
  let utxo3: UTXO;
  let utxo4: UTXO;
  let circuit: any, provingKey: any;

  before(async function () {
    let [d, a, b, c] = await ethers.getSigners();
    deployer = d;
    Alice = await newUser(a);
    Bob = await newUser(b);
    Charlie = await newUser(c);
    ({ zeto } = await ignition.deploy(zetoModule));
    ({ erc20 } = await ignition.deploy(erc20Module));
    const tx4 = await zeto.connect(deployer).setERC20(erc20.target);
    await tx4.wait();

    circuit = await loadCircuit('anon_enc');
    ({ provingKeyFile: provingKey } = loadProvingKeys('anon_enc'));
  });

  it("mint ERC20 tokens to Alice to deposit to Zeto should succeed", async function () {
    const tx = await erc20.connect(deployer).mint(Alice.ethAddress, 100);
    await tx.wait();
    const balance = await erc20.balanceOf(Alice.ethAddress);
    expect(balance).to.equal(100);

    const tx1 = await erc20.connect(Alice.signer).approve(zeto.target, 100);
    await tx1.wait();

    utxo100 = newUTXO(100, Alice);
    const { outputCommitments, encodedProof } = await prepareDepositProof(Alice, utxo100);
    const tx2 = await zeto.connect(Alice.signer).deposit(100, outputCommitments[0], encodedProof);
    await tx2.wait();
  });

  it("mint to Alice and transfer UTXOs honestly to Bob should succeed", async function () {
    // first the authority mints UTXOs to Alice
    utxo1 = newUTXO(10, Alice);
    utxo2 = newUTXO(20, Alice);
    await doMint(zeto, deployer, [utxo1, utxo2]);

    // Alice proposes the output UTXOs
    const _utxo1 = newUTXO(25, Bob);
    utxo4 = newUTXO(5, Alice, _utxo1.salt);

    // Alice transfers UTXOs to Bob
    const result = await doBranch(Alice, [utxo1, utxo2], [_utxo1, utxo4], [Bob, Alice]);

    // Bob uses the information in the event to recover the incoming UTXO
    // first obtain the UTXO from the transaction event
    const events = parseUTXOEvents(zeto, result.txResult!);
    expect(events[0].inputs).to.deep.equal([utxo1.hash, utxo2.hash]);
    expect(events[0].outputs).to.deep.equal([_utxo1.hash, utxo4.hash]);
    const incomingUTXOs: any = events[0].outputs;

    // Bob reconstructs the shared key using his private key and Alice's public key (obtained out of band)
    const senderPublicKey = Alice.babyJubPublicKey;

    const sharedKey = genEcdhSharedKey(Bob.babyJubPrivateKey, senderPublicKey);
    const plainText = poseidonDecrypt(events[0].encryptedValues, sharedKey, events[0].encryptionNonce);
    expect(plainText).to.deep.equal([25n, result.plainTextSalt]);
    // Bob verifies that the UTXO constructed from the decrypted values matches the UTXO from the event
    const hash = poseidonHash([BigInt(plainText[0]), plainText[1], Bob.babyJubPublicKey[0], Bob.babyJubPublicKey[1]]);
    expect(hash).to.equal(incomingUTXOs[0]);

    // simulate Bob using the decrypted values to construct the UTXO received from the transaction
    utxo3 = newUTXO(Number(plainText[0]), Bob, plainText[1]);
  });

  it("Bob transfers UTXOs, previously received from Alice, honestly to Charlie should succeed", async function () {
    // propose the output UTXOs
    const _utxo1 = newUTXO(25, Charlie);
    // Bob should be able to spend the UTXO that was reconstructed from the previous transaction
    await doBranch(Bob, [utxo3, ZERO_UTXO], [_utxo1, ZERO_UTXO], [Charlie, Bob]);
  });

  it("Alice withdraws her UTXOs to ERC20 tokens should succeed", async function () {
    // Alice proposes the output ERC20 tokens
    const outputCommitment = newUTXO(20, Alice);

    const { inputCommitments, outputCommitments, encodedProof } = await prepareWithdrawProof(Alice, [utxo100, ZERO_UTXO], outputCommitment);

    // Alice withdraws her UTXOs to ERC20 tokens
    const tx = await zeto.connect(Alice.signer).withdraw(80, inputCommitments, outputCommitments[0], encodedProof);
    await tx.wait();

    // Alice checks her ERC20 balance
    const balance = await erc20.balanceOf(Alice.ethAddress);
    expect(balance).to.equal(80);
  });

  it("mint existing unspent UTXOs should fail", async function () {
    await expect(doMint(zeto, deployer, [utxo4])).rejectedWith("UTXOAlreadyOwned");
  });

  it("mint existing spent UTXOs should fail", async function () {
    await expect(doMint(zeto, deployer, [utxo1])).rejectedWith("UTXOAlreadySpent");
  });

  it("transfer non-existing UTXOs should fail", async function () {
    const nonExisting1 = newUTXO(10, Alice);
    const nonExisting2 = newUTXO(20, Alice, nonExisting1.salt);
    await expect(doBranch(Alice, [nonExisting1, nonExisting2], [nonExisting1, nonExisting2], [Alice, Alice])).rejectedWith("UTXONotMinted");
  });

  it("transfer spent UTXOs should fail (double spend protection)", async function () {
    // create outputs
    const _utxo1 = newUTXO(25, Bob);
    const _utxo2 = newUTXO(5, Alice);
    await expect(doBranch(Alice, [utxo1, utxo2], [_utxo1, _utxo2], [Bob, Alice])).rejectedWith("UTXOAlreadySpent")
  });

  it("spend by using the same UTXO as both inputs should fail", async function () {
    // mint a new UTXO to Bob
    const _utxo1 = newUTXO(20, Bob);
    await doMint(zeto, deployer, [_utxo1]);

    const _utxo2 = newUTXO(25, Alice);
    const _utxo3 = newUTXO(15, Bob);
    await expect(doBranch(Bob, [_utxo1, _utxo1], [_utxo2, _utxo3], [Alice, Bob])).rejectedWith(`UTXODuplicate(${_utxo1.hash.toString()}`);
  });

  async function doBranch(signer: User, inputs: UTXO[], outputs: UTXO[], owners: User[]) {
    let inputCommitments: [BigNumberish, BigNumberish];
    let outputCommitments: [BigNumberish, BigNumberish];
    let encryptedValues: [BigNumberish, BigNumberish];
    let encryptionNonce: BigNumberish;
    let encodedProof: any;
    const result = await prepareProof(signer, inputs, outputs, owners);
    inputCommitments = result.inputCommitments;
    outputCommitments = result.outputCommitments;
    encodedProof = result.encodedProof;
    encryptedValues = result.encryptedValues;
    encryptionNonce = result.encryptionNonce;

    const txResult = await sendTx(signer, inputCommitments, outputCommitments, encryptedValues, encryptionNonce, encodedProof);
    // add the clear text value so that it can be used by tests to compare with the decrypted value
    return { txResult, plainTextSalt: outputs[0].salt };
  }

  async function prepareProof(signer: User, inputs: UTXO[], outputs: UTXO[], owners: User[]) {
    const inputCommitments: [BigNumberish, BigNumberish] = inputs.map((input) => input.hash) as [BigNumberish, BigNumberish];
    const inputValues = inputs.map((input) => BigInt(input.value || 0n));
    const inputSalts = inputs.map((input) => input.salt || 0n);
    const outputCommitments: [BigNumberish, BigNumberish] = outputs.map((output) => output.hash) as [BigNumberish, BigNumberish];
    const outputValues = outputs.map((output) => BigInt(output.value || 0n));
    const outputOwnerPublicKeys: [[BigNumberish, BigNumberish], [BigNumberish, BigNumberish]] = owners.map(owner => owner.babyJubPublicKey) as [[BigNumberish, BigNumberish], [BigNumberish, BigNumberish]];
    const encryptionNonce: BigNumberish = genRandomSalt() as BigNumberish;
    const encryptInputs = stringifyBigInts({
      encryptionNonce,
      senderPrivateKey: formatPrivKeyForBabyJub(signer.babyJubPrivateKey),
    });

    const startWitnessCalculation = Date.now();
    const witness = await circuit.calculateWTNSBin(
      {
        inputCommitments,
        inputValues,
        inputSalts,
        outputCommitments,
        outputValues,
        outputSalts: outputs.map((output) => output.salt || 0n),
        outputOwnerPublicKeys,
        ...encryptInputs
      },
      true
    );
    const timeWitnessCalculation = Date.now() - startWitnessCalculation;

    const startProofGeneration = Date.now();
    const { proof, publicSignals } = await groth16.prove(provingKey, witness) as { proof: BigNumberish[]; publicSignals: BigNumberish[] };
    const timeProofGeneration = Date.now() - startProofGeneration;
    console.log(`Witness calculation time: ${timeWitnessCalculation}ms, Proof generation time: ${timeProofGeneration}ms`);

    const encodedProof = encodeProof(proof);
    const encryptedValue = publicSignals[0];
    const encryptedSalt = publicSignals[1];
    return {
      inputCommitments,
      outputCommitments,
      encryptedValues: [encryptedValue, encryptedSalt] as [BigNumberish, BigNumberish],
      encryptionNonce,
      encodedProof
    };
  }

  async function sendTx(
    signer: User,
    inputCommitments: [BigNumberish, BigNumberish],
    outputCommitments: [BigNumberish, BigNumberish],
    encryptedValues: [BigNumberish, BigNumberish],
    encryptionNonce: BigNumberish,
    encodedProof: any
  ) {
    const tx = await zeto.connect(signer.signer).transfer(inputCommitments, outputCommitments, encryptionNonce, encryptedValues, encodedProof);
    const results: ContractTransactionReceipt | null = await tx.wait();

    for (const input of inputCommitments) {
      if (input === 0n) continue;
      expect(await zeto.spent(input)).to.equal(true);
    }
    for (const output of outputCommitments) {
      if (output === 0n) continue;
      expect(await zeto.spent(output)).to.equal(false);
    }
    console.log(`Method transfer() complete. Gas used: ${results?.gasUsed}`);

    return results;
  }
});

