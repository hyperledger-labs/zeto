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

func TestHashTokenUri(t *testing.T) {
	tokenUri := "https://example.com/token/1001"
	hash, err := HashTokenUri(tokenUri)
	assert.NoError(t, err)
	check, ok := new(big.Int).SetString("13892450975113644983085716506756448401911601901613040705635669994423608913168", 10)
	assert.True(t, ok)
	assert.Equal(t, check, hash)
}

func TestNonFungibleUTXOs(t *testing.T) {
	x, _ := new(big.Int).SetString("14071052441699386420964762094868612757480677741190253249248703784837194954083", 10)
	y, _ := new(big.Int).SetString("10144222387217718469257170015212761087909907436961262709512987264580109747792", 10)
	alice := &babyjub.PublicKey{
		X: x,
		Y: y,
	}
	salt, _ := new(big.Int).SetString("14366367216420666010683918465570547601749064763665615379119566396413295472937", 10)
	uri, err := HashTokenUri("http://ipfs.io/file-hash-1")
	assert.NoError(t, err)
	utxo1 := NewNonFungible(big.NewInt(1001), uri, alice, salt)

	idx1, err := utxo1.CalculateIndex()
	assert.NoError(t, err)
	assert.Equal(t, "14387265223978393188138799516680159264477343701050531343910120918831961837958", idx1.BigInt().String())
}
