# Confidential UTXO javascript library

The main purpose of the javascript project is testing the circom based ZKP circuits. The test cases demonstrate the expected behaviors of the circuits, which can be used as the reference to build a client implementation for the Confidential UTXO.

# Build

The circuits have already been compiled to WASM based runtime libraries. All the materials are available in order to generate the witness.

On the other hand, proving keys set up have not been performed. You must follow the steps below to generate the proving key, and then export the verification key.

If modifying the circuits, you must go through the full flow of circuit compilation and proving key generation, as well as exporting the verification key and Solidity verifier library.

## Install Pre-requisites

Follow the instructions here to install `circom`, the circuit compiler, and `snarkjs`, the tool to generate proving keys, verification keys and the Solidity library.

[https://docs.circom.io/getting-started/installation/](https://docs.circom.io/getting-started/installation/)

## Compile the circuit

This step is only necessary if you have modified any of the circuits.

```console
circom circuits/X.circom --output ./js/lib --sym --wasm
```

This generates the binary representations of the circuit, as a `.wasm` file. Only the top-level circuit, in our case `X.circom` needs to be compiled.

## Generate the proving key

The proving key is used by the prover code to generate the SNARK proof. This is accomplished with `snarkjs`. It supports 3 proving systems: `groth16`, `plonk` and `fflonk`. We use `groth16` as the default for its faster proof generation time and its support by the binary proof generator [rapidsnark](https://github.com/iden3/rapidsnark).

The result of a trusted setup from a well-coordinated ceremony can be used here. Download one of them from [https://github.com/iden3/snarkjs](https://github.com/iden3/snarkjs?tab=readme-ov-file#7-prepare-phase-2), such as `powersOfTau28_hez_final_15.ptau`.

The different `ptau` files represent different levels of complexity with the circuits. In general, you want to use the smallest file that can accommodate the size of your circuit.

- for `anon.circom`, `powersOfTau28_hez_final_12.ptau` can be used
- for `anon_enc.circom`, `powersOfTau28_hez_final_13.ptau` can be used
- for `anon_nullifier.circom`, `powersOfTau28_hez_final_16.ptau` can be used
- for `anon_enc_nullifier.circom`, `powersOfTau28_hez_final_16.ptau` can be used
- for `nf_anon.circom`, `powersOfTau28_hez_final_11.ptau` can be used
- for `nf_anon_nullifier.circom`, `powersOfTau28_hez_final_15.ptau` can be used

### Generating the R1CS circuit format

The first step is compiling the `.circom` files into an R1CS format that will then be used as input to generating the proving keys.

```console
circom circuits/X.circom --output ~/proving-keys --r1cs
```

### Generating the proving keys for testing purposes

```console
snarkjs groth16 setup ~/proving-keys/X.r1cs ~/Downloads/powersOfTau28_hez_final_Y.ptau ~/proving-keys/X.zkey
```

Note that the above setup command generates **UNSAFE** proving keys that should NOT be used in production. Doing the above skips the phase 2 of a groth16 set up ceremony to contribute more randomness to the proving keys, which is a required step to make the proof generation safe. Doing this is useful for testing purposes only. It also allows us to check in the verification logic in the verifier solidity libraries, which is derived from the proving key generated this way without any randomness.

### Generating the proving keys for production usage

When using the groth16 proving system, per-circuit set up ceremony must be conducted to introduce the required randomness to make the proving keys secure. Follow the procedure described here https://github.com/iden3/snarkjs?tab=readme-ov-file#15-setup to conduct the ceremony. After obtaining the proving key, the verification key and the verifier Solidity libraries in the contracts folder must also be re-generated.

## Export the verification key

The verification key is used by verifier code (either offchain with a JS library or onchain with Solidity). This can be derived from the proving key above.

```console
snarkjs zkey export verificationkey ~/proving_keys/X.zkey ~/proving_keys/X-vkey.json
```

## Export the Solidity verifier library

The verifier library in Solidity can also be derived from the proving key:

```console
snarkjs zkey export solidityverifier ~/proving_keys/X.zkey ../solidity/contracts/lib/verifier_X.sol
```

# Run

Once the proving keys and verification keys are generated, set the environment variable `PROVING_KEYS_ROOT` to the folder that contains the proving keys and verification keys.

```console
$ npm i
$ npm t

> zk-utxo-js@0.0.1 test
> mocha

  check-nullifiers circuit tests
    ✔ should return true for valid witness (45ms)
    ✔ should fail to generate a witness because incorrect values are not used
Proving time:  0.282 s
    ✔ should generate a valid proof using groth16 that can be verified successfully (314ms)

  main circuit tests for ConfidentialUTXO without encryption
    ✔ should succeed for valid witness (39ms)
    ✔ should fail to generate a witness because mass conservation is not obeyed
Proving time:  0.191 s
    ✔ should generate a valid proof that can be verified successfully (205ms)

  main circuit tests for ConfidentialUTXO with encryption
    ✔ should succeed for valid witness and produce an encypted value (69ms)
    ✔ should fail to generate a witness because mass conservation is not obeyed
Proving time:  0.363 s
    ✔ should generate a valid proof that can be verified successfully (375ms)

  main circuit tests for ConfidentialUTXO with encryption and anonymity
    ✔ should succeed for valid witness and produce an encypted value (156ms)
    ✔ should succeed for valid witness and produce an encypted value - single input (107ms)
    ✔ should fail to generate a witness because mass conservation is not obeyed (72ms)
Proving time:  2.235 s
    ✔ should generate a valid proof that can be verified successfully (2253ms)

  main circuit tests for ConfidentialUTXO (NFT) without encryption
    ✔ should succeed for valid witness and produce an encypted value (39ms)
Proving time:  0.131 s
    ✔ should generate a valid proof that can be verified successfully (141ms)

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
    ✔ should return true for valid witness (131ms)
    ✔ should return true for valid witness - single input (78ms)
    ✔ should fail due to using single input but with both merkle proof enablement indicators set to "enabled" (55ms)
    ✔ should fail to generate a witness because mass conservation is not obeyed (58ms)

  Ecdh circuit tests
    ✔ should generate the shared secret in the proof circuit, which can be reproduced by the receiver

  Encryption circuit tests
    ✔ should generate the cipher text in the proof circuit, which can be decrypted by the receiver (109ms)


  38 passing (5s)

```
