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

package utxo

import (
	"math/big"
	"testing"

	"github.com/hyperledger-labs/zeto/go-sdk/pkg/key-manager/key"
	"github.com/iden3/go-iden3-crypto/babyjub"
	"github.com/stretchr/testify/assert"
)

func TestGenerateECDHSharedSecret(t *testing.T) {
	var privKeyBytes [32]byte
	copy(privKeyBytes[:], []byte("8591289168377258325192647276232541221313093486070083428653476231739508184269"))
	keyEntry := key.NewKeyEntryFromPrivateKeyBytes([32]byte(privKeyBytes))
	assert.Equal(t, "18614971213364712859074067781477589685149038833485178398149193853175174072062", babyjub.SkToBigInt(keyEntry.PrivateKey).Text(10))

	sharedSecret := GenerateECDHSharedSecret(keyEntry.PrivateKey, keyEntry.PublicKey)
	x, _ := new(big.Int).SetString("18518446309131784949822597362227135493418835513165915991318565714720134219323", 10)
	y, _ := new(big.Int).SetString("8439048455461513413627610793392358187791494867846033897541485313950764756693", 10)
	expected := &babyjub.Point{
		X: x,
		Y: y,
	}
	assert.Equal(t, expected, sharedSecret)
}
