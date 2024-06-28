pragma circom 2.1.4;

include "../../../circuits/lib/check-nullifier-hashes-sum.circom";

component main {public [ nullifiers, outputCommitments, outputOwnerPublicKeys, enabled ]} = CheckNullifierHashesAndSum(2, 2, 64);