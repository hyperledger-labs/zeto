pragma circom 2.1.0;

include "keccak-p.circom";
include "sponge.circom";

//------------------------------------------------------------------------------
// NIST SHA3 hash functions

template SHA3_224(input_len) {
  signal input  inp[input_len];
  signal output out[224];
  component sponge = KeccakSponge(6, 448, input_len+2, 224);
  for(var i=0; i<input_len; i++) { sponge.inp[i] <== inp[i]; }
  sponge.inp[input_len  ] <== 0;
  sponge.inp[input_len+1] <== 1;  // NIST suffix
  sponge.out ==> out;
}

//--------------------------------------

template SHA3_256(input_len) {
  signal input  inp[input_len];
  signal output out[256];
  component sponge = KeccakSponge(6, 512, input_len+2, 256);
  for(var i=0; i<input_len; i++) { sponge.inp[i] <== inp[i]; }
  sponge.inp[input_len  ] <== 0;
  sponge.inp[input_len+1] <== 1;  
  sponge.out ==> out;
}

//--------------------------------------

template SHA3_384(input_len) {
  signal input  inp[input_len];
  signal output out[384];
  component sponge = KeccakSponge(6, 768, input_len+2, 384);
  for(var i=0; i<input_len; i++) { sponge.inp[i] <== inp[i]; }
  sponge.inp[input_len  ] <== 0;
  sponge.inp[input_len+1] <== 1;  
  sponge.out ==> out;
}

//--------------------------------------

template SHA3_512(input_len) {
  signal input  inp[input_len];
  signal output out[512];
  component sponge = KeccakSponge(6, 1024, input_len+2, 512);
  for(var i=0; i<input_len; i++) { sponge.inp[i] <== inp[i]; }
  sponge.inp[input_len  ] <== 0;
  sponge.inp[input_len+1] <== 1;  
  sponge.out ==> out;
}

//------------------------------------------------------------------------------
// NIST SHA3 Extendable-Output Functions

template SHAKE128(input_len, output_len) {
  signal input  inp[input_len];
  signal output out[output_len];
  component sponge = KeccakSponge(6, 256, input_len+4, output_len);
  for(var i=0; i<input_len; i++) { sponge.inp[i] <== inp[i]; }
  sponge.inp[input_len  ] <== 1;
  sponge.inp[input_len+1] <== 1;  
  sponge.inp[input_len+2] <== 1;  
  sponge.inp[input_len+3] <== 1;  
  sponge.out ==> out;
}

//--------------------------------------

template SHAKE256(input_len, output_len) {
  signal input  inp[input_len];
  signal output out[output_len];
  component sponge = KeccakSponge(6, 512, input_len+4, output_len);
  for(var i=0; i<input_len; i++) { sponge.inp[i] <== inp[i]; }
  sponge.inp[input_len  ] <== 1;
  sponge.inp[input_len+1] <== 1;  
  sponge.inp[input_len+2] <== 1;  
  sponge.inp[input_len+3] <== 1;  
  sponge.out ==> out;
}
