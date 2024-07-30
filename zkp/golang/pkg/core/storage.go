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

package core

import "gorm.io/gorm"

type Storage interface {
	// GetRootNodeIndex returns the root node index.
	// Must return an ErrNotFound error if it does not exist.
	GetRootNodeIndex() (NodeIndex, error)
	// UpsertRootNodeIndex updates the root node index.
	UpsertRootNodeIndex(NodeIndex) error
	// GetNode returns the node with the given index
	// Must return an ErrNotFound error if it does not exist.
	GetNode(NodeIndex) (Node, error)
	// InsertNode inserts a node into the storage. Where the private values of a node are stored
	// is implementation-specific
	InsertNode(Node) error
	// Close closes the storage resource
	Close()
}

const (
	// we use a table to store the root node indexes for
	// all the merkle trees in the database
	TreeRootsTable = "merkelTreeRoots"
	// we use a separate table to store the nodes of each
	// sparse merkle tree by using the following name as
	// the prefix, followed by the name of the tree
	NodesTablePrefix = "smtNodes_"
)

// SqlDBProvider is the interface for providing access to a SQL database to
// the storage layer implementations that are backed by a SQL database.
type SqlDBProvider interface {
	DB() *gorm.DB
	Close()
}

// SMTRoot is used to persist tree root in SQL databases via gorm
type SMTRoot struct {
	// the name of the merkle tree
	Name string `gorm:"primaryKey"`
	// this must be the hex bytes of the root index
	// following the big-endian encoding
	RootIndex string `gorm:"type:text"`
}

// SMTNode is the structure of a node in the merkle tree.
// It only captures the reference key and the index of the node.
// The value properties of a node are local states that are
// handled outside of the merkle tree library.
type SMTNode struct {
	RefKey     string `gorm:"primaryKey"`
	Type       byte
	Index      *string // only leaf nodes have an index
	LeftChild  *string // only branch nodes have children
	RightChild *string
}
