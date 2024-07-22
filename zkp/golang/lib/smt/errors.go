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

import "errors"

var (
	// ErrMaxLevelsExceeded is used when a level is larger than the max
	ErrMaxLevelsExceeded = errors.New("tree height is larger than max allowed (256)")
	// ErrNodeIndexAlreadyExists is used when a node index already exists.
	ErrNodeIndexAlreadyExists = errors.New("key already exists")
	// ErrNodeIndexTooLarge is used when a node index is too large.
	ErrNodeIndexTooLarge = errors.New("key for the new node not inside the Finite Field")
	// ErrKeyNotFound is used when a key is not found in the MerkleTree.
	ErrKeyNotFound = errors.New("key not found in the MerkleTree")
	// ErrNodeBytesBadSize is used when the data of a node has an incorrect
	// size and can't be parsed.
	ErrNodeBytesBadSize = errors.New("expected 32 bytes for the decoded node index")
	// ErrReachedMaxLevel is used when a traversal of the MT reaches the
	// maximum level.
	ErrReachedMaxLevel = errors.New("reached maximum level of the merkle tree")
	// ErrInvalidNodeFound is used when an invalid node is found and can't
	// be parsed.
	ErrInvalidNodeFound = errors.New("found an invalid node in the DB")
	// ErrInvalidDBValue is used when a value in the key value DB is
	// invalid (for example, it doen't contain a byte header and a []byte
	// body of at least len=1.
	ErrInvalidDBValue = errors.New("the value in the DB is invalid")
)
