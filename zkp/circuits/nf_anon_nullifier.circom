pragma circom 2.1.4;

include "./lib/check-nullifier-tokenid-uri.circom";
include "./lib/ecdh.circom";
include "./lib/encrypt.circom";
include "./node_modules/circomlib/circuits/babyjub.circom";

// This version of the circuit performs the following operations:
// - derive the sender's public key from the sender's private key
// - check the input and output commitments match the expected hashes
// - check the input and output values sum to the same amount
// - check the nullifiers are derived from the input commitments and the sender's private key
// - check the nullifiers are included in the Merkle tree
template Zeto(nSMTLevels) {
  signal input tokenId;
  signal input tokenUri;
  signal input nullifier;
  signal input inputCommitment;
  signal input inputSalt;
  // must be properly hashed and trimmed to be compatible with the BabyJub curve.
  // Reference: https://github.com/iden3/circomlib/blob/master/test/babyjub.js#L103
  signal input inputOwnerPrivateKey;
  signal input root;
  signal input merkleProof[nSMTLevels];
  signal input outputCommitment;
  signal input outputOwnerPublicKey[2];
  signal input outputSalt;

  // var nullifiers = [nullifier];

  component checkHashesSum = CheckNullifierForTokenIdAndUri(1, 1, nSMTLevels);
  checkHashesSum.nullifiers <== [nullifier];
  checkHashesSum.inputCommitments <== [inputCommitment];
  checkHashesSum.tokenIds <== [tokenId];
  checkHashesSum.tokenUris <== [tokenUri];
  checkHashesSum.inputSalts <== [inputSalt];
  checkHashesSum.inputOwnerPrivateKey <== inputOwnerPrivateKey;
  checkHashesSum.root <== root;
  checkHashesSum.merkleProof <== [merkleProof];
  checkHashesSum.enabled <== [1];
  checkHashesSum.outputCommitments <== [outputCommitment];
  checkHashesSum.outputSalts <== [outputSalt];
  checkHashesSum.outputOwnerPublicKeys <== [outputOwnerPublicKey];
  // assert successful output
  checkHashesSum.out === 1;
}

component main { public [ nullifier, outputCommitment, root ] } = Zeto(64);