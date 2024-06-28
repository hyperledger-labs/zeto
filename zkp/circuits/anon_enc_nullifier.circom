pragma circom 2.1.4;

include "./lib/check-nullifier-hashes-sum.circom";
include "./lib/ecdh.circom";
include "./lib/encrypt.circom";
include "./node_modules/circomlib/circuits/babyjub.circom";

// This version of the circuit performs the following operations:
// - It derives the sender's public key from the sender's private key
// - It checks the input and output commitments match the expected hashes
// - It checks the input and output values sum to the same amount
// - It performs encryption of the receiver's output UTXO value and salt
// - It checks the nullifiers are derived from the input commitments and the sender's private key
// - It checks the nullifiers are included in the Merkle tree
template ConfidentialUTXO(nInputs, nOutputs, nSMTLevels) {
  signal input nullifiers[nInputs];
  signal input inputCommitments[nInputs];
  signal input inputValues[nInputs];
  signal input inputSalts[nInputs];
  // must be properly hashed and trimmed to be compatible with the BabyJub curve.
  // Reference: https://github.com/iden3/circomlib/blob/master/test/babyjub.js#L103
  signal input inputOwnerPrivateKey;
  signal input root;
  signal input merkleProof[nInputs][nSMTLevels];
  signal input enabled[nInputs];
  signal input outputCommitments[nOutputs];
  signal input outputValues[nOutputs];
  signal input outputOwnerPublicKeys[nOutputs][2];
  signal input outputSalts[nOutputs];
  signal input encryptionNonce;

  signal output cipherText[2];

  component checkHashesSum = CheckNullifierHashesAndSum(nInputs, nOutputs, nSMTLevels);
  checkHashesSum.nullifiers <== nullifiers;
  checkHashesSum.inputCommitments <== inputCommitments;
  checkHashesSum.inputValues <== inputValues;
  checkHashesSum.inputSalts <== inputSalts;
  checkHashesSum.inputOwnerPrivateKey <== inputOwnerPrivateKey;
  checkHashesSum.root <== root;
  checkHashesSum.merkleProof <== merkleProof;
  checkHashesSum.enabled <== enabled;
  checkHashesSum.outputCommitments <== outputCommitments;
  checkHashesSum.outputValues <== outputValues;
  checkHashesSum.outputSalts <== outputSalts;
  checkHashesSum.outputOwnerPublicKeys <== outputOwnerPublicKeys;
  // assert successful output
  checkHashesSum.out === 1;

  // generate shared secret
  var sharedSecret[2];
  component ecdh = Ecdh();
  ecdh.privKey <== inputOwnerPrivateKey;
  // our circuit requires that the output UTXO for the receiver must be the first in the array
  ecdh.pubKey[0] <== outputOwnerPublicKeys[0][0];
  ecdh.pubKey[1] <== outputOwnerPublicKeys[0][1];
  sharedSecret[0] = ecdh.sharedKey[0];
  sharedSecret[1] = ecdh.sharedKey[1];

  // encrypt the value for the receiver
  component encrypt = SymmetricEncrypt(2);
  // our circuit requires that the output UTXO for the receiver must be the first in the array
  encrypt.plainText[0] <== outputValues[0];
  encrypt.plainText[1] <== outputSalts[0];
  encrypt.key <== sharedSecret;
  encrypt.nonce <== encryptionNonce;
  encrypt.cipherText[0] --> cipherText[0];
  encrypt.cipherText[1] --> cipherText[1];
}

component main { public [ nullifiers, outputCommitments, encryptionNonce, root, enabled ] } = ConfidentialUTXO(2, 2, 64);