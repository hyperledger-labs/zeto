pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/bitify.circom";
include "../node_modules/circomlib/circuits/escalarmulany.circom";

// Use the EC Diffie-Hellman protocol to generate a shared secret using
// the receiver's public key and the sender's private key.
template Ecdh() {
    // Note: The private key needs to be hashed and then pruned first
    signal input privKey;
    signal input pubKey[2];

    signal output sharedKey[2];

    component privBits = Num2Bits(253);
    privBits.in <== privKey;

    // calculate the receiver's public key raised to the power of the sender's private key.
    // - Given the receiver's public key g^r ("r" is the receiver's private key)
    //   the shared secret is (g^r)^s ("s" is the sender's private key).
    // - The receiver can derive the same shared secret by raising the sender's public key
    //   to the power of the receiver's private key: (g^s)^r
    // - The shared secret is the same in both cases: g^(r*s) = g^(s*r)
    component mulFix = EscalarMulAny(253);
    mulFix.p[0] <== pubKey[0];
    mulFix.p[1] <== pubKey[1];

    for (var i = 0; i < 253; i++) {
        mulFix.e[i] <== privBits.out[i];
    }

    sharedKey[0] <== mulFix.out[0];
    sharedKey[1] <== mulFix.out[1];
}