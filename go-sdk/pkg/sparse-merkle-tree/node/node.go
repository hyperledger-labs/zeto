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

package node

import (
	"math/big"

	"github.com/hyperledger-labs/zeto/go-sdk/internal/sparse-merkle-tree/node"
	"github.com/hyperledger-labs/zeto/go-sdk/pkg/sparse-merkle-tree/core"
)

func NewEmptyNode() core.Node {
	return node.NewEmptyNode()
}

func NewLeafNode(v core.Indexable) (core.Node, error) {
	return node.NewLeafNode(v)
}

func NewBranchNode(leftChild, rightChild core.NodeIndex) (core.Node, error) {
	return node.NewBranchNode(leftChild, rightChild)
}

func NewNodeIndexFromBigInt(i *big.Int) (core.NodeIndex, error) {
	return node.NewNodeIndexFromBigInt(i)
}

// NewNodeIndexFromHex creates a new NodeIndex from a hex string that
// represents the index in big-endian format.
func NewNodeIndexFromHex(h string) (core.NodeIndex, error) {
	return node.NewNodeIndexFromHex(h)
}
