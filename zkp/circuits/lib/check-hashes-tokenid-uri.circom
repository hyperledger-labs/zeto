pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/comparators.circom";

// CheckHashesForTokenIdAndUri is a circuit that checks the integrity of transactions of Non-Fungible Tokens (NFTs)
//   - it checks that the input commitments match the calculated hashes
//   - it checks that the output commitments match the calculated hashes
//   - it checks that the same tokenId and URI are used for the input and output commitments
//
// commitment = hash(tokenId, uri, salt, ownerAddress)
//
// tokenIds: array of token ids, as preimages for the input hashes and output hashes
// tokenUris: array of token uris, as preimages for the input hashes and output hashes
// input commitments: array of hashes for the input utxos
// output commitments: array of hashes for the output utxos
//
template CheckHashesForTokenIdAndUri(numInputs, numOutputs) {
  signal input tokenIds[numInputs];
  signal input tokenUris[numInputs];
  signal input inputCommitments[numInputs];
  signal input inputSalts[numInputs];
  signal input inputOwnerPublicKey[2];
  signal input outputCommitments[numOutputs];
  signal input outputSalts[numOutputs];
  signal input outputOwnerPublicKeys[numOutputs][2];
  signal output out;

  // hash the input values
  component inputHashes[numInputs];
  var calculatedInputHashes[numInputs];
  for (var i = 0; i < numInputs; i++) {
    // perform the hash calculation even though they are not needed when the input 
    // commitment at the current index is 0; this is because in zkp circuits we
    // must always perform the same computation (have the the same constraints)
    inputHashes[i] = Poseidon(5);
    inputHashes[i].inputs[0] <== tokenIds[i];
    inputHashes[i].inputs[1] <== tokenUris[i];
    inputHashes[i].inputs[2] <== inputSalts[i];
    inputHashes[i].inputs[3] <== inputOwnerPublicKey[0];
    inputHashes[i].inputs[4] <== inputOwnerPublicKey[1];
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
    outputHashes[i] = Poseidon(5);
    outputHashes[i].inputs[0] <== tokenIds[i];
    outputHashes[i].inputs[1] <== tokenUris[i];
    outputHashes[i].inputs[2] <== outputSalts[i];
    outputHashes[i].inputs[3] <== outputOwnerPublicKeys[i][0];
    outputHashes[i].inputs[4] <== outputOwnerPublicKeys[i][1];
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

  out <-- 1;
}
