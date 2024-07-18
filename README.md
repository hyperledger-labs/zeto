# Zeto, a UTXO based privacy-preserving token toolkit using Zero Knowledge Proofs

This project hosts the multiple patterns to implement privacy preserving tokens on EVM. The patterns all share the same basic architectural concepts:

- **Transaction model**: the UTXO model is adopted instead of the account model, for better support of parallel processing. Due to the necessity of maintaining private states offchain in order to achieve privacy, the client must continuously keep their private states in sync with the smart contract. Using an account model makes it more difficult to achieve this because incoming transfers from other parties would invalidate an account's state, making the account owner unable to spend from its account unless the private state has been sync'ed again. Solutions to this issue, often referred to as front-running, typically involve a spending window with a pending queue, which result in limited parallel processing of transactions from the same spending account. With a UTXO model, each state is independent of the others, so parallel processing is better achieved.
- **Commitments**: each UTXO is tracked by the smart contract as a hash, or commitment, of the following components: value, salt and owner public key
- **Finality**: each transaction's validity is verified by the smart contract before allowing the proposed input UTXOs to be nullified and the output UTXOs to come into existence. In other words, this is not an optimistic design and as such does not rely on a multi-day challenge period before a transaction is finalized. Every transaction is immediately finalized once it's mined into a block.

# Enforcing token transfer policies with zero knowledge proofs

The various patterns in this project use Zero Knowledge Proofs (ZKP) to demonstrate the validity of the proposed transaction. There is no centralized party to trust as in the [Notary pattern](#enforce-token-transfer-policies-with-a-notary), which is not implemented in this project but discussed briefly below.

Using ZKPs as validity proofs, each participant can independently submit transactions to the smart contract directly. As long as the participant is able to produce a valid proof, the transaction will be successfully verified and allowed to go through.

This project includes multiple ZKP circuits to support various privacy levels with Zeto, as listed below.

Performing key pair operations, such as deriving the public key from the private key, in the ZKP circuit requires using ZKP-friendly curves, for which we picked Babyjubjub instead of the regular Ethereum curve (secp256k1).

## Confidential payload with anonymity, without encrypted values, without history masking

This is the simplest version of the ZKP circuit. Because the secrets required to open the commitment hashes, namely the output UTXO value and salt, are NOT encrypted and published as part of the transaction payload, using this version requires the secrets to be transmitted from the sender to the receiver in off-chain channels.

The statements in the proof include:

- each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
- the sum of the input values match the sum of output values
- the hashes in the input and output match the `hash(value, salt, owner public key)` formula
- the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes

There is no history masking, meaning the associations between the consumed input UTXOs and the output UTXOs are in the clear.

![Confidential payload without encryption or history masking](/resources/c-utxo-zkp-1.jpg)

## Confidential payload with anonymity, with encrypted values, without history masking

This verison of the ZKP circuit adds encryption that makes it possible to provide data availability onchain. The circuit uses the sender's private key and the receiver's public key to generate a shared secret with ECDH, which guarantees that the receiver will be able to decrypt the values. The encrypted values include the value and salt of the output UTXO for the receiver. With these values the receiver is guaranteed to be able to spend the UTXO sent to them.

The statements in the proof include:

- each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
- the sum of the input values match the sum of output values
- the hashes in the input and output match the hash(value, salt, owner public key) formula
- the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes
- the encrypted value in the input is derived from the receiver's UTXO value and encrypted with a shared secret using the ECDH protocol between the sender and receiver (this guarantees data availability for the receiver)

There is no history masking, meaning the association between the consumed input UTXOs and the output UTXOs are in the clear.

![Confidential payload with encryption but no history masking](/resources/c-utxo-zkp-2.jpg)

## Confidential payload with anonymity, with encrypted values and history masking

To mask the association between the consumed UTXOs and the output UTXOs, we hide which UTXOs are being consumed by each transaction.

To achieve this, we employ the usage of `nullifiers`. It's a unique hash derived from the unique commitment it consumes. For a UTXO commitment `hash(value, salt, owner public key)`, the nullifier is calculated as `hash(value, salt, owner private key)`. Only the owner of the commitment can generate the nullifier hash. Each transaction will record the nullifiers in the smart contract, to ensure that they don't get re-used (double spending).

In order to prove that the UTXOs to be spent actually exist, we use a markle tree proof inside the zero knowledge proof circuit. The merkle proof is validated against a merkle tree root that is maintained by the smart contract. The smart contract keeps track of the new UTXOs in each transaction's output commitments array, and uses a merkle tree to calculate the root hash. Then the ZKP circuit can use a root hash as public input, to prove that the input commitments (UTXOs to be spent), which are private inputs to the circuit, are included in the merkle tree represented by the root.

The statements in the proof include:

- each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
- the sum of the nullified values match the sum of output values
- the hashes in the input and output match the hash(value, salt, owner public key) formula
- the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes, which match the corresponding nullifiers
- the encrypted value in the input is derived from the receiver's UTXO value and encrypted with a shared secret using the ECDH protocol between the sender and receiver (this guarantees data availability for the receiver)
- the nullifiers represent input commitments that are included in a Sparse Merkle Tree represented by the root hash

![Confidential payload with encryption and history masking](/resources/c-utxo-zkp-3.jpg)

# Enforce token transfer policies with a Notary

This pattern relies on a central party, called "Notary", that has access to the private states of all the parties in the system. This knowledge allows the Notary to check the validity of a proposed transaction, and enforce dynamic policies that would otherwise be difficult with some of the other approaches. Every transaction must be accompanied by a "notary certificate" that approve the proposed transaction. The certificate will be verified by the smart contract before allowing the transaction to go through.

The project does not include an implementation of a notary based token transfer policy enforcement.

![Confidential payload with Notary](/resources/c-utxo-notary.jpg)

# Sub-projects

There are 4 sub-projects. Navigate to each sub-project to run the tests and learn how to use each library:

- [ZKP circuits](./zkp/circuits/): ZKP circuits written in circom to support the Zeto privacy patterns
- [golang library for proof generation](./zkp/golang/): test cases written in golang
- [javascript library for proof generation](./zkp/js/): test cases written in javascript
- [Solidity library for onchain proof verification](./solidity/): Sample Solidity contracts for all the ZKP based Zeto privacy patterns
