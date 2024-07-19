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
