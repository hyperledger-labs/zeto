// Copyright © 2024 Kaleido, Inc.
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

package smt

import (
	"math/big"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestNodeIndex(t *testing.T) {
	idx0, _ := NewNodeIndexFromBigInt(big.NewInt(0))
	assert.Equal(t, "0000000000000000000000000000000000000000000000000000000000000000", idx0.Hex())
	idx1, _ := NewNodeIndexFromBigInt(big.NewInt(1))
	assert.Equal(t, "0100000000000000000000000000000000000000000000000000000000000000", idx1.Hex())
	idx2, _ := NewNodeIndexFromBigInt(big.NewInt(10))
	assert.Equal(t, "0a00000000000000000000000000000000000000000000000000000000000000", idx2.Hex())

	idx3, _ := NewNodeIndexFromBigInt(big.NewInt(12345678))
	assert.Equal(t, "4e61bc0000000000000000000000000000000000000000000000000000000000", idx3.Hex())

	v4, _ := new(big.Int).SetString("4932297968297298434239270129193057052722409868268166443802652458940273154854", 10)
	idx4, _ := NewNodeIndexFromBigInt(v4)
	assert.Equal(t, "265baaf161e875c372d08e50f52abddc01d32efc93e90290bb8b3d9ceb94e70a", idx4.Hex())
	expectedBytes4 := []byte{38, 91, 170, 241, 97, 232, 117, 195, 114, 208, 142, 80, 245, 42, 189, 220, 1, 211, 46, 252, 147, 233, 2, 144, 187, 139, 61, 156, 235, 148, 231, 10}
	rawIndex4 := idx4.(*nodeIndex)
	assert.Equal(t, expectedBytes4, rawIndex4[:])

	idx5, err := NewNodeIndexFromHex("265baaf161e875c372d08e50f52abddc01d32efc93e90290bb8b3d9ceb94e70a")
	assert.NoError(t, err)
	assert.Equal(t, 0, v4.Cmp(idx5.BigInt()))
}
