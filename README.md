# Zeto - UTXO based privacy-preserving token toolkit using Zero Knowledge Proofs

This project hosts the multiple patterns to implement privacy preserving tokens on EVM. The patterns all share the same basic architectural concepts:

- **Transaction model**: the UTXO model is adopted instead of the account model, for better support of parallel processing. Due to the necessity of maintaining private states offchain in order to achieve privacy, the client must continuously keep their private states in sync with the smart contract. Using an account model makes it more difficult to achieve this because incoming transfers from other parties would invalidate an account's state, making the account owner unable to spend from its account unless the private state has been sync'ed again. Solutions to this issue, often referred to as front-running, typically involve a spending window with a pending queue, which result in limited parallel processing of transactions from the same spending account. With a UTXO model, each state is independent of the others, so parallel processing is better achieved.
- **Commitments**: each UTXO is tracked by the smart contract as a hash, or commitment, of the following components: value, salt and owner public key
- **Finality**: each transaction's validity is verified by the smart contract before allowing the proposed input UTXOs to be nullified and the output UTXOs to come into existence. In other words, this is not an optimistic design and as such does not rely on a multi-day challenge period before a transaction is finalized. Every transaction is immediately finalized once it's mined into a block.

# Overview of how Zeto tokens work

The following diagram illustrates the basics of Zeto tokens.

![Zeto token basics](/resources/c-utxo-zkp-1.jpg)

- Party A owns 3 Zeto tokens at the beginning: `#1, #2, #3`. The 3 tokens have been minted in the Zeto smart contract and represented by their commitments, or `hash(value, owner public key, salt)`
  - As the owner of the tokens, party A also has access to the secrets that the commitments can be opened to, namely the value and salt. The secrets are represented as private states: `s1, s2, s3`
  - How party A obtained the secrets for the owned tokens, is dependent on the specific Zeto implementation. It can be from offchain channels or from onchain (encrypted) data
- Party A sends transaction `Tx1` to transfer some value to party B. The transaction consumes 2 tokens (`#1, #2`) and produces 2 new tokens (`#4, #5`). `#5` is the value to be transferred to party B. `#4` is the remainder value that goes back to party A
  - Even though party A knows the secrets of `#5`, they won't be able to spend the token because party A is not the owner of the token. Ownership verification is enforced by the Zeto smart contract when it verifies the zero knowledge proofs. Each ZKP circuit ensures that the sender's private key is used as a private input signal to derive the public key, which is then hashed to calculate the commitments
- Party B sends transaction `Tx2` to transfer some value to party C. This works the same as `Tx1`
- All parties get the commitments, `#1, #2, ... #7`, from the onchain events

The above diagram illustrates that the secrets are transmitted from the sender to the receiver in an off-chain secure channel. Other means of sharing the secrets are avaiable in Zeto token implementations. For instance, the [Zeto_AnonEnc](./solidity/contracts/zeto_anon_enc.sol) implementation includes encrypted secrets in the transaction input, and emits an event with the encrypted values. The encrypted values can only be decrypted by the receiver.

# Zeto fungible and non-fungible token implementations

The various patterns in this project use Zero Knowledge Proofs (ZKP) to demonstrate the validity of the proposed transaction. There is no centralized party to trust as in the [Notary pattern](#enforce-token-transfer-policies-with-a-notary), which is not implemented in this project but discussed briefly below.

Using ZKPs as validity proofs, each participant can independently submit transactions to the smart contract directly. As long as the participant is able to produce a valid proof, the transaction will be successfully verified and allowed to go through.

This project includes multiple ZKP circuits to support various privacy levels with Zeto, as listed below.

Performing key pair operations, such as deriving the public key from the private key, in the ZKP circuit requires using ZKP-friendly curves, for which we picked Babyjubjub instead of the regular Ethereum curve (secp256k1).

Another implication to the usage of ZKPs as transaction validity proof and the usage of the Babyjubjub curve, is that the signer of the transaction, eg. `msg.sender`, no longer bears the same significance as in other token implementations such as ERC20, ERC721, where the signer's EVM account address holds the actual assets. In Zeto tokens, it's the Babyjubjub public keys that hold the entitlement to spend the tokens. In fact, the applications are encouraged to use a different signing key for each transaction, to avoid leaking transaction behaviors and breaking anonymity.

## Zeto_Anon

This is the simplest version of the ZKP circuit. Because the secrets required to open the commitment hashes, namely the output UTXO value and salt, are NOT encrypted and published as part of the transaction payload, using this version requires the secrets to be transmitted from the sender to the receiver in off-chain channels.

The statements in the proof include:

- each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
- the sum of the input values match the sum of output values
- the hashes in the input and output match the `hash(value, salt, owner public key)` formula
- the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes

There is no history masking, meaning the associations between the consumed input UTXOs and the output UTXOs are in the clear.

## Zeto_AnonEnc

This verison of the ZKP circuit adds encryption that makes it possible to provide data availability onchain. The circuit uses the sender's private key and the receiver's public key to generate a shared secret with ECDH, which guarantees that the receiver will be able to decrypt the values. The encrypted values include the value and salt of the output UTXO for the receiver. With these values the receiver is guaranteed to be able to spend the UTXO sent to them.

The statements in the proof include:

- each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
- the sum of the input values match the sum of output values
- the hashes in the input and output match the hash(value, salt, owner public key) formula
- the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes
- the encrypted values in the transaction are derived from the receiver's UTXO value and encrypted with a shared secret using the ECDH protocol between a random private key and the receiver (this guarantees data availability for the receiver, because the public key for the random private key used by the sender is published in the transaction)

There is no history masking, meaning the association between the consumed input UTXOs and the output UTXOs are in the clear.

## Zeto_AnonNullifier

To mask the association between the consumed UTXOs and the output UTXOs, we hide which UTXOs are being consumed by each transaction.

To achieve this, we employ the usage of `nullifiers`. It's a unique hash derived from the unique commitment it consumes. For a UTXO commitment `hash(value, salt, owner public key)`, the nullifier is calculated as `hash(value, salt, owner private key)`. Only the owner of the commitment can generate the nullifier hash. Each transaction will record the nullifiers in the smart contract, to ensure that they don't get re-used (double spending).

In order to prove that the UTXOs to be spent actually exist, we use a markle tree proof inside the zero knowledge proof circuit. The merkle proof is validated against a merkle tree root that is maintained by the smart contract. The smart contract keeps track of all the new UTXOs in each transaction's output commitments array, and uses a merkle tree to calculate the root hash. Then the ZKP circuit can use a root hash as public input, to prove that the input commitments (UTXOs to be spent), which are private inputs to the circuit, are included in the merkle tree represented by the root.

The end result is that, from the onchain data, no one can figure out which UTXOs have been spent, while double spending is prevented.

The statements in the proof include:

- each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
- the sum of the nullified values match the sum of output values
- the hashes in the output match the hash(value, salt, owner public key) formula
- the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes, which match the corresponding nullifiers
- the nullifiers represent input commitments that are included in a Sparse Merkle Tree represented by the root hash

![History masking with nullifiers](/resources/c-utxo-zkp-2.jpg)

## Zeto_AnonNullifierKyc

The concept of "KYC with privacy" is introduced in this implementation pattern.

How to enforce a policy of "all senders and receivers of a transaction must be in a KYC registry", while maintaining anomymity of the sender and the receiver? The solution is similar to how nullifiers are supported, via merkle tree proofs.

The implementation of this pattern maintains a `KYC registry` in the smart contract as a Sparse Merkle Tree. The registry is maintained by a designated authority, and includes the public keys of entities that have cleared the KYC process. Each transaction must demonstrate that the public keys of the sender and the receivers are included in the KYC merkle tree, by generating a merkle proof and using it as a private input to the ZKP circuit.

The statements in the proof include:

- each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
- the sum of the nullified values match the sum of output values
- the hashes in the output match the hash(value, salt, owner public key) formula
- the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes, which match the corresponding nullifiers
- the nullifiers represent input commitments that are included in a Sparse Merkle Tree represented by the root hash
- the sender and receiver public keys are included in the Sparse Merkle Tree for the KYC registry, represented by the latest root hash known to the smart contract

## Zeto_AnonEncNullifier

This implementation adds encryption, as described in the section above for Zeto_AnonEnc, to the pattern Zeto_AnonNullifierKyc above.

The statements in the proof include:

- each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
- the sum of the nullified values match the sum of output values
- the hashes in the output match the hash(value, salt, owner public key) formula
- the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes, which match the corresponding nullifiers
- the nullifiers represent input commitments that are included in a Sparse Merkle Tree represented by the root hash
- the encrypted values in the transaction are derived from the receiver's UTXO value and encrypted with a shared secret using the ECDH protocol between a random private key and the receiver (this guarantees data availability for the receiver, because the public key for the random private key used by the sender is published in the transaction)

## Zeto_AnonEncNullifierKyc

This implementation adds encryption, as described in the section above for Zeto_AnonEnc, to the pattern above.

The statements in the proof include:

- each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
- the sum of the nullified values match the sum of output values
- the hashes in the output match the hash(value, salt, owner public key) formula
- the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes, which match the corresponding nullifiers
- the nullifiers represent input commitments that are included in a Sparse Merkle Tree represented by the root hash
- the sender and receiver public keys are included in the Sparse Merkle Tree for the KYC registry, represented by the latest root hash known to the smart contract
- the encrypted values in the transaction are derived from the receiver's UTXO value and encrypted with a shared secret using the ECDH protocol between a random private key and the receiver (this guarantees data availability for the receiver, because the public key for the random private key used by the sender is published in the transaction)

## Zeto_AnonEncNullifierNonRepudiation

The concept of "non-repudiation" is introduced in this implementation pattern.

Since all onchain states are hashes, with ownership information for the assets hidden, it's possible that a participant can send a transaction but subsequently deny it. Because the transaction signer account no longer reflects the identity of the asset owner, as discussed above, it will be impossible to know who was the sender of a transaction from purely looking at the onchain data, which is exactly the point for Zeto's anonymity support. This gives a malicious party the ability to gain repudiation, or deny that they were responsible for a past transaction.

This implementation pattern addresses that concern by encrypting the ownership information of each UTXO involved in a transaction with an authority's registered key. Only the designated authority will be able to decrypt the ownership information. The encryption is performed inside the ZKP circuit, thus guaranteeing that they are the actual owners of the UTXOs.

The statements in the proof include:

- each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
- the sum of the nullified values match the sum of output values
- the hashes in the output match the hash(value, salt, owner public key) formula
- the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes, which match the corresponding nullifiers
- the nullifiers represent input commitments that are included in a Sparse Merkle Tree represented by the root hash
- the encrypted values in the transaction contains cipher texts derived from the receiver's UTXO values and encrypted with a shared secret using the ECDH protocol between a random private key and the receiver (this guarantees data availability for the receiver, because the public key for the random private key used by the sender is published in the transaction)
- the encrypted values in the transaction contains cipher texts derived from the receiver's UTXO values and encrypted with a shared secret using the ECDH protocol between a random private key and the authority

## Zeto_NfAnon

This implements a basic non-fungible token.

For non-fungible tokens, the main concern with the transaction validity check is that the output UTXO contains the same secrets (id, uri) as the input UTXO, with only the ownership updated.

The statements in the proof include:

- the output UTXO hashes are based on the same `id, uri` as the input UTXO hashes
- the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes

## Zeto_NfAnonNullifier

This implements a non-fungible token using nullifiers, thus hiding the spending graph.

The statements in the proof include:

- the output UTXO hashes are based on the same `id, uri` as the input UTXO hashes
- the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes, which match the corresponding nullifiers
- the nullifiers represent input commitments that are included in a Sparse Merkle Tree represented by the root hash

# Enforce token transfer policies with a Notary

This pattern relies on a central party, called "Notary", that has access to the private states of all the parties in the system. This knowledge allows the Notary to check the validity of a proposed transaction, and enforce dynamic policies that would otherwise be difficult with some of the other approaches. Every transaction must be accompanied by a "notary certificate" that approve the proposed transaction. The certificate will be verified by the smart contract before allowing the transaction to go through.

The project does not include an implementation of a notary based token transfer policy enforcement.

# Sub-projects

There are 4 sub-projects. Navigate to each sub-project to run the tests and learn how to use each library:

- [Solidity samples of Zeto token implementations](./solidity/): Sample Solidity contracts for all the ZKP based Zeto privacy patterns
- [ZKP circuits](./zkp/circuits/): ZKP circuits written in circom to support the Zeto privacy patterns
- [golang sdk](./go-sdk/): the ability to interact with Zeto tokens in golang, including a Sparse Merkle Tree implementation, Babyjubjub key manipulations, and proof generations using the WASM modules compiled from circom circuits
- [javascript library for proof generation](./zkp/js/): unit test cases written in javascript
