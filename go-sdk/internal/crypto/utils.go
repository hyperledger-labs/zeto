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

package crypto

import (
	"crypto/rand"
	"fmt"
	"math/big"

	"github.com/iden3/go-iden3-crypto/constants"
)

// NewSalt generates a new random salt in the range of [0, MAX) where MAX is the order of the BabyJub curve.
// This ensures that the salt is a valid scalar for the curve.
func NewSalt() *big.Int {
	// ensure that the salt fits inside the field of SNARKs
	max := constants.Q
	return newRandomNumberInRange(max)
}

const TWO_POW_128 = "340282366920938463463374607431768211456"

func NewEncryptionNonce() *big.Int {
	// per https://drive.google.com/file/d/1EVrP3DzoGbmzkRmYnyEDcIQcXVU7GlOd/view
	// the encrpition nonce should be in the range [0, 2^128)
	max, _ := new(big.Int).SetString(TWO_POW_128, 10)
	return newRandomNumberInRange(max)
}

func newRandomNumberInRange(max *big.Int) *big.Int {
	// ensure that the salt fits inside the field of SNARKs
	maxRounds := 10
	var e error
	for rounds := 0; rounds < maxRounds; rounds++ {
		randInt, err := rand.Int(rand.Reader, max)
		if err == nil {
			return randInt
		}
		e = err
	}
	panic(fmt.Sprintf("failed to generate a random number in [0, %d) after trying %d times: %v", max, maxRounds, e))
}
