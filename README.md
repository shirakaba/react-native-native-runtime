# react-native-objc-runtime

Access the Obj-C runtime from React Native via JSI!

## Installation

```sh
npm install react-native-objc-runtime
```

## Usage

### Accessing the Obj-C runtime

```js
import { multiply } from "react-native-objc-runtime";

// ...

const result = await multiply(3, 7);
```

### Making constants available to the Obj-C runtime

These steps have already been taken in this example project, so just serve as documentation about what I did to set up this proof-of-concept (and what you'd have to do in your own projects if consuming this as a library).

```sh
# Run the NativeScript iOS metadata generator to generate a YAML file of all the Obj-C runtime metadata.
# I have not set up the NativeScript iOS metadata generator in this repo; I actually copied the metadata
# over from an existing standard NativeScript project to simplify this proof-of-concept. But the command
# would look something like this:
TNS_DEBUG_METADATA_PATH="/Users/jamie/Documents/git/react-native-objc-runtime/example/ios/ObjcRuntimeExample/DEBUG" ./build-step-metadata-generator.py

# Now run my script for extracting constants from that YAML metadata.
# For now, we'll just map Foundation alone.
mkdir -vp "example/ios/ObjcRuntimeExample/objc-constants"
node scripts/generate-objc-constants.js --mode=file --input "example/ios/ObjcRuntimeExample/DEBUG-x86_64/Foundation.yaml" --output "example/ios/ObjcRuntimeExample/objc-constants/Foundation.json"

# Next, remember to manually add the folder `objc-constants` to the iOS target in your Xcodeproj.
# Be sure to tick "Create folder references" when adding the folder.

# Also be sure to copy across my function in AppDelegate.m: `readObjcConstants:subdirectory` and call it
# to initialise gObjcConstants before initialising the React Native bundle.
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
