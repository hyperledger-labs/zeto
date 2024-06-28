pragma circom 2.1.4;

include "../../circuits/lib/encrypt.circom";

component main {public [ nonce ]} = SymmetricEncrypt(2);