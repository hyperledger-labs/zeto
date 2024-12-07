pragma circom 2.2.1;

include "../node_modules/circomlib/circuits/poseidon.circom";

template TestPoseidonEx() {
  signal input inputs[4];
  signal output out[4];

  out <== PoseidonEx(4, 4)(initialState <== 0, inputs <== inputs);
}