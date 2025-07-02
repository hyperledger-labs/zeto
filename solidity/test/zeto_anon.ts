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
  prepareBurnProof,
} from "./utils";
import { Zeto_Anon, Zeto_AnonBurnable } from "../typechain-types";
import { deployZeto } from "./lib/deploy";

const ZERO_PUBKEY = [0n, 0n];
const poseidonHash = Poseidon.poseidon4;

describe("Zeto based fungible token with anonymity without encryption or nullifier", function () {
  let deployer: Signer;
  let Alice: User;
  let Bob: User;
  let Charlie: User;
  let erc20: any;
  let zeto: Zeto_Anon;
  let zetoBurnable: Zeto_AnonBurnable;
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
    ({ zeto: zetoBurnable } = await deployZeto("Zeto_AnonBurnable"));

    circuit = await loadCircuit("anon");
    ({ provingKeyFile: provingKey } = loadProvingKeys("anon"));

    batchCircuit = await loadCircuit("anon_batch");
    ({ provingKeyFile: batchProvingKey } = loadProvingKeys("anon_batch"));
  });

  it("has 4 decimals", async function () {
    const decimals = await zeto.decimals();
    expect(decimals).to.equal(4, "Decimals should be 4");
  });

  it.only("(batch) mint to Alice and batch transfer 10 UTXOs honestly to Bob & Charlie then withdraw should succeed", async function () {
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
      .withdraw(3, inputCommitments, outputCommitments[0], encodedProof, "0x");
    await tx.wait();

    // Alice checks her ERC20 balance
    const endingBalance = await erc20.balanceOf(Alice.ethAddress);
    expect(endingBalance - startingBalance).to.be.equal(3);
  });

  it.only("mint ERC20 tokens to Alice to deposit to Zeto should succeed", async function () {
    const startingBalance = await erc20.balanceOf(Alice.ethAddress);
    const tx = await erc20.connect(deployer).mint(Alice.ethAddress, 100);
    await tx.wait();
    const endingBalance = await erc20.balanceOf(Alice.ethAddress);
    expect(endingBalance - startingBalance).to.be.equal(100);

    const tx1 = await erc20.connect(Alice.signer).approve(zeto.target, 100);
    await tx1.wait();

    utxo100 = newUTXO(100, Alice);
    const utxo0 = newUTXO(0, Alice);
    const { outputCommitments, encodedProof } = await prepareDepositProof(
      Alice,
      [utxo100, utxo0],
    );
    const tx2 = await zeto
      .connect(Alice.signer)
      .deposit(100, outputCommitments, encodedProof, "0x");
    const result = await tx2.wait();
    console.log(`Method deposit() complete. Gas used: ${result?.gasUsed}`);
  });

  it.only("mint to Alice and transfer UTXOs honestly to Bob should succeed", async function () {
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
  }).timeout(60000);

  it.only("Bob transfers UTXOs, previously received from Alice, honestly to Charlie should succeed", async function () {
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

  it.only("Alice withdraws her UTXOs to ERC20 tokens should succeed", async function () {
    const startingBalance = await erc20.balanceOf(Alice.ethAddress);

    // Alice proposes the output ERC20 tokens
    const outputCommitment = newUTXO(20, Alice);

    const { inputCommitments, outputCommitments, encodedProof } =
      await prepareWithdrawProof(Alice, [utxo100, ZERO_UTXO], outputCommitment);

    // Alice withdraws her UTXOs to ERC20 tokens
    const tx = await zeto
      .connect(Alice.signer)
      .withdraw(80, inputCommitments, outputCommitments[0], encodedProof, "0x");
    const result = await tx.wait();
    console.log(`Method withdraw() complete. Gas used: ${result?.gasUsed}`);

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

  it("(burnable) mint to Alice and transfer honestly to Bob then burn should succeed", async function () {
    // first mint the tokens for testing
    const inputUtxos = [];
    for (let i = 0; i < 3; i++) {
      inputUtxos.push(newUTXO(10, Alice));
    }
    await doMint(zetoBurnable, deployer, inputUtxos);

    const remainder = newUTXO(5, Alice);

    // Alice can burn the UTXOs she owns
    const { inputCommitments, outputCommitment, encodedProof } =
      await prepareBurnProof(Alice, inputUtxos.slice(0, 2), remainder);
    const tx = await zetoBurnable
      .connect(Alice.signer)
      .burn(inputCommitments, outputCommitment, encodedProof, "0x");
    await tx.wait();

    // check that the burned UTXOs are spent
    let spent = await zetoBurnable.spent(inputCommitments[0]);
    expect(spent).to.be.true;
    spent = await zetoBurnable.spent(inputCommitments[1]);
    expect(spent).to.be.true;
    // check that the remaining UTXO is not spent
    spent = await zetoBurnable.spent(inputUtxos[2].hash as BigNumberish);
    expect(spent).to.be.false;
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
          .withdraw(
            10,
            inputCommitments,
            outputCommitments[0],
            encodedProof,
            "0x",
          ),
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

  describe("lock() tests", function () {
    let lockedUtxo1: UTXO;
    let lockedUtxo2: UTXO;

    it("lock() should fail when duplicate UTXOs are provided", async function () {
      const resusedUtxo = newUTXO(7, Bob);
      const spareUtxo = newUTXO(1, Bob);
      const inflatedInputUtxos = [utxo7, ZERO_UTXO, ZERO_UTXO];
      const inflatedOutputUtxos = [resusedUtxo, spareUtxo, resusedUtxo];
      const inflatedOutputOwners = [Bob, Bob, Bob];
      for (let i = 0; i < 7; i++) {
        inflatedInputUtxos.push(ZERO_UTXO);
        inflatedOutputUtxos.push(ZERO_UTXO);
        inflatedOutputOwners.push(Bob);
      }

      const result = await prepareProof(
        batchCircuit,
        batchProvingKey,
        Bob,
        inflatedInputUtxos,
        inflatedOutputUtxos,
        inflatedOutputOwners,
      );
      await expect(
        zeto.connect(Bob.signer).lock(
          result.inputCommitments,
          [result.outputCommitments[0]], // unlocked output
          result.outputCommitments, // locked output
          result.encodedProof,
          Alice.ethAddress, // make Alice the delegate who can spend the state (if she has the right proof)
          "0x",
        ),
      ).rejectedWith(`UTXODuplicate(${resusedUtxo.hash.toString()})`);
    });

    it("lock() should succeed when using unlocked states", async function () {
      lockedUtxo1 = newUTXO(10, Bob);
      lockedUtxo2 = newUTXO(5, Bob);
      const result = await prepareProof(
        circuit,
        provingKey,
        Bob,
        [utxo7, ZERO_UTXO],
        [lockedUtxo1, lockedUtxo2],
        [Bob, Bob],
      );
      const tx = await zeto.connect(Bob.signer).lock(
        result.inputCommitments,
        [], // unlocked output
        result.outputCommitments, // locked output
        result.encodedProof,
        Alice.ethAddress, // make Alice the delegate who can spend the state (if she has the right proof)
        "0x",
      );
      const results = await tx.wait();
      console.log(`Method transfer() complete. Gas used: ${results?.gasUsed}`);
    });

    it("locked() should return true for locked UTXOs, and false for unlocked or spent UTXOs", async function () {
      expect(await zeto.locked(lockedUtxo1.hash)).to.deep.equal([
        true,
        Alice.ethAddress,
      ]);
      expect(await zeto.locked(lockedUtxo2.hash)).to.deep.equal([
        true,
        Alice.ethAddress,
      ]);
      expect(await zeto.locked(utxo7.hash)).to.deep.equal([
        false,
        "0x0000000000000000000000000000000000000000",
      ]);
      expect(await zeto.locked(utxo1.hash)).to.deep.equal([
        false,
        "0x0000000000000000000000000000000000000000",
      ]);
    });

    it("lock() should fail when trying to lock again", async function () {
      if (network.name !== "hardhat") {
        return;
      }

      // Bob is the owner of the UTXO, so he can generate the right proof
      const utxo1 = newUTXO(10, Bob);
      const result = await prepareProof(
        circuit,
        provingKey,
        Bob,
        [lockedUtxo1, ZERO_UTXO],
        [utxo1, ZERO_UTXO],
        [Bob, Bob],
      );

      // but he's no longer the delegate (Alice is) to spend the state
      await expect(
        zeto
          .connect(Bob.signer)
          .lock(
            result.inputCommitments,
            [],
            result.outputCommitments,
            result.encodedProof,
            Bob.ethAddress,
            "0x",
          ),
      ).rejectedWith(`UTXOAlreadyLocked(${lockedUtxo1.hash.toString()})`);
    });

    it("the original owner can NOT spend the locked state", async function () {
      const utxo1 = newUTXO(10, Alice);
      await expect(
        doTransfer(
          Bob,
          [lockedUtxo1, ZERO_UTXO],
          [utxo1, ZERO_UTXO],
          [Alice, Alice],
        ),
      ).to.be.rejectedWith("UTXOAlreadyLocked");
    });

    it("the original owner can NOT withdraw the locked state", async function () {
      const outputCommitment = newUTXO(5, Bob);

      const { inputCommitments, outputCommitments, encodedProof } =
        await prepareWithdrawProof(
          Bob,
          [lockedUtxo1, ZERO_UTXO],
          outputCommitment,
        );

      // Alice withdraws her UTXOs to ERC20 tokens
      await expect(
        zeto
          .connect(Bob.signer)
          .withdraw(
            10,
            inputCommitments,
            outputCommitments[0],
            encodedProof,
            "0x",
          ),
      ).to.be.rejectedWith("UTXOAlreadyLocked");
    });

    it("an invalid lock delegate can NOT give the lock to another delegate", async function () {
      await expect(
        zeto
          .connect(Bob.signer)
          .delegateLock(
            [lockedUtxo1.hash as BigNumberish],
            Charlie.ethAddress,
            "0x",
          ),
      ).to.be.rejectedWith("NotLockDelegate");
    });

    it("the valid lock delegate can give the lock to another delegate", async function () {
      await expect(
        zeto
          .connect(Alice.signer)
          .delegateLock(
            [lockedUtxo1.hash as BigNumberish],
            Charlie.ethAddress,
            "0x",
          ),
      ).to.be.fulfilled;
    });

    it("attempting to use an existing UTXO as output should fail", async function () {
      const utxo1 = newUTXO(5, Alice);
      const { inputCommitments, outputCommitments, encodedProof } =
        await prepareProof(
          circuit,
          provingKey,
          Bob,
          [lockedUtxo1, ZERO_UTXO],
          [utxo1, lockedUtxo2],
          [Alice, Bob],
        );
      // Charlie is the new delegate (in reality this is usually a contract that orchestrates a trade flow) to spend the locked state
      // using the proof generated by the trade counterparty (Bob in this case)
      await expect(
        sendTx(
          Charlie,
          inputCommitments,
          outputCommitments,
          encodedProof,
          true,
        ),
      ).to.be.rejectedWith(`UTXOAlreadyOwned(${lockedUtxo2.hash.toString()})`);
    });

    it("attempting to use a spent UTXO as output should fail", async function () {
      // spend utxo4
      const utxo1 = newUTXO(2, Bob);
      const utxo2 = newUTXO(3, Alice);
      await expect(
        doTransfer(Alice, [utxo4, ZERO_UTXO], [utxo1, utxo2], [Bob, Alice]),
      ).to.be.fulfilled;

      // attempt to use utxo4 as output
      const utxo3 = newUTXO(5, Alice);
      const { inputCommitments, outputCommitments, encodedProof } =
        await prepareProof(
          circuit,
          provingKey,
          Bob,
          [lockedUtxo1, ZERO_UTXO],
          [utxo3, utxo4],
          [Alice, Alice],
        );
      // Charlie is the new delegate (in reality this is usually a contract that orchestrates a trade flow) to spend the locked state
      // using the proof generated by the trade counterparty (Bob in this case)
      await expect(
        sendTx(
          Charlie,
          inputCommitments,
          outputCommitments,
          encodedProof,
          true,
        ),
      ).to.be.rejectedWith(`UTXOAlreadySpent(${utxo4.hash.toString()})`);
    });

    it("the designated delegate can use the proper proof to spend the locked state", async function () {
      const utxo1 = newUTXO(10, Alice);
      const { inputCommitments, outputCommitments, encodedProof } =
        await prepareProof(
          circuit,
          provingKey,
          Bob,
          [lockedUtxo1, ZERO_UTXO],
          [utxo1, ZERO_UTXO],
          [Alice, Alice],
        );
      // Alice as the delegate (in reality this is usually a contract that orchestrates a trade flow) can spend the locked state
      // using the proof generated by the trade counterparty (Bob in this case)
      await expect(
        sendTx(
          Charlie,
          inputCommitments,
          outputCommitments,
          encodedProof,
          true,
        ),
      ).to.be.fulfilled;
    });

    it("unlocks a previously locked UTXO, and spend as usual", async function () {
      const utxo1 = newUTXO(5, Charlie);
      await expect(
        doTransfer(
          Bob,
          [lockedUtxo2, ZERO_UTXO],
          [utxo1, ZERO_UTXO],
          [Charlie, Charlie],
        ),
      ).to.be.rejectedWith("UTXOAlreadyLocked");

      // Alice as the current delegate can unlock the UTXO
      const { inputCommitments, outputCommitments, encodedProof } =
        await prepareProof(
          circuit,
          provingKey,
          Bob,
          [lockedUtxo2, ZERO_UTXO],
          [utxo1, ZERO_UTXO],
          [Charlie, Charlie],
        );
      await expect(
        zeto
          .connect(Alice.signer)
          .unlock(inputCommitments, outputCommitments, encodedProof, "0x"),
      ).to.be.fulfilled;

      // now Bob as the owner can spend the UTXO as usual
      const utxo2 = newUTXO(5, Bob);
      await expect(
        doTransfer(Charlie, [utxo1, ZERO_UTXO], [utxo2, ZERO_UTXO], [Bob, Bob]),
      ).to.be.fulfilled;
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
      encodedProof,
    );
  }

  async function sendTx(
    signer: User,
    inputCommitments: BigNumberish[],
    outputCommitments: BigNumberish[],
    encodedProof: any,
    isLocked = false,
  ) {
    let tx;
    if (isLocked) {
      tx = await zeto.connect(signer.signer).transferLocked(
        inputCommitments.filter((ic) => ic !== 0n), // trim off empty utxo hashes to check padding logic for batching works
        outputCommitments.filter((oc) => oc !== 0n), // trim off empty utxo hashes to check padding logic for batching works
        encodedProof,
        "0x",
      );
    } else {
      tx = await zeto
        .connect(signer.signer)
        .transfer(inputCommitments, outputCommitments, encodedProof, "0x");
    }
    const results = await tx.wait();
    console.log(`Method transfer() complete. Gas used: ${results?.gasUsed}`);

    for (const input of inputCommitments) {
      if (input === 0n) {
        continue;
      }
      const owner = await zeto.spent(input);
      expect(owner).to.equal(true);
    }
    for (const output of outputCommitments) {
      if (output === 0n) {
        continue;
      }
      expect(await zeto.spent(output)).to.equal(false);
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
