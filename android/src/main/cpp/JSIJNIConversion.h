//
// From https://github.com/mrousavy/react-native-vision-camera/blob/7206a794a9e1a2da4def7fdf4d8a70c9eb7f43ff/android/src/main/cpp/JSIJNIConversion.h
//
// Created by Marc Rousavy on 22.06.21.
//

#pragma once

#include <jsi/jsi.h>
#include <jni.h>
#include <fbjni/fbjni.h>

namespace vision {

namespace JSIJNIConversion {

using namespace facebook;

jobject convertJSIValueToJNIObject(jsi::Runtime& runtime, const jsi::Value& value); // NOLINT(runtime/references)

jsi::Value convertJNIObjectToJSIValue(jsi::Runtime& runtime, const jni::local_ref<jobject>& object); // NOLINT(runtime/references)

} // namespace JSIJNIConversion

} // namespace vision
