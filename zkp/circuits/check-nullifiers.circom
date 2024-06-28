pragma circom 2.1.4;

include "./node_modules/circomlib/circuits/poseidon.circom";
include "./node_modules/circomlib/circuits/comparators.circom";
include "./node_modules/circomlib/circuits/babyjub.circom";

//
// Verifies that the nullifiers are correctly bound to the input commitments
//
// commitment = hash(value, salt, ownerPublicKey1, ownerPublicKey2)
// nullifier = hash(value, salt, ownerPrivatekey)
//
template CheckNullifiers(numInputs) {
  signal input nullifiers[numInputs];
  signal input inputCommitments[numInputs];
  signal input inputValues[numInputs];
  signal input inputSalts[numInputs];
  // must be properly hashed and trimmed to be compatible with the BabyJub curve.
  // Reference: https://github.com/iden3/circomlib/blob/master/test/babyjub.js#L103
  signal input inputOwnerPrivateKey;
  signal output out;

  // derive the sender's public key from the secret input
  // for the sender's private key. This step demonstrates
  // the sender really owns the private key for the input
  // UTXOs
  var inputOwnerPublicKey[2];
  component pub = BabyPbk();
  pub.in <== inputOwnerPrivateKey;
  inputOwnerPublicKey[0] = pub.Ax;
  inputOwnerPublicKey[1] = pub.Ay;

  // hash the input values
  component inputHashes[numInputs];
  var calculatedInputHashes[numInputs];
  for (var i = 0; i < numInputs; i++) {
    inputHashes[i] = Poseidon(4);
    inputHashes[i].inputs[0] <== inputValues[i];
    inputHashes[i].inputs[1] <== inputSalts[i];
    inputHashes[i].inputs[2] <== inputOwnerPublicKey[0];
    inputHashes[i].inputs[3] <== inputOwnerPublicKey[1];
    calculatedInputHashes[i] = inputHashes[i].out;
  }

  // check that the input commitments match the calculated hashes
  for (var i = 0; i < numInputs; i++) {
    assert(inputCommitments[i] == calculatedInputHashes[i]);
  }

  // calculate the nullifier values from the input values
  component nullifierHashes[numInputs];
  var calculatedNullifierHashes[numInputs];
  for (var i = 0; i < numInputs; i++) {
    nullifierHashes[i] = Poseidon(3);
    nullifierHashes[i].inputs[0] <== inputValues[i];
    nullifierHashes[i].inputs[1] <== inputSalts[i];
    nullifierHashes[i].inputs[2] <== inputOwnerPrivateKey;
    calculatedNullifierHashes[i] = nullifierHashes[i].out;
  }

  // check that the nullifiers match the calculated hashes
  for (var i = 0; i < numInputs; i++) {
    assert(nullifiers[i] == calculatedNullifierHashes[i]);
  }

  out <-- 1;
}

component main { public [ nullifiers, inputCommitments ] } = CheckNullifiers(2);