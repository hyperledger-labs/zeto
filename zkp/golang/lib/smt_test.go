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

package zeto

import (
	"math/big"
	"testing"

	"github.com/hyperledger-labs/zeto/lib/smt"
	"github.com/hyperledger-labs/zeto/lib/storage"
	"github.com/hyperledger-labs/zeto/lib/utxo"
	"github.com/iden3/go-iden3-crypto/babyjub"
	"github.com/stretchr/testify/assert"
)

func TestNewMerkleTree(t *testing.T) {
	db := storage.NewMemoryStorage()
	mt, err := NewMerkleTree(db, 64)
	assert.NoError(t, err)
	assert.Equal(t, 0, mt.Root().BigInt().Cmp(big.NewInt(0)))
}

func TestAddNode(t *testing.T) {
	db := storage.NewMemoryStorage()
	mt, err := NewMerkleTree(db, 10)
	assert.NoError(t, err)

	x, _ := new(big.Int).SetString("11815296462877004816435684445965481797264633360809147413216887436044214137854", 10)
	y, _ := new(big.Int).SetString("20876734580825686348991542223684971543479006160633392203305694346145015178322", 10)
	alice := &babyjub.PublicKey{
		X: x,
		Y: y,
	}
	salt1, _ := new(big.Int).SetString("277194cf56e06208f361ad605b9a6fb0fa5377483b1ad94b7cdd45f61075db50", 16)
	utxo1 := utxo.NewFungible(big.NewInt(10), alice, salt1)
	idx1, err := utxo1.CalculateIndex()
	assert.NoError(t, err)
	assert.Equal(t, "c7b236b843c3f2b1dcb5bc0771f204bb2f4f604b3280d47a07545f7d8a34efa", idx1.BigInt().Text(16))

	n1, err := smt.NewLeafNode(utxo1)
	assert.NoError(t, err)
	err = mt.Add(n1)
	assert.NoError(t, err)
	assert.Equal(t, "7065e7374b480648ce4d60e81a981b1ff79e61bc07179572afac516b94e56223", mt.Root().Hex())

	salt2, _ := new(big.Int).SetString("2edbd10ad27b91e1579303fb5d14482bb3c4a2a032977b3cfe9115ef1b3b9e6a", 16)
	utxo2 := utxo.NewFungible(big.NewInt(20), alice, salt2)
	idx2, err := utxo2.CalculateIndex()
	assert.NoError(t, err)
	assert.Equal(t, "1f8eede8ec2acfa35b2b2143e7c3842154a66cc936cb6a8e86baf110fa22146b", idx2.BigInt().Text(16))
	n2, err := smt.NewLeafNode(utxo2)
	assert.NoError(t, err)
	err = mt.Add(n2)
	assert.NoError(t, err)
	assert.Equal(t, "bf6f6bec16f8585b3a37f34fdd0cfe7cee7843a7e7a60fa4214b1c46b683022a", mt.Root().Hex())

	salt3, _ := new(big.Int).SetString("275adcc9717c2da2821d73eaef92009439413fdb50833fe2a89935559a7946c0", 16)
	utxo3 := utxo.NewFungible(big.NewInt(30), alice, salt3)
	idx3, err := utxo3.CalculateIndex()
	assert.NoError(t, err)
	assert.Equal(t, "20f9191701371640fb9e058dc1f8ba4ae7dfa2029640bc7017b9672d8616ceb1", idx3.BigInt().Text(16))
	n3, err := smt.NewLeafNode(utxo3)
	assert.NoError(t, err)
	err = mt.Add(n3)
	assert.NoError(t, err)
	assert.Equal(t, "c64612d9a7f792d4e8f3299e4119362ae6f8c7970467aae56c2fadcaf5e2cc09", mt.Root().Hex())

	// test storage persistence
	rawDB := mt.(*sparseMerkleTree).db
	rootIdx, err := rawDB.GetRootNodeIndex()
	assert.NoError(t, err)
	assert.Equal(t, "c64612d9a7f792d4e8f3299e4119362ae6f8c7970467aae56c2fadcaf5e2cc09", rootIdx.Hex())

	// test storage persistence across tree creation
	mt2, err := NewMerkleTree(db, 10)
	assert.NoError(t, err)
	assert.Equal(t, "c64612d9a7f792d4e8f3299e4119362ae6f8c7970467aae56c2fadcaf5e2cc09", mt2.Root().Hex())
}
