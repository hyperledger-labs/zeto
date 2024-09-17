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
	"fmt"
	"testing"

	"github.com/hyperledger-labs/zeto/go-sdk/internal/sparse-merkle-tree/storage"
	"github.com/hyperledger-labs/zeto/go-sdk/pkg/sparse-merkle-tree/core"
	"github.com/stretchr/testify/assert"
)

type mockStorage struct {
	GetRootNodeIndex_customError bool
}

func (ms *mockStorage) GetRootNodeIndex() (core.NodeIndex, error) {
	if ms.GetRootNodeIndex_customError {
		return nil, fmt.Errorf("nasty error in get root")
	}
	return nil, storage.ErrNotFound
}
func (ms *mockStorage) UpsertRootNodeIndex(core.NodeIndex) error {
	return fmt.Errorf("nasty error in upsert root")
}
func (ms *mockStorage) GetNode(core.NodeIndex) (core.Node, error) {
	return nil, nil
}
func (ms *mockStorage) InsertNode(core.Node) error {
	return nil
}
func (ms *mockStorage) BeginBatch() (core.Transaction, error) {
	return ms, nil
}
func (ms *mockStorage) Commit() error {
	return nil
}
func (ms *mockStorage) Rollback() error {
	return nil
}
func (ms *mockStorage) Close() {}

func TestNewMerkleTreeFailures(t *testing.T) {
	db := &mockStorage{}
	mt, err := NewMerkleTree(db, 0)
	assert.EqualError(t, err, ErrMaxLevelsNotInRange.Error())
	assert.Nil(t, mt)

	mt, err = NewMerkleTree(nil, 257)
	assert.Error(t, err, ErrMaxLevelsNotInRange.Error())
	assert.Nil(t, mt)

	mt, err = NewMerkleTree(db, 64)
	assert.EqualError(t, err, "nasty error in upsert root")
	assert.Nil(t, mt)

	db.GetRootNodeIndex_customError = true
	mt, err = NewMerkleTree(db, 64)
	assert.EqualError(t, err, "nasty error in get root")
	assert.Nil(t, mt)
}
