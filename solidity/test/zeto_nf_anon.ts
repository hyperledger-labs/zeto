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
import { Signer, BigNumberish, AddressLike, AbiCoder } from "ethers";
import { expect } from "chai";
import { loadCircuit, tokenUriHash, encodeProof } from "zeto-js";
import { groth16 } from "snarkjs";
import { formatPrivKeyForBabyJub, stringifyBigInts } from "maci-crypto";
import {
  User,
  UTXO,
  newUser,
  newAssetUTXO,
  doMint,
  ZERO_UTXO,
} from "./lib/utils";
import { loadProvingKeys, prepareAssetLockProof } from "./utils";
import { deployZeto } from "./lib/deploy";

describe("Zeto based non-fungible token with anonymity without encryption or nullifiers", function () {
  let deployer: Signer;
  let Alice: User;
  let Bob: User;
  let Charlie: User;
  let zeto: any;
  let utxo1: UTXO;
  let utxo2: UTXO;
  let utxo3: UTXO;
  let circuit: any, provingKey: any;

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

    ({ deployer, zeto } = await deployZeto("Zeto_NfAnon"));

    circuit = await loadCircuit("nf_anon");
    ({ provingKeyFile: provingKey } = loadProvingKeys("nf_anon"));
  });

  it("mint to Alice and transfer UTXOs honestly to Bob should succeed", async function () {
    const tokenId = 1001;
    const uri = "http://ipfs.io/file-hash-1";
    utxo1 = newAssetUTXO(tokenId, uri, Alice);
    await doMint(zeto, deployer, [utxo1]);

    // propose the output UTXOs
    const _utxo3 = newAssetUTXO(tokenId, uri, Bob);

    // transfer my own UTXOs to the Bob honestly should succeed
    await doTransfer(Alice, utxo1, _utxo3, Bob);

    // simulate Bob constructnig the UTXO from off-chain secure message channels with Alice
    utxo2 = newAssetUTXO(_utxo3.tokenId!, _utxo3.uri!, Bob, _utxo3.salt);
  });

  it("Bob transfers UTXOs, previously received from Alice, honestly to Charlie should succeed", async function () {
    // propose the output UTXOs
    utxo3 = newAssetUTXO(utxo2.tokenId!, utxo2.uri!, Charlie);

    // Bob should be able to spend the UTXO that was reconstructed from the previous transaction
    await doTransfer(Bob, utxo2, utxo3, Charlie);
  });

  describe("failure cases", function () {
    // the following failure cases rely on the hardhat network
    // to return the details of the errors. This is not possible
    // on non-hardhat networks
    if (network.name !== "hardhat") {
      return;
    }

    it("mint existing unspent UTXOs should fail", async function () {
      await expect(doMint(zeto, deployer, [utxo3])).rejectedWith(
        "UTXOAlreadyOwned",
      );
    });

    it("mint existing spent UTXOs should fail", async function () {
      await expect(doMint(zeto, deployer, [utxo1])).rejectedWith(
        "UTXOAlreadySpent",
      );
    });

    it("transfer non-existing UTXOs should fail", async function () {
      const nonExisting1 = newAssetUTXO(
        1002,
        "http://ipfs.io/file-hash-2",
        Alice,
      );
      const nonExisting2 = newAssetUTXO(
        1002,
        "http://ipfs.io/file-hash-2",
        Bob,
      );

      await expect(
        doTransfer(Alice, nonExisting1, nonExisting2, Bob),
      ).rejectedWith("UTXONotMinted");
    });

    it("transfer spent UTXOs should fail (double spend protection)", async function () {
      // create outputs
      const _utxo4 = newAssetUTXO(utxo1.tokenId!, utxo1.uri!, Bob);
      await expect(doTransfer(Alice, utxo1, _utxo4, Bob)).rejectedWith(
        "UTXOAlreadySpent",
      );
    });
  });

  describe("lock() tests", function () {
    describe("lock -> delegate -> spend", function () {
      let lockedUtxo1: UTXO;

      it("lock() should succeed when using unlocked states", async function () {
        lockedUtxo1 = newAssetUTXO(utxo3.tokenId!, utxo3.uri!, Charlie);
        const { inputCommitment, outputCommitment, encodedProof } =
          await prepareProof(
            circuit,
            provingKey,
            Charlie,
            utxo3,
            lockedUtxo1,
            Charlie,
          );

        await expect(
          zeto.connect(Charlie.signer).lock(
            inputCommitment,
            outputCommitment,
            encodeToBytes(encodedProof),
            Alice.ethAddress, // make Alice the delegate who can spend the state (if she has the right proof)
            "0x",
          ),
        ).to.be.fulfilled;
      });

      it("lock() should fail when trying to lock again", async function () {
        if (network.name !== "hardhat") {
          return;
        }

        // Charlie is the owner of the UTXO, so he can generate the right proof
        const utxo1 = newAssetUTXO(
          lockedUtxo1.tokenId!,
          lockedUtxo1.uri!,
          Charlie,
        );
        const { inputCommitment, outputCommitment, encodedProof } =
          await prepareProof(
            circuit,
            provingKey,
            Charlie,
            lockedUtxo1,
            utxo1,
            Charlie,
          );
        await expect(
          zeto
            .connect(Charlie.signer)
            .lock(
              inputCommitment,
              outputCommitment,
              encodeToBytes(encodedProof),
              Bob.ethAddress,
              "0x",
            ),
        ).rejectedWith(`UTXOAlreadyLocked(${lockedUtxo1.hash.toString()})`);
      });

      it("the original owner can NOT use the proper proof to spend the locked state", async function () {
        const utxo1 = newAssetUTXO(
          lockedUtxo1.tokenId!,
          lockedUtxo1.uri!,
          Alice,
        );
        await expect(
          doTransfer(Charlie, lockedUtxo1, utxo1, Alice),
        ).to.be.rejectedWith("UTXOAlreadyLocked");
      });

      it("the current delegate can move the lock to a new delegate", async function () {
        await expect(
          zeto
            .connect(Alice.signer)
            .delegateLock([lockedUtxo1.hash], Bob.ethAddress, "0x"),
        ).to.be.fulfilled;
      });

      it("the designated delegate can use the proper proof to spend the locked state", async function () {
        const utxo1 = newAssetUTXO(lockedUtxo1.tokenId!, lockedUtxo1.uri!, Bob);
        const { inputCommitment, outputCommitment, encodedProof } =
          await prepareProof(
            circuit,
            provingKey,
            Charlie,
            lockedUtxo1,
            utxo1,
            Bob,
          );
        // Alice (in reality this is usually a contract that orchestrates a trade flow) can spend the locked state
        // using the proof generated by the trade counterparty (Charlie in this case)
        await expect(
          sendTx(Bob, inputCommitment, outputCommitment, encodedProof, true),
        ).to.be.fulfilled;
      });
    });

    describe("lock -> unlock -> spend", function () {
      let lockedUtxo1: UTXO;
      let utxo1: UTXO;

      it("lock() should succeed when using unlocked states", async function () {
        const tokenId = 1001;
        const uri = "http://ipfs.io/file-hash-1";
        const utxo1 = newAssetUTXO(tokenId, uri, Alice);
        await doMint(zeto, deployer, [utxo1]);

        lockedUtxo1 = newAssetUTXO(utxo1.tokenId!, utxo1.uri!, Alice);
        const { inputCommitment, outputCommitment, encodedProof } =
          await prepareProof(
            circuit,
            provingKey,
            Alice,
            utxo1,
            lockedUtxo1,
            Alice,
          );

        await expect(
          zeto
            .connect(Alice.signer)
            .lock(
              inputCommitment,
              outputCommitment,
              encodeToBytes(encodedProof),
              Bob.ethAddress,
              "0x",
            ),
        ).to.be.fulfilled;
      });

      it("unlock() should succeed when using locked states", async function () {
        utxo1 = newAssetUTXO(lockedUtxo1.tokenId!, lockedUtxo1.uri!, Alice);
        const { inputCommitment, outputCommitment, encodedProof } =
          await prepareProof(
            circuit,
            provingKey,
            Alice,
            lockedUtxo1,
            utxo1,
            Alice,
          );

        // Bob as the current delegate can unlock the state
        await expect(
          zeto
            .connect(Bob.signer)
            .unlock(inputCommitment, outputCommitment, encodeToBytes(encodedProof), "0x"),
        ).to.be.fulfilled;
      });

      it("current owner can spend an unlocked UTXO as usual", async function () {
        const utxo2 = newAssetUTXO(utxo1.tokenId!, utxo1.uri!, Bob);
        await expect(doTransfer(Alice, utxo1, utxo2, Bob)).to.be.fulfilled;
      });
    });
  });

  async function doTransfer(signer: User, input: UTXO, output: UTXO, to: User) {
    let inputCommitment: BigNumberish;
    let outputCommitment: BigNumberish;
    let outputOwnerAddress: AddressLike;
    let encodedProof: any;
    const result = await prepareProof(
      circuit,
      provingKey,
      signer,
      input,
      output,
      to,
    );
    inputCommitment = result.inputCommitment;
    outputCommitment = result.outputCommitment;
    outputOwnerAddress = to.ethAddress as AddressLike;
    encodedProof = result.encodedProof;

    await sendTx(signer, inputCommitment, outputCommitment, encodedProof);
  }

  async function sendTx(
    signer: User,
    inputCommitment: BigNumberish,
    outputCommitment: BigNumberish,
    encodedProof: any,
    isLocked = false,
  ) {
    let tx;
    const proof = encodeToBytes(encodedProof);
    if (isLocked) {
      tx = await zeto
        .connect(signer.signer)
        .transferLocked(inputCommitment, outputCommitment, proof, "0x");
    } else {
      tx = await zeto
        .connect(signer.signer)
        .transfer(inputCommitment, outputCommitment, proof, "0x");
    }
    const results = await tx.wait();
    console.log(`Method transfer() complete. Gas used: ${results?.gasUsed}`);

    expect(await zeto.spent(inputCommitment)).to.equal(true);
    expect(await zeto.spent(outputCommitment)).to.equal(false);
  }
});

async function prepareProof(
  circuit: any,
  provingKey: any,
  signer: User,
  input: UTXO,
  output: UTXO,
  to: User,
) {
  const tokenId = input.tokenId;
  const inputCommitment: BigNumberish = input.hash as BigNumberish;
  const inputSalt = input.salt;
  const outputCommitment: BigNumberish = output.hash as BigNumberish;
  const outputOwnerPublicKey: [BigNumberish, BigNumberish] =
    to.babyJubPublicKey as [BigNumberish, BigNumberish];
  const otherInputs = stringifyBigInts({
    inputOwnerPrivateKey: formatPrivKeyForBabyJub(signer.babyJubPrivateKey),
  });

  const startWitnessCalculation = Date.now();
  const witness = await circuit.calculateWTNSBin(
    {
      tokenIds: [tokenId],
      tokenUris: [tokenUriHash(input.uri)],
      inputCommitments: [inputCommitment],
      inputSalts: [inputSalt],
      outputCommitments: [outputCommitment],
      outputSalts: [output.salt],
      outputOwnerPublicKeys: [outputOwnerPublicKey],
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
    inputCommitment,
    outputCommitment,
    encodedProof,
  };
}

function encodeToBytes(proof: any) {
  return new AbiCoder().encode(["tuple(uint256[2] pA, uint256[2][2] pB, uint256[2] pC)"], [proof]);
}

module.exports = {
  prepareProof,
};
