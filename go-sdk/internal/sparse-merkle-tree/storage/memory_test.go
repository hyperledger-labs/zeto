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

package storage

import (
	"math/big"
	"testing"

	"github.com/hyperledger-labs/zeto/go-sdk/pkg/sparse-merkle-tree/core"
	"github.com/stretchr/testify/assert"
)

type mockNodeIndex struct{}

func (ni *mockNodeIndex) BigInt() *big.Int            { return big.NewInt(0) }
func (ni *mockNodeIndex) Hex() string                 { return "0" }
func (ni *mockNodeIndex) IsZero() bool                { return true }
func (ni *mockNodeIndex) Equal(n core.NodeIndex) bool { return true }
func (ni *mockNodeIndex) IsBitOn(uint) bool           { return false }
func (ni *mockNodeIndex) ToPath(int) []bool           { return []bool{true, false} }

type mockNode struct {
	idx core.NodeIndex
	ref core.NodeIndex
	lc  core.NodeIndex
	rc  core.NodeIndex
}

func (n *mockNode) Type() core.NodeType        { return core.NodeTypeLeaf }
func (n *mockNode) Index() core.NodeIndex      { return n.idx }
func (n *mockNode) Ref() core.NodeIndex        { return n.ref }
func (n *mockNode) Value() core.Indexable      { return nil }
func (n *mockNode) LeftChild() core.NodeIndex  { return n.lc }
func (n *mockNode) RightChild() core.NodeIndex { return n.rc }

func TestNewMemoryStorage(t *testing.T) {
	s := NewMemoryStorage()
	assert.Nil(t, s.root)
	assert.NotNil(t, s.nodes)
	assert.Empty(t, s.nodes)

	_, err := s.GetRootNodeIndex()
	assert.Equal(t, ErrNotFound, err)

	err = s.UpsertRootNodeIndex(&mockNodeIndex{})
	assert.NoError(t, err)

	ni, err := s.GetRootNodeIndex()
	assert.NoError(t, err)
	assert.NotNil(t, ni)

	idx1 := &mockNodeIndex{}
	_, err = s.GetNode(idx1)
	assert.Equal(t, ErrNotFound, err)

	idx2 := &mockNodeIndex{}
	n1 := &mockNode{idx: idx1, ref: idx2}
	err = s.InsertNode(n1)
	assert.NoError(t, err)

	found, err := s.GetNode(idx1)
	assert.NoError(t, err)
	assert.NotNil(t, found)
	assert.Equal(t, n1, found)
}
