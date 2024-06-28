# Confidential UTXO using Zero Knowledge Proofs

This project hosts the multiple patterns to implement privacy preserving tokens on EVM. The patterns all share the same basic architectural concepts:

- **Transaction model**: the UTXO model is adopted instead of the account model, for better support of parallel processing. Due to the necessity of maintaining private states offchain in order to achieve privacy, the client must continuously keep their private states in sync with the smart contract. Using an account model makes it more difficult to achieve this because incoming transfers from other parties would invalidate an account's state, making the account owner unable to spend from its account unless the private state has been sync'ed again. Solutions to this issue, often referred to as front-running, typically involve a spending window with a pending queue, which result in limited parallel processing of transactions from the same spending account. With a UTXO model, each state is independent of the others, so parallel processing is better achieved.
- **Commitments**: each UTXO is tracked by the smart contract as a hash, or commitment, of the following components: value, salt and owner public key
- **Finality**: each transaction's validity is verified by the smart contract before allowing the proposed input UTXOs to be nullified and the output UTXOs to come into existence. In other words, this is not an optimistic design and as such does not rely on a multi-day challenge period before a transaction is finalize. Every transaction is immediately finalized once it's mined into a block.

# Enforcing token transfer policies with zero knowledge proofs

The various patterns in this project use Zero Knowledge Proofs (ZKP) to demonstrate the validity of the proposed transaction. There is no centralized parties to trust as is the case with the [Notary pattern](#enforce-token-transfer-policies-with-a-notary), which is not implemented in this project but discussed briefly below.

Using ZKPs as validity proofs, each participant can independently submit transactions to the smart contract directly. As long as the participant is able to produce a valid proof, the transaction will be successfully verified and allowed to go through.

This project will host multiple ZKP circuits to support various privacy levels with Confidential UTXO, as listed below.

Performing key pair operations, such as deriving the public key from the private key, in the ZKP circuit requires using ZKP-friendly curves, for which we picked Babyjubjub instead of the regular Ethereum curve (secp256k1).

## Confidential payload with anonymity, without encrypted values, without history masking

This is the simplest version of the ZKP circuit. Because the secrets required to open the commitment hashes, namely the output UTXO value and salt, are NOT encrypted and published as part of the transaction payload, using this version requires the secrets to be transmitted from the sender to the receiver in off-chain channels.

The statements in the proof include:

- each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
- the sum of the input values match the sum of output values
- the hashes in the input and output match the `hash(value, salt, owner public key)` formula
- the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes

There is no history masking, meaning the associations between the consumed input UTXOs and the output UTXOs are in the clear.

![Confidential UTXO without encryption or history masking](/resources/c-utxo-zkp-1.jpg)

## Confidential payload with anonymity, with encrypted values, without history masking

This verison of the ZKP circuit adds encryption that makes it possible to provide data availability onchain. The circuit uses the sender's private key and the receiver's public key to generate a shared secret with ECDH, which guarantees that the receiver will be able to decrypt the values. The encrypted values include the value and salt of the output UTXO for the receiver. With these values the receiver is guaranteed to be able to spend the UTXO sent to them.

The statements in the proof include:

- each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
- the sum of the input values match the sum of output values
- the hashes in the input and output match the hash(value, salt, owner public key) formula
- the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes
- the encrypted value in the input is derived from the receiver's UTXO value and encrypted with a shared secret using the ECDH protocol between the sender and receiver (this guarantees data availability for the receiver)

There is no history masking, meaning the association between the consumed input UTXOs and the output UTXOs are in the clear.

![Confidential UTXO with encryption but no history masking](/resources/c-utxo-zkp-2.jpg)

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

![Confidential UTXO with encryption and history masking](/resources/c-utxo-zkp-3.jpg)

In particular, two types of merkle trees can be used, depending on the requirement to protect against [total supply reduction](#total-supply-reduction) or not.

### Total Supply Reduction (TSR)

This refers to the scenario where existing UTXOs are re-used as part of the output UTXOs array, such that where new value is supposed to be created, existing UTXOs are re-used. The net impact is that the receiver has not received net new value. Consider the following scenario:

1. Alice has 1,000 tokens. Bob has 500. The total supply of tokens is 50,000
2. Alice proposed the following transaction, to transfer 250 tokens to Bob:

```
inputs: utxo1(100, salt1, Alice), utxo2(200, salt2, Alice)
outputs: utxo3(250, salt3, Bob), utxo4(50, salt4, Alice)
```

3. since it's an honest transaction, it's successfully processed by the smart contract and Bob got the 250 tokens as expected

- Alice now has 750, Bob has 750. The total supply is still 50,000

4. So far so good
5. Alice proposed the following transaction, pretending to send Bob another 250:

```
inputs: utxo5(100, salt5, Alice), utxo6(200, salt6, Alice)
outputs: utxo3(250, salt3, Bob), utxo7(50, salt4, Alice)
```

6. note that even though the mass-conservation rule is obeyed, because the sum of inputs equals the sum of outputs, because Alice is re-using utxo3 as part of the outputs, Bob did not gain the additional 250 in the end. Essentially 250 tokens are lost in the process.

- Alice now has 500, Bob still has 750. The total supply is reduced to 49,750

It can be argued whether the above is a legitimate attack or not, because in the process Alice has spent her tokens without having transferred them to Bob. Depending on the specific use case, this may or may not be considered an attack to protect against.

### Anonymity circuits with TSR protection

In order to provide protection against TSR, the smart contract needs to checks that the output commitments are not in the existing list of UTXOs. While merkle trees are great for proving membership inclusion ("I am a leaf node in the tree that has this root hash"), they are not great for membership non-inclusion. The smart contract must keep track of all the UTXOs in order to know if the output UTXOs in the transaction proposal are new or not.

Because of the above, we use a merkle tree implementation that maintains the entire list of UTXOs in onchain storage.

### Anonymity circuits without TSR protection

If a business use case does not need TSR protection, then the onchain storage cost can be greatly reduced. This is because an incremental merkle tree (IMT) design can be used for such use cases. An IMT always appends new leaf nodes to the end, or to the right, and only keeps track of the leading edge of the nodes.

```
Insert to a full tree:
       g                          g'
    /     \                    /     \
   e       f                  e       f'
  / \     / \       ==>      / \     / \
 a   b   c   -              a   b   c'  -
/ \ / \ / \ / \            / \ / \ / \ / \
1 2 3 4 5 - - -            1 2 3 4 5 6 - -

    before                      after
```

```
Insert to an Incremental Merkle Tree:
       g                          g'                          g'
    /     \                    /     \                     /     \
   e       f                  e       f'                  e       f'
          /         ==>              / \       ==>               /
         c                          c'  -                       c'
        /                          / \ / \                     / \
        5                          5 6 - -                     5 6

    before                      insert                      after
```

From the above diagrams, it should be clear that using an IMT, the smart contract can always reliably update the tree nodes that are impacted by the newly inserted node, #6 in the example, to arrive at the same root hash as by using a full merkle tree. The storage savings are very significant as the number of leaf nodes continues to grow over time.

Implementation for this approach to be added.

# Enforce token transfer policies with a Notary

This pattern relies on a central party, called "Notary", that has access to the private states of all the parties in the system. This knowledge allows the Notary to check the validity of a proposed transaction, and enforce dynamic policies that would otherwise be difficult with some of the other approaches. Every transaction must be accompanied by a "notary certificate" that approve the proposed transaction. The certificate will be verified by the smart contract before allowing the transaction to go through.

The project does not include an implementation of a notary based token transfer policy enforcement.

![Confidential UTXO with Notary](/resources/c-utxo-notary.jpg)

# Sub-projects

There are 4 sub-projects. Navigate to each sub-project to run the tests and learn how to use each library:

- [Confidential UTXO ZKP circuits](./zkp/circuits/): ZKP circuits written in circom to support the Confidential UTXO patterns
- [Confidential UTXO golang library](./zkp/golang/): test cases written in golang
- [Confidential UTXO javascript library](./zkp/js/): test cases written in javascript
- [Confidential UTXO Solidity library](./solidity/): Sample Solidity contracts for all the ZKP based Confidential UTXO based patterns
