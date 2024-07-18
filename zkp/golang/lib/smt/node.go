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
	"encoding/hex"
	"math/big"
	"strings"

	"github.com/iden3/go-iden3-crypto/poseidon"
	cryptoUtils "github.com/iden3/go-iden3-crypto/utils"
)

const INDEX_BYTES_LEN = 32

var ZERO_INDEX, _ = NewNodeIndexFromBigInt(big.NewInt(0))

type NodeType int

const (
	// in a sparse merkle tree, all nodes at every possible index are considered
	// present, but nodes are empty until a value has been set to that index.
	// The NodeTypeEmpty is used to represent a non-existent value at an index.
	NodeTypeEmpty NodeType = iota
	// NodeTypeBranch is a node that has two children, which are the left and right
	NodeTypeBranch
	// NodeTypeLeaf is a node that has a value object, and is the bottom level
	// of the tree (which has the highest level number)
	NodeTypeLeaf
)

// NodeIndex is the index of a node in the Sparse Merkle Tree
type NodeIndex interface {
	// BigInt returns the big integer representation of the index
	BigInt() *big.Int
	// Hex returns the hex string representation of the index in big-endian format
	Hex() string
	// IsZero returns true if the index is zero
	IsZero() bool
	// Equal returns true if the index is equal to another index
	Equal(NodeIndex) bool
	// IsBitOn returns true if the index bit at the given position is 1
	IsBitOn(uint) bool
	// ToPath returns the binary path from the root to the leaf
	ToPath(int) []bool
}

// Indexable is the interface that wraps the value object of a
// Node, which is required to produce a unique index for the node.
type Indexable interface {
	CalculateIndex() (NodeIndex, error)
}

// Node is the object of a node in the Sparse Merkle Tree, which has an
// index, and a value object. The node can be a leaf (sits on the bottom
// of the tree), a branch (on the upper levels of the tree), or empty.
type Node interface {
	// returns the type of the node
	Type() NodeType
	// calculate the index from the values of a leaf node, which determines
	// the position of the leaf node in the bottom level of the tree
	Index() NodeIndex
	// calculated by combining the index and value of the node, as
	// the reference to the node from its parent in the tree, as well as the
	// key to the storage record for the node
	Ref() NodeIndex
	// returns the value object. only leaf nodes have a value object. If the
	// client is the owner of a UTXO, the value object includes the secre values.
	// otherwise the value object is simply the index of the node.
	Value() Indexable
	// returns the index of the left child. Only branch nodes have a left child.
	LeftChild() NodeIndex
	// returns the index of the right child. Only branch nodes have a right child.
	RightChild() NodeIndex
}

// nodeIndex is a wrapper around []byte to implement the NodeIndex interface.
// it's a 256-bit number. the path from the root node to a leaf node is determined
// by the index's bits. 0 means go left, 1 means go right.
type nodeIndex [32]byte

// node is an implementation of the Node interface
type node struct {
	nodeType   NodeType
	index      NodeIndex
	refKey     NodeIndex
	value      Indexable
	leftChild  NodeIndex
	rightChild NodeIndex
}

// //////////////////////////////////////
// implementation of node
func NewEmptyNode() Node {
	return &node{nodeType: NodeTypeEmpty}
}

func NewLeafNode(v Indexable) (Node, error) {
	n := &node{nodeType: NodeTypeLeaf, value: v}
	// the leaf node's index is calculated as follows:
	// 1. calculate the index (aka hash) of the value object, call it hV
	// 2. calculate hash(hV, hV, 1)
	idx, err := n.value.CalculateIndex()
	if err != nil {
		return nil, err
	}
	n.index = idx
	elements := []*big.Int{idx.BigInt(), idx.BigInt(), big.NewInt(1)}
	hash, err := poseidon.Hash(elements)
	if err != nil {
		return nil, err
	}
	n.refKey, err = NewNodeIndexFromBigInt(hash)
	return n, err
}

func NewBranchNode(leftChild, rightChild NodeIndex) (Node, error) {
	n := &node{nodeType: NodeTypeBranch, leftChild: leftChild, rightChild: rightChild}
	elements := []*big.Int{leftChild.BigInt(), rightChild.BigInt()}
	hash, err := poseidon.Hash(elements)
	if err != nil {
		return nil, err
	}
	n.refKey, err = NewNodeIndexFromBigInt(hash)
	return n, err
}

func (n *node) Type() NodeType {
	return n.nodeType
}

func (n *node) Index() NodeIndex {
	return n.index
}

func (n *node) Ref() NodeIndex {
	return n.refKey
}

func (n *node) Value() Indexable {
	return n.value
}

func (n *node) LeftChild() NodeIndex {
	return n.leftChild
}

func (n *node) RightChild() NodeIndex {
	return n.rightChild
}

// //////////////////////////////////////
// implementation of nodeIndex
func NewNodeIndexFromBigInt(i *big.Int) (NodeIndex, error) {
	// verfy that the integer are valid and fit inside the Finite Field.
	if !cryptoUtils.CheckBigIntInField(i) {
		return nil, ErrNodeIndexTooLarge
	}
	idx := new(nodeIndex)
	copy(idx[:], swapEndianness(i.Bytes()))
	return idx, nil
}

// NewNodeIndexFromHex creates a new NodeIndex from a hex string that
// represents the index in big-endian format.
func NewNodeIndexFromHex(h string) (NodeIndex, error) {
	h = strings.TrimPrefix(h, "0x")
	b, err := hex.DecodeString(h)
	if err != nil {
		return nil, err
	}
	if len(b) != INDEX_BYTES_LEN {
		return nil, ErrNodeBytesBadSize
	}
	idx := new(nodeIndex)
	copy(idx[:], b)
	return idx, nil
}

func (idx *nodeIndex) BigInt() *big.Int {
	return new(big.Int).SetBytes(swapEndianness(idx[:]))
}

func (idx *nodeIndex) Hex() string {
	return hex.EncodeToString(idx[:])
}

func (idx *nodeIndex) IsZero() bool {
	return idx.BigInt().Sign() == 0
}

func (idx *nodeIndex) Equal(other NodeIndex) bool {
	return idx.BigInt().Cmp(other.BigInt()) == 0
}

// getPath returns the binary path, from the root to the leaf.
func (idx *nodeIndex) ToPath(levels int) []bool {
	path := make([]bool, levels)
	for l := 0; l < levels; l++ {
		path[l] = idx.IsBitOn(uint(l))
	}
	return path
}

func (idx *nodeIndex) IsBitOn(pos uint) bool {
	if pos >= 256 {
		return false
	}
	return (idx[pos/8] & (1 << (pos % 8))) != 0
}

// swapEndianness swaps the order of the bytes in the byte array of a node index.
// the byte array is used in little-endian format for calculating the big integer value of the index,
// while the big-endian format is used as the bit-wise path to traverse down the tree.
func swapEndianness(b []byte) []byte {
	o := make([]byte, len(b))
	for i := range b {
		o[len(b)-1-i] = b[i]
	}
	return o
}
