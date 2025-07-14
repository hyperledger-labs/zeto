const { polyFromBytes, MlKem512 } = require('crystals-kyber-js');
const { sha3_256 } = require('@noble/hashes/sha3');
const crypto = require('crypto');
const { bytesToBits } = require('../../js/lib/util.js');

async function generateQurrencyKey() {
  // generate a 64-byte seed, which can be used in any standard ML-KEM implementation
  // to derive the public and private keys
  const buff = crypto.randomBytes(64);
  const seed = new Uint8Array(buff);

  let m = new MlKem512();
  let [ek, dk] = await m.deriveKeyPair(seed);

  let t0 = ek.slice(0, 384);
  let t1 = ek.slice(384, 768);
  let rho = ek.slice(768);

  let t0_out = polyFromBytes(t0);
  let t1_out = polyFromBytes(t1);

  let a = m.sampleMatrix(rho, false);

  const pkR = new Uint8Array(ek);
  const pkHash = h(pkR);
  const pkHashBits = bytesToBits(pkHash);

  console.log(`t[0]: [${t0_out.slice(0, 256)}]\n`);
  console.log(`t[1]: [${t1_out.slice(0, 256)}]\n`);
  console.log(`a[0][0]: [${a[0][0].slice(0, 256)}]\n`);
  console.log(`a[0][1]: [${a[0][1].slice(0, 256)}]\n`);
  console.log(`a[1][0]: [${a[1][0].slice(0, 256)}]\n`);
  console.log(`a[1][1]: [${a[1][1].slice(0, 256)}]\n`);
  console.log(`PUBLIC KEY: [${ek}]\n`);
  console.log(`PUBLIC KEY HASH: [${pkHashBits}]\n`);
  console.log(`SECRET KEY: [${dk}]\n`);
  console.log(`Secret seed: [${seed}]\n`);
}

// copied from node_modules/mlkem/script/src/mlKemBase.js
function h(pk) {
  const hash = sha3_256.create();
  hash.update(pk);
  return hash.digest();
}

generateQurrencyKey()
  .then(() => {
    console.log('Key generation completed successfully.');
  })
  .catch((error) => {
    console.error('Error during key generation:', error);
  });
