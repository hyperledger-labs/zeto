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

include "../../../common/util.circom";

//------------------------------------------------------------------------------
// compute the number of chunks

function SHA2_224_256_compute_number_of_chunks(len_bits) {
  var nchunks = ((len_bits + 1 + 64) + 511) \ 512;
  return nchunks;  
}

//------------------------------------------------------------------------------
// padding for SHA2-224 and SHA2-256 (they are the same)
// NOTE: `len` should be given as the number of *bits* 

template SHA2_224_256_padding(len) {

  var nchunks = SHA2_224_256_compute_number_of_chunks(len);
  var nbits   = nchunks * 512;

  signal input  inp[len];           
  signal output out[nchunks][512];

  for(var i=0; i<len; i++) {
    inp[i] ==> out[i\512][i%512];
  }

  out[len\512][len%512] <== 1;
  for(var i=len+1; i<nbits-64; i++) { out[i\512][i%512] <== 0; }

  component len_tb = ToBits(64);
  len_tb.inp <== len;
  for(var j=0; j<64; j++) { 
    var i = nbits - 64 + j;
    out[i\512][i%512] <== len_tb.out[63-j];
  }

}

//------------------------------------------------------------------------------
