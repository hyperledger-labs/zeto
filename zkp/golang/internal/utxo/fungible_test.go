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

package utxo

import (
	"math/big"
	"testing"

	"github.com/iden3/go-iden3-crypto/babyjub"
	"github.com/stretchr/testify/assert"
)

func TestFungibleUTXOs(t *testing.T) {
	x, _ := new(big.Int).SetString("825008057393653951717923193550498143270634388542414913039278922773034837543", 10)
	y, _ := new(big.Int).SetString("12283738323983038985315025769936102865095332379710901215078187917699827946177", 10)
	alice := &babyjub.PublicKey{
		X: x,
		Y: y,
	}
	salt, _ := new(big.Int).SetString("13de02d64a5736a56b2d35d2a83dd60397ba70aae6f8347629f0960d4fee5d58", 16)
	utxo1 := NewFungible(big.NewInt(10), alice, salt)

	idx1, err := utxo1.CalculateIndex()
	assert.NoError(t, err)
	assert.Equal(t, "26e3879b46b15a4ddbaca5d96af1bd2743f67f13f0bb85c40782950a2a700138", idx1.BigInt().Text(16))
}
