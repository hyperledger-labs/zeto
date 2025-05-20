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

include "../sha2_common.circom";
include "sha256_padding.circom";
include "sha256_initial_value.circom";
include "sha256_schedule.circom";
include "sha256_rounds.circom";

//------------------------------------------------------------------------------
// Computes the SHA256 hash of a sequence of bits
// The output is 8 little-endian 32-bit words.
// See below for the more standard "digest" version

template Sha256_hash_bits(len) {

  signal input  inp_bits[len];            // `len` bits
  signal output hash_dwords[8][32];       // 256 bits, as 8 little-endian 32-bit words

  var nchunks = SHA2_224_256_compute_number_of_chunks(len);

  signal chunks[nchunks  ][512];
  signal states[nchunks+1][8][32];

  component pad = SHA2_224_256_padding(len);
  pad.inp <== inp_bits;
  pad.out ==> chunks;

  component iv = Sha256_initial_value();
  iv.out ==> states[0];

  component sch[nchunks]; 
  component rds[nchunks]; 

  for(var m=0; m<nchunks; m++) { 

    sch[m] = SHA2_224_256_schedule();
    rds[m] = SHA2_224_256_rounds(64); 

    for(var k=0; k<16; k++) {
      for(var i=0; i<32; i++) {
        sch[m].chunk_bits[k][i] <== chunks[m][ k*32 + (31-i) ];
      }
    }

    sch[m].out_words ==> rds[m].words;

    rds[m].inp_hash  <== states[m  ];
    rds[m].out_hash  ==> states[m+1];
  }

  hash_dwords <== states[nchunks];

}

//------------------------------------------------------------------------------
// Computes the SHA256 hash of a sequence of bits
// The output is 32 bytes in the standard order

template Sha256_hash_bits_digest(len) {

  signal input  inp_bits[len];      // `len` bits
  signal output hash_bytes[32];     // 32 bytes

  component sha = Sha256_hash_bits(len);
  component ser = DWordsToByteString(8);

  inp_bits        ==> sha.inp_bits;
  sha.hash_dwords ==> ser.inp;
  ser.out         ==> hash_bytes;
}

//------------------------------------------------------------------------------
