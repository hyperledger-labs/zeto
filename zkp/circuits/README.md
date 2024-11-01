# Circom based circuits library for Zeto

The following circuits are included:

## Circuits for fungible tokens

- `anon.circom`, `anon_batch.circom`: fungible tokens with anonymity, no encrypted secrets, no history masking
- `anon_enc.circom`, `anon_enc_batch.circom`: fungible tokens with anonymity and encrypted secrets, no history masking
- `anon_nullifier.circom`, `anon_nullifier_batch.circom`: fungible tokens with anonymity, no encrypted secrets, with history masking using nullifiers
- `anon_enc_nullifier.circom`, `anon_enc_nullifier_batch.circom`: fungible tokens with anonymity and encrypted secrets, with history masking using nullifiers
- `anon_enc_nullifier_kyc.circom`, `anon_enc_nullifier_kyc_batch.circom`: fungible tokens with anonymity and encrypted secrets, with history masking using nullifiers, and KYC with privacy
- `anon_enc_nullifier_non_repudiation.circom`, `anon_enc_nullifier_non_repudiation_batch.circom`: fungible tokens with anonymity and encrypted secrets, with history masking using nullifiers, and encrypted secrets for an authority for non-repudiation
- `check_hashes_value.circom`, `check_hashes_value_batch.circom`: used for verifying deposit calls in a fungible token implementation
- `check_inputs_outputs_value.circom`, `check_inputs_outputs_value_batch.circom`: used for verifying withdraw calls in a fungible token implementation

> the circuits with a `_batch` suffix in the name has the same computation logic as the circuit without the suffix. The only difference is the `_batch` circuit supports input and output array of size 10, rather than 2.

## Circuits for non-fungible tokens

- `nf_anon.circom`: non-fungible tokens with anonymity, no encrypted secrets, no history masking
- `nf_anon_nullifier.circom`: non-fungible tokens with anonymity, no encrypted secrets, with history masking using nullifiers

## Circuits for misc. usage

- `check_nullifiers`: demonstrates nullifiers are securely bound to target commitments. This can be useful for a notary to validate that a proposed list of nullifiers are legitimate for the input UTXOs, which are sent to the notary for verification but not included in the transaction payload, in order to sign off on the transaction proposal.

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

# Generating Runtime Artifacts

To use the circuits in a ZKP application, 3 types of artifacts are needed:

- Witness calculator: this step uses the circuit's computation logic to calculate the witness values, namely the intermediate states involved in the computation steps.
- Proving keys: a SNARK proof generator uses the witnesses and the proving keys to construct a SNARK proof. Depending on the specific proving system used by the ZKP application, a trusted setup may or may not be needed for each circuit, before the proving keys for the circuit can be generated. The default proving system used by Zeto is groth16, for its fast proof generation speed and compact SNARK proof size, which does require a per-circuit trusted setup.
- Solidity verifiers: for the SNARK proof to be verified by a smart contract, verification keys derived from the providing key are needed, along with verification logic specific to the proving system used.

Zeto provides an artifact generation program, `gen.js`, that can generate the above artifacts. Note that it does NOT perform a trusted setup, this step should be conducted as a coordinated ceremony by the deployer of the ZKP application if groth16 is used. It generates proving keys for **TESTING PURPOSE ONLY**.

```console
export CIRCUITS_ROOT="$HOME/circuits"
export PROVING_KEYS_ROOT="$HOME/proving-keys"
export PTAU_DOWNLOAD_PATH="$HOME/ptaus"
mkdir -p $PROVING_KEYS_ROOT $PTAU_DOWNLOAD_PATH $CIRCUITS_ROOT

npm i
npm run gen
```

**run `npm run gen -- -c $circuit` to generate artifacts for a single circuit**
**run `npm run gen -- -v` to show verbose outputs**
**use `GEN_CONCURRENCY` to control how many circuits to be processed in parallel, default to 10**

> Refer to [generation script explanation](#generation-script-explanation) for what the script does

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
