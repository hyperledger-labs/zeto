pragma circom 2.2.2;

include "./ecdh.circom";
include "./encrypt.circom";
include "../node_modules/circomlib/circuits/babyjub.circom";
include "./buses.circom";

// encrypts a list of output UTXO values & salts
// with the corresponding shared ECDH keys for their
// owners. A single ephemeral private key is used
// to generate ECDH shared keys for different owners
template EncryptOutputs(nOutputs) {
  signal input ecdhPrivateKey;
  signal input encryptionNonce;
  input CommitmentInputs() commitmentInputs[nOutputs];

  
  // the output for the public key of the ephemeral private key used in generating ECDH shared key
  signal output ecdhPublicKey[2];

  // the output for the list of encrypted output UTXOs cipher texts
  signal output cipherTexts[nOutputs][4];

  for (var i = 0; i < nOutputs; i++) {
    // generate shared secret
    var sharedSecret[2];
    sharedSecret = Ecdh()(privKey <== ecdhPrivateKey, pubKey <== commitmentInputs[i].ownerPublicKey);

    // encrypt the value for the output UTXOs
    cipherTexts[i] <== SymmetricEncrypt(2)(plainText <== [commitmentInputs[i].value, commitmentInputs[i].salt], key <== sharedSecret, nonce <== encryptionNonce);
  }

  (ecdhPublicKey[0], ecdhPublicKey[1]) <== BabyPbk()(in <== ecdhPrivateKey);
}
