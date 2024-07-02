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

package cutxo

import (
	"crypto/rand"
	"fmt"
	"math/big"
	"testing"
	"time"

	"github.com/iden3/go-iden3-crypto/babyjub"
	"github.com/iden3/go-iden3-crypto/poseidon"
	"github.com/iden3/go-merkletree"
	"github.com/iden3/go-merkletree/db/memory"
	"github.com/iden3/go-rapidsnark/prover"
	"github.com/stretchr/testify/assert"
)

type User struct {
	PrivateKey       *babyjub.PrivateKey
	PublicKey        *babyjub.PublicKey
	PrivateKeyBigInt *big.Int
}

func TestZeto_1_SuccessfulProving(t *testing.T) {
	calc, provingKey, err := LoadCircuit("anon")
	assert.NoError(t, err)
	assert.NotNil(t, calc)

	sender := newKeypair()
	receiver := newKeypair()

	inputValues := []*big.Int{big.NewInt(30), big.NewInt(40)}
	outputValues := []*big.Int{big.NewInt(32), big.NewInt(38)}

	salt1 := newSalt()
	input1, _ := poseidon.Hash([]*big.Int{inputValues[0], salt1, sender.PublicKey.X, sender.PublicKey.Y})
	salt2 := newSalt()
	input2, _ := poseidon.Hash([]*big.Int{inputValues[1], salt2, sender.PublicKey.X, sender.PublicKey.Y})
	inputCommitments := []*big.Int{input1, input2}

	salt3 := newSalt()
	output1, _ := poseidon.Hash([]*big.Int{outputValues[0], salt3, receiver.PublicKey.X, receiver.PublicKey.Y})
	salt4 := newSalt()
	output2, _ := poseidon.Hash([]*big.Int{outputValues[1], salt4, sender.PublicKey.X, sender.PublicKey.Y})
	outputCommitments := []*big.Int{output1, output2}

	witnessInputs := map[string]interface{}{
		"inputCommitments":      inputCommitments,
		"inputValues":           inputValues,
		"inputSalts":            []*big.Int{salt1, salt2},
		"senderPrivateKey":      sender.PrivateKeyBigInt,
		"outputCommitments":     outputCommitments,
		"outputValues":          outputValues,
		"outputSalts":           []*big.Int{salt3, salt4},
		"outputOwnerPublicKeys": [][]*big.Int{{receiver.PublicKey.X, receiver.PublicKey.Y}, {sender.PublicKey.X, sender.PublicKey.Y}},
	}

	// calculate the witness object for checking correctness
	witness, err := calc.CalculateWitness(witnessInputs, true)
	assert.NoError(t, err)
	assert.NotNil(t, witness)

	assert.Equal(t, 0, witness[0].Cmp(big.NewInt(1)))
	assert.Equal(t, 0, witness[1].Cmp(inputCommitments[0]))
	assert.Equal(t, 0, witness[2].Cmp(inputCommitments[1]))
	assert.Equal(t, 0, witness[3].Cmp(outputCommitments[0]))
	assert.Equal(t, 0, witness[4].Cmp(outputCommitments[1]))

	// generate the witness binary to feed into the prover
	startTime := time.Now()
	witnessBin, err := calc.CalculateWTNSBin(witnessInputs, true)
	assert.NoError(t, err)
	assert.NotNil(t, witnessBin)

	proof, err := prover.Groth16Prover(provingKey, witnessBin)
	elapsedTime := time.Since(startTime)
	fmt.Printf("Proving time: %s\n", elapsedTime)
	assert.NoError(t, err)
	assert.Equal(t, 3, len(proof.Proof.A))
	assert.Equal(t, 3, len(proof.Proof.B))
	assert.Equal(t, 3, len(proof.Proof.C))
	assert.Equal(t, 4, len(proof.PubSignals))
}

func TestZeto_2_SuccessfulProving(t *testing.T) {
	calc, provingKey, err := LoadCircuit("anon_enc")
	assert.NoError(t, err)
	assert.NotNil(t, calc)

	sender := newKeypair()
	receiver := newKeypair()

	inputValues := []*big.Int{big.NewInt(30), big.NewInt(40)}
	outputValues := []*big.Int{big.NewInt(32), big.NewInt(38)}

	salt1 := newSalt()
	input1, _ := poseidon.Hash([]*big.Int{inputValues[0], salt1, sender.PublicKey.X, sender.PublicKey.Y})
	salt2 := newSalt()
	input2, _ := poseidon.Hash([]*big.Int{inputValues[1], salt2, sender.PublicKey.X, sender.PublicKey.Y})
	inputCommitments := []*big.Int{input1, input2}

	salt3 := newSalt()
	output1, _ := poseidon.Hash([]*big.Int{outputValues[0], salt3, receiver.PublicKey.X, receiver.PublicKey.Y})
	salt4 := newSalt()
	output2, _ := poseidon.Hash([]*big.Int{outputValues[1], salt4, sender.PublicKey.X, sender.PublicKey.Y})
	outputCommitments := []*big.Int{output1, output2}

	encryptionNonce := newSalt()

	witnessInputs := map[string]interface{}{
		"inputCommitments":      inputCommitments,
		"inputValues":           inputValues,
		"inputSalts":            []*big.Int{salt1, salt2},
		"senderPrivateKey":      sender.PrivateKeyBigInt,
		"outputCommitments":     outputCommitments,
		"outputValues":          outputValues,
		"outputSalts":           []*big.Int{salt3, salt4},
		"outputOwnerPublicKeys": [][]*big.Int{{receiver.PublicKey.X, receiver.PublicKey.Y}, {sender.PublicKey.X, sender.PublicKey.Y}},
		"encryptionNonce":       encryptionNonce,
	}

	startTime := time.Now()
	witnessBin, err := calc.CalculateWTNSBin(witnessInputs, true)
	assert.NoError(t, err)
	assert.NotNil(t, witnessBin)

	proof, err := prover.Groth16Prover(provingKey, witnessBin)
	elapsedTime := time.Since(startTime)
	fmt.Printf("Proving time: %s\n", elapsedTime)
	assert.NoError(t, err)
	assert.Equal(t, 3, len(proof.Proof.A))
	assert.Equal(t, 3, len(proof.Proof.B))
	assert.Equal(t, 3, len(proof.Proof.C))
	assert.Equal(t, 7, len(proof.PubSignals))
}

func TestZeto_3_SuccessfulProving(t *testing.T) {
	calc, provingKey, err := LoadCircuit("anon_enc_nullifier")
	assert.NoError(t, err)
	assert.NotNil(t, calc)

	sender := newKeypair()
	receiver := newKeypair()

	inputValues := []*big.Int{big.NewInt(30), big.NewInt(40)}
	outputValues := []*big.Int{big.NewInt(32), big.NewInt(38)}

	salt1 := newSalt()
	input1, _ := poseidon.Hash([]*big.Int{inputValues[0], salt1, sender.PublicKey.X, sender.PublicKey.Y})
	salt2 := newSalt()
	input2, _ := poseidon.Hash([]*big.Int{inputValues[1], salt2, sender.PublicKey.X, sender.PublicKey.Y})
	inputCommitments := []*big.Int{input1, input2}

	nullifier1, _ := poseidon.Hash([]*big.Int{inputValues[0], salt1, sender.PrivateKeyBigInt})
	nullifier2, _ := poseidon.Hash([]*big.Int{inputValues[1], salt2, sender.PrivateKeyBigInt})
	nullifiers := []*big.Int{nullifier1, nullifier2}

	MAX_HEIGHT := 64
	smt, err := merkletree.NewMerkleTree(memory.NewMemoryStorage(), MAX_HEIGHT)
	assert.NoError(t, err)
	err = smt.Add(input1, input1)
	assert.NoError(t, err)
	err = smt.Add(input2, input2)
	assert.NoError(t, err)
	proof1, err := smt.GenerateCircomVerifierProof(input1, nil)
	assert.NoError(t, err)
	proof2, err := smt.GenerateCircomVerifierProof(input2, nil)
	assert.NoError(t, err)

	salt3 := newSalt()
	output1, _ := poseidon.Hash([]*big.Int{outputValues[0], salt3, receiver.PublicKey.X, receiver.PublicKey.Y})
	salt4 := newSalt()
	output2, _ := poseidon.Hash([]*big.Int{outputValues[1], salt4, sender.PublicKey.X, sender.PublicKey.Y})
	outputCommitments := []*big.Int{output1, output2}

	encryptionNonce := newSalt()

	proof1Siblings := make([]*big.Int, len(proof1.Siblings)-1)
	for i, s := range proof1.Siblings[0 : len(proof1.Siblings)-1] {
		proof1Siblings[i] = s.BigInt()
	}
	proof2Siblings := make([]*big.Int, len(proof2.Siblings)-1)
	for i, s := range proof2.Siblings[0 : len(proof2.Siblings)-1] {
		proof2Siblings[i] = s.BigInt()
	}
	witnessInputs := map[string]interface{}{
		"nullifiers":            nullifiers,
		"inputCommitments":      inputCommitments,
		"inputValues":           inputValues,
		"inputSalts":            []*big.Int{salt1, salt2},
		"inputOwnerPrivateKey":  sender.PrivateKeyBigInt,
		"root":                  proof2.Root.BigInt(),
		"merkleProof":           [][]*big.Int{proof1Siblings, proof2Siblings},
		"enabled":               []*big.Int{big.NewInt(1), big.NewInt(1)},
		"outputCommitments":     outputCommitments,
		"outputValues":          outputValues,
		"outputSalts":           []*big.Int{salt3, salt4},
		"outputOwnerPublicKeys": [][]*big.Int{{receiver.PublicKey.X, receiver.PublicKey.Y}, {sender.PublicKey.X, sender.PublicKey.Y}},
		"encryptionNonce":       encryptionNonce,
	}

	startTime := time.Now()
	witnessBin, err := calc.CalculateWTNSBin(witnessInputs, true)
	assert.NoError(t, err)
	assert.NotNil(t, witnessBin)

	proof, err := prover.Groth16Prover(provingKey, witnessBin)
	elapsedTime := time.Since(startTime)
	fmt.Printf("Proving time: %s\n", elapsedTime)
	assert.NoError(t, err)
	assert.Equal(t, 3, len(proof.Proof.A))
	assert.Equal(t, 3, len(proof.Proof.B))
	assert.Equal(t, 3, len(proof.Proof.C))
	assert.Equal(t, 10, len(proof.PubSignals))
}

func TestHashTokenUri(t *testing.T) {
	tokenUri := "https://example.com/token/1001"
	hash, err := HashTokenUri(tokenUri)
	assert.NoError(t, err)
	check, ok := new(big.Int).SetString("13892450975113644983085716506756448401911601901613040705635669994423608913168", 10)
	assert.True(t, ok)
	assert.Equal(t, check, hash)
}

func TestZeto_4_SuccessfulProving(t *testing.T) {
	calc, provingKey, err := LoadCircuit("nf_anon")
	assert.NoError(t, err)
	assert.NotNil(t, calc)

	sender := newKeypair()
	receiver := newKeypair()

	tokenId := big.NewInt(1001)
	tokenUri, err := HashTokenUri("https://example.com/token/1001")
	assert.NoError(t, err)

	salt1 := newSalt()
	input1, err := poseidon.Hash([]*big.Int{tokenId, tokenUri, salt1, sender.PublicKey.X, sender.PublicKey.Y})
	assert.NoError(t, err)

	salt3 := newSalt()
	output1, err := poseidon.Hash([]*big.Int{tokenId, tokenUri, salt3, receiver.PublicKey.X, receiver.PublicKey.Y})
	assert.NoError(t, err)

	witnessInputs := map[string]interface{}{
		"tokenIds":              []*big.Int{tokenId},
		"tokenUris":             []*big.Int{tokenUri},
		"inputCommitments":      []*big.Int{input1},
		"inputSalts":            []*big.Int{salt1},
		"inputOwnerPublicKey":   []*big.Int{sender.PublicKey.X, sender.PublicKey.Y},
		"senderPrivateKey":      sender.PrivateKeyBigInt,
		"outputCommitments":     []*big.Int{output1},
		"outputSalts":           []*big.Int{salt3},
		"outputOwnerPublicKeys": [][]*big.Int{{receiver.PublicKey.X, receiver.PublicKey.Y}},
	}

	// calculate the witness object for checking correctness
	witness, err := calc.CalculateWitness(witnessInputs, true)
	assert.NoError(t, err)
	assert.NotNil(t, witness)

	assert.Equal(t, 0, witness[0].Cmp(big.NewInt(1)))
	assert.Equal(t, 0, witness[1].Cmp(input1))
	assert.Equal(t, 0, witness[2].Cmp(output1))
	assert.Equal(t, 0, witness[3].Cmp(tokenId))
	assert.Equal(t, 0, witness[4].Cmp(tokenUri))

	// generate the witness binary to feed into the prover
	startTime := time.Now()
	witnessBin, err := calc.CalculateWTNSBin(witnessInputs, true)
	assert.NoError(t, err)
	assert.NotNil(t, witnessBin)

	proof, err := prover.Groth16Prover(provingKey, witnessBin)
	elapsedTime := time.Since(startTime)
	fmt.Printf("Proving time: %s\n", elapsedTime)
	assert.NoError(t, err)
	assert.Equal(t, 3, len(proof.Proof.A))
	assert.Equal(t, 3, len(proof.Proof.B))
	assert.Equal(t, 3, len(proof.Proof.C))
	assert.Equal(t, 2, len(proof.PubSignals))
}

func TestZeto_5_SuccessfulProving(t *testing.T) {
	calc, provingKey, err := LoadCircuit("nf_anon_nullifier")
	assert.NoError(t, err)
	assert.NotNil(t, calc)

	sender := newKeypair()
	receiver := newKeypair()

	tokenId := big.NewInt(1001)
	tokenUri, err := HashTokenUri("https://example.com/token/1001")
	assert.NoError(t, err)

	salt1 := newSalt()
	input1, err := poseidon.Hash([]*big.Int{tokenId, tokenUri, salt1, sender.PublicKey.X, sender.PublicKey.Y})
	assert.NoError(t, err)

	nullifier1, _ := poseidon.Hash([]*big.Int{tokenId, tokenUri, salt1, sender.PrivateKeyBigInt})

	MAX_HEIGHT := 64
	smt, err := merkletree.NewMerkleTree(memory.NewMemoryStorage(), MAX_HEIGHT)
	assert.NoError(t, err)
	err = smt.Add(input1, input1)
	assert.NoError(t, err)
	proof1, err := smt.GenerateCircomVerifierProof(input1, nil)
	assert.NoError(t, err)
	proof1Siblings := make([]*big.Int, len(proof1.Siblings)-1)
	for i, s := range proof1.Siblings[0 : len(proof1.Siblings)-1] {
		proof1Siblings[i] = s.BigInt()
	}

	salt3 := newSalt()
	output1, err := poseidon.Hash([]*big.Int{tokenId, tokenUri, salt3, receiver.PublicKey.X, receiver.PublicKey.Y})
	assert.NoError(t, err)

	witnessInputs := map[string]interface{}{
		"tokenId":              tokenId,
		"tokenUri":             tokenUri,
		"nullifier":            nullifier1,
		"inputCommitment":      input1,
		"inputSalt":            salt1,
		"inputOwnerPrivateKey": sender.PrivateKeyBigInt,
		"root":                 proof1.Root.BigInt(),
		"merkleProof":          proof1Siblings,
		"outputCommitment":     output1,
		"outputSalt":           salt3,
		"outputOwnerPublicKey": []*big.Int{receiver.PublicKey.X, receiver.PublicKey.Y},
	}

	// calculate the witness object for checking correctness
	witness, err := calc.CalculateWitness(witnessInputs, true)
	assert.NoError(t, err)
	assert.NotNil(t, witness)

	assert.Equal(t, 0, witness[0].Cmp(big.NewInt(1)))
	assert.Equal(t, 0, witness[1].Cmp(nullifier1))

	// generate the witness binary to feed into the prover
	startTime := time.Now()
	witnessBin, err := calc.CalculateWTNSBin(witnessInputs, true)
	assert.NoError(t, err)
	assert.NotNil(t, witnessBin)

	proof, err := prover.Groth16Prover(provingKey, witnessBin)
	elapsedTime := time.Since(startTime)
	fmt.Printf("Proving time: %s\n", elapsedTime)
	assert.NoError(t, err)
	assert.Equal(t, 3, len(proof.Proof.A))
	assert.Equal(t, 3, len(proof.Proof.B))
	assert.Equal(t, 3, len(proof.Proof.C))
	assert.Equal(t, 3, len(proof.PubSignals))
}

// generate a new BabyJub keypair
func newKeypair() *User {
	// generate babyJubjub private key randomly
	babyJubjubPrivKey := babyjub.NewRandPrivKey()
	// generate public key from private key
	babyJubjubPubKey := babyJubjubPrivKey.Public()
	// convert the private key to big.Int for use inside circuits
	privKeyBigInt := babyjub.SkToBigInt(&babyJubjubPrivKey)

	return &User{
		PrivateKey:       &babyJubjubPrivKey,
		PublicKey:        babyJubjubPubKey,
		PrivateKeyBigInt: privKeyBigInt,
	}
}

func newSalt() *big.Int {
	max := big.NewInt(1000000000000)
	randInt, _ := rand.Int(rand.Reader, max)
	return randInt
}
