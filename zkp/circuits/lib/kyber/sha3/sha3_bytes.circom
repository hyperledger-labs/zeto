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

include "sha3_bits.circom";
include "./util.circom";

//------------------------------------------------------------------------------
// NIST SHA3 hash functions

template SHA3_224_bytes(input_len) {
  signal input  inp_bytes[input_len];
  signal output out_bytes[28];

  component unpack = UnpackBytes(input_len);
  component sha3   = SHA3_224(input_len*8);
  component pack   = PackBytes(28);

  inp_bytes   ==> unpack.bytes;
  unpack.bits ==> sha3.inp;
  sha3.out    ==> pack.bits;
  pack.bytes  ==> out_bytes;
}

//--------------------------------------

template SHA3_256_bytes(input_len) {
  signal input  inp_bytes[input_len];
  signal output out_bytes[32];

  component unpack = UnpackBytes(input_len);
  component sha3   = SHA3_256(input_len*8);
  component pack   = PackBytes(32);

  inp_bytes   ==> unpack.bytes;
  unpack.bits ==> sha3.inp;
  sha3.out    ==> pack.bits;
  pack.bytes  ==> out_bytes;
}

//--------------------------------------

template SHA3_384_bytes(input_len) {
  signal input  inp_bytes[input_len];
  signal output out_bytes[48];

  component unpack = UnpackBytes(input_len);
  component sha3   = SHA3_384(input_len*8);
  component pack   = PackBytes(48);

  inp_bytes   ==> unpack.bytes;
  unpack.bits ==> sha3.inp;
  sha3.out    ==> pack.bits;
  pack.bytes  ==> out_bytes;
}

//--------------------------------------

template SHA3_512_bytes(input_len) {
  signal input  inp_bytes[input_len];
  signal output out_bytes[64];

  component unpack = UnpackBytes(input_len);
  component sha3   = SHA3_512(input_len*8);
  component pack   = PackBytes(64);

  inp_bytes   ==> unpack.bytes;
  unpack.bits ==> sha3.inp;
  sha3.out    ==> pack.bits;
  pack.bytes  ==> out_bytes;
}

//------------------------------------------------------------------------------
// NIST SHA3 Extendable-Output Functions

template SHAKE128_bytes(input_len, output_len) {
  signal input  inp_bytes[input_len];
  signal output out_bytes[output_len];

  component unpack = UnpackBytes(input_len);
  component sha3   = SHAKE128(input_len*8, output_len*8);
  component pack   = PackBytes(output_len);

  inp_bytes   ==> unpack.bytes;
  unpack.bits ==> sha3.inp;
  sha3.out    ==> pack.bits;
  pack.bytes  ==> out_bytes;
}

//--------------------------------------

template SHAKE256_bytes(input_len, output_len) {
  signal input  inp_bytes[input_len];
  signal output out_bytes[output_len];

  component unpack = UnpackBytes(input_len);
  component sha3   = SHAKE256(input_len*8, output_len*8);
  component pack   = PackBytes(output_len);

  inp_bytes   ==> unpack.bytes;
  unpack.bits ==> sha3.inp;
  sha3.out    ==> pack.bits;
  pack.bytes  ==> out_bytes;
}
