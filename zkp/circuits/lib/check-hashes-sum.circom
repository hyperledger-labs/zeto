pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/comparators.circom";

// CheckHashesAndSum is a circuit that checks the integrity of transactions of Fungible Tokens
//   - check that all output values are positive numbers (within the range of 0 to 2^40)
//   - check that the input commitments are the hash of the input values
//   - check that the output commitments are the hash of the output values
//   - check that the sum of input values equals the sum of output values
//
// input commitments: array of hashes for the input utxos
// inputValues: array of values, as preimages for the input hashes, for the input utxos
// output commitments: array of hashes for the output utxos
// outputValues: array of values, as preimages for the output hashes, for the output utxos
//
// commitment = hash(value, salt, ownerAddress)
//
template CheckHashesAndSum(numInputs, numOutputs) {
  signal input inputCommitments[numInputs];
  signal input inputValues[numInputs];
  signal input inputSalts[numInputs];
  signal input inputOwnerPublicKey[2];
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
