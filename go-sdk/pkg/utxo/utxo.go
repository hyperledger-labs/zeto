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
	"crypto/rand"
	"fmt"
	"math/big"

	"github.com/hyperledger-labs/zeto/go-sdk/internal/utxo"
	"github.com/hyperledger-labs/zeto/go-sdk/pkg/utxo/core"
	"github.com/iden3/go-iden3-crypto/babyjub"
	"github.com/iden3/go-iden3-crypto/constants"
)

func NewFungible(amount *big.Int, owner *babyjub.PublicKey, salt *big.Int) core.UTXO {
	return utxo.NewFungible(amount, owner, salt)
}

func NewNonFungible(tokenId *big.Int, tokenUri string, owner *babyjub.PublicKey, salt *big.Int) core.UTXO {
	return utxo.NewNonFungible(tokenId, tokenUri, owner, salt)
}

func NewFungibleNullifier(amount *big.Int, owner *big.Int, salt *big.Int) core.UTXO {
	return utxo.NewFungibleNullifier(amount, owner, salt)
}

func NewNonFungibleNullifier(tokenId *big.Int, tokenUri string, owner *big.Int, salt *big.Int) core.UTXO {
	return utxo.NewNonFungibleNullifier(tokenId, tokenUri, owner, salt)
}

func HashTokenUri(tokenUri string) (*big.Int, error) {
	return utxo.HashTokenUri(tokenUri)
}

// NewSalt generates a new random salt in the range of [0, MAX) where MAX is the order of the BabyJub curve.
// This ensures that the salt is a valid scalar for the curve.
func NewSalt() *big.Int {
	// ensure that the salt fits inside the field of SNARKs
	max := constants.Q
	maxRounds := 10
	var e error
	for rounds := 0; rounds < maxRounds; rounds++ {
		randInt, err := rand.Int(rand.Reader, max)
		if err == nil {
			return randInt
		}
		e = err
	}
	panic(fmt.Sprintf("failed to generate a random salt after trying %d times: %v", maxRounds, e))
}
