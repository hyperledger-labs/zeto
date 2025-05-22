# Zeto_AnonNullifierQurrency

| Anonymity          | History Masking    | Encryption         | KYC | Non-repudiation | Gas Cost (estimate) |
| ------------------ | ------------------ | ------------------ | --- | --------------- | ------------------- |
| :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | -   | -               | 2,066,430           |

![pqc](../images/pqc-dark-100px.png)

This implementation builds on top of the `anon_nullifiers` to add post-quantum cryptography inside the circuit to encrypt sensitive information for a designated authority, such as a regulator, for auditing purposes.

The encryption scheme is based on the ML-KEM (Module-Lattice-Based Key-Encapsulation Mechanism) derived from the CRYSTALS-KYBER algorithm. This is a NIST approved algorithm for post-quantum secure encryption, meaning even the quatum computers can not break the encryption.

The encryption is performed in the follow step, according to the ML-KEM scheme:

- An AES-256 encryption key is generated for the transaction. This key is used only for this transaction
  - AES encryption is quantum secure
- The secrets meant for the auditing authority are encrypted with this key, and sent as part of the transaction payload
- The key is passed into the circuit as a private input and encrypted inside the circuit under the ML-KEM scheme, using the auditing authority's public key
  - The public key is statically programmed into the circuit. This is to avoid making it a signal which would be very inefficient due to the large size of the public key (1184 bytes)
  - <span style="color:red">IMPORTANT:</span> This means for a real world deployment, the deployer MUST update the circuit with the auditing authority's public key and re-compile the circuit
- The ciphertext is extracted from the circuit's witness array and sent as a part of the transaction payload
- The circuit also calculates the SHA256 hash of the ciphertext to use as a public input, instead of using the ciphertext itself as a public input
  - This is an optimization step. The ciphertext is a large array of 768 numbers (of value 0 or 1), to represent the 768-bit ciphertext, which would make proof verification more expensive
  - The SHA256 hashing algorithm is picked to make verification inside EVM more efficient, due to the native sha256 support via EVM precompiles.
- The authority can then use the private key to decrypt the ciphertext to recover the AES encryption key, then use the recovered key to decrypt the AES ciphertext to recover the secrets

The statements in the proof include:

- each value in the output commitments must be a positive number in the range 0 ~ (2\*\*40 - 1)
- the sum of the nullified values match the sum of output values
- the hashes in the output match the hash(value, salt, owner public key) formula
- the sender possesses the private BabyJubjub key, whose public key is part of the pre-image of the input commitment hashes, which match the corresponding nullifiers
- the nullifiers represent input commitments that are included in a Sparse Merkle Tree represented by the root hash
- the AES encryption key is correctly encrypted using the auditing authority's public key, resulting in the ciphretext
- the public signals representing the SHA256 hash of the ciphertext is correctly calculated

![wiring_anon_nullifier_qurrency](../images/circuit_wiring_anon_nullifier_qurrency.jpg)
