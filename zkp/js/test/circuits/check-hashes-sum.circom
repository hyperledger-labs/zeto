pragma circom 2.1.4;

include "../../../circuits/lib/check-hashes-sum.circom";

component main {public [ inputCommitments, inputOwnerPublicKey, outputCommitments, outputOwnerPublicKeys ]} = CheckHashesAndSum(2, 2);