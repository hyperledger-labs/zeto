pragma circom 2.1.4;

include "./ecdh.circom";
include "./encrypt.circom";
include "../node_modules/circomlib/circuits/babyjub.circom";

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

  component ecdh[numOutputs];
  component encrypt[numOutputs];

  for (var i = 0; i < numOutputs; i++) {
    // generate shared secret
    var sharedSecret[2];
    ecdh[i] = Ecdh();
    ecdh[i].privKey <== ecdhPrivateKey;
    ecdh[i].pubKey[0] <== outputOwnerPublicKeys[i][0];
    ecdh[i].pubKey[1] <== outputOwnerPublicKeys[i][1];
    sharedSecret[0] = ecdh[i].sharedKey[0];
    sharedSecret[1] = ecdh[i].sharedKey[1];

    // encrypt the value for the output UTXOs
    encrypt[i] = SymmetricEncrypt(2);
    encrypt[i].plainText[0] <== outputValues[i];
    encrypt[i].plainText[1] <== outputSalts[i];
    encrypt[i].key <== sharedSecret;
    encrypt[i].nonce <== encryptionNonce;
    for (var j = 0; j < 4; j++) {
      encrypt[i].cipherText[j] ==> cipherTexts[i][j];
    }
  }

  component ecdhPub = BabyPbk();
  ecdhPub.in <== ecdhPrivateKey;
  ecdhPublicKey[0] <== ecdhPub.Ax;
  ecdhPublicKey[1] <== ecdhPub.Ay;
}
