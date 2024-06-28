pragma circom 2.1.4;

include "../../../circuits/lib/check-hashes-tokenid-uri.circom";

component main {public [ inputCommitments, inputOwnerPublicKey, outputCommitments, outputOwnerPublicKeys ]} = CheckHashesForTokenIdAndUri(1, 1);