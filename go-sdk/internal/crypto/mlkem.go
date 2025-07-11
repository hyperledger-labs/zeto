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
	"crypto/mlkem"
	"crypto/rand"
)

func GenerateMLKEMKeyPair() (*mlkem.DecapsulationKey768, []byte, error) {
	privateKey, err := mlkem.GenerateKey768()
	if err != nil {
		return nil, nil, err
	}
	publicKey := privateKey.EncapsulationKey().Bytes() // encapKey is the public key to be shared
	return privateKey, publicKey, nil
}

func MlKemEncapsulate(publicKey []byte) ([]byte, error) {
	encapKey, err := mlkem.NewEncapsulationKey768(publicKey)
	if err != nil {
		return nil, err
	}
	// generate a random 32 bytes
	randomness := make([]byte, 32)
	if _, err := rand.Read(randomness); err != nil {
		return nil, err
	}
	_, ciphertext := encapKey.Encapsulate()
	return ciphertext, nil
}
