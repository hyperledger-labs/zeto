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
	"math/big"
)

// Proof defines the required elements for a MT proof of existence or
// non-existence.
type Proof struct {
	// existence indicates wether this is a proof of existence or non-existence.
	Existence bool
	// Siblings is a list of non-empty sibling keys.
	Siblings []NodeIndex
	// depth indicates how deep in the tree the proof goes.
	Depth uint
	// ExistingNode is only used in a non-existence proof. It's the node
	// that was located by the target index but had a different value. It
	// is used to calculate the root hash to proof inclusion in the tree, thus
	// demonstrating non-inclusion of the target node.
	ExistingNode Node
	// nonEmptySiblings is a bitmap of non-empty Siblings found in Siblings. This helps
	// to save space in the proof, by not having to carry around empty nodes.
	nonEmptySiblings []byte
}

// CircomVerifierProof defines the proof with signals compatible with circom's SMT proof
// verification:
// https://github.com/iden3/circomlib/blob/master/circuits/smt/smtverifier.circom
type CircomVerifierProof struct {
	Root     NodeIndex   `json:"root"`
	Siblings []NodeIndex `json:"siblings"`
	OldKey   NodeIndex   `json:"oldKey"`
	OldValue NodeIndex   `json:"oldValue"`
	IsOld0   bool        `json:"isOld0"`
	Key      NodeIndex   `json:"key"`
	Value    NodeIndex   `json:"value"`
	Fnc      int         `json:"fnc"` // 0: inclusion, 1: non inclusion
}

func (p *Proof) MarkNonEmptySibling(level uint) {
	desiredLength := (level + 7) / 8
	if desiredLength == 0 {
		desiredLength = 1
	}
	if len(p.nonEmptySiblings) <= int(desiredLength) {
		newBytes := make([]byte, desiredLength)
		if len(p.nonEmptySiblings) == 0 {
			p.nonEmptySiblings = newBytes
		} else {
			copy(newBytes, p.nonEmptySiblings)
			p.nonEmptySiblings = newBytes
		}
	}
	setBitBigEndian(p.nonEmptySiblings, level)
}

func (p *Proof) IsNonEmptySibling(level uint) bool {
	return isBitOnBigEndian(p.nonEmptySiblings, level)
}

func (p *Proof) AllSiblings() []NodeIndex {
	sibIdx := 0
	siblings := []NodeIndex{}
	for lvl := 0; lvl < int(p.Depth); lvl++ {
		if p.IsNonEmptySibling(uint(lvl)) {
			siblings = append(siblings, p.Siblings[sibIdx])
			sibIdx++
		} else {
			siblings = append(siblings, ZERO_INDEX)
		}
	}
	return siblings
}

// getPath returns the binary path, from the root to the leaf.
func (p *Proof) getPath(index NodeIndex) []bool {
	path := make([]bool, p.Depth)
	for n := 0; n < int(p.Depth); n++ {
		path[n] = index.IsBitOn(uint(n))
	}
	return path
}

// ToCircomVerifierProof enhances the generic merkle proof with additional
// signals required by the circuit for Sparse Merkle Tree proof verification:
// https://github.com/iden3/circomlib/blob/master/circuits/smt/smtverifier.circom
func (p *Proof) ToCircomVerifierProof(k, v *big.Int, rootKey NodeIndex, levels int) (*CircomVerifierProof, error) {
	var cp CircomVerifierProof
	cp.Root = rootKey
	cp.Siblings = p.AllSiblings()
	if p.ExistingNode != nil {
		cp.OldKey = p.ExistingNode.Index()
		cp.OldValue = p.ExistingNode.Index()
	} else {
		cp.OldKey = ZERO_INDEX
		cp.OldValue = ZERO_INDEX
	}
	var err error
	cp.Key, err = NewNodeIndexFromBigInt(k)
	if err != nil {
		return nil, err
	}
	cp.Value, err = NewNodeIndexFromBigInt(v)
	if err != nil {
		return nil, err
	}
	if p.Existence {
		cp.Fnc = 0 // inclusion
	} else {
		cp.Fnc = 1 // non inclusion
	}
	// returns the full siblings compatible with circom
	// Add the rest of empty levels to the siblings
	for i := len(cp.Siblings); i < levels+1; i++ {
		cp.Siblings = append(cp.Siblings, ZERO_INDEX)
	}
	return &cp, nil
}

// VerifyProof verifies the Merkle Proof for the entry and root.
func VerifyProof(rootKey NodeIndex, proof *Proof, leafNode Node) bool {
	rootFromProof, err := CalculateRootFromProof(proof, leafNode)
	if err != nil {
		return false
	}
	return rootKey.Equal(rootFromProof)
}

// CalculateRootFromProof calculates the root that would correspond to a tree whose
// siblings are the ones in the proof with the leaf node
func CalculateRootFromProof(proof *Proof, leafNode Node) (NodeIndex, error) {
	sibIdx := len(proof.Siblings) - 1
	var midKey NodeIndex
	if proof.Existence {
		midKey = leafNode.Ref()
	} else {
		if proof.ExistingNode == nil {
			midKey = ZERO_INDEX
		} else {
			if leafNode.Index().Equal(proof.ExistingNode.Index()) {
				return nil, fmt.Errorf("non-existence proof being checked but the target node is found in the proof")
			}
			midKey = proof.ExistingNode.Ref()
		}
	}
	path := proof.getPath(leafNode.Index())
	var siblingKey NodeIndex
	for lvl := int(proof.Depth) - 1; lvl >= 0; lvl-- {
		if proof.IsNonEmptySibling(uint(lvl)) {
			siblingKey = proof.Siblings[sibIdx]
			sibIdx--
		} else {
			siblingKey = ZERO_INDEX
		}
		if path[lvl] { // go right
			branchNode, err := NewBranchNode(siblingKey, midKey)
			if err != nil {
				return nil, err
			}
			midKey = branchNode.Ref()
		} else { // go left
			branchNode, err := NewBranchNode(midKey, siblingKey)
			if err != nil {
				return nil, err
			}
			midKey = branchNode.Ref()
		}
	}
	return midKey, nil
}

// isBitOnBigEndian tests whether the bit n in bitmap is 1, in Big Endian.
func isBitOnBigEndian(bitmap []byte, n uint) bool {
	return bitmap[uint(len(bitmap))-n/8-1]&(1<<(n%8)) != 0
}

// setBitBigEndian sets the bit n in the bitmap to 1, in Big Endian.
func setBitBigEndian(bitmap []byte, n uint) {
	bitmap[uint(len(bitmap))-n/8-1] |= 1 << (n % 8)
}
