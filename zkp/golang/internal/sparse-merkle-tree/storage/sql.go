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
	"github.com/hyperledger-labs/zeto/go-sdk/internal/sparse-merkle-tree/node"
	"github.com/hyperledger-labs/zeto/go-sdk/internal/sparse-merkle-tree/utils"
	"github.com/hyperledger-labs/zeto/go-sdk/pkg/sparse-merkle-tree/core"
	"gorm.io/gorm"
)

type sqlStorage struct {
	p              core.SqlDBProvider
	smtName        string
	nodesTableName string
}

// NewSqlStorage creates a new sqlStorage instance
// The "smtName" is the name for the tree instance, it must
// be unique within the backend database instance
func NewSqlStorage(p core.SqlDBProvider, smtName string) *sqlStorage {
	return &sqlStorage{
		p:              p,
		smtName:        smtName,
		nodesTableName: core.NodesTablePrefix + smtName,
	}
}

func (s *sqlStorage) GetRootNodeIndex() (core.NodeIndex, error) {
	root := core.SMTRoot{
		Name: s.smtName,
	}
	err := s.p.DB().Table(core.TreeRootsTable).First(&root).Error
	if err == gorm.ErrRecordNotFound {
		return nil, ErrNotFound
	} else if err != nil {
		return nil, err
	}
	idx, err := node.NewNodeIndexFromHex(root.RootIndex)
	return idx, err
}

func (s *sqlStorage) UpsertRootNodeIndex(root core.NodeIndex) error {
	err := s.p.DB().Table(core.TreeRootsTable).Save(&core.SMTRoot{
		RootIndex: root.Hex(),
		Name:      s.smtName,
	}).Error
	return err
}

func (s *sqlStorage) GetNode(ref core.NodeIndex) (core.Node, error) {
	// the node's reference key (not the index) is used as the key to
	// store the node in the DB
	n := core.SMTNode{
		RefKey: ref.Hex(),
	}
	err := s.p.DB().Table(s.nodesTableName).First(&n).Error
	if err == gorm.ErrRecordNotFound {
		return nil, ErrNotFound
	} else if err != nil {
		return nil, err
	}
	var newNode core.Node
	nodeType := core.NodeTypeFromByte(n.Type)
	switch nodeType {
	case core.NodeTypeLeaf:
		idx, err1 := node.NewNodeIndexFromHex(*n.Index)
		if err1 != nil {
			return nil, err1
		}
		v := utils.NewIndexOnly(idx)
		newNode, err = node.NewLeafNode(v)
	case core.NodeTypeBranch:
		leftChild, err1 := node.NewNodeIndexFromHex(*n.LeftChild)
		if err1 != nil {
			return nil, err1
		}
		rightChild, err2 := node.NewNodeIndexFromHex(*n.RightChild)
		if err2 != nil {
			return nil, err2
		}
		newNode, err = node.NewBranchNode(leftChild, rightChild)
	}
	return newNode, err
}

func (s *sqlStorage) InsertNode(n core.Node) error {
	// we clone the node so that the value properties are not saved
	dbNode := &core.SMTNode{
		RefKey: n.Ref().Hex(),
		Type:   n.Type().ToByte(),
	}
	if n.Type() == core.NodeTypeBranch {
		left := n.LeftChild().Hex()
		dbNode.LeftChild = &left
		right := n.RightChild().Hex()
		dbNode.RightChild = &right
	} else if n.Type() == core.NodeTypeLeaf {
		idx := n.Index().Hex()
		dbNode.Index = &idx
	}

	err := s.p.DB().Table(s.nodesTableName).Create(dbNode).Error
	return err
}

func (m *sqlStorage) Close() {
	m.p.Close()
}
