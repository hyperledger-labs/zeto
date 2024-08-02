#!/bin/bash

# Check if PROVING_KEYS_ROOT is not set or is empty
if [ -z "$PROVING_KEYS_ROOT" ]; then
  echo "Error: PROVING_KEYS_ROOT is not set."
  exit 1
fi

# Define arrays
X_values=(
    "anon"
    "anon_enc"
    "anon_nullifier"
    "anon_enc_nullifier"
    "nf_anon"
    "nf_anon_nullifier"
    "check_hashes_value"
    "check_inputs_outputs_value"
    "check_nullifier_value"
    "check_nullifiers"
)
Y_values=(
    "powersOfTau28_hez_final_12"
    "powersOfTau28_hez_final_13"
    "powersOfTau28_hez_final_16"
    "powersOfTau28_hez_final_16"
    "powersOfTau28_hez_final_11"
    "powersOfTau28_hez_final_15"
    "powersOfTau28_hez_final_09"
    "powersOfTau28_hez_final_11"
    "powersOfTau28_hez_final_16"
    "powersOfTau28_hez_final_11"
)

# Check if both arrays have the same length
if [ ${#X_values[@]} -ne ${#Y_values[@]} ]; then
    echo "Error: X_values and Y_values arrays have different lengths."
    exit 1
fi

# Loop through the arrays
for i in "${!X_values[@]}"; do
    X=${X_values[$i]}
    Y=${Y_values[$i]}
    echo "Processing $X"

    CIRCOM_INPUT="circuits/$X.circom"
    PTIAU_FILE="$HOME/Downloads/$Y.ptau"
    ZKEY_OUTPUT="$PROVING_KEYS_ROOT/$X.zkey"

    if [ ! -f "$CIRCOM_INPUT" ]; then
        echo "Error: Input file does not exist: $CIRCOM_INPUT"
        continue
    fi

    echo "Compile circuit for $X"
    circom "$CIRCOM_INPUT" --output ./js/lib --sym --wasm
    circom "$CIRCOM_INPUT" --output "$PROVING_KEYS_ROOT" --r1cs

    echo "Generate test proving key for $X with $Y"
    snarkjs groth16 setup "$PROVING_KEYS_ROOT/$X.r1cs" "$PTIAU_FILE" "$ZKEY_OUTPUT"
    
    echo "Generate verification key for $X"
    snarkjs zkey export verificationkey "$PROVING_KEYS_ROOT/$X.zkey" "$PROVING_KEYS_ROOT/$X.-vkey.json"
    
    echo "Generate solidity verifier for $X"
    snarkjs zkey export solidityverifier "$PROVING_KEYS_ROOT/$X.zkey" "../solidity/contracts/lib/verifier_$X.sol"
done

