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

//------------------------------------------------------------------------------

// function min(a,b) {
//   return (a <= b) ? a : b;
// }

//------------------------------------------------------------------------------

template KeccakSponge(level, capacity, input_len, output_len) {
  var w    = (1<<level);
  var bits = 25 * w;
  var rate = bits - capacity;

  assert(rate > 0   );
  assert(rate < bits);

  signal input  inp[ input_len];
  signal output out[output_len];

  // round up to rate the input + 2 bits ("10*1" padding)
  var nblocks    = ((input_len + 2) + (rate-1)) \ rate;
  var nout       = (output_len      + (rate-1)) \ rate;
  var padded_len = nblocks * rate;

  signal padded[padded_len];
  for(var i=0; i<input_len; i++) { padded[i] <== inp[i]; }
  padded[input_len   ] <== 1;
  padded[padded_len-1] <== 1;
  for(var i=input_len+1; i<padded_len-1; i++) { padded[i] <== 0; } 

  signal state[nblocks+nout][bits];
  signal xored[nblocks     ][rate];
 
  // initialize state
  for(var i=0; i<bits; i++) { state[0][i] <== 0; }

  component absorb [nblocks];
  component squeeze[nout-1];

  for(var m=0; m<nblocks; m++) {

    for(var i=0; i<rate; i++) {
      var a = state [m][i];
      var b = padded[m*rate+i];
      xored[m][i] <== a + b - 2*a*b;
    }
 
    absorb[m] = LinearizedKeccakF(level);
    for(var j=0   ; j<rate; j++) { absorb[m].inp[j] <== xored[m][j]; }
    for(var j=rate; j<bits; j++) { absorb[m].inp[j] <== state[m][j]; }
    absorb[m].out ==> state[m+1];

  }

  var q = min(rate, output_len);
  for(var i=0; i<q; i++) {
    state[nblocks][i] ==> out[i];
  }
  var out_ptr = rate;

  for(var n=1; n<nout; n++) {
    squeeze[n-1] = LinearizedKeccakF(level);
    squeeze[n-1].inp <== state[nblocks+n-1];
    squeeze[n-1].out ==> state[nblocks+n  ];

    var q = min(rate, output_len-out_ptr);
    for(var i=0; i<q; i++) {
      state[nblocks+n][i] ==> out[out_ptr+i];
    }
    out_ptr += rate;
  }

}
