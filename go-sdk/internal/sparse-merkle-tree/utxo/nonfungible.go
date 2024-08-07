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
	"crypto/sha256"
	"fmt"
	"math/big"

	"github.com/hyperledger-labs/zeto/go-sdk/internal/sparse-merkle-tree/node"
	"github.com/hyperledger-labs/zeto/go-sdk/pkg/sparse-merkle-tree/core"
	"github.com/iden3/go-iden3-crypto/babyjub"
	"github.com/iden3/go-iden3-crypto/poseidon"
)

type NonFungible struct {
	TokenId  *big.Int
	TokenUri *big.Int // hash of the token uri string
	Owner    *babyjub.PublicKey
	Salt     *big.Int
}

func NewNonFungible(tokenId, tokenUri *big.Int, owner *babyjub.PublicKey, salt *big.Int) *NonFungible {
	return &NonFungible{
		TokenId:  tokenId,
		TokenUri: tokenUri,
		Owner:    owner,
		Salt:     salt,
	}
}

func (f *NonFungible) CalculateIndex() (core.NodeIndex, error) {
	hash, err := poseidon.Hash([]*big.Int{f.TokenId, f.TokenUri, f.Salt, f.Owner.X, f.Owner.Y})
	if err != nil {
		return nil, err
	}
	return node.NewNodeIndexFromBigInt(hash)
}

// the "Owner" is the private key that must be properly hashed and trimmed to be
// compatible with the BabyJub curve.
// Reference: https://github.com/iden3/circomlib/blob/master/test/babyjub.js#L103
type NonFungibleNullifier struct {
	TokenId  *big.Int
	TokenUri *big.Int // hash of the token uri string
	Owner    *big.Int
	Salt     *big.Int
}

func NewNonFungibleNullifier(tokenId, tokenUri *big.Int, owner *big.Int, salt *big.Int) *NonFungibleNullifier {
	return &NonFungibleNullifier{
		TokenId:  tokenId,
		TokenUri: tokenUri,
		Owner:    owner,
		Salt:     salt,
	}
}

func (f *NonFungibleNullifier) CalculateIndex() (core.NodeIndex, error) {
	hash, err := poseidon.Hash([]*big.Int{f.TokenId, f.TokenUri, f.Salt, f.Owner})
	if err != nil {
		return nil, err
	}
	return node.NewNodeIndexFromBigInt(hash)
}

func HashTokenUri(tokenUri string) (*big.Int, error) {
	hash := sha256.New()
	_, err := hash.Write([]byte(tokenUri))
	if err != nil {
		return nil, err
	}
	v := new(big.Int).SetBytes(hash.Sum(nil))

	// to fit the result within the range of the Finite Field used in the poseidon hash,
	// use 253 bit long numbers. we need to remove the most significant three bits.
	// first print the binary representation of the big int with padding to 256 bits
	binStr := fmt.Sprintf("%0256b", v)
	// then remove the most significant three bits
	binStr = binStr[3:]
	// finally parse the binary string back to big int
	v, ok := v.SetString(binStr, 2)
	if !ok {
		return nil, fmt.Errorf("failed to parse binary string")
	}
	return v, nil
}
