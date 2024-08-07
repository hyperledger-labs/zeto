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

const path = require("path");
const { readFileSync } = require("fs");

function provingKeysRoot() {
  const PROVING_KEYS_ROOT = process.env.PROVING_KEYS_ROOT;
  if (!PROVING_KEYS_ROOT) {
    throw new Error("PROVING_KEYS_ROOT env var is not set");
  }
  return PROVING_KEYS_ROOT;
}

function loadProvingKeys(type) {
  const provingKeyFile = path.join(provingKeysRoot(), `${type}.zkey`);
  const verificationKey = JSON.parse(
    new TextDecoder().decode(
      readFileSync(path.join(provingKeysRoot(), `${type}-vkey.json`))
    )
  );
  return {
    provingKeyFile,
    verificationKey,
  };
}

module.exports = { loadProvingKeys };
