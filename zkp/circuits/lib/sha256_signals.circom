// Copyright © 2025 Kaleido, Inc.
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

include "./kyber/sha2/sha256/sha256_hash_bits.circom";
include "../node_modules/circomlib/circuits/bitify.circom";

template sha256Signals(n) {
  signal input signals[n];
  signal output h0;
  signal output h1;

  // convert to bits
  component num2Bits[n];
  for (var i = 0; i < n; i++) {
    num2Bits[i] = Num2Bits(256);
    num2Bits[i].in <== signals[i];
  }
  // concatenate the bits
  var bitSize = n*256;
  var bits[bitSize];
  var offset = 0;
  for (var i = 0; i < n; i++) {
    var idx = 0;
    // for each of the signals, we need to reverse the bits
    // because the Num2Bits circuit outputs them in reverse order
    for (var j = 0; j < 256; j++) {
      bits[offset + idx] = num2Bits[i].out[255 - j];
      idx++;
    }
    offset += 256;
  }

  // use this safe sha256 implementation that produces
  // the output as 32 signals each for 8 bits
  signal h[32] <== Sha256_hash_bits_digest(n*256)(bits);

  // consolidate the output into two signals representing
  // the lower and higher 16 bytes of the hash. This is necessary
  // because the signals are field elements of 254 bits, so
  // may not fit some sha256 outputs.
  var sum = 0;
  for (var i = 0; i < 16; i++) {
      sum += h[i]*(1<<(8*i));
  }
  h0 <== sum;

  sum = 0;
  for (var i = 16; i < 32; i++) {
      sum += h[i]*(1<<(8*(i-16)));
  }
  h1 <== sum;
}