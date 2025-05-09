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

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/comparators.circom";

template hash9Signals() {
  signal input signals[9];
  signal output out;

  component p1 = Poseidon(5);
  p1.inputs[0] <== signals[0];
  p1.inputs[1] <== signals[1];
  p1.inputs[2] <== signals[2];
  p1.inputs[3] <== signals[3];
  p1.inputs[4] <== signals[4];
  var p1out = p1.out;
  component p2 = Poseidon(5);
  p2.inputs[0] <== p1out;
  p2.inputs[1] <== signals[5];
  p2.inputs[2] <== signals[6];
  p2.inputs[3] <== signals[7];
  p2.inputs[4] <== signals[8];
  out <== p2.out;
}

template hash33Signals() {
  signal input signals[33];
  signal output out;

  // the first found hashes the first 3 signals
  component p1 = Poseidon(3);
  p1.inputs[0] <== signals[0];
  p1.inputs[1] <== signals[1];
  p1.inputs[2] <== signals[2];

  // we do 6 more rounds of Poseidon hashing,
  // each time taking the output of the previous round
  // and the next 5 signals as input
  var pOuts[7];
  pOuts[0] = p1.out;
  component p[6];
  for (var i = 0; i < 6; i++) {
    var offset = 3 + i * 5;
    p[i] = Poseidon(6);
    p[i].inputs[0] <== pOuts[i];
    p[i].inputs[1] <== signals[offset];
    p[i].inputs[2] <== signals[offset + 1];
    p[i].inputs[3] <== signals[offset + 2];
    p[i].inputs[4] <== signals[offset + 3];
    p[i].inputs[5] <== signals[offset + 4];
    pOuts[i + 1] = p[i].out;
  }
  out <== pOuts[6];
}