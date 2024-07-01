pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/babyjub.circom";
include "../node_modules/circomlib/circuits/smt/smtverifier.circom";

// CheckNullifierHashesAndSum is a circuit that checks the integrity of transactions of Fungible Tokens
//   - check that all output values are positive numbers (within the range of 0 to 2^40)
//   - check that the nullifiers are correctly computed from the input values and salts
//   - check that the input commitments are correctly computed from the input values, salts, and owner public keys
//   - check that the input commitments are included in the Sparse Merkle Tree with the root `root`
//   - check that the output commitments are correctly computed from the output values, salts, and owner public keys
//   - check that the sum of input values equals the sum of output values
//
// nullifiers: array of hashes for the nullifiers corresponding to the input utxos
// inputValues: array of values, as preimages for the input hashes, for the input utxos
// output commitments: array of hashes for the output utxos
// outputValues: array of values, as preimages for the output hashes, for the output utxos
//
// commitment = hash(value, salt, ownerPublicKey1, ownerPublicKey2)
// nullifier = hash(value, salt, ownerPrivatekey)
//
template CheckNullifierHashesAndSum(numInputs, numOutputs, nSMTLevels) {
  signal input nullifiers[numInputs];
  signal input inputCommitments[numInputs];
  signal input inputValues[numInputs];
  signal input inputSalts[numInputs];
  // must be properly hashed and trimmed to be compatible with the BabyJub curve.
  // Reference: https://github.com/iden3/circomlib/blob/master/test/babyjub.js#L103
  signal input inputOwnerPrivateKey;
  signal input root;
  signal input merkleProof[numInputs][nSMTLevels];
  signal input enabled[numInputs];
  signal input outputCommitments[numOutputs];
  signal input outputValues[numOutputs];
  signal input outputSalts[numOutputs];
  signal input outputOwnerPublicKeys[numOutputs][2];
  signal output out;

  // check that the output values are within the expected range. we don't allow negative values
  component positive[numOutputs];
  var isPositive[numOutputs];
  for (var i = 0; i < numOutputs; i++) {
    positive[i] = GreaterEqThan(40);
    positive[i].in[0] <== outputValues[i];
    positive[i].in[1] <== 0;
    isPositive[i] = positive[i].out;
    assert(isPositive[i] == 1);
  }

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
    // perform the hash calculation even though they are not needed when the input 
    // commitment at the current index is 0; this is because in zkp circuits we
    // must always perform the same computation (have the the same constraints)
    inputHashes[i] = Poseidon(4);
    inputHashes[i].inputs[0] <== inputValues[i];
    inputHashes[i].inputs[1] <== inputSalts[i];
    inputHashes[i].inputs[2] <== inputOwnerPublicKey[0];
    inputHashes[i].inputs[3] <== inputOwnerPublicKey[1];
    if (inputCommitments[i] == 0) {
      calculatedInputHashes[i] = 0;
    } else {
      calculatedInputHashes[i] = inputHashes[i].out;
    }
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
    if (nullifiers[i] == 0) {
      calculatedNullifierHashes[i] = 0;
    } else {
      calculatedNullifierHashes[i] = nullifierHashes[i].out;
    }
  }

  // check that the nullifiers match the calculated hashes
  for (var i = 0; i < numInputs; i++) {
    assert(nullifiers[i] == calculatedNullifierHashes[i]);
  }

  // With the above steps, we demonstrated that the nullifiers
  // are securely bound to the input commitments. Now we need to
  // demonstrate that the input commitments belong to the Sparse
  // Merkle Tree with the root `root`.
  component smtVerifier[numInputs];
  for (var i = 0; i < numInputs; i++) {
    smtVerifier[i] = SMTVerifier(nSMTLevels);
    smtVerifier[i].enabled <== enabled[i];
    smtVerifier[i].root <== root;
    for (var j = 0; j < nSMTLevels; j++) {
      smtVerifier[i].siblings[j] <== merkleProof[i][j];
    }
    smtVerifier[i].oldKey <== 0;
    smtVerifier[i].oldValue <== 0;
    smtVerifier[i].isOld0 <== 0;
    smtVerifier[i].key <== inputCommitments[i];
    smtVerifier[i].value <== inputCommitments[i];
    smtVerifier[i].fnc <== 0;
  }

  // hash the output values
  component outputHashes[numOutputs];
  var calculatedOutputHashes[numOutputs];
  for (var i = 0; i < numOutputs; i++) {
    outputHashes[i] = Poseidon(4);
    outputHashes[i].inputs[0] <== outputValues[i];
    outputHashes[i].inputs[1] <== outputSalts[i];
    outputHashes[i].inputs[2] <== outputOwnerPublicKeys[i][0];
    outputHashes[i].inputs[3] <== outputOwnerPublicKeys[i][1];
    if (outputCommitments[i] == 0) {
      calculatedOutputHashes[i] = 0;
    } else {
      calculatedOutputHashes[i] = outputHashes[i].out;
    }
  }

  // check that the output commitments match the calculated hashes
  for (var i = 0; i < numOutputs; i++) {
    assert(outputCommitments[i] == calculatedOutputHashes[i]);
  }

  // check that the sum of input values equals the sum of output values
  var sumInputs = 0;
  for (var i = 0; i < numInputs; i++) {
    sumInputs = sumInputs + inputValues[i];
  }
  var sumOutputs = 0;
  for (var i = 0; i < numOutputs; i++) {
    sumOutputs = sumOutputs + outputValues[i];
  }
  assert(sumInputs == sumOutputs);

  out <-- 1;
}
