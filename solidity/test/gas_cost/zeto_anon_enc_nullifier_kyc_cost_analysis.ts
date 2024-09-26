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
import fs from 'fs';
import path from 'path';
import { ethers, network } from 'hardhat';
import { ContractTransactionReceipt, Signer, BigNumberish } from 'ethers';
import { expect } from 'chai';
import { loadCircuit, encodeProof, newEncryptionNonce, kycHash } from 'zeto-js';
import { groth16 } from 'snarkjs';
import { stringifyBigInts } from 'maci-crypto';
import AsyncLock from 'async-lock';
const lock = new AsyncLock();
import { Merkletree, InMemoryDB, str2Bytes } from '@iden3/js-merkletree';
import {
  UTXO,
  User,
  newUser,
  newUTXO,
  newNullifier,
  doMint,
  doDeposit,
  doWithdraw,
  ZERO_UTXO,
  parseUTXOEvents,
  parseRegistryEvents,
} from '../lib/utils';
import {
  loadProvingKeys,
  prepareDepositProof,
  prepareNullifierWithdrawProof,
} from '../utils';
import { deployZeto } from '../lib/deploy';

const TOTAL_AMOUNT = parseInt(process.env.TOTAL_ROUNDS || '1000');
const TX_CONCURRENCY = parseInt(process.env.TX_CONCURRENCY || '30');

describe.skip('(Gas cost analysis) Zeto based fungible token with anonymity using nullifiers and encryption with KYC', function () {
  let deployer: Signer;
  let Alice: User;
  let Bob: User;
  let Charlie: User;
  let erc20: any;
  let zeto: any;
  const atMostHalfAmount = Math.floor(TOTAL_AMOUNT / 2);
  const atLeastHalfAmount = atMostHalfAmount + (TOTAL_AMOUNT % 2);
  let unspentAliceUTXOs: UTXO[] = [];
  let unspentBobUTXOs: UTXO[] = [];
  let mintGasCostHistory: number[] = [];
  let depositGasCostHistory: number[] = [];
  let transferGasCostHistory: number[] = [];
  let withdrawGasCostHistory: number[] = [];
  let circuit: any, provingKey: any;
  let smtAlice: Merkletree;
  let smtBob: Merkletree;
  let smtKyc: Merkletree;

  const date = new Date();
  const reportPrefix = date.toISOString();

  before(async function () {
    if (network.name !== 'hardhat') {
      // accommodate for longer block times on public networks
      this.timeout(120000);
    }
    let [d, a, b, c, e] = await ethers.getSigners();
    deployer = d;
    Alice = await newUser(a);
    Bob = await newUser(b);
    Charlie = await newUser(c);

    ({ deployer, zeto, erc20 } = await deployZeto('Zeto_AnonEncNullifierKyc'));

    const tx2 = await zeto.connect(deployer).register(Alice.babyJubPublicKey);
    const result1 = await tx2.wait();
    const tx3 = await zeto.connect(deployer).register(Bob.babyJubPublicKey);
    const result2 = await tx3.wait();
    const tx4 = await zeto.connect(deployer).register(Charlie.babyJubPublicKey);
    const result3 = await tx4.wait();

    circuit = await loadCircuit('anon_enc_nullifier_kyc');
    ({ provingKeyFile: provingKey } = loadProvingKeys(
      'anon_enc_nullifier_kyc'
    ));

    const storage1 = new InMemoryDB(str2Bytes('alice'));
    smtAlice = new Merkletree(storage1, true, 64);

    const storage2 = new InMemoryDB(str2Bytes('bob'));
    smtBob = new Merkletree(storage2, true, 64);

    const storage3 = new InMemoryDB(str2Bytes('kyc'));
    smtKyc = new Merkletree(storage3, true, 10);

    const publicKey1 = parseRegistryEvents(zeto, result1);
    await smtKyc.add(kycHash(publicKey1), kycHash(publicKey1));
    const publicKey2 = parseRegistryEvents(zeto, result2);
    await smtKyc.add(kycHash(publicKey2), kycHash(publicKey2));
    const publicKey3 = parseRegistryEvents(zeto, result3);
    await smtKyc.add(kycHash(publicKey3), kycHash(publicKey3));
  });

  after(function () {
    // console.log(`Mint costs: ${mintGasCostHistory.join(',')}`);
    // console.log(`Deposit costs: ${depositGasCostHistory.join(',')}`);
    // console.log(`Transfer costs: ${transferGasCostHistory.join(',')}`);
    // console.log(`Withdraw costs: ${withdrawGasCostHistory.join(',')}`);
  });

  describe(`Transfer ${TOTAL_AMOUNT} tokens (half from deposit, half from mint) from single address to another`, function () {
    before(async function () {
      const root = await smtAlice.root();
      const onchainRoot = await zeto.getRoot();
      expect(onchainRoot).to.equal(0n);
      expect(root.string()).to.equal(onchainRoot.toString());
      const startingBalance = await erc20.balanceOf(Alice.ethAddress);
      const tx = await erc20
        .connect(deployer)
        .mint(Alice.ethAddress, atMostHalfAmount); // mint to alice the amount of token that can be deposited
      await tx.wait();

      const endingBalance = await erc20.balanceOf(Alice.ethAddress);
      expect(endingBalance - startingBalance).to.be.equal(atMostHalfAmount);
      console.log(
        `ERC20 successfully minted ${atMostHalfAmount} to Alice for deposit`
      );
      const tx1 = await erc20
        .connect(Alice.signer)
        .approve(zeto.target, atMostHalfAmount);
      await tx1.wait();

      const startingBalanceDep = await erc20.balanceOf(zeto.target);
      const txDep = await erc20
        .connect(deployer)
        .mint(zeto.target, atLeastHalfAmount); // mint to zeto contract the amount of token that can be minted
      await txDep.wait();
      const endingBalanceDep = await erc20.balanceOf(zeto.target);
      expect(endingBalanceDep - startingBalanceDep).to.be.equal(
        atLeastHalfAmount
      );
    });

    it(`Alice deposit ${atMostHalfAmount} token`, async function () {
      let promises = [];
      for (let i = 0; i < atMostHalfAmount; i++) {
        promises.push(
          (async () => {
            const utxoSingle = newUTXO(1, Alice);
            const { outputCommitments, encodedProof } =
              await prepareDepositProof(Alice, utxoSingle);
            await doDeposit(
              zeto,
              Alice.signer,
              1,
              outputCommitments[0],
              encodedProof,
              depositGasCostHistory
            );
            await smtAlice.add(utxoSingle.hash, utxoSingle.hash);
            await smtBob.add(utxoSingle.hash, utxoSingle.hash);
            unspentAliceUTXOs.push(utxoSingle);
          })()
        );

        // If we reach the concurrency limit, wait for the current batch to finish
        if (promises.length >= TX_CONCURRENCY) {
          await Promise.all(promises);
          promises = []; // Reset promises for the next batch
        }
      }

      // Run any remaining promises that didn’t fill the batch
      if (promises.length > 0) {
        await Promise.all(promises);
      }
      writeGasCostsToCSV(
        `${reportPrefix}deposit_gas_costs.csv`,
        depositGasCostHistory
      );
    }).timeout(6000000000000);

    it(`Zeto mint ${atMostHalfAmount + (TOTAL_AMOUNT % 2)} token to Alice in ${
      Math.floor(atLeastHalfAmount / 2) + (atLeastHalfAmount % 2)
    } txs`, async function () {
      const mintRounds =
        Math.floor(atLeastHalfAmount / 2) + (atLeastHalfAmount % 2);
      let promises = [];
      for (let i = 0; i < mintRounds; i++) {
        promises.push(
          (async () => {
            const utxo1 = newUTXO(1, Alice);
            let utxo2 = newUTXO(1, Alice);

            if (i === mintRounds - 1 && atLeastHalfAmount % 2 === 1) {
              utxo2 = newUTXO(0, Alice); // odd number
            }

            const result1 = await doMint(
              zeto,
              deployer,
              [utxo1, utxo2],
              mintGasCostHistory
            );
            const mintEvents = parseUTXOEvents(zeto, result1);
            const [_utxo1, _utxo2] = mintEvents[0].outputs;

            // Add UTXOs to the sets
            await smtAlice.add(_utxo1, _utxo1);
            await smtBob.add(_utxo1, _utxo1);
            await smtAlice.add(_utxo2, _utxo2);
            await smtBob.add(_utxo2, _utxo2);

            // Save unspent UTXOs
            unspentAliceUTXOs.push(utxo1);
            unspentAliceUTXOs.push(utxo2);
          })()
        );

        // If we reach the concurrency limit, wait for the current batch to finish
        if (promises.length >= TX_CONCURRENCY) {
          await Promise.all(promises);
          promises = []; // Reset promises for the next batch
        }
      }

      // Run any remaining promises that didn’t fill the batch
      if (promises.length > 0) {
        await Promise.all(promises);
      }
      writeGasCostsToCSV(
        `${reportPrefix}mint_gas_costs.csv`,
        mintGasCostHistory
      );
    }).timeout(6000000000000);

    it(`Alice transfer ${TOTAL_AMOUNT} tokens to Bob in ${atLeastHalfAmount} txs`, async function () {
      const totalTxs = Math.floor(unspentAliceUTXOs.length / 2);
      const utxosRoot = await smtAlice.root(); // get the root before all transfer and use it for all the proofs
      let promises = [];
      // Alice generates inclusion proofs for the identities in the transaction
      const identitiesRoot = await smtKyc.root();
      const proof3 = await smtKyc.generateCircomVerifierProof(
        kycHash(Alice.babyJubPublicKey),
        identitiesRoot
      );
      const proof4 = await smtKyc.generateCircomVerifierProof(
        kycHash(Bob.babyJubPublicKey),
        identitiesRoot
      );
      const identityMerkleProofs = [
        proof3.siblings.map((s) => s.bigInt()), // identity proof for the sender (Alice)
        proof4.siblings.map((s) => s.bigInt()), // identity proof for the 1st owner of the output UTXO (Bob)
        proof4.siblings.map((s) => s.bigInt()), // identity proof for the 2nd owner of the output UTXO (Bob)
      ];

      for (let i = 0; i < totalTxs; i++) {
        promises.push(
          (async () => {
            const utxo1 = unspentAliceUTXOs[i * 2];
            const utxo2 = unspentAliceUTXOs[i * 2 + 1];

            const newUtxo1 = newUTXO(1, Bob);
            let newUtxo2 = newUTXO(1, Bob);
            if (i === totalTxs - 1 && TOTAL_AMOUNT % 2 === 1) {
              // last round
              newUtxo2 = newUTXO(0, Bob); // odd number
            }
            const nullifier1 = newNullifier(utxo1, Alice);
            const nullifier2 = newNullifier(utxo2, Alice);
            // Alice generates inclusion proofs for the UTXOs to be spent
            const proof1 = await smtAlice.generateCircomVerifierProof(
              utxo1.hash,
              utxosRoot
            );
            const proof2 = await smtAlice.generateCircomVerifierProof(
              utxo2.hash,
              utxosRoot
            );
            const utxoMerkleProofs = [
              proof1.siblings.map((s) => s.bigInt()),
              proof2.siblings.map((s) => s.bigInt()),
            ];

            // Alice transfers her UTXOs to Bob
            await doTransfer(
              Alice,
              [utxo1, utxo2],
              [nullifier1, nullifier2],
              [newUtxo1, newUtxo2],
              utxosRoot.bigInt(),
              utxoMerkleProofs,
              identitiesRoot.bigInt(),
              identityMerkleProofs,
              [Bob, Bob],
              transferGasCostHistory
            );
            await smtAlice.add(newUtxo1.hash, newUtxo1.hash);
            await smtBob.add(newUtxo1.hash, newUtxo1.hash);
            await smtAlice.add(newUtxo2.hash, newUtxo2.hash);
            await smtBob.add(newUtxo2.hash, newUtxo2.hash);
            unspentBobUTXOs.push(newUtxo1);
            unspentBobUTXOs.push(newUtxo2);
          })()
        );

        // If we reach the concurrency limit, wait for the current batch to finish
        if (promises.length >= TX_CONCURRENCY) {
          await Promise.all(promises);
          promises = []; // Reset promises for the next batch
        }
      }

      // Run any remaining promises that didn’t fill the batch
      if (promises.length > 0) {
        await Promise.all(promises);
      }
      writeGasCostsToCSV(
        `${reportPrefix}transfer_gas_costs.csv`,
        transferGasCostHistory
      );
    }).timeout(6000000000000);

    it(`Bob withdraw ${TOTAL_AMOUNT} tokens`, async function () {
      const startingBalance = await erc20.balanceOf(Bob.ethAddress);

      const root = await smtBob.root();
      let promises = [];
      for (let i = 0; i < unspentBobUTXOs.length; i++) {
        if (unspentBobUTXOs[i].value) {
          promises.push(
            (async () => {
              const utxoToWithdraw = unspentBobUTXOs[i];
              const nullifier1 = newNullifier(utxoToWithdraw, Bob);

              const proof1 = await smtBob.generateCircomVerifierProof(
                utxoToWithdraw.hash,
                root
              );
              const proof2 = await smtBob.generateCircomVerifierProof(0n, root);
              const merkleProofs = [
                proof1.siblings.map((s) => s.bigInt()),
                proof2.siblings.map((s) => s.bigInt()),
              ];
              const { nullifiers, outputCommitments, encodedProof } =
                await prepareNullifierWithdrawProof(
                  Bob,
                  [utxoToWithdraw, ZERO_UTXO],
                  [nullifier1, ZERO_UTXO],
                  newUTXO(0, Bob),
                  root.bigInt(),
                  merkleProofs
                );

              // Bob withdraws UTXOs to ERC20 tokens
              await doWithdraw(
                zeto,
                Bob.signer,
                1,
                nullifiers,
                outputCommitments[0],
                root.bigInt(),
                encodedProof,
                withdrawGasCostHistory
              );
            })()
          );
        }
        // If we reach the concurrency limit, wait for the current batch to finish
        if (promises.length >= TX_CONCURRENCY) {
          await Promise.all(promises);
          promises = []; // Reset promises for the next batch
        }
      }
      // Run any remaining promises that didn’t fill the batch
      if (promises.length > 0) {
        await Promise.all(promises);
      }
      writeGasCostsToCSV(
        `${reportPrefix}withdraw_gas_costs.csv`,
        withdrawGasCostHistory
      );
      // Bob checks ERC20 balance
      const endingBalance = await erc20.balanceOf(Bob.ethAddress);
      expect(endingBalance - startingBalance).to.be.equal(TOTAL_AMOUNT);
    }).timeout(6000000000000);
  }).timeout(6000000000000);

  async function doTransfer(
    signer: User,
    inputs: UTXO[],
    _nullifiers: UTXO[],
    outputs: UTXO[],
    utxosRoot: BigInt,
    utxosMerkleProof: BigInt[][],
    identitiesRoot: BigInt,
    identitiesMerkleProof: BigInt[][],
    owners: User[],
    gasHistories: number[]
  ) {
    let nullifiers: [BigNumberish, BigNumberish];
    let outputCommitments: [BigNumberish, BigNumberish];
    let encryptedValues: BigNumberish[];
    let encryptionNonce: BigNumberish;
    let encodedProof: any;
    const result = await prepareProof(
      signer,
      inputs,
      _nullifiers,
      outputs,
      utxosRoot,
      utxosMerkleProof,
      identitiesRoot,
      identitiesMerkleProof,
      owners
    );

    nullifiers = _nullifiers.map((nullifier) => nullifier.hash) as [
      BigNumberish,
      BigNumberish
    ];
    outputCommitments = result.outputCommitments;
    encodedProof = result.encodedProof;
    encryptedValues = result.encryptedValues;
    encryptionNonce = result.encryptionNonce;

    const txResult = await sendTx(
      signer,
      nullifiers,
      outputCommitments,
      utxosRoot,
      encryptedValues,
      encryptionNonce,
      encodedProof
    );
    if (txResult?.gasUsed && Array.isArray(gasHistories)) {
      gasHistories.push(txResult?.gasUsed);
    }
    // add the clear text value so that it can be used by tests to compare with the decrypted value
    return { txResult, plainTextSalt: outputs[0].salt };
  }

  async function prepareProof(
    signer: User,
    inputs: UTXO[],
    _nullifiers: UTXO[],
    outputs: UTXO[],
    utxosRoot: BigInt,
    utxosMerkleProof: BigInt[][],
    identitiesRoot: BigInt,
    identitiesMerkleProof: BigInt[][],
    owners: User[]
  ) {
    const nullifiers = _nullifiers.map((nullifier) => nullifier.hash) as [
      BigNumberish,
      BigNumberish
    ];
    const inputCommitments: [BigNumberish, BigNumberish] = inputs.map(
      (input) => input.hash
    ) as [BigNumberish, BigNumberish];
    const inputValues = inputs.map((input) => BigInt(input.value || 0n));
    const inputSalts = inputs.map((input) => input.salt || 0n);
    const outputCommitments: [BigNumberish, BigNumberish] = outputs.map(
      (output) => output.hash
    ) as [BigNumberish, BigNumberish];
    const outputValues = outputs.map((output) => BigInt(output.value || 0n));
    const outputOwnerPublicKeys: [
      [BigNumberish, BigNumberish],
      [BigNumberish, BigNumberish]
    ] = owners.map((owner) => owner.babyJubPublicKey) as [
      [BigNumberish, BigNumberish],
      [BigNumberish, BigNumberish]
    ];
    const encryptionNonce: BigNumberish = newEncryptionNonce() as BigNumberish;
    const encryptInputs = stringifyBigInts({
      encryptionNonce,
    });

    const startWitnessCalculation = Date.now();
    const inputObj = {
      nullifiers,
      inputCommitments,
      inputValues,
      inputSalts,
      inputOwnerPrivateKey: signer.formattedPrivateKey,
      utxosRoot,
      enabled: [nullifiers[0] !== 0n ? 1 : 0, nullifiers[1] !== 0n ? 1 : 0],
      utxosMerkleProof,
      identitiesRoot,
      identitiesMerkleProof,
      outputCommitments,
      outputValues,
      outputSalts: outputs.map((output) => output.salt || 0n),
      outputOwnerPublicKeys,
      ...encryptInputs,
    };
    const witness = await lock.acquire('proofGen', async () => {
      // this lock is added for https://github.com/hyperledger-labs/zeto/issues/80, which only happens for Transfer circuit, not deposit/mint
      return circuit.calculateWTNSBin(inputObj, true);
    });
    const timeWithnessCalculation = Date.now() - startWitnessCalculation;

    const startProofGeneration = Date.now();
    const { proof, publicSignals } = (await groth16.prove(
      provingKey,
      witness
    )) as { proof: BigNumberish[]; publicSignals: BigNumberish[] };
    const timeProofGeneration = Date.now() - startProofGeneration;

    console.log(
      `Witness calculation time: ${timeWithnessCalculation}ms. Proof generation time: ${timeProofGeneration}ms.`
    );

    const encodedProof = encodeProof(proof);
    const encryptedValues = publicSignals.slice(0, 4);
    return {
      inputCommitments,
      outputCommitments,
      encryptedValues,
      encryptionNonce,
      encodedProof,
    };
  }

  async function sendTx(
    signer: User,
    nullifiers: [BigNumberish, BigNumberish],
    outputCommitments: [BigNumberish, BigNumberish],
    root: BigNumberish,
    encryptedValues: BigNumberish[],
    encryptionNonce: BigNumberish,
    encodedProof: any
  ) {
    const startTx = Date.now();
    const tx = await zeto
      .connect(signer.signer)
      .transfer(
        nullifiers,
        outputCommitments,
        root,
        encryptionNonce,
        encryptedValues,
        encodedProof,
        '0x'
      );
    const result: ContractTransactionReceipt | null = await tx.wait();
    console.log(
      `Transfer transaction took: ${Date.now() - startTx}ms. Gas used: ${
        result?.gasUsed
      }`
    );
    return result;
  }
});

function writeGasCostsToCSV(filename: string, gasCosts: number[]) {
  const filePath = path.join(__dirname, filename);

  // Prepare the CSV content
  const csvData = gasCosts.join(',\n') + '\n'; // Each value in a new line

  // Write the CSV content to a file (overwrite if file exists)
  fs.writeFileSync(filePath, 'gas_costs,\n' + csvData, 'utf8');

  console.log(`Gas costs written to ${filePath}`);
}
