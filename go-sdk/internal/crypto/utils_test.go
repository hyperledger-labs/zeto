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

package crypto

import (
	"math/big"
	"testing"

	"github.com/iden3/go-iden3-crypto/constants"
	"github.com/stretchr/testify/assert"
)

func TestNewSalt(t *testing.T) {
	salt := NewSalt()
	assert.NotNil(t, salt)
	max := constants.Q
	assert.Less(t, salt.Cmp(max), 0)
}

func TestNewEncryptionNonce(t *testing.T) {
	nonce := NewEncryptionNonce()
	assert.NotNil(t, nonce)
	max, _ := new(big.Int).SetString("340282366920938463463374607431768211456", 10)
	assert.Less(t, nonce.Cmp(max), 0)
}
