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

package crypto

import (
	"testing"

	"github.com/cloudflare/circl/kem/mlkem/mlkem512"

	"github.com/stretchr/testify/assert"
)

func TestDeriveKeyPairFromSeed(t *testing.T) {
	seed := []uint8{250, 194, 254, 134, 182, 94, 137, 14, 117, 191, 14, 236, 64, 46, 237, 248, 232, 51, 113, 137, 93, 110, 178, 99, 254, 75, 29, 62, 89, 148, 20, 66, 116, 45, 176, 82, 40, 240, 42, 172, 185, 106, 139, 250, 148, 211, 84, 155, 212, 134, 83, 156, 51, 190, 13, 87, 3, 125, 114, 205, 168, 73, 92, 247}

	_, sk := mlkem512.NewKeyFromSeed(seed)

	// generated from a javascript based standard ML-KEM implementation, using the same DK seed
	ciphertext := []uint8{116, 142, 101, 251, 15, 34, 199, 66, 163, 245, 234, 244, 165, 189, 15, 9, 68, 99, 220, 254, 192, 114, 126, 118, 69, 92, 89, 210, 159, 82, 244, 226, 133, 196, 36, 254, 147, 97, 245, 243, 22, 53, 141, 254, 124, 76, 146, 3, 73, 83, 159, 246, 34, 95, 33, 224, 76, 113, 36, 15, 195, 215, 121, 27, 217, 42, 232, 144, 150, 14, 126, 4, 41, 184, 13, 86, 167, 36, 7, 164, 210, 130, 162, 18, 170, 73, 75, 68, 133, 216, 131, 87, 168, 82, 40, 2, 15, 87, 206, 119, 162, 165, 248, 218, 133, 133, 112, 90, 89, 252, 13, 7, 53, 40, 134, 27, 179, 7, 104, 238, 99, 168, 248, 145, 160, 117, 212, 86, 147, 27, 23, 124, 203, 210, 125, 157, 244, 51, 161, 49, 159, 23, 194, 200, 67, 113, 236, 81, 79, 57, 145, 105, 189, 190, 10, 121, 31, 16, 235, 214, 200, 98, 59, 147, 227, 95, 169, 233, 254, 52, 29, 41, 228, 196, 101, 168, 45, 168, 179, 212, 108, 241, 66, 168, 94, 141, 148, 175, 211, 160, 134, 175, 112, 179, 152, 218, 42, 172, 196, 52, 208, 222, 219, 60, 166, 52, 17, 50, 178, 10, 53, 89, 204, 157, 81, 80, 122, 191, 97, 81, 117, 106, 169, 175, 232, 72, 145, 168, 2, 8, 129, 78, 162, 128, 139, 235, 14, 120, 13, 58, 151, 35, 151, 108, 108, 32, 112, 207, 67, 164, 167, 186, 100, 196, 229, 232, 9, 227, 54, 31, 255, 231, 158, 51, 85, 48, 200, 182, 140, 55, 161, 44, 146, 252, 41, 40, 200, 187, 199, 141, 218, 140, 244, 128, 217, 135, 104, 207, 213, 24, 213, 61, 23, 196, 132, 66, 103, 204, 176, 39, 124, 175, 139, 37, 99, 214, 220, 43, 242, 53, 42, 11, 98, 251, 205, 34, 153, 10, 29, 82, 67, 222, 106, 245, 16, 100, 187, 175, 100, 66, 189, 128, 63, 19, 212, 115, 27, 156, 63, 181, 167, 95, 244, 7, 3, 88, 246, 102, 88, 237, 210, 9, 1, 178, 125, 177, 84, 66, 111, 48, 81, 49, 126, 104, 76, 229, 204, 53, 83, 230, 247, 239, 135, 74, 167, 6, 129, 186, 68, 101, 164, 125, 252, 202, 152, 156, 163, 52, 221, 228, 142, 141, 83, 131, 249, 247, 197, 54, 226, 16, 102, 201, 155, 104, 188, 141, 132, 64, 160, 86, 149, 178, 70, 120, 251, 162, 228, 140, 179, 250, 91, 207, 106, 70, 89, 237, 163, 53, 67, 45, 135, 40, 168, 117, 109, 239, 100, 4, 170, 202, 237, 209, 115, 82, 109, 177, 4, 58, 241, 56, 160, 243, 74, 25, 121, 168, 102, 246, 138, 84, 108, 39, 197, 123, 98, 85, 145, 55, 50, 183, 161, 3, 186, 87, 94, 46, 100, 164, 164, 67, 244, 236, 7, 80, 247, 193, 11, 51, 231, 178, 112, 118, 91, 27, 144, 186, 244, 5, 93, 18, 79, 56, 60, 31, 164, 117, 155, 209, 18, 185, 71, 38, 66, 66, 196, 243, 10, 126, 23, 170, 52, 100, 6, 59, 0, 112, 73, 238, 244, 40, 242, 152, 77, 249, 194, 139, 159, 9, 88, 93, 18, 144, 199, 23, 46, 21, 37, 56, 94, 226, 55, 144, 65, 15, 165, 146, 102, 18, 121, 169, 58, 133, 105, 137, 16, 9, 88, 58, 156, 34, 1, 130, 211, 246, 138, 45, 33, 176, 141, 58, 208, 73, 64, 191, 251, 60, 104, 247, 156, 21, 54, 4, 223, 177, 35, 96, 136, 191, 118, 185, 124, 189, 24, 88, 105, 88, 13, 49, 135, 178, 199, 4, 129, 203, 171, 30, 142, 12, 166, 158, 92, 74, 232, 239, 204, 150, 219, 161, 59, 177, 239, 43, 176, 248, 170, 162, 249, 133, 44, 109, 17, 121, 14, 48, 170, 208, 211, 79, 39, 75, 72, 1, 155, 88, 96, 248, 16, 62, 30, 103, 163, 154, 136, 2, 155, 78, 177, 63, 190, 122, 129, 120, 115, 195, 131, 253, 166, 49, 65, 61, 136, 169, 207, 68, 63, 14, 230, 22, 66, 244, 158, 11, 34, 173, 84, 32, 209, 220, 221, 132, 107, 105, 191, 69, 205, 162, 114, 84, 242, 112, 78, 247, 187, 101, 66, 214, 58, 54, 73, 76, 140, 143, 2, 72, 7, 113, 106, 241, 90, 102, 180, 51, 29, 235, 151, 29, 156, 120, 255, 226, 9, 141, 139, 15, 112, 201, 203, 3, 187, 78, 170, 30, 121, 97, 200, 254, 181, 102, 231, 89, 207, 12, 71, 145, 31, 250, 141, 128}
	expectedSS := []uint8{235, 33, 14, 73, 48, 217, 168, 249, 233, 93, 39, 193, 15, 228, 73, 69, 33, 66, 110, 244, 35, 102, 12, 202, 181, 225, 232, 171, 174, 128, 248, 84}

	ss, err := sk.Scheme().Decapsulate(sk, ciphertext)
	assert.NoError(t, err, "Failed to decapsulate ciphertext")
	assert.Equal(t, 32, len(ss), "Shared secret size mismatch")
	assert.Equal(t, expectedSS, ss, "Shared secret mismatch")
}
