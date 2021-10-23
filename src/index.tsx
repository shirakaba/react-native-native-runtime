import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-objc-runtime' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  "- You are not running this in the Expo Go app (it doesn't include this module's native code)\n";

const ObjcRuntime = NativeModules.ObjcRuntime
  ? NativeModules.ObjcRuntime
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function multiply(a: number, b: number): Promise<number> {
  return ObjcRuntime.multiply(a, b);
}
