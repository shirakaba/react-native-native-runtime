#!/usr/bin/env node

const yaml = require('js-yaml');
const yargs = require('yargs/yargs');
const fs = require('fs/promises');
const path = require('path');

const logPrefix = '[generateBindings]';

const { input, output, mode } = yargs(process.argv.slice(2))
  .scriptName('generateBindings')
  .usage('Usage: $0 [options]')
  .example('$0 --input [Foundation.yaml] --output [constants.json] --mode=file')
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
 * @param {import('./generateBindingsTypes').ObjcMetadata} doc
 * @return {string}
 */
function getImplementationForLibrary(doc) {
  const implementation = doc.Items.map((item) =>
    getImplementationForItem(item)
      .split('\n')
      .map((line) => `  ${line}`)
      .join('\n')
  ).join('\n');

  return `
${getImportForModule(doc.Module)}

// Forked from https://github.com/mrousavy/react-native-vision-camera/blob/b7bfa5ef0ad9a1c0add3d3508d7a4e0c65d2f6da/ios/Frame%20Processor/FrameHostObject.mm

#import <objc/runtime.h>
#import <stdio.h>
#import <stdlib.h>
#import "HostObjectObjc.h"
#import "HostObjectClass.h"
#import "HostObjectClassInstance.h"
#import "HostObjectSelector.h"
#import "HostObjectProtocol.h"
#import "JSIUtils.h"
#import <Foundation/Foundation.h>
#import <React/RCTBridge.h>
#import <React/RCTBridge+Private.h>
#import <ReactCommon/RCTTurboModule.h>
#import <ReactCommon/CallInvoker.h>
#import <React/RCTBridge.h>
#import <ReactCommon/TurboModuleUtils.h>
#import <jsi/jsi.h>
#import <dlfcn.h>

std::vector<jsi::PropNameID> HostObjectObjc::getPropertyNames(jsi::Runtime& rt) {
  std::vector<jsi::PropNameID> result;
  result.push_back(jsi::PropNameID::forUtf8(rt, std::string("toString")));
  
  return result;
}

jsi::Value HostObjectObjc::get(jsi::Runtime& runtime, const jsi::PropNameID& propName) {
  auto name = propName.utf8(runtime);
  NSString* nameNSString = [NSString stringWithUTF8String:name.c_str()];

  if (name == "toString") {
    auto toString = [this] (jsi::Runtime& runtime, const jsi::Value&, const jsi::Value*, size_t) -> jsi::Value {
      NSString* string = [NSString stringWithFormat:@"[object HostObjectObjc]"];
      return jsi::String::createFromUtf8(runtime, string.UTF8String);
    };
    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "toString"), 0, toString);
  }

${implementation}

  // If no matching symbol was found
  return jsi::Value::undefined();
}

`;
}

/**
 * @param {import('./generateBindingsTypes').MetadataModule} Module
 * @return {string}
 */
function getImportForModule(Module) {
  // I'm not great with C-style imports, but I think Apple use a naming convention for their SDK frameworks anyway.
  // I believe the naming is entirely determined by the module.modulemap file; I'm not sure how the NativeScript
  // metadata generator exposes that to us just yet. And don't ask me about #import vs. #include!
  //
  // @see /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Library/Frameworks/Foundation.framework/Headers/Foundation.h
  // @see /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Library/Frameworks/Foundation.framework/Modules/module.modulemap
  return `#import <${Module.FullName}/${Module.FullName}.h>`;
}

/**
 * @param {import('./generateBindingsTypes').MetadataItem} Item
 */
function getImplementationForItem(Item) {
  const { Name, Type } = Item;

  // eslint-disable-next-line no-unused-vars
  const notImplemented = `
if (name == "${Name}") {
  throw jsi::JSError(runtime, [[NSString stringWithFormat:@"NotImplementedError: Not implemented: %@", nameNSString] cStringUsingEncoding:NSUTF8StringEncoding]);
}
`.slice(1, -1);
  let implementation = `// TODO: ${Name} (${Type})`;
  switch (Type) {
    case 'EnumConstant':
      implementation = `
if (name == "${Name}") {
${getImplementationForItemEnumConstant(Item)}
}
`.slice(1, -1);
      break;
    case 'Enum':
      implementation = getImplementationForItemEnum(Item);
      break;
    case 'Function':
      implementation = getImplementationForItemFunction(Item);
      break;
  }

  return implementation;
}

/**
 * @param {import('./generateBindingsTypes').MetadataItemEnumConstant} Item
 */
function getImplementationForItemEnumConstant(Item) {
  const { Name } = Item;
  return `
  return convertObjCObjectToJSIValue(runtime, ${Name});
`.slice(1, -1);
}

/**
 * @param {import('./generateBindingsTypes').MetadataItemEnum} Item
 */
function getImplementationForItemEnum(Item) {
  const { Name, FullNameFields, SwiftNameFields } = Item;

  const dicContents = SwiftNameFields.map((field, i) => {
    const key = Object.keys(field)[0];
    const value = Object.keys(FullNameFields[i])[0];
    return `@"${key}": ${value}`;
  }).join(', ');

  const fullNames = FullNameFields.map((field) => {
    const key = Object.keys(field)[0];
    return `
if (name == "${key}") {
  return convertObjCObjectToJSIValue(runtime, ${key});
}
`.slice(1, -1);
  }).join('\n');

  return `
if (name == "${Name}") {
  return convertNSDictionaryToJSIObject(runtime, @{ ${dicContents} });
}
${fullNames}
`.slice(1, -1);
}

/**
 * @param {import('./generateBindingsTypes').MetadataItemFunction} Item
 */
function getImplementationForItemFunction(Item) {
  const { Name, Signature } = Item;
  // The first arg is the return type.
  // We'll need that later for TypeScript definitions, but not at runtime.
  const [, ...args] = Signature;
  return `
if (name == "${Name}") {
  auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
    id result = ${Name}(${args.map((arg, i) => `arguments[${i}]`).join(', ')});
    // FIXME: support non-primitive values like class instances.
    return convertObjCObjectToJSIValue(runtime, result);
  };
  return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "${Name}"), ${
    args.length
  }, func);
}
`.slice(1, -1);
}

/**
 * @param {import('./generateBindingsTypes').ObjcMetadata} doc
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
    // @see https://developer.apple.com/documentation/swift/objective-c_and_c_code_customization/grouping_related_objective-c_constants
    if (item.Type === 'EnumConstant') {
      const value =
        /** @type {import('./generateBindingsTypes').MetadataItemEnumConstant} */ (
          item
        ).Value;
      const parsedValue = parseInt(value, 10);
      if (isNaN(parsedValue)) {
        console.warn(
          `${logPrefix} Unexpectedly got NaN parsing value: "${value}" for item "${item.Name}". Will leave it as a string.`
        );
        acc[item.Name] = value;
        return acc;
      }
      acc[item.Name] = parsedValue;
      return acc;
    }

    if (item.Type === 'Enum') {
      const fullNameFields =
        /** @type {import('./generateBindingsTypes').MetadataItemEnum} */ (item)
          .FullNameFields;
      fullNameFields.forEach((field) => {
        Object.keys(field).forEach((key) => {
          const value = field[key];
          const parsedValue = parseInt(value, 10);
          if (isNaN(parsedValue)) {
            console.warn(
              `${logPrefix} Unexpectedly got NaN parsing value: "${value}" for key "${key}" of item "${item.Name}". Will leave it as a string.`
            );
            acc[key] = value;
            return;
          }
          acc[key] = parsedValue;
        });
      });
      return acc;
    }

    // Obj-C doesn't offer any tools to look up variables at runtime.
    // It's just a pity that there are many variables, particularly NSString ones like NSStringTransformToLatin,
    // that are constant in nature (and used effectively as enums), yet not declared as such (you can't statically
    // declare an NSString).
    // I wonder whether we could do it using dlsym..?
    //
    // if (item.Type === 'Var') {
    //   const signature =
    //     /** @type {import('./generateBindingsTypes').MetadataItemVar} */ (
    //       item
    //     ).Signature;
    //   if (signature.Type === 'Interface' && signature.Name === 'NSString') {
    //     acc[item.Name] = /* I'd assign its value here... if only the headers held it! */;
    //   }

    //   return acc;
    // }

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

    const libraryImplementation = getImplementationForLibrary(doc);

    return fs
      .writeFile(resolvedOutput, libraryImplementation, {
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
