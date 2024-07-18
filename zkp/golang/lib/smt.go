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
	"sync"

	"github.com/hyperledger-labs/zeto/lib/smt"
	"github.com/hyperledger-labs/zeto/lib/storage"
	"github.com/hyperledger-labs/zeto/lib/utxo"
)

// MAX_TREE_HEIGHT is the maximum number of levels of the sparse merkle tree.
// This is determined by the number of bits in the index of a leaf node.
const MAX_TREE_HEIGHT = 256

// An append-only sparse merkle tree implementation using a pluggable
// storage backend. Each leaf node is a key-value pair where the key is
// a 256-bit unique index into the array of leaf nodes. Branch nodes and
// the root node only has the hash of its children nodes.
//
// The tree is built from the root node, at level 0, down to the leaf nodes.
//
//	      root           level 0
//	    /     \
//		 e       f  		   level 1
//	  / \     / \
//	 a   b   c   d 	     level 2
//	 / \ / \ / \ / \
//	 1 2 3 4 5 - - -     level 3
type SparseMerkleTree interface {
	// Root returns the root hash of the tree
	Root() smt.NodeIndex
	// AddLeaf adds a key-value pair to the tree
	AddLeaf(smt.Node) error
	// GetnerateProof generates a proof of existence (or non-existence) of a leaf node
	GenerateProof(*big.Int, smt.NodeIndex) (*smt.Proof, *big.Int, error)
}

type sparseMerkleTree struct {
	sync.RWMutex
	db        Storage
	rootKey   smt.NodeIndex
	maxLevels int
}

func NewMerkleTree(db Storage, maxLevels int) (SparseMerkleTree, error) {
	if maxLevels > MAX_TREE_HEIGHT {
		return nil, smt.ErrMaxLevelsExceeded
	}
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

// AddLeaf adds a new leaf node into the MerkleTree. It starts from the root node
func (mt *sparseMerkleTree) AddLeaf(node smt.Node) error {
	mt.Lock()
	defer mt.Unlock()

	idx := node.Index()
	path := idx.ToPath(mt.maxLevels)

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

// GenerateProof generates the proof of existence (or non-existence) of a leaf node
// for a Merkle Tree given the root. It uses the node's index to represent the node.
// If the rootKey is nil, the current merkletree root is used
func (mt *sparseMerkleTree) GenerateProof(k *big.Int, rootKey smt.NodeIndex) (*smt.Proof, *big.Int, error) {
	p := &smt.Proof{}
	var siblingKey smt.NodeIndex

	kHash, err := smt.NewNodeIndexFromBigInt(k)
	if err != nil {
		return nil, nil, err
	}
	path := kHash.ToPath(mt.maxLevels)
	if rootKey == nil {
		rootKey = mt.Root()
	}
	nextKey := rootKey
	for p.Depth = 0; p.Depth < uint(mt.maxLevels); p.Depth++ {
		n, err := mt.GetNode(nextKey)
		if err != nil {
			return nil, nil, err
		}
		switch n.Type() {
		case smt.NodeTypeEmpty:
			return p, big.NewInt(0), nil
		case smt.NodeTypeLeaf:
			idx := n.Index()
			value := n.Index()
			if kHash.Equal(idx) {
				p.Existence = true
				// in our nodes, the value is the same as the index
				return p, value.BigInt(), nil
			}
			// We found a leaf whose entry didn't match the node index
			p.ExistingNode, err = smt.NewLeafNode(utxo.NewIndexOnly(idx))
			if err != nil {
				return nil, nil, err
			}
			return p, value.BigInt(), nil
		case smt.NodeTypeBranch:
			if path[p.Depth] { // go right
				nextKey = n.RightChild()
				siblingKey = n.LeftChild()
			} else { // go left
				nextKey = n.LeftChild()
				siblingKey = n.RightChild()
			}
		default:
			return nil, nil, smt.ErrInvalidNodeFound
		}

		if !siblingKey.Equal(smt.ZERO_INDEX) {
			p.MarkNonEmptySibling(uint(p.Depth))
			p.Siblings = append(p.Siblings, siblingKey)
		}
	}
	return nil, nil, smt.ErrKeyNotFound
}

// addLeaf adds a new LeafNode to the MerkleTree. It starts with the current node.
//   - if the current node is empty, it adds the new leaf node at that location.
//   - if the current node is a leaf node, it means there's an existing node that shares
//     the same index, because it hasn't fully utilized the bits of the index. We will
//     extend the path of both the existing node and the new node, using more bits of the
//     index, until the paths of the two nodes diverge, at which point they will be created
//     as children of a new branch node.
//   - if the current node is a branch node, it will continue traversing the tree, using the
//     next bit of the new node's index to determine which child to go down to.
func (mt *sparseMerkleTree) addLeaf(newLeaf smt.Node, currentNodeIndex smt.NodeIndex, level int, path []bool) (smt.NodeIndex, error) {
	if level > mt.maxLevels-1 {
		// we have exhausted all levels but could not find a unique path for the new leaf.
		// this happens when two leaf nodes have the same beginning bits of the index, of
		// length of the maxLevels value.
		return nil, smt.ErrReachedMaxLevel
	}

	var nextKey smt.NodeIndex
	currentNode, err := mt.GetNode(currentNodeIndex)
	if err != nil {
		return nil, err
	}
	switch currentNode.Type() {
	case smt.NodeTypeEmpty:
		// We have searched to the bottom level and are ensured that
		// the node doesn't exist yet. We can add the new leaf node
		return mt.addNode(newLeaf)
	case smt.NodeTypeLeaf:
		nIndex := currentNode.Index()
		// Check if leaf node found contains the leaf node we are
		// trying to add
		newLeafIndex := newLeaf.Index()
		if nIndex.Equal(newLeafIndex) {
			return nil, smt.ErrNodeIndexAlreadyExists
		}
		// we found a leaf node that shares the same index as the new leaf node.
		// but we still have more bits in the index to use. We need to extend the
		// path of the existing leaf node and the new leaf node until they diverge.
		pathOldLeaf := nIndex.ToPath(mt.maxLevels)
		return mt.extendPath(newLeaf, currentNode, level, path, pathOldLeaf)
	case smt.NodeTypeBranch:
		// We need to go deeper, continue traversing the tree, left or
		// right depending on path
		var newBranchNode smt.Node
		if path[level] { // go right
			nextKey, err = mt.addLeaf(newLeaf, currentNode.RightChild(), level+1, path)
			if err != nil {
				return nil, err
			}
			// replace the branch node with the new branch node, which now has a new right child
			newBranchNode, err = smt.NewBranchNode(currentNode.LeftChild(), nextKey)
		} else { // go left
			nextKey, err = mt.addLeaf(newLeaf, currentNode.LeftChild(), level+1, path)
			if err != nil {
				return nil, err
			}
			// replace the branch node with the new branch node, which now has a new left child
			newBranchNode, err = smt.NewBranchNode(nextKey, currentNode.RightChild())
		}
		if err != nil {
			return nil, err
		}
		// persist the updated branch node
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

func (mt *sparseMerkleTree) extendPath(newLeaf smt.Node, oldLeaf smt.Node, level int, pathNewLeaf []bool, pathOldLeaf []bool) (smt.NodeIndex, error) {
	if level > mt.maxLevels-2 {
		return nil, smt.ErrReachedMaxLevel
	}
	var newBranchNode smt.Node
	if pathNewLeaf[level] == pathOldLeaf[level] {
		// If the next bit of the new leaf node's index is the same as the
		// next bit of the existing leaf node's index, we need to further extend
		// the path of both nodes.
		nextKey, err := mt.extendPath(newLeaf, oldLeaf, level+1, pathNewLeaf, pathOldLeaf)
		if err != nil {
			return nil, err
		}
		if pathNewLeaf[level] {
			// the new branch node returned is on the right
			newBranchNode, err = smt.NewBranchNode(smt.ZERO_INDEX, nextKey)
		} else {
			// the new branch node returned is on the left
			newBranchNode, err = smt.NewBranchNode(nextKey, smt.ZERO_INDEX)
		}
		if err != nil {
			return nil, err
		}
		// persist the new branch node. and return the key of the new branch node
		return mt.addNode(newBranchNode)
	}

	// at the current level, the two nodes finally diverges. We can now create a
	// new branch node with the two leaf nodes as children.
	oldLeafRef := oldLeaf.Ref()
	newLeafRef := newLeaf.Ref()

	var err error
	if pathNewLeaf[level] {
		// the new leaf node is on the right
		newBranchNode, err = smt.NewBranchNode(oldLeafRef, newLeafRef)
	} else {
		// the new leaf node is on the left
		newBranchNode, err = smt.NewBranchNode(newLeafRef, oldLeafRef)
	}
	if err != nil {
		return nil, err
	}
	// We can add newLeaf to the DB now. We don't need to add oldLeaf because it's
	// already in the DB.
	_, err = mt.addNode(newLeaf)
	if err != nil {
		return nil, err
	}
	// finally don't forget to add the new branch node that
	// is the parent of the new leaf node to the DB. We also
	// return this new branch node's key to allow the caller
	// to create branch nodes as needed.
	return mt.addNode(newBranchNode)
}
