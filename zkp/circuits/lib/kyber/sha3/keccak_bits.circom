pragma circom 2.1.0;

include "keccak-p.circom";
include "sponge.circom";

//------------------------------------------------------------------------------
// Keccak hash functions

template Keccak_224(input_len) {
  signal input  inp[input_len];
  signal output out[224];
  component sponge = KeccakSponge(6, 448, input_len, 224);
  sponge.inp <== inp;
  sponge.out ==> out;
}

//--------------------------------------

template Keccak_256(input_len) {
  signal input  inp[input_len];
  signal output out[256];
  component sponge = KeccakSponge(6, 512, input_len, 256);
  sponge.inp <== inp;
  sponge.out ==> out;
}

//--------------------------------------

template Keccak_384(input_len) {
  signal input  inp[input_len];
  signal output out[384];
  component sponge = KeccakSponge(6, 768, input_len, 384);
  sponge.inp <== inp;
  sponge.out ==> out;
}

//--------------------------------------

template Keccak_512(input_len) {
  signal input  inp[input_len];
  signal output out[512];
  component sponge = KeccakSponge(6, 1024, input_len, 512);
  sponge.inp <== inp;
  sponge.out ==> out;
}
