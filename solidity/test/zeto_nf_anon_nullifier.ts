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
import { ContractTransactionReceipt, Signer, BigNumberish } from "ethers";
import { expect } from "chai";
import { loadCircuit, Poseidon, encodeProof, tokenUriHash } from "zeto-js";
import { groth16 } from "snarkjs";
import { Merkletree, InMemoryDB, str2Bytes } from "@iden3/js-merkletree";
import {
  UTXO,
  User,
  newUser,
  newAssetUTXO,
  newAssetNullifier,
  doMint,
  parseUTXOEvents,
} from "./lib/utils";
import { loadProvingKeys } from "./utils";
import { deployZeto } from "./lib/deploy";

describe("Zeto based non-fungible token with anonymity using nullifiers without encryption", function () {
  let deployer: Signer;
  let Alice: User;
  let Bob: User;
  let Charlie: User;
  let zeto: any;
  let utxo1: UTXO;
  let utxo2: UTXO;
  let circuit: any, provingKey: any;
  let circuitLocked: any, provingKeyLocked: any;
  let smtAlice: Merkletree;
  let smtBob: Merkletree;

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

    ({ deployer, zeto } = await deployZeto("Zeto_NfAnonNullifier"));

    circuit = await loadCircuit("nf_anon_nullifier_transfer");
    ({ provingKeyFile: provingKey } = loadProvingKeys(
      "nf_anon_nullifier_transfer",
    ));
    circuitLocked = await loadCircuit("nf_anon_nullifier_transferLocked");
    ({ provingKeyFile: provingKeyLocked } = loadProvingKeys(
      "nf_anon_nullifier_transferLocked",
    ));

    const storage1 = new InMemoryDB(str2Bytes(""));
    smtAlice = new Merkletree(storage1, true, 64);

    const storage2 = new InMemoryDB(str2Bytes(""));
    smtBob = new Merkletree(storage2, true, 64);
  });

  it("onchain SMT root should be equal to the offchain SMT root", async function () {
    const root = await smtAlice.root();
    const onchainRoot = await zeto.getRoot();
    expect(onchainRoot).to.equal(0n);
    expect(root.string()).to.equal(onchainRoot.toString());
  });

  it("mint to Alice and transfer UTXOs honestly to Bob should succeed", async function () {
    // The authority mints a new UTXO and assigns it to Alice
    const tokenId = 1001;
    const uri = "http://ipfs.io/file-hash-1";
    utxo1 = newAssetUTXO(tokenId, uri, Alice);
    const result1 = await doMint(zeto, deployer, [utxo1]);

    // Alice locally tracks the UTXOs inside the Sparse Merkle Tree
    // hardhat doesn't have a good way to subscribe to events so we have to parse the Tx result object
    const mintEvents = parseUTXOEvents(zeto, result1);
    const [_utxo1] = mintEvents[0].outputs;
    await smtAlice.add(_utxo1, _utxo1);
    let root = await smtAlice.root();
    let onchainRoot = await zeto.getRoot();
    expect(root.string()).to.equal(onchainRoot.toString());
    // Bob also locally tracks the UTXOs inside the Sparse Merkle Tree
    await smtBob.add(_utxo1, _utxo1);

    // Alice proposes the output UTXOs for the transfer to Bob
    const _utxo2 = newAssetUTXO(tokenId, uri, Bob);

    // Alice generates the nullifiers for the UTXOs to be spent
    const nullifier1 = newAssetNullifier(utxo1, Alice);

    // Alice generates inclusion proofs for the UTXOs to be spent
    const proof1 = await smtAlice.generateCircomVerifierProof(utxo1.hash, root);
    const merkleProof = proof1.siblings.map((s) => s.bigInt());

    // Alice transfers her UTXOs to Bob
    const result2 = await doTransfer(
      Alice,
      utxo1,
      nullifier1,
      _utxo2,
      root.bigInt(),
      merkleProof,
      Bob,
    );

    // Alice locally tracks the UTXOs inside the Sparse Merkle Tree
    await smtAlice.add(_utxo2.hash, _utxo2.hash);
    root = await smtAlice.root();
    onchainRoot = await zeto.getRoot();
    expect(root.string()).to.equal(onchainRoot.toString());

    // Bob locally tracks the UTXOs inside the Sparse Merkle Tree
    // Bob parses the UTXOs from the onchain event
    const signerAddress = await Alice.signer.getAddress();
    const events = parseUTXOEvents(zeto, result2.txResult!);
    expect(events[0].submitter).to.equal(signerAddress);
    expect(events[0].inputs).to.deep.equal([nullifier1.hash]);
    expect(events[0].outputs).to.deep.equal([_utxo2.hash]);
    await smtBob.add(events[0].outputs[0], events[0].outputs[0]);

    // Bob uses the information received from Alice to reconstruct the UTXO sent to him
    const receivedTokenId = _utxo2.tokenId!;
    const receivedUri = _utxo2.uri!;
    const receivedSalt = _utxo2.salt;
    const incomingUTXOs: any = events[0].outputs;
    const hash = Poseidon.poseidon5([
      BigInt(receivedTokenId),
      tokenUriHash(receivedUri),
      receivedSalt,
      Bob.babyJubPublicKey[0],
      Bob.babyJubPublicKey[1],
    ]);
    expect(incomingUTXOs[0]).to.equal(hash);

    // Bob uses the decrypted values to construct the UTXO received from the transaction
    utxo2 = newAssetUTXO(receivedTokenId, receivedUri, Bob, receivedSalt);
  }).timeout(600000);

  it("Bob transfers UTXOs, previously received from Alice, honestly to Charlie should succeed", async function () {
    // Bob generates the nullifiers for the UTXO to be spent
    const nullifier1 = newAssetNullifier(utxo2, Bob);

    // Bob generates inclusion proofs for the UTXOs to be spent, as private input to the proof generation
    const root = await smtBob.root();
    const proof1 = await smtBob.generateCircomVerifierProof(utxo2.hash, root);
    const merkleProof = proof1.siblings.map((s) => s.bigInt());

    // Bob proposes the output UTXOs
    const _utxo1 = newAssetUTXO(utxo2.tokenId!, utxo2.uri!, Charlie);

    // Bob should be able to spend the UTXO that was reconstructed from the previous transaction
    const result = await doTransfer(
      Bob,
      utxo2,
      nullifier1,
      _utxo1,
      root.bigInt(),
      merkleProof,
      Charlie,
    );

    // Bob keeps the local SMT in sync
    await smtBob.add(_utxo1.hash, _utxo1.hash);

    // Alice gets the new UTXOs from the onchain event and keeps the local SMT in sync
    const events = parseUTXOEvents(zeto, result.txResult!);
    await smtAlice.add(events[0].outputs[0], events[0].outputs[0]);
  }).timeout(600000);

  describe("lock() tests", function () {
    let lockedUtxo: UTXO;
    let smtAliceLocked: Merkletree;

    before(async function () {
      const storage1 = new InMemoryDB(str2Bytes(""));
      smtAliceLocked = new Merkletree(storage1, true, 64);
    });

    it("lock a UTXO should succeed", async function () {
      const tokenId = 1002;
      const uri = "http://ipfs.io/file-hash-2";
      const _utxo1 = newAssetUTXO(tokenId, uri, Alice);
      await doMint(zeto, deployer, [_utxo1]);

      await smtAlice.add(_utxo1.hash, _utxo1.hash);

      const nullifier = newAssetNullifier(_utxo1, Alice);
      let root = await smtAlice.root();
      const proof1 = await smtAlice.generateCircomVerifierProof(
        _utxo1.hash,
        root,
      );
      const merkleProof = proof1.siblings.map((s) => s.bigInt());
      lockedUtxo = newAssetUTXO(_utxo1.tokenId!, _utxo1.uri!, Alice);
      const { outputCommitment, encodedProof } = await prepareProof(
        Alice,
        _utxo1,
        nullifier,
        lockedUtxo,
        root.bigInt(),
        merkleProof,
        Alice,
      );
      await expect(
        zeto
          .connect(Alice.signer)
          .lock(
            nullifier.hash,
            outputCommitment,
            root.bigInt(),
            encodedProof,
            Bob.ethAddress,
            "0x",
          ),
      ).to.be.fulfilled;

      await smtAliceLocked.add(
        lockedUtxo.hash,
        ethers.toBigInt(Bob.ethAddress),
      );
    });

    it("onchain SMT root for the locked UTXOs should be equal to the offchain SMT root", async function () {
      const root = await smtAliceLocked.root();
      const onchainRoot = await zeto.getRootForLocked();
      expect(root.string()).to.equal(onchainRoot.toString());
    });

    it("lock a UTXO that has already been locked should fail", async function () {
      const nullifier = newAssetNullifier(lockedUtxo, Alice);
      let root = await smtAliceLocked.root();
      const proof1 = await smtAliceLocked.generateCircomVerifierProof(
        lockedUtxo.hash,
        root,
      );
      const merkleProof = proof1.siblings.map((s) => s.bigInt());
      const _utxo1 = newAssetUTXO(lockedUtxo.tokenId!, lockedUtxo.uri!, Alice);
      const { outputCommitment, encodedProof } = await prepareProof(
        Alice,
        lockedUtxo,
        nullifier,
        _utxo1,
        root.bigInt(),
        merkleProof,
        Alice,
        Bob,
      );
      await expect(
        zeto
          .connect(Alice.signer)
          .lock(
            nullifier.hash,
            outputCommitment,
            root.bigInt(),
            encodedProof,
            Bob.ethAddress,
            "0x",
          ),
      ).to.be.rejectedWith("UTXORootNotFound");
    });

    it("the owner trying to spend a locked UTXO should fail", async function () {
      const nullifier = newAssetNullifier(lockedUtxo, Alice);
      let root = await smtAliceLocked.root();
      const proof1 = await smtAliceLocked.generateCircomVerifierProof(
        lockedUtxo.hash,
        root,
      );
      const merkleProof = proof1.siblings.map((s) => s.bigInt());
      const _utxo1 = newAssetUTXO(lockedUtxo.tokenId!, lockedUtxo.uri!, Bob);
      const { outputCommitment, encodedProof } = await prepareProof(
        Alice,
        lockedUtxo,
        nullifier,
        _utxo1,
        root.bigInt(),
        merkleProof,
        Bob,
        Bob,
      );
      await expect(
        zeto
          .connect(Alice.signer)
          .transfer(
            nullifier.hash,
            outputCommitment,
            root.bigInt(),
            encodedProof,
            "0x",
          ),
      ).to.be.rejectedWith("UTXORootNotFound");
    });

    it("the current delegate can move the lock to a new delegate", async function () {
      const tx = await zeto
        .connect(Bob.signer)
        .delegateLock([lockedUtxo.hash], Charlie.ethAddress, "0x");
      const result = await tx.wait();
      const events = parseUTXOEvents(zeto, result);
      // this should update the existing leaf node value from address of Alice to Charlie
      await smtAliceLocked.update(
        events[0].lockedOutputs[0],
        ethers.toBigInt(events[0].newDelegate),
      );
    });

    it("onchain SMT root for the locked UTXOs should be equal to the offchain SMT root", async function () {
      const root = await smtAliceLocked.root();
      const onchainRoot = await zeto.getRootForLocked();
      expect(root.string()).to.equal(onchainRoot.toString());
    });

    it("the new delegate can spend the locked UTXO using a valid proof from the current owner", async function () {
      const nullifier = newAssetNullifier(lockedUtxo, Alice);
      let root = await smtAliceLocked.root();
      const proof1 = await smtAliceLocked.generateCircomVerifierProof(
        lockedUtxo.hash,
        root,
      );
      const merkleProof = proof1.siblings.map((s) => s.bigInt());
      const _utxo1 = newAssetUTXO(lockedUtxo.tokenId!, lockedUtxo.uri!, Bob);
      const { outputCommitment, encodedProof } = await prepareProof(
        Alice,
        lockedUtxo,
        nullifier,
        _utxo1,
        root.bigInt(),
        merkleProof,
        Bob,
        Charlie,
      );
      await expect(
        zeto
          .connect(Charlie.signer)
          .transferLocked(
            nullifier.hash,
            outputCommitment,
            root.bigInt(),
            encodedProof,
            "0x",
          ),
      ).to.be.fulfilled;
    });
  });

  describe("failure cases", function () {
    // the following failure cases rely on the hardhat network
    // to return the details of the errors. This is not possible
    // on non-hardhat networks
    if (network.name !== "hardhat") {
      return;
    }

    it("mint existing unspent UTXOs should fail", async function () {
      await expect(doMint(zeto, deployer, [utxo2])).rejectedWith(
        "UTXOAlreadyOwned",
      );
    });

    it("mint existing spent UTXOs should fail", async function () {
      await expect(doMint(zeto, deployer, [utxo1])).rejectedWith(
        "UTXOAlreadyOwned",
      );
    });

    it("transfer spent UTXOs should fail (double spend protection)", async function () {
      // Alice create outputs in an attempt to send to Charlie an already spent asset
      const _utxo1 = newAssetUTXO(utxo1.tokenId!, utxo1.uri!, Charlie);

      // generate the nullifiers for the UTXOs to be spent
      const nullifier1 = newAssetNullifier(utxo1, Alice);

      // generate inclusion proofs for the UTXOs to be spent
      let root = await smtAlice.root();
      const proof1 = await smtAlice.generateCircomVerifierProof(
        utxo1.hash,
        root,
      );
      const merkleProof = proof1.siblings.map((s) => s.bigInt());

      await expect(
        doTransfer(
          Alice,
          utxo1,
          nullifier1,
          _utxo1,
          root.bigInt(),
          merkleProof,
          Charlie,
        ),
      ).rejectedWith("UTXOAlreadySpent");
    }).timeout(600000);

    it("transfer non-existing UTXOs should fail", async function () {
      const nonExisting1 = newAssetUTXO(
        1002,
        "http://ipfs.io/file-hash-2",
        Alice,
      );

      // add to our local SMT (but they don't exist on the chain)
      await smtAlice.add(nonExisting1.hash, nonExisting1.hash);

      // generate the nullifiers for the UTXOs to be spent
      const nullifier1 = newAssetNullifier(nonExisting1, Alice);

      // generate inclusion proofs for the UTXOs to be spent
      let root = await smtAlice.root();
      const proof1 = await smtAlice.generateCircomVerifierProof(
        nonExisting1.hash,
        root,
      );
      const merkleProof = proof1.siblings.map((s) => s.bigInt());

      // propose the output UTXOs
      const _utxo1 = newAssetUTXO(
        nonExisting1.tokenId!,
        nonExisting1.uri!,
        Charlie,
      );

      await expect(
        doTransfer(
          Alice,
          nonExisting1,
          nullifier1,
          _utxo1,
          root.bigInt(),
          merkleProof,
          Charlie,
        ),
      ).rejectedWith("UTXORootNotFound");
    }).timeout(600000);
  });

  async function doTransfer(
    signer: User,
    input: UTXO,
    _nullifier: UTXO,
    output: UTXO,
    root: BigInt,
    merkleProof: BigInt[],
    owner: User,
  ) {
    let nullifier: BigNumberish;
    let outputCommitment: BigNumberish;
    let encodedProof: any;
    const result = await prepareProof(
      signer,
      input,
      _nullifier,
      output,
      root,
      merkleProof,
      owner,
    );
    nullifier = _nullifier.hash as BigNumberish;
    outputCommitment = result.outputCommitment;
    encodedProof = result.encodedProof;

    const txResult = await sendTx(
      signer,
      nullifier,
      outputCommitment,
      root,
      encodedProof,
    );
    return { txResult };
  }

  async function prepareProof(
    signer: User,
    input: UTXO,
    _nullifier: UTXO,
    output: UTXO,
    root: BigInt,
    merkleProof: BigInt[],
    owner: User,
    lockDelegate?: User,
  ) {
    const nullifier = _nullifier.hash as BigNumberish;
    const inputCommitment: BigNumberish = input.hash as BigNumberish;
    const tokenId = BigInt(input.tokenId!);
    const tokenUri = tokenUriHash(input.uri!);
    const inputSalt = input.salt!;
    const outputCommitment: BigNumberish = output.hash as BigNumberish;
    const outputSalt = output.salt!;
    const outputOwnerPublicKey: [BigNumberish, BigNumberish] =
      owner.babyJubPublicKey as [BigNumberish, BigNumberish];

    const startWitnessCalculation = Date.now();
    const inputObj: any = {
      nullifier,
      inputCommitment,
      tokenId,
      tokenUri,
      inputSalt,
      inputOwnerPrivateKey: signer.formattedPrivateKey,
      root,
      merkleProof,
      outputCommitment,
      outputSalt,
      outputOwnerPublicKey,
    };
    if (lockDelegate) {
      inputObj["lockDelegate"] = ethers.toBigInt(lockDelegate.ethAddress);
    }

    let circuitToUse = lockDelegate ? circuitLocked : circuit;
    let provingKeyToUse = lockDelegate ? provingKeyLocked : provingKey;
    const witness = await circuitToUse.calculateWTNSBin(inputObj, true);
    const timeWithnessCalculation = Date.now() - startWitnessCalculation;

    const startProofGeneration = Date.now();
    const { proof, publicSignals } = (await groth16.prove(
      provingKeyToUse,
      witness,
    )) as { proof: BigNumberish[]; publicSignals: BigNumberish[] };
    const timeProofGeneration = Date.now() - startProofGeneration;

    console.log(
      `Witness calculation time: ${timeWithnessCalculation}ms. Proof generation time: ${timeProofGeneration}ms.`,
    );

    const encodedProof = encodeProof(proof);
    return {
      inputCommitment,
      outputCommitment,
      encodedProof,
    };
  }

  async function sendTx(
    signer: User,
    nullifier: BigNumberish,
    outputCommitment: BigNumberish,
    root: BigNumberish,
    encodedProof: any,
  ) {
    const startTx = Date.now();
    const tx = await zeto
      .connect(signer.signer)
      .transfer(nullifier, outputCommitment, root, encodedProof, "0x");
    const results: ContractTransactionReceipt | null = await tx.wait();
    console.log(
      `Time to execute transaction: ${Date.now() - startTx}ms. Gas used: ${
        results?.gasUsed
      }`,
    );
    return results;
  }
});
