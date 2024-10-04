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

import "math/big"

// An append-only sparse merkle tree implementation using a pluggable
// storage backend. Each leaf node is a key-value pair where the key is
// a 256-bit unique index into the array of leaf nodes. Branch nodes and
// the root node only has the hash of its children nodes.
//
// The tree is built from the root node, at level 0, down to the leaf nodes.
//
//	     root           level 0
//	    /     \
//	   e       f        level 1
//	  / \     / \
//	 a   b   c   d      level 2
//	/ \ / \ / \ / \
//	1 2 3 4 5 - - -     level 3
type SparseMerkleTree interface {
	// Root returns the root hash of the tree
	Root() NodeRef
	// AddLeaf adds a key-value pair to the tree
	AddLeaf(leaf Node) error
	// GetNode returns the node at the given reference hash
	// nodeRef: the reference hash of the node (node.Ref()). Note, this is NOT the index of the node
	GetNode(nodeRef NodeRef) (Node, error)
	// GetnerateProof generates a proof of existence (or non-existence) of a leaf node
	// nodeIndexes: the index of the leaf nodes to generate proofs for
	// rootRef: the reference hash of the root node
	GenerateProofs(nodeIndexes []*big.Int, rootRef NodeRef) ([]Proof, []*big.Int, error)
}
