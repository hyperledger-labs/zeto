import { ethers, ignition, network } from "hardhat";
import { Signer, encodeBytes32String, ZeroHash, lock, Contract } from "ethers";
import smtModule from "../../ignition/modules/test/smt";

describe("smt tests", function () {
  let deployer: Signer;
  let smt: any;

  before(async function () {
    let [d] = await ethers.getSigners();
    deployer = d;

    const { testSmt } = await ignition.deploy(smtModule);
    console.log(`TestSmt contract deployed at ${testSmt.target}`);
    smt = testSmt as Contract;
  });

  it("should insert a leaf: i=1, v=1", async function () {
    await smt.insert(1n, 1n);
    const root = await smt.root();
    console.log(`root: ${root}`);
  });

  it("should retrieve a leaf: i=1", async function () {
    const result = await smt.get(1n, 1n);
    console.log("node: ", result);
  });

  it("should insert a leaf: i=1, v=2", async function () {
    await smt.insert(1n, 2n);
    const root = await smt.root();
    console.log(`root: ${root}`);
  });

  it("should retrieve a leaf: i=1", async function () {
    const result1 = await smt.get(1n, 1n);
    console.log("node (1, 1): ", result1);
    const result2 = await smt.get(1n, 2n);
    console.log("node (1, 2): ", result2);
  });

  it("should retrieve a proof: i=1", async function () {
    const proof = await smt.getProof(1n);
    console.log(
      `proof: ${proof} (existence: ${proof.existence}, value: ${proof.value})`,
    );
  });

  it("should retrieve a proof: i=2", async function () {
    const proof = await smt.getProof(2n);
    console.log(
      `proof: ${proof} (existence: ${proof.existence}, value: ${proof.value})`,
    );
  });
});
