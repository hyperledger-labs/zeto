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
	"fmt"
	"math/big"

	"github.com/iden3/go-iden3-crypto/ff"
	"github.com/iden3/go-iden3-crypto/poseidon"
)

var two128 big.Int

func init() {
	two128.SetString(TWO_POW_128, 10)
}

// Implements the encryption and decryption functions using Poseidon hash
// as described: https://drive.google.com/file/d/1EVrP3DzoGbmzkRmYnyEDcIQcXVU7GlOd/view
// The encryption and decryption functions are compatible with the circom implementations,
// meaning the cipher texts encrypted by the circuit in circuits/lib/encrypt.circom can
// be decrypted by the PoseidonDecrypt function. And vice versa.
func PoseidonEncrypt(msg []*big.Int, key []*big.Int, nonce *big.Int) ([]*big.Int, error) {
	if len(key) != 2 {
		return nil, fmt.Errorf("the key must have 2 elements, but got %d", len(key))
	}

	// the size of the message array must be a multiple of 3
	// pad with 0 if necessary
	length := len(msg)
	if length%3 > 0 {
		length += 3 - (length % 3)
	}
	message := make([]*big.Int, length)
	copy(message, msg)
	for idx := len(msg); idx < length; idx++ {
		message[idx] = big.NewInt(0)
	}

	// Create the initial state
	// S = (0, kS[0], kS[1], N + l * 2^128)
	l := big.NewInt(int64(len(msg)))
	state := []*big.Int{big.NewInt(0), key[0], key[1], nonce.Add(nonce, l.Mul(l, &two128))}

	cipherText := make([]*big.Int, length+1)
	var err error

	n := length / 3
	i := 0
	for ; i < n; i++ {
		// Iterate Poseidon on the state
		state, err = poseidon.HashEx(state, 4)
		if err != nil {
			return nil, err
		}

		// Modify the state for the next round
		// state[1] = addMod(message[i * 3], state[1]);
		state[1] = ff.NewElement().Add(ff.NewElement().SetBigInt(message[i*3]), ff.NewElement().SetBigInt(state[1])).ToBigIntRegular(state[1])
		// state[2] = addMod(message[i * 3 + 1], state[2]);
		state[2] = ff.NewElement().Add(ff.NewElement().SetBigInt(message[i*3+1]), ff.NewElement().SetBigInt(state[2])).ToBigIntRegular(state[2])
		// state[3] = addMod(message[i * 3 + 2], state[3]);
		state[3] = ff.NewElement().Add(ff.NewElement().SetBigInt(message[i*3+2]), ff.NewElement().SetBigInt(state[3])).ToBigIntRegular(state[3])

		// Record the three elements of the encrypted message
		cipherText[i*3] = state[1]
		cipherText[i*3+1] = state[2]
		cipherText[i*3+2] = state[3]
	}

	// Iterate Poseidon on the state one last time
	state, err = poseidon.HashEx(state, 4)
	if err != nil {
		return nil, err
	}

	// Record the last ciphertext element
	cipherText[i*3] = state[1]

	return cipherText, nil
}