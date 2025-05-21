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

include "keccak_bits.circom";

//------------------------------------------------------------------------------

template UnpackBytes(n) {
  signal input  bytes[n];
  signal output bits[8*n];

  component tobits[n];

  for(var j=0; j<n; j++) {
    tobits[j] = ToBits(8);
    tobits[j].inp <== bytes[j];
    for(var i=0; i<8; i++) {
      tobits[j].out[i] ==> bits[ j*8 + i ];
    }
  }
}

//--------------------------------------

template PackBytes(n) {
  signal input  bits[8*n];
  signal output bytes[n];

  for(var k=0; k<n; k++) {
    var sum = 0;
    for(var i=0; i<8; i++) {
      sum += bits[ 8*k + i ] * (1<<i);
    }
    bytes[k] <== sum;
  }
}
  
//------------------------------------------------------------------------------
// Keccak hash functions

template Keccak_224_bytes(input_len) {
  signal input  inp_bytes[input_len];
  signal output out_bytes[28];

  component unpack = UnpackBytes(input_len);
  component keccak = Keccak_224(input_len*8);
  component pack   = PackBytes(28);

  inp_bytes   ==> unpack.bytes;
  unpack.bits ==> keccak.inp;
  keccak.out  ==> pack.bits;
  pack.bytes  ==> out_bytes;
}

//--------------------------------------

template Keccak_256_bytes(input_len) {
  signal input  inp_bytes[input_len];
  signal output out_bytes[32];

  component unpack = UnpackBytes(input_len);
  component keccak = Keccak_256(input_len*8);
  component pack   = PackBytes(32);

  inp_bytes   ==> unpack.bytes;
  unpack.bits ==> keccak.inp;
  keccak.out  ==> pack.bits;
  pack.bytes  ==> out_bytes;
}

//--------------------------------------

template Keccak_384_bytes(input_len) {
  signal input  inp_bytes[input_len];
  signal output out_bytes[48];

  component unpack = UnpackBytes(input_len);
  component keccak = Keccak_384(input_len*8);
  component pack   = PackBytes(48);

  inp_bytes   ==> unpack.bytes;
  unpack.bits ==> keccak.inp;
  keccak.out  ==> pack.bits;
  pack.bytes  ==> out_bytes;
}

//--------------------------------------

template Keccak_512_bytes(input_len) {
  signal input  inp_bytes[input_len];
  signal output out_bytes[64];

  component unpack = UnpackBytes(input_len);
  component keccak = Keccak_512(input_len*8);
  component pack   = PackBytes(64);

  inp_bytes   ==> unpack.bytes;
  unpack.bits ==> keccak.inp;
  keccak.out  ==> pack.bits;
  pack.bytes  ==> out_bytes;
}