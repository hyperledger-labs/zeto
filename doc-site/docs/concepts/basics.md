# Basic Concepts

Zeto is built on the following fundamental concepts.

## Transaction model

The UTXO model is adopted instead of the account model, for better support of parallel processing. Due to the necessity of maintaining private states offchain in order to achieve privacy, the client must continuously keep their private states in sync with the smart contract. Using an account model makes it more difficult to achieve this because incoming transfers from other parties would invalidate an account's state, making the account owner unable to spend from its account unless the private state has been sync'ed again. Solutions to this issue, often referred to as front-running, typically involve a spending window with a pending queue, which result in limited parallel processing of transactions from the same spending account. With a UTXO model, each state is independent of the others, so parallel processing is better achieved.

## Commitments

Each UTXO is tracked by the smart contract as a hash, or commitment, of the following components: value, salt and owner public key

## Finality

Each transaction's validity is verified by the smart contract before allowing the proposed input UTXOs to be nullified and the output UTXOs to come into existence. In other words, this is not an optimistic design and as such does not rely on a multi-day challenge period before a transaction is finalized. Every transaction is immediately finalized once it's mined into a block.
