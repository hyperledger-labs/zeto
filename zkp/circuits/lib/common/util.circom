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

function min(x, y) {
    if (x > y) {
        return y;
    } else {
        return x;
    }
}

function max(x, y) {
    if (x > y) {
        return x;
    } else {
        return y;
    }
}

// assumes 0 <= a <= 2^252
function log2(a) {
    return logb(a, 2);
}

// assumes 0 <= a <= b^k where k is the largest integer such that b^k < p/2,
// where p is circom's prime
function logb(a, b) {
    if (a==0) {
        return 0;
    }
    var n = 1;
    var r = 0;
    while (n<a) {
        r++;
        n *= b;
    }
    return r;
}

function extended_gcd(a, b) {
    var old_r = a; 	var r = b;
    var old_s = 1; 	var s = 0;
    var old_t = 0; 	var t = 1;
    var quotient;
    
    while (r != 0) {
        quotient = old_r \ r;
        old_r = r; r = old_r - quotient * r;
        old_s = s; s = old_s - quotient * s;
        old_t = t; t = old_t - quotient * t;
    }
    
    return [old_s, old_t]; // old_s * a + old_t * b == 1
}

template ToBits(n) {
  signal input  inp;
  signal output out[n];

  var sum = 0;
  for(var i=0; i<n; i++) {
    out[i] <-- (inp >> i) & 1;
    out[i] * (1-out[i]) === 0;
    sum += (1<<i) * out[i];
  }

  inp === sum;
}

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