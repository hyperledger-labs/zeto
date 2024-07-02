# Circom based circuits library for Zeto

The following circuits are included:

## Circuits for fungible tokens

- `anon.circom`: fungible tokens with anonymity, no encrypted secrets, no history masking
- `anon_enc.circom`: fungible tokens with anonymity and encrypted secrets, no history masking
- `anon_nullifier.circom`: fungible tokens with anonymity, no encrypted secrets, with history masking using nullifiers
- `anon_enc_nullifier.circom`: fungible tokens with anonymity and encrypted secrets, with history masking using nullifiers

## Circuits for non-fungible tokens

- `nf_anon.circom`: non-fungible tokens with anonymity, no encrypted secrets, no history masking
- `nf_anon_enc.circom`: (todo) non-fungible tokens with anonymity and encrypted secrets, no history masking
- `nf_anon_nullifier.circom`: non-fungible tokens with anonymity, no encrypted secrets, with history masking using nullifiers
- `nf_anon_enc_nullifier.circom`: (todo) non-fungible tokens with anonymity and encrypted secrets, with history masking using nullifiers

## Circuits for misc. usage

- `check-nullifiers`: demonstrates nullifiers are securely bound to target commitments. This can be useful for a notary to validate that a proposed list of nullifiers are legitimate for the input UTXOs, which are sent to the notary for verification but not included in the transaction payload, in order to sign off on the transaction proposal.

# Testing

## Install Dependencies

The circuits make use of the `circomlib` library, which must be installed with:

```console
npm i
```

## Run Circuit Tests

Tests for these circuits are provided in two programming languages:

- node.js: go to the [js](/zkp/js/) folder
- golang: go to the [golang](/zkp/golang/) folder
