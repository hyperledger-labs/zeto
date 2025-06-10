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
	"github.com/iden3/go-iden3-crypto/poseidon"
	"github.com/iden3/go-rapidsnark/prover"
	"github.com/stretchr/testify/assert"
)

func (s *E2ETestSuite) TestZeto_anon_SuccessfulProving() {
	calc, provingKey, err := loadCircuit("anon")
	assert.NoError(s.T(), err)
	assert.NotNil(s.T(), calc)

	sender := testKeyFromKeyStorev3(s.T())
	receiver := testutils.NewKeypair()

	inputValues := []*big.Int{big.NewInt(30), big.NewInt(40)}
	outputValues := []*big.Int{big.NewInt(32), big.NewInt(38)}

	salt1 := crypto.NewSalt()
	input1, _ := poseidon.Hash([]*big.Int{inputValues[0], salt1, sender.PublicKey.X, sender.PublicKey.Y})
	salt2 := crypto.NewSalt()
	input2, _ := poseidon.Hash([]*big.Int{inputValues[1], salt2, sender.PublicKey.X, sender.PublicKey.Y})
	inputCommitments := []*big.Int{input1, input2}

	salt3 := crypto.NewSalt()
	output1, _ := poseidon.Hash([]*big.Int{outputValues[0], salt3, receiver.PublicKey.X, receiver.PublicKey.Y})
	salt4 := crypto.NewSalt()
	output2, _ := poseidon.Hash([]*big.Int{outputValues[1], salt4, sender.PublicKey.X, sender.PublicKey.Y})
	outputCommitments := []*big.Int{output1, output2}

	witnessInputs := map[string]interface{}{
		"inputCommitments":      inputCommitments,
		"inputValues":           inputValues,
		"inputSalts":            []*big.Int{salt1, salt2},
		"inputOwnerPrivateKey":  sender.PrivateKeyForZkp,
		"outputCommitments":     outputCommitments,
		"outputValues":          outputValues,
		"outputSalts":           []*big.Int{salt3, salt4},
		"outputOwnerPublicKeys": [][]*big.Int{{receiver.PublicKey.X, receiver.PublicKey.Y}, {sender.PublicKey.X, sender.PublicKey.Y}},
	}

	// calculate the witness object for checking correctness
	witness, err := calc.CalculateWitness(witnessInputs, true)
	assert.NoError(s.T(), err)
	assert.NotNil(s.T(), witness)

	assert.Equal(s.T(), 0, witness[0].Cmp(big.NewInt(1)))
	assert.Equal(s.T(), 0, witness[1].Cmp(inputCommitments[0]))
	assert.Equal(s.T(), 0, witness[2].Cmp(inputCommitments[1]))
	assert.Equal(s.T(), 0, witness[3].Cmp(outputCommitments[0]))
	assert.Equal(s.T(), 0, witness[4].Cmp(outputCommitments[1]))

	// generate the witness binary to feed into the prover
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
	assert.Equal(s.T(), 4, len(proof.PubSignals))
}
