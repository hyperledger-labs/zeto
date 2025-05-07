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

include "../node_modules/circomlib/circuits/sha256/sha256.circom";
include "../node_modules/circomlib/circuits/bitify.circom";

template sha256Signals(n) {
  signal input signals[n];
  signal output out;

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

  // hash the bits
  component sha256 = Sha256(bitSize);
  sha256.in <== bits;

  // because the output signal, being a field element, is only 254 bits,
  // we disgard the last 2 bits of the hash output. This needs to be
  // taken into account when buildng the hash for verification
  component bits2num = Bits2Num(254);
  for (var i = 0; i < 254; i++) {
    bits2num.in[i] <== sha256.out[255 - i];
  }
  bits2num.out ==> out;
}