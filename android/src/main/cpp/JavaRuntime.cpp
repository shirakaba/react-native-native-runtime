// Forked from https://github.com/mrousavy/react-native-vision-camera/blob/main/android/src/main/cpp/VisionCamera.cpp

#include <jni.h>
#include <fbjni/fbjni.h>

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM *vm, void *) {
  return facebook::jni::initialize(vm, [] {
    // TODO: register the native host object, `java`, here.
  });
}
