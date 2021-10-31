import { NativeModules, Platform } from 'react-native';

const packageName =
  Platform.OS === 'android'
    ? 'react-native-java-runtime'
    : 'react-native-objc-runtime';

const runtimeName = Platform.OS === 'android' ? 'JavaRuntime' : 'ObjcRuntime';

const LINKING_ERROR =
  `The package '${packageName}' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  "- You are not running this in the Expo Go app (it doesn't include this module's native code)\n";

const NativeRuntime = NativeModules[runtimeName]
  ? NativeModules[runtimeName]
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function multiply(a: number, b: number): Promise<number> {
  return NativeRuntime.multiply(a, b);
}
