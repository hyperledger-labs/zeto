pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/poseidon.circom";

template TestPoseidonEx() {
  signal input inputs[4];
  signal output out[4];

  component poseidon = PoseidonEx(4, 4);
  poseidon.initialState <== 0;
  poseidon.inputs[0] <== inputs[0];
  poseidon.inputs[1] <== inputs[1];
  poseidon.inputs[2] <== inputs[2];
  poseidon.inputs[3] <== inputs[3];

  out[0] <== poseidon.out[0];
  out[1] <== poseidon.out[1];
  out[2] <== poseidon.out[2];
  out[3] <== poseidon.out[3];
}