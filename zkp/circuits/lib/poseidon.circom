pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/poseidon.circom";

template TestPoseidon() {
  signal input a;
  signal input b;
  signal input c;
  signal output out;

  component poseidon = Poseidon(3);
  poseidon.inputs[0] <== a;
  poseidon.inputs[1] <== b;
  poseidon.inputs[2] <== c;

  out <== poseidon.out;
}