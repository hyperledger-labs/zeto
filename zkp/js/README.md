# Zeto toolkit javascript library

The main purpose of the javascript project is testing the circom based ZKP circuits. The test cases demonstrate the expected behaviors of the circuits, which can be used as the reference to build a client implementation for the Zeto toolkit.

# Build

The circuits have already been compiled to WASM based runtime libraries. All the materials are available in order to generate the witness.

On the other hand, proving keys set up have not been performed. You must follow the steps below to generate the proving key, and then export the verification key.

If modifying the circuits, you must go through the full flow of circuit compilation and proving key generation, as well as exporting the verification key and Solidity verifier library.

## Install Pre-requisites

Follow the instructions here to install `circom`, the circuit compiler, and `snarkjs`, the tool to generate proving keys, verification keys and the Solidity library.

[https://docs.circom.io/getting-started/installation/](https://docs.circom.io/getting-started/installation/)

## Compile the circuits and generate verification keys and solidity libraries

1. Install the dependencies of the circuits, by going to the `/zkp/circuits` folder:

```console
cd zkp/circuits
npm i
```

2. Compile the circuits and generate verification keys and solidity files.

- set where you want to store the generated verification keys and the downloaded PTAU files
  ```console
  export CIRCUITS_ROOT="$HOME/circuits"
  export PROVING_KEYS_ROOT="$HOME/proving-keys"
  export PTAU_DOWNLOAD_PATH="$HOME/ptaus"
  mkdir -p $PROVING_KEYS_ROOT $PTAU_DOWNLOAD_PATH $CIRCUITS_ROOT
  ```
- run the generation script for **ALL** circuits
  ```console
  npm run gen
  ```
  **run `npm run gen -- -c $circuit` for developing a single circuit**
  **run `npm run gen -- -v` to show details outputs of each command**
  **use `GEN_CONCURRENCY` to control how many circuits to be processed in parallel, default to 10**

# Run

Once the proving keys and verification keys are generated, set the environment variable `PROVING_KEYS_ROOT` to the folder that contains the proving keys and verification keys.

```console
$ npm i
$ npm t

> zeto-js@0.0.1 test
> mocha

  main circuit tests for Zeto fungible tokens with anonymity without encryption
    ✔ should succeed for valid witness (39ms)
    ✔ should fail to generate a witness because mass conservation is not obeyed
Proving time:  0.333 s
    ✔ should generate a valid proof that can be verified successfully (345ms)

  main circuit tests for Zeto fungible tokens with anonymity with encryption
    ✔ should succeed for valid witness and produce an encypted value (70ms)
    ✔ should fail to generate a witness because mass conservation is not obeyed
Proving time:  0.372 s
    ✔ should generate a valid proof that can be verified successfully (383ms)

  main circuit tests for Zeto fungible tokens with encryption and anonymity using nullifiers
    ✔ should succeed for valid witness and produce an encypted value (160ms)
    ✔ should succeed for valid witness and produce an encypted value - single input (108ms)
    ✔ should fail to generate a witness because mass conservation is not obeyed (74ms)
Proving time:  2.167 s
    ✔ should generate a valid proof that can be verified successfully (2183ms)

  main circuit tests for Zeto fungible tokens with anonymity using nullifiers and without encryption
    ✔ should succeed for valid witness (126ms)
    ✔ should succeed for valid witness - single input (79ms)
    ✔ should fail to generate a witness because mass conservation is not obeyed (57ms)
Proving time:  2.056 s
    ✔ should generate a valid proof that can be verified successfully (2076ms)

  check-nullifiers circuit tests
    ✔ should return true for valid witness (44ms)
    ✔ should fail to generate a witness because incorrect values are not used
Proving time:  0.138 s
    ✔ should generate a valid proof using groth16 that can be verified successfully (168ms)

  main circuit tests for Zeto non-fungible tokens with anonymity without encryption
    ✔ should succeed for valid witness and produce an encypted value (39ms)
Proving time:  0.135 s
    ✔ should generate a valid proof that can be verified successfully (144ms)

  main circuit tests for Zeto non-fungible tokens with anonymity using nullifiers and without encryption
    ✔ should succeed for valid witness (88ms)
Proving time:  1.08 s
    ✔ should generate a valid proof that can be verified successfully (1093ms)

  check-hashes-sum circuit tests
    ✔ should return true for valid witness
    ✔ should return true for valid witness using a single input value
    ✔ should return true for valid witness giving all values to receiver, without change to self
    ✔ should return true for valid witness using single input to transfer to receiver, without change to self
    ✔ should return true for valid witness when merging UTXOs to a single UTXO for self
    ✔ should fail to generate a witness because mass conservation is not obeyed
    ✔ should fail to generate a witness because of invalid input commitments
    ✔ should fail to generate a witness because of invalid output commitments
    ✔ should fail to generate a witness because of negative values in output commitments
    ✔ should fail to generate a witness because of using the inverse of a negative value in output commitments
    ✔ should succeed to generate a witness using the MAX_VALUE for output
    ✔ should fail to generate a witness because a larger than MAX_VALUE is used in output

  check-hashes-tokenid-uri circuit tests
    ✔ should return true for valid witness
    ✔ should fail to generate a witness because token Id changed
    ✔ should fail to generate a witness because token URI changed
    ✔ should fail to generate a witness because of invalid input commitments
    ✔ should fail to generate a witness because of invalid output commitments

  check-nullifier-hashes-sum circuit tests
    ✔ should return true for valid witness (126ms)
    ✔ should return true for valid witness - single input (78ms)
    ✔ should fail due to using single input but with both merkle proof enablement indicators set to "enabled" (56ms)
    ✔ should fail to generate a witness because mass conservation is not obeyed (57ms)

  check-nullifier-tokenid-uri circuit tests
    ✔ should return true for valid witness (95ms)
    ✔ should fail to generate a witness because token ID changed (40ms)
    ✔ should fail to generate a witness because token URI changed (40ms)
    ✔ should fail to generate a witness because of invalid input commitments
    ✔ should fail to generate a witness because of invalid output commitments

  Ecdh circuit tests
    ✔ should generate the shared secret in the proof circuit, which can be reproduced by the receiver

  Encryption circuit tests
    ✔ should generate the cipher text in the proof circuit, which can be decrypted by the receiver (48ms)


  49 passing (9s)

```

