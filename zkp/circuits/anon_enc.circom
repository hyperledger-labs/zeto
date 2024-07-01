pragma circom 2.1.4;

include "./lib/check-hashes-sum.circom";
include "./lib/ecdh.circom";
include "./lib/encrypt.circom";
include "./node_modules/circomlib/circuits/babyjub.circom";

// This version of the circuit performs the following operations:
// - derive the sender's public key from the sender's private key
// - check the input and output commitments match the expected hashes
// - check the input and output values sum to the same amount
// - perform encryption of the receiver's output UTXO value and salt
template ConfidentialUTXO(nInputs, nOutputs) {
  signal input inputCommitments[nInputs];
  signal input inputValues[nInputs];
  signal input inputSalts[nInputs];
  signal input outputCommitments[nOutputs];
  signal input outputValues[nOutputs];
  signal input outputSalts[nOutputs];
  signal input outputOwnerPublicKeys[nOutputs][2];
  // must be properly hashed and trimmed to be compatible with the BabyJub curve.
  // Reference: https://github.com/iden3/circomlib/blob/master/test/babyjub.js#L103
  signal input senderPrivateKey;
  signal input encryptionNonce;

  signal output cipherText[2];

  // derive the sender's public key from the secret input
  // for the sender's private key. This step demonstrates
  // the sender really owns the private key for the input
  // UTXOs
  var senderPublicKey[2];
  component pub = BabyPbk();
  pub.in <== senderPrivateKey;
  senderPublicKey[0] = pub.Ax;
  senderPublicKey[1] = pub.Ay;

  component checkHashesSum = CheckHashesAndSum(nInputs, nOutputs);
  checkHashesSum.inputCommitments <== inputCommitments;
  checkHashesSum.inputValues <== inputValues;
  checkHashesSum.inputSalts <== inputSalts;
  checkHashesSum.inputOwnerPublicKey <== senderPublicKey;
  checkHashesSum.outputCommitments <== outputCommitments;
  checkHashesSum.outputValues <== outputValues;
  checkHashesSum.outputSalts <== outputSalts;
  checkHashesSum.outputOwnerPublicKeys <== outputOwnerPublicKeys;
  // assert successful output
  checkHashesSum.out === 1;

  // generate shared secret
  var sharedSecret[2];
  component ecdh = Ecdh();
  ecdh.privKey <== senderPrivateKey;
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

component main { public [ inputCommitments, outputCommitments, encryptionNonce ] } = ConfidentialUTXO(2, 2);