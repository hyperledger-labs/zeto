# ERC20 Tokens integration

All fungible Zeto implementations support integration with an ERC20 contract via `deposit` and `withdraw` functions.

![erc20 integration](../images/erc20-deposit-withdraw.jpg)

## Deposit

When depositing, users take their balances in ERC20 and exchanges for the same amount in Zeto tokens. The deposited amount will be transfered to the Zeto contract to own, until the time when a withdraw is called.

The ZKP circuit for the deposit function contains the following statements:

- the commitments for the output UTXOs are based on positive numbers
- the commitments for the output UTXOs are well formed, obeying the `hash(value, owner public key, salt)` formula
- the sum of the output UTXO values are returned as the output signal, which can be compared with the `amount` value in the transaction call. aka `depositAmount == sum(outputs)`

One obvious observation with the deposit function is that it leaks the value of the output UTXO. For instance, consider the following transaction:

```javascript
deposit(amount, outputUTXO, proof);
```

The output UTXO's value will be equal to the `amount`. To mitigate this, the output is an array of UTXOs, of size `2`. This way the exact value of each of the UTXOs in the output is unknown except by the owner(s).

## Withdraw

When withdrawing, users spend their UTXOs in the Zeto contract and request for the corresponding amount to be transferred to their Ethereum account in the ERC20 contract.

The ZKP circuit for the withdraw function contains the following statements:

- the commitments for the output UTXOs are based on positive numbers
- the commitments for the input and output UTXOs are well formed, obeying the `hash(value, owner public key, salt)` formula
- the sum of the input UTXO values is subtracted by the sum of the output UTXO values, with the result returned as the output signal, which can be compared with the `amount` value in the transaction call. aka `sum(inputs) == sum(outputs) + withdarwAmount`

## How to use ERC20 integration

It's very easy to enable the ERC20 integration on any fungible Zeto implementation. Call `setERC20(erc20_contract_address)` to configure the ERC20 contract that the Zeto token should work with. That's it!

## deposit/withdraw vs. mint

A solution developer who considers using the ERC20 integration feature must take into account how this works alongside the `mint` function. While the `mint` function preserves the privacy of new token issuance inside the Zeto contract, it could lead to an insufficient balance in the ERC20 contract when the `withdraw` function is invoked.

Consider the following sequence of events:

- The Zeto contract is deployed and configured to work with an ERC20 contract
- Alice deposits 100 from her ERC20 balance
  > Zeto contract's balance becomes 100
- The regulator mints 50 to Alice
- Bob deposits 100 from his ERC20 balance
  > Zeto contract's balance becomes 200
- Alice withdraws all her 150 Zeto tokens
  > Zeto contract's balance becomes 50
- Bob attempts to withdraw 100
  > This will fail because the Zeto contract's balance is below the requested amount
