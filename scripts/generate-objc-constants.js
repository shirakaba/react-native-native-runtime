#!/usr/bin/env node

const yaml = require('js-yaml');
const yargs = require('yargs/yargs');
const fs = require('fs/promises');
const path = require('path');

const logPrefix = '[generate-objc-constants]';

const { input, output, mode } = yargs(process.argv.slice(2))
  .scriptName('generate-objc-constants')
  .usage('Usage: $0 [options]')
  .example('$0 --input [metadata.yaml] --output [constants.json] --mode=file')
  .example('$0 --input [metadata-dir] --output [constants-dir] --mode=dir')
  .option('input', {
    describe:
      'The path to a single metadata file (in --mode=file) generated by the NativeScript metadata generator, or a directory of such files (in --mode=dir)',
  })
  .option('output', {
    describe:
      'The path to output a single constants JSON file (in --mode=file), or a directory of such files (in --mode=dir)',
  })
  .option('mode', {
    choices: ['file', 'dir'],
    describe:
      'Whether to work with a single metadata file (--mode=file) or a directory of them (--mode=dir)',
  })
  .demandOption(['input', 'output', 'mode'])
  .help().argv;

const resolvedInput = path.resolve(input);
const resolvedOutput = path.resolve(output);

/**
 * @param {string} inputFilePath
 * @returns {Promise<unknown>}
 */
async function readMetadataFile(inputFilePath) {
  /** @type {string} */
  let metadataContents;
  try {
    metadataContents = await fs.readFile(inputFilePath, 'utf8');
  } catch (error) {
    console.error(
      `${logPrefix} Unable to read input file from: ${inputFilePath}`
    );
    process.exit(1);
  }
  /** @type {unknown} */
  let yamlDoc;
  try {
    yamlDoc = yaml.load(metadataContents, {
      schema: yaml.JSON_SCHEMA,
      json: true,
    });
  } catch (error) {
    console.error(`${logPrefix} Unable to parse YAML from: ${inputFilePath}`);
    process.exit(1);
  }
  return yamlDoc;
}

/**
 * @param {string} inputDirPath
 * @returns {Promise<[string, unknown][]>}
 */
async function readMetadataDir(inputDirPath) {
  /** @type {string[]} */
  let fileNames;
  try {
    fileNames = await fs.readdir(inputDirPath);
  } catch (error) {
    console.error(`${logPrefix} Unable to list dir from: ${inputDirPath}`);
    process.exit(1);
  }
  return await Promise.all(
    fileNames.map(async (fileName) => {
      const doc = await readMetadataFile(path.resolve(inputDirPath, fileName));
      return [fileName, doc];
    })
  );
}

/**
 * @param {import('./generate-objc-constants-types').ObjcMetadata} doc
 */
function buildConstantsJson(doc) {
  if (typeof doc !== 'object') {
    throw new Error(
      `${logPrefix} expected doc to be of type 'object', but was ${typeof doc}.`
    );
  }

  const { Module, Items } = doc;
  if (typeof Module !== 'object') {
    throw new Error(
      `${logPrefix} expected doc to have a field 'Module' of type 'object', but was ${typeof Module}.`
    );
  }
  if (typeof Items !== 'object') {
    throw new Error(
      `${logPrefix} expected doc to have a field 'Items' of type 'object', but was ${typeof Module}.`
    );
  }

  return Items.reduce((acc, item) => {
    if (item.Type === 'EnumConstant') {
      const value =
        /** @type {import('./generate-objc-constants-types').MetadataItemEnumConstant} */ (
          item
        ).Value;
      const parsedValue = parseInt(value, 10);
      if (isNaN(parsedValue)) {
        console.warn(
          `${logPrefix} Unexpectedly got NaN parsing value: "${value}" for item "${item.Name}". Won't include it.`
        );
        return acc;
      }
      acc[item.Name] = parsedValue;
      return acc;
    }

    if (item.Type === 'Enum') {
      const fullNameFields =
        /** @type {import('./generate-objc-constants-types').MetadataItemEnum} */ (
          item
        ).FullNameFields;
      fullNameFields.forEach((field) => {
        Object.keys(field).forEach((key) => {
          const value = field[key];
          const parsedValue = parseInt(value, 10);
          if (isNaN(parsedValue)) {
            console.warn(
              `${logPrefix} Unexpectedly got NaN parsing value: "${value}" for key "${key}" of item "${item.Name}". Won't include it.`
            );
            return;
          }
          acc[key] = parsedValue;
        });
      });
      return acc;
    }

    if (
      ![
        'Struct',
        'Protocol',
        'Var',
        'Method',
        'Interface',
        'BridgedInterface',
        'Function',
      ].includes(item.Type)
    ) {
      console.log(
        `${logPrefix} Unencountered item type "${item.Type}" for item "${item.Name}"`
      );
    }

    return acc;
  }, {});
}

if (mode === 'file') {
  readMetadataFile(resolvedInput).then((doc) => {
    console.log(`${logPrefix} got doc for file path: ${resolvedInput}`);

    const json = buildConstantsJson(doc);

    return fs
      .writeFile(resolvedOutput, JSON.stringify(json, null, 4), {
        encoding: 'utf8',
      })
      .then(() => {
        console.log(`${logPrefix} Wrote file to ${resolvedOutput}`);
      })
      .catch((error) => {
        console.error(
          `${logPrefix} Failed to write file to ${resolvedOutput}`,
          error
        );
      });
  });
} else {
  readMetadataDir(resolvedInput).then((tuples) => {
    console.log(`${logPrefix} got all docs within ${resolvedInput}`);
  });
}
