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

include "fast_compconstant.circom";

// assumes 1 < q <= 2^252, 0 <= in <= 2^252
template parallel Mod(q) {
    signal input in;
    signal output out;

    out <== ModBound(q, 1 << 252)(in);
}

// return in % q, given that 0 <= in <= b
// assumes 1 < q <= 2^252, 0 <= b <= 2^252
template ModBound(q, b) {
    signal input in;
    signal quotient;
    signal output out;

    quotient <-- in \ q;
    out <-- in % q;

    LtConstant(q)(out);

    var bound_quot = b \ q + 1;
    LtConstant(bound_quot)(quotient);

    in === quotient * q + out;
}

template parallel FastAddMod(q) {
    signal input in[2]; // both inputs need to be in Z/qZ
    signal sum <== in[0] + in[1];
    signal quotient <-- sum \ q; // quotient is either 0 or 1
    signal output out <-- sum % q;

    LtConstant(q)(out); // Check that remainder is less than q
    quotient * q + out === sum; // Check that quotient and remainder are correct
    quotient * (quotient - 1) === 0; // Check that quotient is in {0, 1}
}

template parallel FastSubMod(q) {
    signal input in[2]; // both inputs need to be in Z/qZ
    signal sub <== in[0] + q - in[1];
    signal quotient <-- sub \ q; // quotient is either 0 or 1
    signal output out <-- sub % q;

    LtConstant(q)(out); // Check that remainder is less than q
    quotient * q + out === sub; // Check that quotient and remainder are correct
    quotient * (quotient - 1) === 0; // Check that quotient is in {0, 1}
}

// compute round((q*in)/Q) mod q
template ModSwitchInt(q, Q) {
    assert(log2(q)+log2(Q) < 252);
    signal input in;
    signal output out;
    
    signal prod <== q * in;
    signal quot <-- prod \ Q;
    signal rem <-- prod % Q;

    prod === Q * quot + rem; // correct division
    LtConstant(Q)(rem); // rem < Q
    LtConstant(q)(quot); // quot < q

    var nbits = log2(Q)+1;
    signal {binary} rem2_bits[nbits] <== Num2Bits(nbits)(2*rem);

    signal {binary} bit_add <== IsGeqtConstant(Q, nbits)(rem2_bits);

    // total <== quot + (2*rem < Q) ? 0 : 1
    signal total <== quot + bit_add;

    // reduce mod q
    signal {binary} iszero <== IsEqual()([total, q]);
    out <== (1-iszero)*total;
}