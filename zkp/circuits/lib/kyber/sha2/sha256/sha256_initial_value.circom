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

//------------------------------------------------------------------------------
// initial hash value for SHA2-256 

template Sha256_initial_value() {

  signal output out[8][32];

  var initial_state[8] =  
        [ 0x6a09e667
        , 0xbb67ae85
        , 0x3c6ef372
        , 0xa54ff53a
        , 0x510e527f
        , 0x9b05688c
        , 0x1f83d9ab
        , 0x5be0cd19
        ];

  for(var k=0; k<8; k++) { 
    for(var i=0; i<32; i++) {
      out[k][i] <== (initial_state[k] >> i) & 1; 
    }
  }

}
