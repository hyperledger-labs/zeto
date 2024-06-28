pragma circom 2.1.4;

include "../../circuits/lib/ecdh.circom";

component main {public [ pubKey ]} = Ecdh();