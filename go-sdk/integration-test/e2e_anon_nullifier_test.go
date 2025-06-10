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

func (s *E2ETestSuite) TestZeto_anon_nullifier_SuccessfulProving() {
	calc, provingKey, err := loadCircuit("anon_nullifier_transfer")
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

	sender := testutils.NewKeypair()
	receiver := testutils.NewKeypair()
	senderEthAddress, ok := new(big.Int).SetString("5d093e9b41911be5f5c4cf91b108bac5d130fa83", 16)
	assert.True(s.T(), ok)
	mt, err := smt.NewMerkleTree(s.db, MAX_HEIGHT)
	assert.NoError(s.T(), err)

	const size = 2

	inputValues := []*big.Int{big.NewInt(1), big.NewInt(2)}
	outputValues := []*big.Int{big.NewInt(2), big.NewInt(1)}

	inputCommitments := make([]*big.Int, 0, size)
	inputSalts := make([]*big.Int, 0, size)
	nullifiers := make([]*big.Int, 0, size)
	for _, value := range inputValues {
		salt := crypto.NewSalt()
		commitment, _ := poseidon.Hash([]*big.Int{value, salt, sender.PublicKey.X, sender.PublicKey.Y})
		nullifier, _ := poseidon.Hash([]*big.Int{value, salt, sender.PrivateKeyBigInt})
		inputCommitments = append(inputCommitments, commitment)
		inputSalts = append(inputSalts, salt)
		nullifiers = append(nullifiers, nullifier)

		utxo := node.NewFungible(value, sender.PublicKey, salt)
		n, err := node.NewLeafNode(utxo, senderEthAddress)
		assert.NoError(s.T(), err)
		err = mt.AddLeaf(n)
		assert.NoError(s.T(), err)
	}

	outputCommitments := make([]*big.Int, 0, size)
	outputSalts := make([]*big.Int, 0, size)
	outputOwnerPublicKeys := make([][]*big.Int, 0, size)
	enabled := make([]*big.Int, 0, size)
	for _, value := range outputValues {
		salt := crypto.NewSalt()
		commitment, _ := poseidon.Hash([]*big.Int{value, salt, receiver.PublicKey.X, receiver.PublicKey.Y})
		outputCommitments = append(outputCommitments, commitment)
		outputSalts = append(outputSalts, salt)
		outputOwnerPublicKeys = append(outputOwnerPublicKeys, []*big.Int{receiver.PublicKey.X, receiver.PublicKey.Y})
		enabled = append(enabled, big.NewInt(1)) // all outputs are enabled
	}

	proofs, _, err := mt.GenerateProofs(inputCommitments, nil)
	assert.NoError(s.T(), err)
	proofSiblingsArray := make([][]*big.Int, 0, len(proofs))
	for i, proof := range proofs {
		input := inputCommitments[i]
		circomProof, err := proof.ToCircomVerifierProof(input, input, mt.Root(), MAX_HEIGHT)
		assert.NoError(s.T(), err)
		proofSiblings := make([]*big.Int, len(circomProof.Siblings)-1)
		for j, s := range circomProof.Siblings[0 : len(circomProof.Siblings)-1] {
			proofSiblings[j] = s.BigInt()
		}
		proofSiblingsArray = append(proofSiblingsArray, proofSiblings)
	}

	witnessInputs := map[string]interface{}{
		"nullifiers":            nullifiers,
		"inputCommitments":      inputCommitments,
		"inputValues":           inputValues,
		"inputSalts":            inputSalts,
		"inputOwnerPrivateKey":  sender.PrivateKeyBigInt,
		"root":                  mt.Root().BigInt(),
		"merkleProof":           proofSiblingsArray,
		"enabled":               enabled,
		"outputCommitments":     outputCommitments,
		"outputValues":          outputValues,
		"outputSalts":           outputSalts,
		"outputOwnerPublicKeys": outputOwnerPublicKeys,
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

	sender := testutils.NewKeypair()
	receiver := testutils.NewKeypair()
	mt, err := smt.NewMerkleTree(s.db, MAX_HEIGHT)
	assert.NoError(s.T(), err)

	inputValues := []*big.Int{big.NewInt(1), big.NewInt(2), big.NewInt(3), big.NewInt(4), big.NewInt(5), big.NewInt(6), big.NewInt(7), big.NewInt(8), big.NewInt(9), big.NewInt(10)}
	outputValues := []*big.Int{big.NewInt(10), big.NewInt(9), big.NewInt(8), big.NewInt(7), big.NewInt(6), big.NewInt(5), big.NewInt(4), big.NewInt(3), big.NewInt(2), big.NewInt(1)}

	inputCommitments := make([]*big.Int, 0, 10)
	inputSalts := make([]*big.Int, 0, 10)
	nullifiers := make([]*big.Int, 0, 10)
	for _, value := range inputValues {
		salt := crypto.NewSalt()
		commitment, _ := poseidon.Hash([]*big.Int{value, salt, sender.PublicKey.X, sender.PublicKey.Y})
		nullifier, _ := poseidon.Hash([]*big.Int{value, salt, sender.PrivateKeyBigInt})
		inputCommitments = append(inputCommitments, commitment)
		inputSalts = append(inputSalts, salt)
		nullifiers = append(nullifiers, nullifier)

		utxo := node.NewFungible(value, sender.PublicKey, salt)
		n, err := node.NewLeafNode(utxo)
		assert.NoError(s.T(), err)
		err = mt.AddLeaf(n)
		assert.NoError(s.T(), err)
	}

	outputCommitments := make([]*big.Int, 0, 10)
	outputSalts := make([]*big.Int, 0, 10)
	outputOwnerPublicKeys := make([][]*big.Int, 0, 10)
	enabled := make([]*big.Int, 0, 10)
	for _, value := range outputValues {
		salt := crypto.NewSalt()
		commitment, _ := poseidon.Hash([]*big.Int{value, salt, receiver.PublicKey.X, receiver.PublicKey.Y})
		outputCommitments = append(outputCommitments, commitment)
		outputSalts = append(outputSalts, salt)
		outputOwnerPublicKeys = append(outputOwnerPublicKeys, []*big.Int{receiver.PublicKey.X, receiver.PublicKey.Y})
		enabled = append(enabled, big.NewInt(1)) // all outputs are enabled
	}

	proofs, _, err := mt.GenerateProofs(inputCommitments, nil)
	assert.NoError(s.T(), err)
	proofSiblingsArray := make([][]*big.Int, 0, len(proofs))
	for i, proof := range proofs {
		input := inputCommitments[i]
		circomProof, err := proof.ToCircomVerifierProof(input, input, mt.Root(), MAX_HEIGHT)
		assert.NoError(s.T(), err)
		proofSiblings := make([]*big.Int, len(circomProof.Siblings)-1)
		for j, s := range circomProof.Siblings[0 : len(circomProof.Siblings)-1] {
			proofSiblings[j] = s.BigInt()
		}
		proofSiblingsArray = append(proofSiblingsArray, proofSiblings)
	}

	witnessInputs := map[string]interface{}{
		"nullifiers":            nullifiers,
		"inputCommitments":      inputCommitments,
		"inputValues":           inputValues,
		"inputSalts":            inputSalts,
		"inputOwnerPrivateKey":  sender.PrivateKeyBigInt,
		"root":                  mt.Root().BigInt(),
		"merkleProof":           proofSiblingsArray,
		"enabled":               enabled,
		"outputCommitments":     outputCommitments,
		"outputValues":          outputValues,
		"outputSalts":           outputSalts,
		"outputOwnerPublicKeys": outputOwnerPublicKeys,
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

	sender := testutils.NewKeypair()
	mt, err := smt.NewMerkleTree(s.db, MAX_HEIGHT)
	assert.NoError(s.T(), err)

	inputValues := []*big.Int{big.NewInt(10), big.NewInt(20)}
	outputValues := []*big.Int{big.NewInt(15)}

	size := 2

	inputCommitments := make([]*big.Int, 0, size)
	inputSalts := make([]*big.Int, 0, size)
	nullifiers := make([]*big.Int, 0, size)
	enabled := make([]*big.Int, 0, size)
	for _, value := range inputValues {
		salt := crypto.NewSalt()
		commitment, _ := poseidon.Hash([]*big.Int{value, salt, sender.PublicKey.X, sender.PublicKey.Y})
		nullifier, _ := poseidon.Hash([]*big.Int{value, salt, sender.PrivateKeyBigInt})
		inputCommitments = append(inputCommitments, commitment)
		inputSalts = append(inputSalts, salt)
		nullifiers = append(nullifiers, nullifier)
		enabled = append(enabled, big.NewInt(1)) // all outputs are enabled

		utxo := node.NewFungible(value, sender.PublicKey, salt)
		n, err := node.NewLeafNode(utxo)
		assert.NoError(s.T(), err)
		err = mt.AddLeaf(n)
		assert.NoError(s.T(), err)
	}

	outputCommitments := make([]*big.Int, 0, 1)
	outputSalts := make([]*big.Int, 0, 1)
	for _, value := range outputValues {
		salt := crypto.NewSalt()
		commitment, _ := poseidon.Hash([]*big.Int{value, salt, sender.PublicKey.X, sender.PublicKey.Y})
		outputCommitments = append(outputCommitments, commitment)
		outputSalts = append(outputSalts, salt)
	}

	proofs, _, err := mt.GenerateProofs(inputCommitments, nil)
	assert.NoError(s.T(), err)
	proofSiblingsArray := make([][]*big.Int, 0, len(proofs))
	for i, proof := range proofs {
		input := inputCommitments[i]
		circomProof, err := proof.ToCircomVerifierProof(input, input, mt.Root(), MAX_HEIGHT)
		assert.NoError(s.T(), err)
		proofSiblings := make([]*big.Int, len(circomProof.Siblings)-1)
		for j, s := range circomProof.Siblings[0 : len(circomProof.Siblings)-1] {
			proofSiblings[j] = s.BigInt()
		}
		proofSiblingsArray = append(proofSiblingsArray, proofSiblings)
	}

	witnessInputs := map[string]interface{}{
		"nullifiers":       nullifiers,
		"inputCommitments": inputCommitments,
		"inputValues":      inputValues,
		"inputSalts":       inputSalts,
		"ownerPrivateKey":  sender.PrivateKeyBigInt,
		"root":             mt.Root().BigInt(),
		"merkleProof":      proofSiblingsArray,
		"enabled":          enabled,
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
