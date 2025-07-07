// Copyright © 2025 Kaleido, Inc.
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

	"github.com/hyperledger-labs/zeto/go-sdk/pkg/crypto"
	"github.com/hyperledger-labs/zeto/go-sdk/pkg/sparse-merkle-tree/node"
	"github.com/hyperledger-labs/zeto/go-sdk/pkg/sparse-merkle-tree/smt"
	"github.com/iden3/go-iden3-crypto/poseidon"
	"github.com/iden3/go-rapidsnark/prover"
	"github.com/stretchr/testify/assert"
)

func (s *E2ETestSuite) TestZeto_anon_nullifier_SuccessfulProving() {
	calc, provingKey, err := loadCircuit("anon_nullifier_transfer")
	assert.NoError(s.T(), err)
	assert.NotNil(s.T(), calc)

	witnessInputs := map[string]interface{}{
		"nullifiers":            s.regularTest.nullifiers,
		"inputCommitments":      s.regularTest.inputCommitments,
		"inputValues":           s.regularTest.inputValues,
		"inputSalts":            s.regularTest.inputSalts,
		"inputOwnerPrivateKey":  s.sender.PrivateKeyBigInt,
		"root":                  s.regularTest.root,
		"merkleProof":           s.regularTest.merkleProofs,
		"enabled":               s.regularTest.enabled,
		"outputCommitments":     s.regularTest.outputCommitments,
		"outputValues":          s.regularTest.outputValues,
		"outputSalts":           s.regularTest.outputSalts,
		"outputOwnerPublicKeys": s.regularTest.outputOwnerPublicKeys,
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
	assert.Equal(s.T(), 7, len(proof.PubSignals))
}

func (s *E2ETestSuite) TestZeto_anon_nullifier_locked_SuccessfulProving() {
	calc, provingKey, err := loadCircuit("anon_nullifier_transferLocked")
	assert.NoError(s.T(), err)
	assert.NotNil(s.T(), calc)

	senderEthAddress, ok := new(big.Int).SetString("5d093e9b41911be5f5c4cf91b108bac5d130fa83", 16)
	assert.True(s.T(), ok)
	_, db, _, _ := newSqliteStorage(s.T())
	mt, err := smt.NewMerkleTree(db, MAX_HEIGHT)
	assert.NoError(s.T(), err)

	for i, value := range s.regularTest.inputValues {
		utxo := node.NewFungible(value, s.sender.PublicKey, s.regularTest.inputSalts[i])
		n, err := node.NewLeafNode(utxo, senderEthAddress)
		assert.NoError(s.T(), err)
		err = mt.AddLeaf(n)
		assert.NoError(s.T(), err)
	}

	proofs, _, err := mt.GenerateProofs(s.regularTest.inputCommitments, nil)
	assert.NoError(s.T(), err)
	proofSiblingsArray := make([][]*big.Int, 0, len(proofs))
	for i, proof := range proofs {
		input := s.regularTest.inputCommitments[i]
		circomProof, err := proof.ToCircomVerifierProof(input, senderEthAddress, mt.Root(), MAX_HEIGHT)
		assert.NoError(s.T(), err)
		proofSiblings := make([]*big.Int, len(circomProof.Siblings)-1)
		for j, s := range circomProof.Siblings[0 : len(circomProof.Siblings)-1] {
			proofSiblings[j] = s.BigInt()
		}
		proofSiblingsArray = append(proofSiblingsArray, proofSiblings)
	}

	witnessInputs := map[string]interface{}{
		"nullifiers":            s.regularTest.nullifiers,
		"inputCommitments":      s.regularTest.inputCommitments,
		"inputValues":           s.regularTest.inputValues,
		"inputSalts":            s.regularTest.inputSalts,
		"inputOwnerPrivateKey":  s.sender.PrivateKeyBigInt,
		"root":                  mt.Root().BigInt(),
		"merkleProof":           proofSiblingsArray,
		"enabled":               s.regularTest.enabled,
		"outputCommitments":     s.regularTest.outputCommitments,
		"outputValues":          s.regularTest.outputValues,
		"outputSalts":           s.regularTest.outputSalts,
		"outputOwnerPublicKeys": s.regularTest.outputOwnerPublicKeys,
		"lockDelegate":          senderEthAddress,
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
	assert.Equal(s.T(), 8, len(proof.PubSignals))
}

func (s *E2ETestSuite) TestZeto_anon_nullifier_batch_SuccessfulProving() {
	calc, provingKey, err := loadCircuit("anon_nullifier_transfer_batch")
	assert.NoError(s.T(), err)
	assert.NotNil(s.T(), calc)

	witnessInputs := map[string]interface{}{
		"nullifiers":            s.batchTest.nullifiers,
		"inputCommitments":      s.batchTest.inputCommitments,
		"inputValues":           s.batchTest.inputValues,
		"inputSalts":            s.batchTest.inputSalts,
		"inputOwnerPrivateKey":  s.sender.PrivateKeyBigInt,
		"root":                  s.batchTest.root,
		"merkleProof":           s.batchTest.merkleProofs,
		"enabled":               s.batchTest.enabled,
		"outputCommitments":     s.batchTest.outputCommitments,
		"outputValues":          s.batchTest.outputValues,
		"outputSalts":           s.batchTest.outputSalts,
		"outputOwnerPublicKeys": s.batchTest.outputOwnerPublicKeys,
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
	assert.Equal(s.T(), 31, len(proof.PubSignals))
}

func (s *E2ETestSuite) TestZeto_anon_nullifier_burn_SuccessfulProving() {
	calc, provingKey, err := loadCircuit("burn_nullifier")
	assert.NoError(s.T(), err)
	assert.NotNil(s.T(), calc)

	// burn 55 out of 70, and return 15
	outputValues := []*big.Int{big.NewInt(15)}

	outputCommitments := make([]*big.Int, 0, 1)
	outputSalts := make([]*big.Int, 0, 1)
	for _, value := range outputValues {
		salt := crypto.NewSalt()
		commitment, _ := poseidon.Hash([]*big.Int{value, salt, s.sender.PublicKey.X, s.sender.PublicKey.Y})
		outputCommitments = append(outputCommitments, commitment)
		outputSalts = append(outputSalts, salt)
	}

	witnessInputs := map[string]interface{}{
		"nullifiers":       s.regularTest.nullifiers,
		"inputCommitments": s.regularTest.inputCommitments,
		"inputValues":      s.regularTest.inputValues,
		"inputSalts":       s.regularTest.inputSalts,
		"ownerPrivateKey":  s.sender.PrivateKeyBigInt,
		"root":             s.regularTest.root,
		"merkleProof":      s.regularTest.merkleProofs,
		"enabled":          s.regularTest.enabled,
		"outputCommitment": outputCommitments,
		"outputValue":      outputValues,
		"outputSalt":       outputSalts,
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
	assert.Equal(s.T(), 6, len(proof.PubSignals))
}
