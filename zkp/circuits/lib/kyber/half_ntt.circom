// Copyright 2025 Guru Vamsi Policharla
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

include "util.circom";
include "mod.circom";
include "fast_compconstant.circom";

// half NTT from Kyber spec. We store intermediate values at each layer and place constraints between consecutive layers.
// If we ensure the inputs come from the correct field, then we can delay the modular reduction until the end.
// This is because we start with 12 bit valyes and at each layer they only grow by at most 12 bits -- and there are 7 layers
// The proof systems field size is ~256 bits
// todo: estimate the correct bit limit
// NOTE: assumed the inputs are in the correct field
template parallel halfNTT() {
    var n = 256;

    signal input p[n]; //the polynomial to be NTT-ed
    signal output out[n];

    var q = 3329;
    var zetas[128] = [ 1, 1729, 2580, 3289, 2642, 630, 1897, 848, 1062, 1919, 193, 797, 2786, 3260, 569, 1746, 296, 2447, 1339, 1476, 3046, 56, 2240, 1333, 1426, 2094, 535, 2882, 2393, 2879, 1974, 821, 289, 331,3253, 1756, 1197, 2304, 2277, 2055, 650, 1977, 2513, 632, 2865, 33, 1320, 1915, 2319, 1435, 807, 452, 1438, 2868, 1534, 2402, 2647, 2617, 1481, 648, 2474, 3110, 1227, 910, 17, 2761, 583, 2649, 1637, 723, 2288, 1100, 1409, 2662, 3281, 233, 756, 2156, 3015, 3050, 1703, 1651, 2789, 1789, 1847, 952, 1461, 2687, 939, 2308, 2437, 2388, 733, 2337, 268, 641, 1584, 2298, 2037, 3220, 375, 2549, 2090, 1645, 1063, 319, 2773, 757, 2099, 561, 2466, 2594, 2804, 1092, 403, 1026, 1143, 2150, 2775, 886, 1722, 1212, 1874, 1029, 2110, 2935, 885, 2154];
    var neg_zetas[128] = [3328, 1600, 749, 40, 687, 2699, 1432, 2481, 2267, 1410, 3136, 2532, 543, 69, 2760, 1583, 3033, 882, 1990, 1853, 283, 3273, 1089, 1996, 1903, 1235, 2794, 447, 936, 450, 1355, 2508, 3040, 2998, 76, 1573, 2132, 1025, 1052, 1274, 2679, 1352, 816, 2697, 464, 3296, 2009, 1414, 1010, 1894, 2522, 2877, 1891, 461, 1795, 927, 682, 712, 1848, 2681, 855, 219, 2102, 2419, 3312, 568, 2746, 680, 1692, 2606, 1041, 2229, 1920, 667, 48, 3096, 2573, 1173, 314, 279, 1626, 1678, 540, 1540, 1482, 2377, 1868, 642, 2390, 1021, 892, 941, 2596, 992, 3061, 2688, 1745, 1031, 1292, 109, 2954, 780, 1239, 1684, 2266, 3010, 556, 2572, 1230, 2768, 863, 735, 525, 2237, 2926, 2303, 2186, 1179, 554, 2443, 1607, 2117, 1455, 2300, 1219, 394, 2444, 1175];

    // intermediate values at each layer of the FFT
    // (input) f[7] -> f[6] -> f[5] -> f[4] -> f[3] -> f[2] -> f[1] -> f[0] (out)
    signal f[8][n];
    for (var i = 0; i < n; i++) {
        f[7][i] <== p[i];
    }

    var i = 0;
    for (var l = 7; l >= 1; l--) {
        var len = 1 << l;
        for (var start = 0; start < 256; start += 2*len) {
            i++;
            for (var j = start; j < start + len; j++) {
                f[l-1][j + len] <== f[l][j] + neg_zetas[i] * f[l][j + len];
                f[l-1][j] <== f[l][j] + zetas[i] * f[l][j + len];
            }            
        }
    }

    // Final reduction mod q
    for (var i = 0; i < n; i++) {
        out[i] <== ModBound(q, (1 << 92))(f[0][i]);
    }
}

// inverse half NTT
// todo: estimate the correct bit limit
// NOTE: assumed the inputs are in the correct field
template parallel inv_halfNTT() {
    var n = 256;

    signal input p[n]; //the polynomial to be NTT-ed
    signal output out[n];

    var q = 3329;
    var zetas[128] = [ 1, 1729, 2580, 3289, 2642, 630, 1897, 848, 1062, 1919, 193, 797, 2786, 3260, 569, 1746, 296, 2447, 1339, 1476, 3046, 56, 2240, 1333, 1426, 2094, 535, 2882, 2393, 2879, 1974, 821, 289, 331,3253, 1756, 1197, 2304, 2277, 2055, 650, 1977, 2513, 632, 2865, 33, 1320, 1915, 2319, 1435, 807, 452, 1438, 2868, 1534, 2402, 2647, 2617, 1481, 648, 2474, 3110, 1227, 910, 17, 2761, 583, 2649, 1637, 723, 2288, 1100, 1409, 2662, 3281, 233, 756, 2156, 3015, 3050, 1703, 1651, 2789, 1789, 1847, 952, 1461, 2687, 939, 2308, 2437, 2388, 733, 2337, 268, 641, 1584, 2298, 2037, 3220, 375, 2549, 2090, 1645, 1063, 319, 2773, 757, 2099, 561, 2466, 2594, 2804, 1092, 403, 1026, 1143, 2150, 2775, 886, 1722, 1212, 1874, 1029, 2110, 2935, 885, 2154];
    var neg_zetas[128] = [3328, 1600, 749, 40, 687, 2699, 1432, 2481, 2267, 1410, 3136, 2532, 543, 69, 2760, 1583, 3033, 882, 1990, 1853, 283, 3273, 1089, 1996, 1903, 1235, 2794, 447, 936, 450, 1355, 2508, 3040, 2998, 76, 1573, 2132, 1025, 1052, 1274, 2679, 1352, 816, 2697, 464, 3296, 2009, 1414, 1010, 1894, 2522, 2877, 1891, 461, 1795, 927, 682, 712, 1848, 2681, 855, 219, 2102, 2419, 3312, 568, 2746, 680, 1692, 2606, 1041, 2229, 1920, 667, 48, 3096, 2573, 1173, 314, 279, 1626, 1678, 540, 1540, 1482, 2377, 1868, 642, 2390, 1021, 892, 941, 2596, 992, 3061, 2688, 1745, 1031, 1292, 109, 2954, 780, 1239, 1684, 2266, 3010, 556, 2572, 1230, 2768, 863, 735, 525, 2237, 2926, 2303, 2186, 1179, 554, 2443, 1607, 2117, 1455, 2300, 1219, 394, 2444, 1175];

    // intermediate values at each layer of the FFT
    // (input) f[0] -> f[1] -> f[2] -> f[3] -> f[4] -> f[5] -> f[6] -> f[7] (out)
    signal f[8][n];
    for (var i = 0; i < n; i++) {
        f[0][i] <== p[i];
    }

    var i = 128;
    for (var l = 1; l <= 7; l++) {
        var len = 1 << l;
        for (var start = 0; start < 256; start += 2*len) {
            i--;
            for (var j = start; j < start + len; j++) {
                f[l][j] <== f[l-1][j] + f[l-1][j + len];
                f[l][j + len] <== zetas[i] * f[l-1][j + len] + neg_zetas[i] * f[l-1][j];
            }            
        }
    }

    // Final reduction mod q
    for (var i = 0; i < n; i++) {
        out[i] <== ModBound(q, (1 << 105))(3303 * f[7][i]);
    }
}

// multiply two NTTed vectors
// NOTE: assumed the inputs are in the correct field
template multiply_nttvec() {
    var n = 256;

    signal input in1[n];
    signal input in2[n]; 
    
    signal temp[n];
    signal temp1[n/2];
    signal temp2[n/2];
    signal temp3[n/2];

    signal output out[n];

    var q = 3329;
    var gamma[n/2] = [17, 3312, 2761, 568, 583, 2746, 2649, 680, 1637, 1692, 723, 2606, 2288, 1041, 1100, 2229, 1409, 1920, 2662, 667, 3281, 48, 233, 3096, 756, 2573, 2156, 1173, 3015, 314, 3050, 279, 1703, 1626, 1651, 1678, 2789, 540, 1789, 1540, 1847, 1482, 952, 2377, 1461, 1868, 2687, 642, 939, 2390, 2308, 1021, 2437, 892, 2388, 941, 733, 2596, 2337, 992, 268, 3061, 641, 2688, 1584, 1745, 2298, 1031, 2037, 1292, 3220, 109, 375, 2954, 2549, 780, 2090, 1239, 1645, 1684, 1063, 2266, 319, 3010, 2773, 556, 757, 2572, 2099, 1230, 561, 2768, 2466, 863, 2594, 735, 2804, 525, 1092, 2237, 403, 2926, 1026, 2303, 1143, 2186, 2150, 1179, 2775, 554, 886, 2443, 1722, 1607, 1212, 2117, 1874, 1455, 1029, 2300, 2110, 1219, 2935, 394, 885, 2444, 2154, 1175];

    for (var i=0; i<n/2; i++) {
        temp1[i] <== in1[2*i + 1] * in2[2*i + 1];
        temp2[i] <== gamma[i] * temp1[i];
        temp3[i] <== in1[2*i + 1] * in2[2*i];

        temp[2*i] <== (in1[2*i] * in2[2*i]) + temp2[i];
        temp[2*i + 1] <== (in1[2*i] * in2[2*i + 1]) + temp3[i];
    }

    // Final reduction mod q
    for (var i = 0; i < n; i++) {
        out[i] <== ModBound(q, (1 << 36))(temp[i]);
    }
}