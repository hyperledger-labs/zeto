# Sample Implementations of Zeto base Privacy Preserving Tokens

This project contains sample implementations of privacy preserving tokens for both fungible and non-fungible assets, using the Zeto toolkit.

# Prerequisites

The Hardhat test cases make use of the `zeto-js` library, which must be built first. Refer to the steps in [the library's README](/zkp/js/README.md) to build the proving keys, and verification keys. Make sure you can successfully run the unit tests for the zeto-js library, before returning back here to continue with the hardhat tests for the Solidity implementation.

# Run The Hardhat Tests

Once the above pre-reqs are complete, you can proceed to run the hardhat tests in this project.

```console
npm i
npm t

> zeto@0.0.1 test
> npx hardhat test



  Registry tests
Registry deployed to 0x5FbDB2315678afecb367f032d93F642f64180aa3
    ✔ should register a new user (43ms)
    ✔ should return the correct public key

  Zeto based fungible token with anonymity without encryption or nullifier
Method mint() complete. Gas used: 75301
Witness calculation time: 38ms, Proof generation time: 334ms
Method transfer() complete. Gas used: 336231
    ✔ mint to Alice and transfer UTXOs honestly to Bob should succeed (395ms)
Method mint() complete. Gas used: 50947
Witness calculation time: 19ms, Proof generation time: 179ms
Method transfer() complete. Gas used: 336337
    ✔ Bob transfers UTXOs, previously received from Alice, honestly to Charlie should succeed (215ms)
    ✔ mint existing unspent UTXOs should fail
    ✔ mint existing spent UTXOs should fail
Witness calculation time: 20ms, Proof generation time: 178ms
    ✔ transfer non-existing UTXOs should fail (207ms)
Witness calculation time: 20ms, Proof generation time: 181ms
    ✔ transfer spent UTXOs should fail (double spend protection) (210ms)
Witness calculation time: 19ms, Proof generation time: 193ms
    ✔ spend by using the same UTXO as both inputs should fail (222ms)

  Zeto based fungible token with anonymity and encryption
Method mint() complete. Gas used: 75301
Witness calculation time: 52ms, Proof generation time: 359ms
Method transfer() complete. Gas used: 362628
    ✔ mint to Alice and transfer UTXOs honestly to Bob should succeed (449ms)
Witness calculation time: 33ms, Proof generation time: 336ms
Method transfer() complete. Gas used: 355662
    ✔ Bob transfers UTXOs, previously received from Alice, honestly to Charlie should succeed (383ms)
    ✔ mint existing unspent UTXOs should fail
    ✔ mint existing spent UTXOs should fail
Witness calculation time: 32ms, Proof generation time: 334ms
    ✔ transfer non-existing UTXOs should fail (376ms)
Witness calculation time: 33ms, Proof generation time: 378ms
    ✔ transfer spent UTXOs should fail (double spend protection) (421ms)
Method mint() complete. Gas used: 50959
Witness calculation time: 33ms, Proof generation time: 341ms
    ✔ spend by using the same UTXO as both inputs should fail (385ms)

  Zeto based fungible token with anonymity using nullifiers and encryption
    ✔ onchain SMT root should be equal to the offchain SMT root
Method mint() complete. Gas used: 823254
Witness calculation time: 118ms. Proof generation time: 2288ms.
Time to execute transaction: 40ms. Gas used: 1763072
    ✔ mint to Alice and transfer UTXOs honestly to Bob should succeed (2491ms)
Witness calculation time: 80ms. Proof generation time: 2235ms.
Time to execute transaction: 28ms. Gas used: 1677252
    ✔ Bob transfers UTXOs, previously received from Alice, honestly to Charlie should succeed (2351ms)
    ✔ mint existing unspent UTXOs should fail
    ✔ mint existing spent UTXOs should fail
Witness calculation time: 77ms. Proof generation time: 2345ms.
    ✔ transfer spent UTXOs should fail (double spend protection) (2435ms)
Method mint() complete. Gas used: 878936
Witness calculation time: 78ms. Proof generation time: 2248ms.
    ✔ transfer with existing UTXOs in the output should fail (mass conservation protection) (2362ms)
Witness calculation time: 77ms. Proof generation time: 2292ms.
    ✔ spend by using the same UTXO as both inputs should fail (2381ms)
Witness calculation time: 78ms. Proof generation time: 2324ms.
    ✔ transfer non-existing UTXOs should fail (2454ms)

  Zeto based fungible token with anonymity using nullifiers without encryption
    ✔ onchain SMT root should be equal to the offchain SMT root
Method mint() complete. Gas used: 906173
Witness calculation time: 105ms. Proof generation time: 2151ms.
Time to execute transaction: 30ms. Gas used: 1737824
    ✔ mint to Alice and transfer UTXOs honestly to Bob should succeed (2312ms)
Witness calculation time: 63ms. Proof generation time: 2137ms.
Time to execute transaction: 33ms. Gas used: 2025451
    ✔ Bob transfers UTXOs, previously received from Alice, honestly to Charlie should succeed (2245ms)
    ✔ mint existing unspent UTXOs should fail
    ✔ mint existing spent UTXOs should fail
Witness calculation time: 64ms. Proof generation time: 2181ms.
    ✔ transfer spent UTXOs should fail (double spend protection) (2256ms)
Method mint() complete. Gas used: 941948
Witness calculation time: 64ms. Proof generation time: 2171ms.
    ✔ transfer with existing UTXOs in the output should fail (mass conservation protection) (2272ms)
Witness calculation time: 64ms. Proof generation time: 2128ms.
    ✔ spend by using the same UTXO as both inputs should fail (2202ms)
Witness calculation time: 63ms. Proof generation time: 2183ms.
    ✔ transfer non-existing UTXOs should fail (2294ms)

  Zeto based non-fungible token with anonymity without encryption or nullifiers
Method mint() complete. Gas used: 50959
Witness calculation time: 39ms, Proof generation time: 116ms
Method transfer() complete. Gas used: 288112
    ✔ mint to Alice and transfer UTXOs honestly to Bob should succeed (170ms)
Witness calculation time: 19ms, Proof generation time: 120ms
Method transfer() complete. Gas used: 288136
    ✔ Bob transfers UTXOs, previously received from Alice, honestly to Charlie should succeed (152ms)
    ✔ mint existing unspent UTXOs should fail
    ✔ mint existing spent UTXOs should fail
Witness calculation time: 19ms, Proof generation time: 150ms
    ✔ transfer non-existing UTXOs should fail (179ms)
Witness calculation time: 18ms, Proof generation time: 115ms
    ✔ transfer spent UTXOs should fail (double spend protection) (141ms)

  Zeto based non-fungible token with anonymity using nullifiers without encryption
    ✔ onchain SMT root should be equal to the offchain SMT root
Method mint() complete. Gas used: 338260
Witness calculation time: 84ms. Proof generation time: 1137ms.
Time to execute transaction: 17ms. Gas used: 796127
    ✔ mint to Alice and transfer UTXOs honestly to Bob should succeed (1250ms)
Witness calculation time: 46ms. Proof generation time: 1172ms.
Time to execute transaction: 19ms. Gas used: 909983
    ✔ Bob transfers UTXOs, previously received from Alice, honestly to Charlie should succeed (1243ms)
    ✔ mint existing unspent UTXOs should fail
    ✔ mint existing spent UTXOs should fail
Witness calculation time: 41ms. Proof generation time: 1146ms.
    ✔ transfer spent UTXOs should fail (double spend protection) (1196ms)
Witness calculation time: 38ms. Proof generation time: 1163ms.
    ✔ transfer non-existing UTXOs should fail (1229ms)

  DvP flows between fungible and non-fungible tokens based on Zeto with anonymity without encryption or nullifiers
ZK Asset contract deployed at 0xf4B146FbA71F41E0592668ffbF264F1D186b2Ca8
ZK Payment contract deployed at 0xBEc49fA140aCaA83533fB00A2BB19bDdd0290f25
Method mint() complete. Gas used: 75289
    ✔ mint to Alice some payment tokens
Method mint() complete. Gas used: 75277
    ✔ mint to Bob some asset tokens
    ✔ Initiating a DvP transaction without payment input or asset input should fail
    ✔ Initiating a DvP transaction with payment input but no payment output should fail
    ✔ Initiating a DvP transaction with payment inputs and asset inputs should fail
    ✔ Initiating a DvP transaction with asset input but no asset output should fail
    ✔ Initiating a successful DvP transaction with payment inputs
    ✔ Initiating a successful DvP transaction with asset inputs
    ✔ Accepting a trade using an invalid trade ID should fail
    ✔ Failing cases for accepting a trade with payment terms
    ✔ Failing cases for accepting a trade with asset terms
Method mint() complete. Gas used: 50959
Method mint() complete. Gas used: 50959
Witness calculation time: 36ms, Proof generation time: 183ms
Witness calculation time: 38ms, Proof generation time: 121ms
    ✔ Initiating a successful DvP transaction with payment inputs and accepting by specifying asset inputs (421ms)


  59 passing (41s)
```
