# Zeto - UTXO based privacy-preserving token toolkit using Zero Knowledge Proofs

This project hosts the multiple patterns to implement privacy preserving tokens on EVM.

Refer to the [Zeto documentation](https://hyperledger-labs.github.io/zeto) for details.

# Sub-projects

There are 4 sub-projects. Navigate to each sub-project to run the tests and learn how to use each library:

- [Solidity samples of Zeto token implementations](./solidity/): Sample Solidity contracts for all the ZKP based Zeto privacy patterns
- [ZKP circuits](./zkp/circuits/): ZKP circuits written in circom to support the Zeto privacy patterns
- [golang sdk](./go-sdk/): the ability to interact with Zeto tokens in golang, including a Sparse Merkle Tree implementation, Babyjubjub key manipulations, and proof generations using the WASM modules compiled from circom circuits
- [javascript library for proof generation](./zkp/js/): unit test cases written in javascript
