const { polyFromBytes, MlKem512 } = require('crystals-kyber-js');

async function generateQurrencyKey() {
  let m = new MlKem512();
  let [ek, dk] = await m.generateKeyPair();

  let t0 = ek.slice(0, 384);
  let t1 = ek.slice(384, 768);
  let rho = ek.slice(768);

  let t0_out = polyFromBytes(t0);
  let t1_out = polyFromBytes(t1);

  let a = m.sampleMatrix(rho, false);

  console.log(`t[0]: [${t0_out.slice(0, 256)}]\n`);
  console.log(`t[1]: [${t1_out.slice(0, 256)}]\n`);
  console.log(`a[0][0]: [${a[0][0].slice(0, 256)}]\n`);
  console.log(`a[0][1]: [${a[0][1].slice(0, 256)}]\n`);
  console.log(`a[1][0]: [${a[1][0].slice(0, 256)}]\n`);
  console.log(`a[1][1]: [${a[1][1].slice(0, 256)}]\n`);
  console.log(`PUBLIC KEY: [${ek}]\n`);
  console.log(`SECRET KEY: [${dk.slice(0, 768)}]`);
}

generateQurrencyKey()
  .then(() => {
    console.log('Key generation completed successfully.');
  })
  .catch((error) => {
    console.error('Error during key generation:', error);
  });
