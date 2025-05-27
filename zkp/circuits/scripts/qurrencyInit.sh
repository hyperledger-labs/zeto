#!/bin/bash

git clone https://github.com/dajiaji/crystals-kyber-js.git
cd crystals-kyber-js

sed -i '' 's/private _sampleMatrix[(]/public _sampleMatrix(/g' src/mlKemBase.ts
sed -i '' 's/function polyFromBytes[(]a: Uint8Array[)]: Array<number> [{]/export function polyFromBytes(a: Uint8Array): Array<number> {/g' src/mlKemBase.ts

cp ../generateQurrencyKey.ts ./generateQurrencyKey.ts
deno run generateQurrencyKey.ts

cd ..
rm -rf crystals-kyber-js