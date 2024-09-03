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

	"github.com/iden3/go-iden3-crypto/poseidon"
	"github.com/stretchr/testify/assert"
)

func TestPoseidonEx(t *testing.T) {
	inputs := []*big.Int{big.NewInt(1234567890), big.NewInt(2345678901), big.NewInt(3456789012), big.NewInt(4567890123)}
	result, err := poseidon.HashEx(inputs, 4)
	assert.NoError(t, err)
	v1, _ := new(big.Int).SetString("11501175702185290676838936720607163128640649954538569247536215022783738807825", 10)
	v2, _ := new(big.Int).SetString("6120530503331008674221484812464542651389744817446661784148353548752694803697", 10)
	v3, _ := new(big.Int).SetString("7124537720832890754896732787915836308362735099852420819626168545145412807782", 10)
	v4, _ := new(big.Int).SetString("1847024135263482697175502194253586321631751560455204108489523026877035496452", 10)
	assert.Equal(t, result, []*big.Int{v1, v2, v3, v4})
}

func TestPoseidonEncrypt(t *testing.T) {
	x, _ := new(big.Int).SetString("2225468530552752510522780019536893048169408270351832766087923920964657502364", 10)
	y, _ := new(big.Int).SetString("18264896395019517559018400396898398442219687903646821466907778802937824776999", 10)
	key := []*big.Int{x, y}
	nonce, _ := new(big.Int).SetString("220373351579243596212522709113509916796", 10)
	msg := []*big.Int{big.NewInt(1234567890), big.NewInt(2345678901)}
	cipherText, err := PoseidonEncrypt(msg, key, nonce)
	assert.NoError(t, err)
	assert.Equal(t, "3623473636383738070031324804097049685564466189577273141109672613904615191520", cipherText[0].Text(10))
	assert.Equal(t, "14192366070411288656840625597415252300006763456323771445497376523077328650161", cipherText[1].Text(10))
	assert.Equal(t, "8948874854696341437962075211230225158124203775185169948359228967178039019393", cipherText[2].Text(10))
	assert.Equal(t, "13654519867376896827561074824557193869787926453227340059166840999629617764240", cipherText[3].Text(10))
}
