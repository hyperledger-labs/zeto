const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');
const { promisify } = require('util');
const axios = require('axios');

const provingKeysRoot = process.env.PROVING_KEYS_ROOT;
const ptauDownload = process.env.PTAU_DOWNLOAD_PATH;
const specificCircuit = process.argv[2];
const parallelLimit = parseInt(process.env.GEN_CONCURRENCY, 10) || 10; // Default to compile 10 circuits in parallel

// check env vars

if (!provingKeysRoot) {
  console.error('Error: PROVING_KEYS_ROOT is not set.');
  process.exit(1);
}

if (!ptauDownload) {
  console.error('Error: PTAU_DOWNLOAD_PATH is not set.');
  process.exit(1);
}

// load circuits

const circuits = require('./gen-config.json');

const toCamelCase = (str) => {
  return str
    .split('_')
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
    .join('');
};

// util functions

const execAsync = promisify(exec);

const timestamp = () => new Date().toISOString();
const logPrefix = (circuit) => `[${timestamp()}] [${circuit}]`;

const log = (circuit, message) => {
  console.log(logPrefix(circuit) + ' ' + message);
};

// main circuit process logic
const processCircuit = async (circuit, ptau, skipSolidityGenaration) => {
  const circomInput = path.join('./', `${circuit}.circom`);
  const ptauFile = path.join(ptauDownload, `${ptau}.ptau`);
  const zkeyOutput = path.join(provingKeysRoot, `${circuit}.zkey`);

  if (!fs.existsSync(circomInput)) {
    log(circuit, `Error: Input file does not exist: ${circomInput}`);
    return;
  }

  if (!fs.existsSync(ptauFile)) {
    log(circuit, `PTAU file does not exist, downloading: ${ptauFile}`);
    try {
      const response = await axios.get(
        `https://storage.googleapis.com/zkevm/ptau/${ptau}.ptau`,
        {
          responseType: 'stream',
        }
      );
      response.data.pipe(fs.createWriteStream(ptauFile));
      await new Promise((resolve, reject) => {
        response.data.on('end', resolve);
        response.data.on('error', reject);
      });
    } catch (error) {
      log(circuit, `Failed to download PTAU file: ${error}`);
      process.exit(1);
    }
  }

  log(circuit, `Compiling circuit`);
  await execAsync(`circom ${circomInput} --output ../js/lib --sym --wasm`);
  await execAsync(`circom ${circomInput} --output ${provingKeysRoot} --r1cs`);

  log(circuit, `Generating test proving key with ${ptau}`);
  await execAsync(
    `snarkjs groth16 setup ${path.join(
      provingKeysRoot,
      `${circuit}.r1cs`
    )} ${ptauFile} ${zkeyOutput}`
  );

  log(circuit, `Generating verification key`);
  await execAsync(
    `snarkjs zkey export verificationkey ${zkeyOutput} ${path.join(
      provingKeysRoot,
      `${circuit}-vkey.json`
    )}`
  );

  if (skipSolidityGenaration) {
    log(circuit, `Skipping solidity verifier generation`);
    return;
  }

  log(circuit, `Generating solidity verifier`);
  const solidityFile = path.join(
    '..',
    '..',
    'solidity',
    'contracts',
    'lib',
    `verifier_${circuit}.sol`
  );
  await execAsync(
    `snarkjs zkey export solidityverifier ${zkeyOutput} ${solidityFile}`
  );

  log(circuit, `Modifying the contract name in the Solidity file`);
  const camelCaseCircuitName = toCamelCase(circuit);
  const solidityFileTmp = `${solidityFile}.tmp`;

  const fileContent = fs.readFileSync(solidityFile, 'utf8');
  const updatedContent = fileContent.replace(
    ' Groth16Verifier ',
    ` Groth16Verifier_${camelCaseCircuitName} `
  );
  fs.writeFileSync(solidityFileTmp, updatedContent);
  fs.renameSync(solidityFileTmp, solidityFile);
};

const run = async () => {
  if (specificCircuit) {
    // if a specific circuit is provided, check it's in the map
    if (!circuits[specificCircuit]) {
      console.error(`Error: Unknown circuit: ${specificCircuit}`);
      process.exit(1);
    }
  }

  const circuitsArray = Object.entries(circuits);
  const activePromises = new Set();

  for (const [circuit, { ptau, skipSolidityGenaration }] of circuitsArray) {
    if (specificCircuit && circuit !== specificCircuit) {
      continue;
    }

    const pcPromise = processCircuit(circuit, ptau, skipSolidityGenaration);
    activePromises.add(pcPromise);

    if (activePromises.size >= parallelLimit) {
      await Promise.race(activePromises);
    }

    pcPromise.finally(() => activePromises.delete(pcPromise));
  }

  await Promise.all(activePromises);
};

run().catch((err) => {
  console.error(`An error occurred: ${err.message}`);
  process.exit(1);
});