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

// Proof defines the required elements for a MT proof of existence or
// non-existence.
type Proof interface {
	// existence indicates wether this is a proof of existence or non-existence.
	IsExistenceProof() bool
	// Siblings is a list of non-empty sibling keys.
	Siblings() []NodeIndex
	// depth indicates how deep in the tree the proof goes.
	Depth() uint
	// ExistingNode is only used in a non-existence proof. It's the node
	// that was located by the target index but had a different value. It
	// is used to calculate the root hash to proof inclusion in the tree, thus
	// demonstrating non-inclusion of the target node.
	ExistingNode() Node
	// ToCircomVerifierProof converts the proof to a CircomVerifierProof
	ToCircomVerifierProof(k, v *big.Int, rootKey NodeIndex, levels int) (*CircomVerifierProof, error)
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
