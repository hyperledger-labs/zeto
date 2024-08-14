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
  export PTAU_DOWNLOAD_PATH="$HOME/Downloads"
  mkdir -p $PROVING_KEYS_ROOT $PTAU_DOWNLOAD_PATH $CIRCUITS_ROOT
  ```
- run the generation script for **ALL** circuits
  ```console
  npm run gen
  ```
  **run `npm run gen -- -c $circuit` for developing a single circuit**
  **use `GEN_CONCURRENCY` to control how many circuits to be processed in parallel, default to 10**

> Refer to [generation script explanation](#generation-script-explanation) for what the script does

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

## generation script explanation

The `CIRCUIT_FILE_NAME` and `PTAU_FILE_NAME` referenced below refer to the circuit name and their corresponding ptau in [../circuits/gen-config.json](../circuits/gen-config.json).

### Compile the circuit

You can then compile the circuits:

```console
circom circuits/CIRCUIT_FILE_NAME.circom --output ./js/lib --sym --wasm
```

This generates the binary representations of the circuit, as a `.wasm` file. Only the top-level circuit, in our case `CIRCUIT_FILE_NAME.circom` needs to be compiled.

### Generate the proving key

The proving key is used by the prover code to generate the SNARK proof. This is accomplished with `snarkjs`. It supports 3 proving systems: `groth16`, `plonk` and `fflonk`. We use `groth16` as the default for its faster proof generation time and its support by the binary proof generator [rapidsnark](https://github.com/iden3/rapidsnark).

The result of a trusted setup from a well-coordinated ceremony can be used here. Download one of them from [https://github.com/iden3/snarkjs](https://github.com/iden3/snarkjs?tab=readme-ov-file#7-prepare-phase-2), such as `powersOfTau28_hez_final_15.ptau`.

The different `ptau` files represent different levels of complexity with the circuits. In general, you want to use the smallest file that can accommodate the size of your circuit.

#### Generating the R1CS circuit format

The first step is compiling the `.circom` files into an R1CS format that will then be used as input to generate the proving keys.

```console
circom circuits/CIRCUIT_FILE_NAME.circom --output ~/proving-keys --r1cs
```

#### Generating the proving keys for testing purposes

```console
snarkjs groth16 setup ~/proving-keys/CIRCUIT_FILE_NAME.r1cs ~/Downloads/PTAU_FILE_NAME.ptau ~/proving-keys/CIRCUIT_FILE_NAME.zkey
```

Note that the above setup command generates **UNSAFE** proving keys that should NOT be used in production. Doing the above skips the phase 2 of a groth16 set up ceremony to contribute more randomness to the proving keys, which is a required step to make the proof generation safe. Doing this is useful for testing purposes only. It also allows us to check in the verification logic in the verifier solidity libraries, which is derived from the proving key generated this way without any randomness.

#### Generating the proving keys for production usage

When using the groth16 proving system, per-circuit set up ceremony must be conducted to introduce the required randomness to make the proving keys secure. Follow the procedure described here https://github.com/iden3/snarkjs?tab=readme-ov-file#15-setup to conduct the ceremony. After obtaining the proving key, the verification key and the verifier Solidity libraries in the contracts folder must also be re-generated.

### Export the verification key

The verification key is used by verifier code (either offchain with a JS library or onchain with Solidity). This can be derived from the proving key above.

```console
snarkjs zkey export verificationkey ~/proving-keys/CIRCUIT_FILE_NAME.zkey ~/proving-keys/CIRCUIT_FILE_NAME-vkey.json
```

### Export the Solidity verifier library

You can skip this step for running tests. Solidity verifiers have already been generated from the UNSAFE test proving keys as described above.

However, if you have performed the per-circuit set up ceremonies to generate the proving keys, for instance in a production deployment, then you must re-generated the solidity verifiers.

The verifier library in Solidity are also derived from the proving key:

```console
snarkjs zkey export solidityverifier ~/proving-keys/CIRCUIT_FILE_NAME.zkey ../solidity/contracts/lib/verifier_CIRCUIT_FILE_NAME.sol
```

### Rename contracts in the verifier solidity libraries

After EACH verifier library is generated, you need to navigate to the solidity file for the verifier and modify the name of the contract, to match the naming convention used by the top-level token contract that references the verifier library. For instance, for the `anon_nullifier` circuit, you will have generated the following file:

```
/solidity/contracts/lib/verifier_anon_nullifier.sol
```

The file contains a contract called `Groth16Verifier`. That must be renamed to `Groth16Verifier_AnonEncNullifier` to match its name used by the contract:

```
/solidity/contracts/zeto_anon_nullifier.sol
```
