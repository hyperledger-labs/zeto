const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');
const { promisify } = require('util');
const axios = require('axios');
const yargs = require('yargs/yargs');
const blake = require('blakejs');
const { hideBin } = require('yargs/helpers');
const argv = yargs(hideBin(process.argv))
  .option('c', {
    alias: 'circuit',
    describe: 'Specify a single circuit to build',
    type: 'string',
  })
  .option('v', {
    alias: 'verbose',
    describe: 'Enable verbose mode',
    type: 'boolean',
    default: false,
  })
  .option('cp', {
    alias: 'compileOnly',
    describe: 'Compile only',
    type: 'boolean',
    default: false,
  })
  .option('cr', {
    alias: 'circuitsRoot',
    describe: 'Specify the root folder for storing circuits compilation files',
    type: 'string',
  })
  .option('pk', {
    alias: 'provingKeysRoot',
    describe: 'Specify the root folder for storing generated proving keys',
    type: 'string',
  })
  .option('pt', {
    alias: 'ptauDownloadPath',
    describe: 'Specify the root folder for storing downloaded PTAU',
    type: 'string',
  }).argv;

const circuitsRoot = process.env.CIRCUITS_ROOT || argv.circuitsRoot;
const provingKeysRoot = process.env.PROVING_KEYS_ROOT || argv.provingKeysRoot;
const ptauDownload = process.env.PTAU_DOWNLOAD_PATH || argv.ptauDownloadPath;
const specificCircuits = argv.c;
const verbose = argv.v;
const compileOnly = argv.compileOnly;
const parallelLimit = parseInt(process.env.GEN_CONCURRENCY, 10) || 8; // Default to compile 8 circuits in parallel

// check env vars
if (!circuitsRoot) {
  console.error('Error: CIRCUITS_ROOT is not set.');
  process.exit(1);
}

if (!compileOnly && !provingKeysRoot) {
  console.error('Error: PROVING_KEYS_ROOT is not set.');
  process.exit(1);
}

if (!compileOnly && !ptauDownload) {
  console.error('Error: PTAU_DOWNLOAD_PATH is not set.');
  process.exit(1);
}

console.log(
  'Generating circuits with the following settings:\n' +
    JSON.stringify(
      {
        specificCircuits,
        compileOnly,
        verbose,
        parallelLimit,
        circuitsRoot,
        provingKeysRoot,
        ptauDownload,
      },
      null,
      2
    ) +
    '\n'
);

// load configuration

const genConfig = require('./gen-config.json');
const circuits = genConfig.circuits;

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

const calculateHash = async (ptauFile) => {
  return new Promise((resolve, reject) => {
    const context = blake.blake2bInit(64, null);
    const ptauStream = fs.createReadStream(ptauFile);

    ptauStream.on('data', (chunk) => {
      blake.blake2bUpdate(context, chunk);
    });

    ptauStream.on('end', () => {
      const computedHashBytes = blake.blake2bFinal(context);
      const computedHash = Buffer.from(computedHashBytes).toString('hex');
      resolve(computedHash);
    });

    ptauStream.on('error', (err) => {
      reject(err);
    });
  });
};

const downloadAndVerifyPtau = async (ptau) => {
  const ptauFile = path.join(ptauDownload, `${ptau}.ptau`);
  if (!compileOnly && !fs.existsSync(ptauFile)) {
    log(ptau, `PTAU file does not exist, downloading and verifying`);
    try {
      const response = await axios.get(`https://storage.googleapis.com/zkevm/ptau/${ptau}.ptau`, {
        responseType: 'stream',
      });

      const writer = fs.createWriteStream(ptauFile);
      response.data.pipe(writer);
      await new Promise((resolve, reject) => {
        writer.on('finish', resolve);
        writer.on('error', reject);
      });
    } catch (error) {
      log(ptau, `Failed to download PTAU file: ${error}`);
      process.exit(1);
    }

    // Compute blake2b hash and compare to expected value
    try {
      const computedHash = await calculateHash(ptauFile);

      const ptauHashes = require('./ptau_valid_hashes.json');
      const expectedHash = ptauHashes[`${ptau}`];

      if (verbose) {
        log(ptau, `Expected hash: ${expectedHash}`);
        log(ptau, `Computed hash: ${computedHash}`);
      }

      if (expectedHash != computedHash) {
        throw new Error(`${ptau} Expected PTAU hash ${expectedHash}, got ${computedHash}`);
      } else {
        log(ptau, 'Verification successful');
      }
    } catch (error) {
      log(ptau, `Failed to validate PTAU file: ${error}`);
      process.exit(1);
    }
  }
};

// main circuit process logic
const processCircuit = async (circuit, ptau, skipSolidityGeneration) => {
  const circomInput = path.join(__dirname, '../', `${circuit}.circom`);
  const ptauFile = path.join(ptauDownload, `${ptau}.ptau`);
  const zkeyOutput = path.join(provingKeysRoot, `${circuit}.zkey`);

  if (!fs.existsSync(circomInput)) {
    log(circuit, `Error: Input file does not exist: ${circomInput}`);
    return;
  }

  log(circuit, `Compiling circuit`);
  const { stdout: cmOut, stderr: cmErr } = await execAsync(`circom ${circomInput} --output ${circuitsRoot} --sym --wasm`);
  if (verbose) {
    if (cmOut) {
      log(circuit, 'compile output:\n' + cmOut);
    }
    if (cmErr) {
      log(circuit, 'compile error:\n' + cmErr);
    }
  }
  if (compileOnly) {
    return;
  }

  const { stdout: ctOut, stderr: ctErr } = await execAsync(`circom ${circomInput} --output ${provingKeysRoot} --r1cs`);
  if (verbose) {
    if (ctOut) {
      log(circuit, 'constraint generation output:\n' + ctOut);
      const { stdout: csOut } = await execAsync(`npx snarkjs r1cs print ${provingKeysRoot}/${circuit}.r1cs ${circuitsRoot}/${circuit}.sym `);
      // log(circuit, "constraints:\n" + csOut);
    }
    if (ctErr) {
      log(circuit, 'constraint error:\n' + ctErr);
    }
  }

  log(circuit, `Generating test proving key with ${ptau}`);
  const { stdout: pkOut, stderr: pkErr } = await execAsync(`npx snarkjs groth16 setup ${path.join(provingKeysRoot, `${circuit}.r1cs`)} ${ptauFile} ${zkeyOutput}`);
  if (verbose) {
    if (pkOut) {
      // log(circuit, "test proving key generation output:\n" + pkOut);
    }
    if (pkErr) {
      log(circuit, 'test proving key generation error:\n' + pkErr);
    }
  }
  log(circuit, `Exporting verification key`);
  const { stdout: vkOut, stderr: vkErr } = await execAsync(`npx snarkjs zkey export verificationkey ${zkeyOutput} ${path.join(provingKeysRoot, `${circuit}-vkey.json`)}`);
  if (verbose) {
    if (vkOut) {
      // log(circuit, "verification key export output:\n" + vkOut);
    }
    if (vkErr) {
      log(circuit, 'verification key export error:\n' + vkErr);
    }
  }
  if (skipSolidityGeneration) {
    log(circuit, `Skipping solidity verifier generation`);
    return;
  }

  log(circuit, `Generating solidity verifier`);
  const solidityFile = path.join(__dirname, '..', '..', '..', 'solidity', 'contracts', 'verifiers', `verifier_${circuit}.sol`);
  const { stdout: svOut, stderr: svErr } = await execAsync(`npx snarkjs zkey export solidityverifier ${zkeyOutput} ${solidityFile}`);
  if (verbose) {
    if (svOut) {
      log(circuit, 'solidity verifier export output:\n' + svOut);
    }
    if (svErr) {
      log(circuit, 'solidity verifier export error:\n' + svErr);
    }
  }
  log(circuit, `Modifying the contract name in the Solidity file`);
  const camelCaseCircuitName = toCamelCase(circuit);
  const solidityFileTmp = `${solidityFile}.tmp`;

  const fileContent = fs.readFileSync(solidityFile, 'utf8');
  const updatedContent = fileContent.replace(' Groth16Verifier ', ` Groth16Verifier_${camelCaseCircuitName} `);
  fs.writeFileSync(solidityFileTmp, updatedContent);
  fs.renameSync(solidityFileTmp, solidityFile);
  log(circuit, `Circuit process complete`);
};

const run = async () => {
  let onlyCircuits = specificCircuits;
  if (specificCircuits) {
    if (!Array.isArray(specificCircuits)) {
      onlyCircuits = [specificCircuits];
    }

    // if specific circuits are provided, check it's in the map
    for (const circuit of onlyCircuits) {
      if (!circuits[circuit]) {
        console.error(`Error: Unknown circuit: ${circuit}`);
        process.exit(1);
      }
    }
  }

  const circuitsArray = Object.entries(circuits);
  const activePromises = new Set();

  let snarkjsVersion;
  // first check circom version and snarkjs version matches the one in the package.json
  try {
    const { stdout: circomVersion } = await execAsync('circom --version');
    // Trigger error to get snarkjs version
    try {
      await execAsync('npx snarkjs --version');
    } catch (error) {
      // Extract snarkjs version from error message
      snarkjsVersion = error.stdout.match(/snarkjs@([\d.]+)/)?.[1];
      if (!snarkjsVersion) {
        throw new Error('Failed to extract SnarkJS version from error output.');
      }
    }
    const { stdout: packageJson } = await execAsync('cat package.json');

    const packageJsonObj = JSON.parse(packageJson);
    const expectedCircomVersion = genConfig.circomVersion;

    // Sanitize and extract version numbers
    const circomVersionTrimmed = circomVersion.trim().replace('circom compiler ', '');
    let hasMismatch = false;
    if (circomVersionTrimmed !== expectedCircomVersion) {
      console.error(
        `Error: circom version mismatch with the version in gen-config.json :\n` +
          `\tExpected circom: ${expectedCircomVersion}, got: ${circomVersionTrimmed}\n` +
          `\tFollow https://docs.circom.io/getting-started/installation/ to update your circom\n`
      );
      hasMismatch = true;
    }

    if (snarkjsVersion !== packageJsonObj.devDependencies.snarkjs) {
      console.error(
        `Error: snarkjs version mismatch with package.json:\n` +
          `\tExpected snarkjs: ${packageJsonObj.devDependencies.snarkjs}, got: ${snarkjsVersion}\n` +
          `\tUse npm to update your snarkjs node module\n`
      );
      hasMismatch = true;
    }
    if (hasMismatch) {
      process.exit(1);
    }

    console.log('Version check passed.');
  } catch (error) {
    console.error(`An error occurred: ${error.message}`);
    process.exit(1);
  }

  // Download all PTAU files that we need
  var allPtaus = new Set();
  for (const [circuit, { ptau, batchPtau }] of circuitsArray) {
    if (onlyCircuits && !onlyCircuits.includes(circuit)) {
      continue;
    }

    allPtaus.add(ptau);
    if (batchPtau) {
      allPtaus.add(batchPtau);
    }
  }

  // Download and verify all missing PTAU files
  for (p of allPtaus) {
    // download the PTAU files serially to avoid
    // overwhelming the build server. plus doing
    // these in parallel doesn't really help
    await downloadAndVerifyPtau(p);
  }

  for (const [circuit, { ptau, skipSolidityGeneration, batchPtau }] of circuitsArray) {
    if (onlyCircuits && !onlyCircuits.includes(circuit)) {
      continue;
    }

    const pcPromise = processCircuit(circuit, ptau, skipSolidityGeneration);
    activePromises.add(pcPromise);

    if (activePromises.size >= parallelLimit) {
      await Promise.race(activePromises);
    }

    if (batchPtau) {
      const pcBatchPromise = processCircuit(circuit + '_batch', batchPtau, skipSolidityGeneration);
      activePromises.add(pcBatchPromise);

      if (activePromises.size >= parallelLimit) {
        await Promise.race(activePromises);
      }

      pcBatchPromise.finally(() => activePromises.delete(pcBatchPromise));
    }

    pcPromise.finally(() => activePromises.delete(pcPromise));
  }

  await Promise.all(activePromises);
};

run().catch((err) => {
  console.error(`An error occurred: ${err.message}`);
  process.exit(1);
});
