pragma circom 2.2.2;

include "./ecdh.circom";
include "./encrypt.circom";
include "../scripts/node_modules/circomlib/circuits/babyjub.circom";

// encrypts a list of output UTXO values & salts
// with the corresponding shared ECDH keys for their
// owners. A single ephemeral private key is used
// to generate ECDH shared keys for different owners
template EncryptOutputs(numOutputs) {
  signal input ecdhPrivateKey;
  signal input encryptionNonce;
  signal input outputValues[numOutputs];
  signal input outputSalts[numOutputs];
  signal input outputOwnerPublicKeys[numOutputs][2];
  
  // the output for the public key of the ephemeral private key used in generating ECDH shared key
  signal output ecdhPublicKey[2];

  // the output for the list of encrypted output UTXOs cipher texts
  signal output cipherTexts[numOutputs][4];

  for (var i = 0; i < numOutputs; i++) {
    // generate shared secret
    var sharedSecret[2];
    sharedSecret = Ecdh()(privKey <== ecdhPrivateKey, pubKey <== outputOwnerPublicKeys[i]);

    // encrypt the value for the output UTXOs
    cipherTexts[i] <== SymmetricEncrypt(2)(plainText <== [outputValues[i], outputSalts[i]], key <== sharedSecret, nonce <== encryptionNonce);
  }

  (ecdhPublicKey[0], ecdhPublicKey[1]) <== BabyPbk()(in <== ecdhPrivateKey);
}
