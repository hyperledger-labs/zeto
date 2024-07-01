pragma circom 2.1.4;

include "../../../circuits/lib/check-nullifier-tokenid-uri.circom";

component main {public [ nullifiers, outputCommitments, outputOwnerPublicKeys, enabled ]} = CheckNullifierForTokenIdAndUri(1, 1, 64);