pragma circom 2.2.2;

include "../node_modules/circomlib/circuits/poseidon.circom";

template TestPoseidon() {
  signal input a;
  signal input b;
  signal input c;
  signal output out;

  out <== Poseidon(3)(inputs <== [a, b, c]);
}