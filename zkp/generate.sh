#!/bin/bash

specific_circuit="$1"

if [ -z "$PROVING_KEYS_ROOT" ]; then
  echo "Error: PROVING_KEYS_ROOT is not set."
  exit 1
fi

if [ -z "$PTAU_DOWNLOAD" ]; then
  echo "Error: PTAU_DOWNLOAD is not set."
  exit 1
fi

circuit_names=(
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
ptau_names=(
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
if [ ${#circuit_names[@]} -ne ${#ptau_names[@]} ]; then
    echo "Error: circuit_names and ptau_names arrays have different lengths."
    exit 1
fi

function to_camel_case() {
    echo "$1" | awk -F'_' '{
        str = "";
        for (i=1; i<=NF; i++) {
            str = str toupper(substr($i,1,1)) tolower(substr($i,2));
        }
        print str
    }'
}

for i in "${!circuit_names[@]}"; do
    circuit=${circuit_names[$i]}
    ptau=${ptau_names[$i]}
    
    # Skip processing if a specific circuit is provided and it doesn't match the current one
    if [ -n "$specific_circuit" ] && [ "$circuit" != "$specific_circuit" ]; then
        continue
    fi
    
    echo "Processing $circuit"

    CIRCOM_INPUT="circuits/$circuit.circom"
    PTAU_FILE="$PTAU_DOWNLOAD/$ptau.ptau"
    ZKEY_OUTPUT="$PROVING_KEYS_ROOT/$circuit.zkey"

    if [ ! -f "$CIRCOM_INPUT" ]; then
        echo "Error: Input file does not exist: $CIRCOM_INPUT"
        continue
    fi

    if [ ! -f "$PTAU_FILE" ]; then
        echo "PTAU file does not exist, downloading: $PTAU_FILE"
        curl -o "$PTAU_FILE" "https://storage.googleapis.com/zkevm/ptau/$ptau.ptau" || exit 1
    fi

    echo "Compiling circuit for $circuit"
    circom "$CIRCOM_INPUT" --output ./js/lib --sym --wasm
    circom "$CIRCOM_INPUT" --output "$PROVING_KEYS_ROOT" --r1cs

    echo "Generating test proving key for $circuit with $ptau"
    snarkjs groth16 setup "$PROVING_KEYS_ROOT/$circuit.r1cs" "$PTAU_FILE" "$ZKEY_OUTPUT"
    
    echo "Generating verification key for $circuit"
    snarkjs zkey export verificationkey "$PROVING_KEYS_ROOT/$circuit.zkey" "$PROVING_KEYS_ROOT/$circuit-vkey.json"
   
    echo "Generating solidity verifier for $circuit"
    SOLIDITY_FILE="../solidity/contracts/lib/verifier_$circuit.sol"
    snarkjs zkey export solidityverifier "$PROVING_KEYS_ROOT/$circuit.zkey" "$SOLIDITY_FILE"
    
    echo "Modifying the contract name in the generated Solidity file for $circuit"
    CAMEL_CASE_CIRCUIT_NAME=$(to_camel_case "$circuit")
    SOLIDITY_FILE_TMP=$SOLIDITY_FILE.tmp

    sed "s| Groth16Verifier | Groth16Verifier_$CAMEL_CASE_CIRCUIT_NAME |" "$SOLIDITY_FILE" > "$SOLIDITY_FILE_TMP"
    mv $SOLIDITY_FILE_TMP $SOLIDITY_FILE

done
