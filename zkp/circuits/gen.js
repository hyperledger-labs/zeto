const fs = require("fs");
const path = require("path");
const { exec } = require("child_process");
const { promisify } = require("util");
const axios = require("axios");
const yargs = require("yargs/yargs");
const { hideBin } = require("yargs/helpers");
const argv = yargs(hideBin(process.argv))
  .option("c", {
    alias: "circuit",
    describe: "Specify a single circuit to build",
    type: "string",
  })
  .option("v", {
    alias: "verbose",
    describe: "Enable verbose mode",
    type: "boolean",
    default: false,
  })
  .option("cp", {
    alias: "compileOnly",
    describe: "Compile only",
    type: "boolean",
    default: false,
  })
  .option("cr", {
    alias: "circuitsRoot",
    describe: "Specify the root folder for storing circuits compilation files",
    type: "string",
  })
  .option("pk", {
    alias: "provingKeysRoot",
    describe: "Specify the root folder for storing generated proving keys",
    type: "string",
  })
  .option("pt", {
    alias: "ptauDownloadPath",
    describe: "Specify the root folder for storing downloaded PTAU",
    type: "string",
  }).argv;

const circuitsRoot = process.env.CIRCUITS_ROOT || argv.circuitsRoot;
const provingKeysRoot = process.env.PROVING_KEYS_ROOT || argv.provingKeysRoot;
const ptauDownload = process.env.PTAU_DOWNLOAD_PATH || argv.ptauDownloadPath;
const specificCircuits = argv.c;
const verbose = argv.v;
const compileOnly = argv.compileOnly;
const parallelLimit = parseInt(process.env.GEN_CONCURRENCY, 10) || 30; // Default to compile 30 circuits in parallel

// check env vars
if (!circuitsRoot) {
  console.error("Error: CIRCUITS_ROOT is not set.");
  process.exit(1);
}

if (!compileOnly && !provingKeysRoot) {
  console.error("Error: PROVING_KEYS_ROOT is not set.");
  process.exit(1);
}

if (!compileOnly && !ptauDownload) {
  console.error("Error: PTAU_DOWNLOAD_PATH is not set.");
  process.exit(1);
}

console.log(
  "Generating circuits with the following settings:\n" +
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
      2,
    ) +
    "\n",
);

// load circuits

const circuits = require("./gen-config.json");

const toCamelCase = (str) => {
  return str
    .split("_")
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
    .join("");
};

// util functions

const execAsync = promisify(exec);

const timestamp = () => new Date().toISOString();
const logPrefix = (circuit) => `[${timestamp()}] [${circuit}]`;

const log = (circuit, message) => {
  console.log(logPrefix(circuit) + " " + message);
};

// main circuit process logic
const processCircuit = async (circuit, ptau, skipSolidityGenaration) => {
  const circomInput = path.join("./", `${circuit}.circom`);
  const ptauFile = path.join(ptauDownload, `${ptau}.ptau`);
  const zkeyOutput = path.join(provingKeysRoot, `${circuit}.zkey`);

  if (!fs.existsSync(circomInput)) {
    log(circuit, `Error: Input file does not exist: ${circomInput}`);
    return;
  }

  if (!compileOnly && !fs.existsSync(ptauFile)) {
    log(circuit, `PTAU file does not exist, downloading: ${ptauFile}`);
    try {
      const response = await axios.get(
        `https://storage.googleapis.com/zkevm/ptau/${ptau}.ptau`,
        {
          responseType: "stream",
        },
      );
      response.data.pipe(fs.createWriteStream(ptauFile));
      await new Promise((resolve, reject) => {
        response.data.on("end", resolve);
        response.data.on("error", reject);
      });
    } catch (error) {
      log(circuit, `Failed to download PTAU file: ${error}`);
      process.exit(1);
    }
  }

  log(circuit, `Compiling circuit`);
  const { stdout: cmOut, stderr: cmErr } = await execAsync(
    `circom ${circomInput} --output ${circuitsRoot} --sym --wasm`,
  );
  if (verbose) {
    if (cmOut) {
      log(circuit, "compile output:\n" + cmOut);
    }
    if (cmErr) {
      log(circuit, "compile error:\n" + cmErr);
    }
  }
  if (compileOnly) {
    return;
  }

  const { stdout: ctOut, stderr: ctErr } = await execAsync(
    `circom ${circomInput} --output ${provingKeysRoot} --r1cs`,
  );
  if (verbose) {
    if (ctOut) {
      log(circuit, "constraint generation output:\n" + ctOut);
      const { stdout: csOut } = await execAsync(
        `npx snarkjs r1cs print ${provingKeysRoot}/${circuit}.r1cs ${circuitsRoot}/${circuit}.sym `,
      );
      log(circuit, "constraints:\n" + csOut);
    }
    if (ctErr) {
      log(circuit, "constraint error:\n" + ctErr);
    }
  }

  log(circuit, `Generating test proving key with ${ptau}`);
  const { stdout: pkOut, stderr: pkErr } = await execAsync(
    `npx snarkjs groth16 setup ${path.join(
      provingKeysRoot,
      `${circuit}.r1cs`,
    )} ${ptauFile} ${zkeyOutput}`,
  );
  if (verbose) {
    if (pkOut) {
      log(circuit, "test proving key generation output:\n" + pkOut);
    }
    if (pkErr) {
      log(circuit, "test proving key generation error:\n" + pkErr);
    }
  }
  log(circuit, `Exporting verification key`);
  const { stdout: vkOut, stderr: vkErr } = await execAsync(
    `npx snarkjs zkey export verificationkey ${zkeyOutput} ${path.join(
      provingKeysRoot,
      `${circuit}-vkey.json`,
    )}`,
  );
  if (verbose) {
    if (vkOut) {
      log(circuit, "verification key export output:\n" + vkOut);
    }
    if (vkErr) {
      log(circuit, "verification key export error:\n" + vkErr);
    }
  }
  if (skipSolidityGenaration) {
    log(circuit, `Skipping solidity verifier generation`);
    return;
  }

  log(circuit, `Generating solidity verifier`);
  const solidityFile = path.join(
    "..",
    "..",
    "solidity",
    "contracts",
    "lib",
    `verifier_${circuit}.sol`,
  );
  const { stdout: svOut, stderr: svErr } = await execAsync(
    `npx snarkjs zkey export solidityverifier ${zkeyOutput} ${solidityFile}`,
  );
  if (verbose) {
    if (svOut) {
      log(circuit, "solidity verifier export output:\n" + svOut);
    }
    if (svErr) {
      log(circuit, "solidity verifier export error:\n" + svErr);
    }
  }
  log(circuit, `Modifying the contract name in the Solidity file`);
  const camelCaseCircuitName = toCamelCase(circuit);
  const solidityFileTmp = `${solidityFile}.tmp`;

  const fileContent = fs.readFileSync(solidityFile, "utf8");
  const updatedContent = fileContent.replace(
    " Groth16Verifier ",
    ` Groth16Verifier_${camelCaseCircuitName} `,
  );
  fs.writeFileSync(solidityFileTmp, updatedContent);
  fs.renameSync(solidityFileTmp, solidityFile);
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

  for (const [
    circuit,
    { ptau, skipSolidityGenaration, batchPtau },
  ] of circuitsArray) {
    if (onlyCircuits && !onlyCircuits.includes(circuit)) {
      continue;
    }

    const pcPromise = processCircuit(circuit, ptau, skipSolidityGenaration);
    activePromises.add(pcPromise);

    if (activePromises.size >= parallelLimit) {
      await Promise.race(activePromises);
    }

    if (batchPtau) {
      const pcBatchPromise = processCircuit(
        circuit + "_batch",
        batchPtau,
        skipSolidityGenaration,
      );
      activePromises.add(pcBatchPromise);

      if (activePromises.size >= parallelLimit) {
        await Promise.race(activePromises);
      }
    }

    pcPromise.finally(() => activePromises.delete(pcPromise));
  }

  await Promise.all(activePromises);
};

run().catch((err) => {
  console.error(`An error occurred: ${err.message}`);
  process.exit(1);
});
