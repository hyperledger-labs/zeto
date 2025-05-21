//
// SPDX-License-Identifier: Apache-2.0
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
pragma circom 2.2.2;

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
