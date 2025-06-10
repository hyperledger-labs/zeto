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

package integration_test

import (
	"fmt"
	"math/big"
	"time"

	"github.com/hyperledger-labs/zeto/go-sdk/internal/testutils"
	"github.com/hyperledger-labs/zeto/go-sdk/pkg/crypto"
	"github.com/hyperledger-labs/zeto/go-sdk/pkg/sparse-merkle-tree/node"
	"github.com/hyperledger-labs/zeto/go-sdk/pkg/sparse-merkle-tree/smt"
	"github.com/iden3/go-iden3-crypto/poseidon"
	"github.com/iden3/go-rapidsnark/prover"
	"github.com/stretchr/testify/assert"
)

func (s *E2ETestSuite) TestZeto_anon_enc_nullifier_SuccessfulProving() {
	calc, provingKey, err := loadCircuit("anon_enc_nullifier")
	assert.NoError(s.T(), err)
	assert.NotNil(s.T(), calc)

	sender := testutils.NewKeypair()
	receiver := testutils.NewKeypair()

	inputValues := []*big.Int{big.NewInt(30), big.NewInt(40)}
	outputValues := []*big.Int{big.NewInt(32), big.NewInt(38)}

	salt1 := crypto.NewSalt()
	input1, _ := poseidon.Hash([]*big.Int{inputValues[0], salt1, sender.PublicKey.X, sender.PublicKey.Y})
	salt2 := crypto.NewSalt()
	input2, _ := poseidon.Hash([]*big.Int{inputValues[1], salt2, sender.PublicKey.X, sender.PublicKey.Y})
	inputCommitments := []*big.Int{input1, input2}

	nullifier1, _ := poseidon.Hash([]*big.Int{inputValues[0], salt1, sender.PrivateKeyBigInt})
	nullifier2, _ := poseidon.Hash([]*big.Int{inputValues[1], salt2, sender.PrivateKeyBigInt})
	nullifiers := []*big.Int{nullifier1, nullifier2}

	mt, err := smt.NewMerkleTree(s.db, MAX_HEIGHT)
	assert.NoError(s.T(), err)
	utxo1 := node.NewFungible(inputValues[0], sender.PublicKey, salt1)
	n1, err := node.NewLeafNode(utxo1)
	assert.NoError(s.T(), err)
	err = mt.AddLeaf(n1)
	assert.NoError(s.T(), err)
	utxo2 := node.NewFungible(inputValues[1], sender.PublicKey, salt2)
	n2, err := node.NewLeafNode(utxo2)
	assert.NoError(s.T(), err)
	err = mt.AddLeaf(n2)
	assert.NoError(s.T(), err)
	proofs, _, err := mt.GenerateProofs([]*big.Int{input1, input2}, nil)
	assert.NoError(s.T(), err)
	circomProof1, err := proofs[0].ToCircomVerifierProof(input1, input1, mt.Root(), MAX_HEIGHT)
	assert.NoError(s.T(), err)
	circomProof2, err := proofs[1].ToCircomVerifierProof(input2, input2, mt.Root(), MAX_HEIGHT)
	assert.NoError(s.T(), err)

	salt3 := crypto.NewSalt()
	output1, _ := poseidon.Hash([]*big.Int{outputValues[0], salt3, receiver.PublicKey.X, receiver.PublicKey.Y})
	salt4 := crypto.NewSalt()
	output2, _ := poseidon.Hash([]*big.Int{outputValues[1], salt4, sender.PublicKey.X, sender.PublicKey.Y})
	outputCommitments := []*big.Int{output1, output2}

	encryptionNonce := crypto.NewEncryptionNonce()
	ephemeralKeypair := testutils.NewKeypair()

	proof1Siblings := make([]*big.Int, len(circomProof1.Siblings)-1)
	for i, s := range circomProof1.Siblings[0 : len(circomProof1.Siblings)-1] {
		proof1Siblings[i] = s.BigInt()
	}
	proof2Siblings := make([]*big.Int, len(circomProof2.Siblings)-1)
	for i, s := range circomProof2.Siblings[0 : len(circomProof2.Siblings)-1] {
		proof2Siblings[i] = s.BigInt()
	}
	witnessInputs := map[string]interface{}{
		"nullifiers":            nullifiers,
		"inputCommitments":      inputCommitments,
		"inputValues":           inputValues,
		"inputSalts":            []*big.Int{salt1, salt2},
		"inputOwnerPrivateKey":  sender.PrivateKeyBigInt,
		"root":                  mt.Root().BigInt(),
		"merkleProof":           [][]*big.Int{proof1Siblings, proof2Siblings},
		"enabled":               []*big.Int{big.NewInt(1), big.NewInt(1)},
		"outputCommitments":     outputCommitments,
		"outputValues":          outputValues,
		"outputSalts":           []*big.Int{salt3, salt4},
		"outputOwnerPublicKeys": [][]*big.Int{{receiver.PublicKey.X, receiver.PublicKey.Y}, {sender.PublicKey.X, sender.PublicKey.Y}},
		"encryptionNonce":       encryptionNonce,
		"ecdhPrivateKey":        ephemeralKeypair.PrivateKey.Scalar().BigInt(),
	}

	startTime := time.Now()
	witnessBin, err := calc.CalculateWTNSBin(witnessInputs, true)
	assert.NoError(s.T(), err)
	assert.NotNil(s.T(), witnessBin)

	proof, err := prover.Groth16Prover(provingKey, witnessBin)
	elapsedTime := time.Since(startTime)
	fmt.Printf("Proving time: %s\n", elapsedTime)
	assert.NoError(s.T(), err)
	assert.Equal(s.T(), 3, len(proof.Proof.A))
	assert.Equal(s.T(), 3, len(proof.Proof.B))
	assert.Equal(s.T(), 3, len(proof.Proof.C))
	assert.Equal(s.T(), 18, len(proof.PubSignals))
}
