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

import "github.com/hyperledger-labs/zeto/go-sdk/pkg/sparse-merkle-tree/core"

type memoryStorage struct {
	root  core.NodeIndex
	nodes map[core.NodeIndex]core.Node
}

func NewMemoryStorage() *memoryStorage {
	var nodes = make(map[core.NodeIndex]core.Node)
	return &memoryStorage{
		nodes: nodes,
	}
}

func (m *memoryStorage) GetRootNodeIndex() (core.NodeIndex, error) {
	if m.root == nil {
		return nil, ErrNotFound
	}
	return m.root, nil
}

func (m *memoryStorage) UpsertRootNodeIndex(root core.NodeIndex) error {
	m.root = root
	return nil
}

func (m *memoryStorage) GetNode(idx core.NodeIndex) (core.Node, error) {
	n, ok := m.nodes[idx]
	if !ok {
		return nil, ErrNotFound
	}
	return n, nil
}

func (m *memoryStorage) InsertNode(node core.Node) error {
	m.nodes[node.Ref()] = node
	return nil
}

func (m *memoryStorage) Close() {
}
