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

import { ethers, ignition, network } from "hardhat";
import { Signer, encodeBytes32String, ZeroHash } from "ethers";
import { expect } from "chai";
import { loadCircuit, getProofHash } from "zeto-js";
import zkDvPModule from "../ignition/modules/zkDvP";
import zetoAnonTests from "./zeto_anon";
import zetoNFAnonTests from "./zeto_nf_anon";
import {
  UTXO,
  User,
  newUser,
  newUTXO,
  doMint,
  newAssetUTXO,
  ZERO_UTXO,
  parseUTXOEvents,
} from "./lib/utils";
import { loadProvingKeys } from "./utils";
import { deployZeto } from "./lib/deploy";

describe("DvP flows between fungible and non-fungible tokens based on Zeto with anonymity without encryption or nullifiers", function () {
  // users interacting with each other in the DvP transactions
  let Alice: User;
  let Bob: User;
  let Charlie: User;

  // instances of the contracts
  let zkAsset: any;
  let zkPayment: any;
  let zkDvP: any;

  // asset UTXOs to be minted and transferred
  let asset1: UTXO;
  let asset2: UTXO;
  // payment UTXOs to be minted and transferred
  let payment1: UTXO;
  let payment2: UTXO;

  // other variables
  let deployer: Signer;

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

    ({ deployer, zeto: zkAsset } = await deployZeto("Zeto_NfAnon"));
    console.log(`ZK Asset contract deployed at ${zkAsset.target}`);
    ({ deployer, zeto: zkPayment } = await deployZeto("Zeto_Anon"));
    console.log(`ZK Payment contract deployed at ${zkPayment.target}`);
    ({ zkDvP } = await ignition.deploy(zkDvPModule, {
      parameters: {
        zkDvP: {
          assetToken: zkAsset.target,
          paymentToken: zkPayment.target,
        },
      },
    }));
  });

  it("mint to Alice some payment tokens", async function () {
    payment1 = newUTXO(10, Alice);
    payment2 = newUTXO(20, Alice);
    const result = await doMint(zkPayment, deployer, [payment1, payment2]);

    // simulate Alice and Bob listening to minting events and updating his local merkle tree
    for (const log of result.logs) {
      const event = zkPayment.interface.parseLog(log as any);
      expect(event.args.outputs.length).to.equal(2);
    }
  });

  it("mint to Bob some asset tokens", async function () {
    asset1 = newUTXO(10, Alice);
    asset2 = newUTXO(20, Alice);
    const result = await doMint(zkAsset, deployer, [asset1, asset2]);

    // simulate Bob listening to minting events and updating his local merkle tree
    const event = zkAsset.interface.parseLog(result.logs[0] as any);
    expect(event.args.outputs[0].toString()).to.equal(asset1.hash.toString());
    expect(event.args.outputs[1].toString()).to.equal(asset2.hash.toString());
  });

  it("Initiating a successful DvP transaction with payment inputs", async function () {
    const utxo1 = newUTXO(10, Alice);
    const utxo2 = newUTXO(20, Alice);
    const utxo3 = newUTXO(25, Bob);
    const utxo4 = newUTXO(5, Alice);
    await expect(
      zkDvP
        .connect(Alice.signer)
        .initiateTrade(
          [utxo1.hash, utxo2.hash],
          [utxo3.hash, utxo4.hash],
          ZeroHash,
          0,
          0,
          ZeroHash,
        ),
    ).fulfilled;
  });

  it("Initiating a successful DvP transaction with asset inputs", async function () {
    const utxo1 = newUTXO(10, Alice);
    const utxo2 = newUTXO(20, Alice);
    await expect(
      zkDvP
        .connect(Alice.signer)
        .initiateTrade(
          [0, 0],
          [0, 0],
          ZeroHash,
          utxo1.hash,
          utxo2.hash,
          ZeroHash,
        ),
    ).fulfilled;
  });

  it("Initiating a successful DvP transaction with payment inputs and accepting by specifying asset inputs", async function () {
    // the authority mints some payment tokens to Alice
    const _utxo1 = newUTXO(100, Alice);
    await doMint(zkPayment, deployer, [_utxo1]);
    // the authority mints some asset tokens to Bob
    const utxo3 = newAssetUTXO(202, "http://ipfs.io/file-hash-1", Bob);
    await doMint(zkAsset, deployer, [utxo3]);

    // 1. Alice initiates a trade with Bob using the payment tokens
    // 1.1 Alice generates the proposed output payment UTXO for Bob
    const utxo2 = newUTXO(100, Bob);

    // 1.2 Alice generates the proof for the trade proposal
    const circuit1 = await loadCircuit("anon");
    const { provingKeyFile: provingKey1 } = loadProvingKeys("anon");
    const proof1 = await zetoAnonTests.prepareProof(
      circuit1,
      provingKey1,
      Alice,
      [_utxo1, ZERO_UTXO],
      [utxo2, ZERO_UTXO],
      [Bob, {}],
    );
    const hash1 = getProofHash(proof1.encodedProof);

    // 1.3 Alice initiates the trade with Bob
    const tx1 = await zkDvP
      .connect(Alice.signer)
      .initiateTrade([_utxo1.hash, 0], [utxo2.hash, 0], hash1, 0, 0, ZeroHash);
    const result1 = await tx1.wait();
    const event = zkDvP.interface.parseLog(result1.logs[0]);
    const tradeId = event.args.tradeId;

    // 2. Bob accepts the trade by using the asset tokens
    // 2.1 Bob generates the proposed output asset UTXO for Alice
    const utxo4 = newAssetUTXO(202, "http://ipfs.io/file-hash-1", Alice);

    // 2.2 Bob generates the proof for accepting the trade
    const circuit2 = await loadCircuit("nf_anon");
    const { provingKeyFile: provingKey2 } = loadProvingKeys("nf_anon");
    const proof2 = await zetoNFAnonTests.prepareProof(
      circuit2,
      provingKey2,
      Bob,
      utxo3,
      utxo4,
      Alice,
    );
    const hash2 = getProofHash(proof2.encodedProof);

    await expect(
      zkDvP
        .connect(Bob.signer)
        .acceptTrade(
          tradeId,
          [0, 0],
          [0, 0],
          ZeroHash,
          utxo3.hash,
          utxo4.hash,
          hash2,
        ),
    ).fulfilled;

    // 3. Alice sends her proof to complete the trade (the trade will still be pending completion)
    const tx2 = await zkDvP
      .connect(Alice.signer)
      .completeTrade(tradeId, proof1.encodedProof);
    const tx2Result = await tx2.wait();

    // 4. Bob sends his proof to complete the trade (the trade will be completed)
    const tx3 = await zkDvP
      .connect(Bob.signer)
      .completeTrade(tradeId, proof2.encodedProof);
    const tx3Result = await tx3.wait();

    // check that the trade is completed
    const events = parseUTXOEvents(zkDvP, tx3Result);
    expect(events[0].tradeId).to.equal(tradeId);
    expect(events[0].trade.status).to.equal(2n); // enum for TradeStatus.Completed
  });
  describe("failure cases", function () {
    // the following failure cases rely on the hardhat network
    // to return the details of the errors. This is not possible
    // on non-hardhat networks
    if (network.name !== "hardhat") {
      return;
    }

    it("Initiating a DvP transaction without payment input or asset input should fail", async function () {
      await expect(
        zkDvP
          .connect(Alice.signer)
          .initiateTrade([0, 0], [0, 0], ZeroHash, 0, 0, ZeroHash),
      ).rejectedWith(
        "Payment inputs and asset input cannot be zero at the same time",
      );
    });

    it("Initiating a DvP transaction with payment input but no payment output should fail", async function () {
      const utxo1 = newUTXO(10, Alice);
      const utxo2 = newUTXO(20, Alice);
      await expect(
        zkDvP
          .connect(Alice.signer)
          .initiateTrade(
            [utxo1.hash, utxo2.hash],
            [0, 0],
            ZeroHash,
            0,
            0,
            ZeroHash,
          ),
      ).rejectedWith(
        "Payment outputs cannot be zero when payment inputs are non-zero",
      );
    });

    it("Initiating a DvP transaction with payment inputs and asset inputs should fail", async function () {
      const utxo1 = newUTXO(10, Alice);
      const utxo2 = newUTXO(20, Alice);
      const utxo3 = newUTXO(25, Bob);
      const utxo4 = newUTXO(5, Alice);
      await expect(
        zkDvP
          .connect(Alice.signer)
          .initiateTrade(
            [utxo1.hash, utxo2.hash],
            [utxo3.hash, utxo4.hash],
            ZeroHash,
            utxo3.hash,
            0,
            ZeroHash,
          ),
      ).rejectedWith(
        "Payment inputs and asset input cannot be provided at the same time",
      );
    });

    it("Initiating a DvP transaction with asset input but no asset output should fail", async function () {
      const utxo1 = newUTXO(10, Alice);
      await expect(
        zkDvP
          .connect(Alice.signer)
          .initiateTrade([0, 0], [0, 0], ZeroHash, utxo1.hash, 0, ZeroHash),
      ).rejectedWith(
        "Asset output cannot be zero when asset input is non-zero",
      );
    });

    it("Accepting a trade using an invalid trade ID should fail", async function () {
      await expect(
        zkDvP
          .connect(Bob.signer)
          .acceptTrade(1000, [0, 0], [0, 0], ZeroHash, 0, 0, ZeroHash),
      ).rejectedWith("Trade does not exist");
    });

    it("Failing cases for accepting a trade with payment terms", async function () {
      const mockProofHash = encodeBytes32String("moch proof hash");
      const utxo1 = newUTXO(20, Alice);
      const utxo2 = newUTXO(20, Bob);
      const tx1 = await zkDvP
        .connect(Alice.signer)
        .initiateTrade(
          [utxo1.hash, 0],
          [utxo2.hash, 0],
          mockProofHash,
          0,
          0,
          mockProofHash,
        );
      const result = await tx1.wait();
      const event = zkDvP.interface.parseLog(result.logs[0]);
      const tradeId = event.args.tradeId;

      const utxo3 = newAssetUTXO(25, "http://ipfs.io/file-hash-1", Bob);
      await expect(
        zkDvP
          .connect(Bob.signer)
          .acceptTrade(
            tradeId,
            [utxo1.hash, 0],
            [0, 0],
            mockProofHash,
            0,
            0,
            mockProofHash,
          ),
      ).rejectedWith("Payment inputs already provided by the trade initiator");
      await expect(
        zkDvP
          .connect(Bob.signer)
          .acceptTrade(
            tradeId,
            [0, 0],
            [utxo2.hash, 0],
            mockProofHash,
            0,
            0,
            mockProofHash,
          ),
      ).rejectedWith("Payment outputs already provided by the trade initiator");
      await expect(
        zkDvP
          .connect(Bob.signer)
          .acceptTrade(
            tradeId,
            [0, 0],
            [0, 0],
            mockProofHash,
            0,
            0,
            mockProofHash,
          ),
      ).rejectedWith("Asset input must be provided to accept the trade");
      await expect(
        zkDvP
          .connect(Bob.signer)
          .acceptTrade(
            tradeId,
            [0, 0],
            [0, 0],
            mockProofHash,
            utxo3.hash,
            0,
            mockProofHash,
          ),
      ).rejectedWith("Asset output must be provided to accept the trade");
    });

    it("Failing cases for accepting a trade with asset terms", async function () {
      const mockProofHash = encodeBytes32String("mock proof hash");
      const utxo1 = newAssetUTXO(100, "http://ipfs.io/file-hash-1", Alice);
      const utxo2 = newAssetUTXO(202, "http://ipfs.io/file-hash-2", Bob);
      const tx1 = await zkDvP
        .connect(Alice.signer)
        .initiateTrade(
          [0, 0],
          [0, 0],
          ZeroHash,
          utxo1.hash,
          utxo2.hash,
          mockProofHash,
        );
      const result = await tx1.wait();
      const event = zkDvP.interface.parseLog(result.logs[0]);
      const tradeId = event.args.tradeId;

      const utxo3 = newUTXO(10, Bob);
      const utxo4 = newUTXO(20, Bob);
      const utxo5 = newUTXO(25, Alice);
      const utxo6 = newUTXO(5, Bob);
      await expect(
        zkDvP
          .connect(Bob.signer)
          .acceptTrade(
            tradeId,
            [utxo3.hash, utxo4.hash],
            [utxo5.hash, utxo6.hash],
            mockProofHash,
            utxo1.hash,
            utxo2.hash,
            mockProofHash,
          ),
      ).rejectedWith("Asset inputs already provided by the trade initiator");
      await expect(
        zkDvP
          .connect(Bob.signer)
          .acceptTrade(
            tradeId,
            [utxo3.hash, utxo4.hash],
            [utxo5.hash, utxo6.hash],
            mockProofHash,
            0,
            utxo2.hash,
            mockProofHash,
          ),
      ).rejectedWith("Asset outputs already provided by the trade initiator");
      await expect(
        zkDvP
          .connect(Bob.signer)
          .acceptTrade(
            tradeId,
            [0, 0],
            [0, 0],
            mockProofHash,
            0,
            0,
            mockProofHash,
          ),
      ).rejectedWith("Payment inputs must be provided to accept the trade");
      await expect(
        zkDvP
          .connect(Bob.signer)
          .acceptTrade(
            tradeId,
            [utxo3.hash, utxo4.hash],
            [0, 0],
            mockProofHash,
            0,
            0,
            mockProofHash,
          ),
      ).rejectedWith("Payment outputs must be provided to accept the trade");
    });

    it("test proof locking", async function () {
      const circuit1 = await loadCircuit("anon");
      const { provingKeyFile: provingKey1 } = loadProvingKeys("anon");
      const utxo1 = newUTXO(100, Alice);
      const proof = await zetoAnonTests.prepareProof(
        circuit1,
        provingKey1,
        Alice,
        [utxo1, ZERO_UTXO],
        [utxo1, ZERO_UTXO],
        [Alice, {}],
      );

      await expect(
        zkPayment
          .connect(Alice.signer)
          .lockProof(proof.encodedProof, await Alice.signer.getAddress()),
      ).fulfilled;
      await expect(
        zkPayment
          .connect(Bob.signer)
          .lockProof(proof.encodedProof, await Bob.signer.getAddress()),
      ).rejectedWith("Proof already locked by another party");
      await expect(
        zkPayment
          .connect(Alice.signer)
          .lockProof(proof.encodedProof, await Bob.signer.getAddress()),
      ).fulfilled;
      await expect(
        zkPayment
          .connect(Bob.signer)
          .lockProof(
            proof.encodedProof,
            "0x0000000000000000000000000000000000000000",
          ),
      ).fulfilled;
    });
  });
}).timeout(600000);
