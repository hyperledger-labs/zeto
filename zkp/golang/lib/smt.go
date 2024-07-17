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
	"sync"

	"github.com/hyperledger-labs/zeto/lib/smt"
	"github.com/hyperledger-labs/zeto/lib/storage"
)

// An append-only sparse merkle tree implementation using a pluggable
// storage backend. Each leaf node is a key-value pair where the key is
// a 256-bit unique index into the array of leaf nodes. Branch nodes and
// the root node only has the hash of its children nodes.
type SparseMerkleTree interface {
	// Root returns the root hash of the tree
	Root() smt.NodeIndex
	// Add adds a key-value pair to the tree
	Add(smt.Node) error
}

type sparseMerkleTree struct {
	sync.RWMutex
	db        Storage
	rootKey   smt.NodeIndex
	maxLevels int
}

func NewMerkleTree(db Storage, maxLevels int) (SparseMerkleTree, error) {
	mt := sparseMerkleTree{db: db, maxLevels: maxLevels}

	root, err := mt.db.GetRootNodeIndex()
	if err == storage.ErrNotFound {
		mt.rootKey = smt.ZERO_INDEX
		err = mt.db.UpsertRootNodeIndex(mt.rootKey)
		if err != nil {
			return nil, err
		}
		return &mt, nil
	} else if err != nil {
		return nil, err
	}
	mt.rootKey = root
	return &mt, nil
}

func (mt *sparseMerkleTree) Root() smt.NodeIndex {
	return mt.rootKey
}

// Add adds a Key & Value into the MerkleTree. Where the `k` determines the
// path from the Root to the Leaf.
func (mt *sparseMerkleTree) Add(node smt.Node) error {
	idx := node.Index()

	mt.Lock()
	defer mt.Unlock()

	path := mt.getPath(idx)

	newRootKey, err := mt.addLeaf(node, mt.rootKey, 0, path)
	if err != nil {
		return err
	}
	mt.rootKey = newRootKey

	err = mt.db.UpsertRootNodeIndex(mt.rootKey)
	if err != nil {
		return err
	}

	return nil
}

// GetNode gets a node by key from the merkle tree. Empty nodes are not stored in the
// tree: they are all the same and assumed to always exist.
func (mt *sparseMerkleTree) GetNode(key smt.NodeIndex) (smt.Node, error) {
	if key.IsZero() {
		return smt.NewEmptyNode(), nil
	}
	node, err := mt.db.GetNode(key)
	if err != nil {
		return nil, err
	}
	return node, nil
}

// addLeaf adds a new LeafNode to the MerkleTree. It traverses the tree from
// the node at "rootKey", following the path determined by the "path" parameter
func (mt *sparseMerkleTree) addLeaf(newLeaf smt.Node, rootKey smt.NodeIndex, lvl int, path []bool) (smt.NodeIndex, error) {
	var err error
	var nextKey smt.NodeIndex
	if lvl > mt.maxLevels-1 {
		return nil, smt.ErrReachedMaxLevel
	}
	n, err := mt.GetNode(rootKey)
	if err != nil {
		return nil, err
	}
	switch n.Type() {
	case smt.NodeTypeEmpty:
		// We have searched to the bottom level and are ensured that
		// the node doesn't exist yet. We can add the new leaf node
		return mt.addNode(newLeaf)
	case smt.NodeTypeLeaf:
		nIndex := n.Index()
		// Check if leaf node found contains the leaf node we are
		// trying to add
		newLeafIndex := newLeaf.Index()
		if nIndex.Equal(newLeafIndex) {
			return nil, smt.ErrNodeIndexAlreadyExists
		}
		pathOldLeaf := mt.getPath(nIndex)
		// We need to push newLeaf down until its path diverges from
		// n's path
		return mt.pushLeaf(newLeaf, n, lvl, path, pathOldLeaf)
	case smt.NodeTypeBranch:
		// We need to go deeper, continue traversing the tree, left or
		// right depending on path
		var newBranchNode smt.Node
		if path[lvl] { // go right
			nextKey, err = mt.addLeaf(newLeaf, n.RightChild(), lvl+1, path)
			if err != nil {
				return nil, err
			}
			newBranchNode, err = smt.NewBranchNode(n.LeftChild(), nextKey)
		} else { // go left
			nextKey, err = mt.addLeaf(newLeaf, n.LeftChild(), lvl+1, path)
			if err != nil {
				return nil, err
			}
			newBranchNode, err = smt.NewBranchNode(nextKey, n.RightChild())
		}
		if err != nil {
			return nil, err
		}
		// Update the node to reflect the modified child
		return mt.addNode(newBranchNode)
	default:
		return nil, smt.ErrInvalidNodeFound
	}
}

// addNode adds a node into the MT.  Empty nodes are not stored in the tree;
// they are all the same and assumed to always exist.
func (mt *sparseMerkleTree) addNode(n smt.Node) (smt.NodeIndex, error) {
	if n.Type() == smt.NodeTypeEmpty {
		return n.Ref(), nil
	}
	k := n.Ref()
	// Check that the node key doesn't already exist
	if _, err := mt.db.GetNode(k); err == nil {
		return nil, smt.ErrNodeIndexAlreadyExists
	}
	err := mt.db.InsertNode(n)
	return k, err
}

// getPath returns the binary path, from the root to the leaf.
func (mt *sparseMerkleTree) getPath(index smt.NodeIndex) []bool {
	path := make([]bool, mt.maxLevels)
	for n := 0; n < mt.maxLevels; n++ {
		path[n] = index.IsBitPositionOn(uint(n))
	}
	return path
}

// pushLeaf recursively pushes an existing oldLeaf down until its path diverges
// from newLeaf, at which point both leafs are stored, all while updating the
// path.
func (mt *sparseMerkleTree) pushLeaf(newLeaf smt.Node, oldLeaf smt.Node, lvl int, pathNewLeaf []bool, pathOldLeaf []bool) (smt.NodeIndex, error) {
	if lvl > mt.maxLevels-2 {
		return nil, smt.ErrReachedMaxLevel
	}
	var newBranchNode smt.Node
	if pathNewLeaf[lvl] == pathOldLeaf[lvl] { // We need to go deeper!
		nextKey, err := mt.pushLeaf(newLeaf, oldLeaf, lvl+1, pathNewLeaf, pathOldLeaf)
		if err != nil {
			return nil, err
		}
		if pathNewLeaf[lvl] { // go right
			newBranchNode, err = smt.NewBranchNode(smt.ZERO_INDEX, nextKey)
		} else { // go left
			newBranchNode, err = smt.NewBranchNode(nextKey, smt.ZERO_INDEX)
		}
		if err != nil {
			return nil, err
		}
		return mt.addNode(newBranchNode)
	}

	oldLeafRef := oldLeaf.Ref()
	newLeafRef := newLeaf.Ref()

	var err error
	if pathNewLeaf[lvl] {
		newBranchNode, err = smt.NewBranchNode(oldLeafRef, newLeafRef)
	} else {
		newBranchNode, err = smt.NewBranchNode(newLeafRef, oldLeafRef)
	}
	if err != nil {
		return nil, err
	}
	// We can add newLeaf now. We don't need to add oldLeaf because it's
	// already in the tree.
	_, err = mt.addNode(newLeaf)
	if err != nil {
		return nil, err
	}
	return mt.addNode(newBranchNode)
}
