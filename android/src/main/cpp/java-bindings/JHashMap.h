//
// From https://github.com/mrousavy/react-native-vision-camera/blob/7206a794a9e1a2da4def7fdf4d8a70c9eb7f43ff/android/src/main/cpp/java-bindings/JHashMap.h
//
// Created by Marc Rousavy on 25.06.21.
//

#pragma once

#include <jni.h>
#include <fbjni/fbjni.h>


namespace facebook {
namespace jni {

// TODO: Remove when fbjni 0.2.3 releases.
template <typename K = jobject, typename V = jobject>
struct JHashMap : JavaClass<JHashMap<K, V>, JMap<K, V>> {
  constexpr static auto kJavaDescriptor = "Ljava/util/HashMap;";

  static local_ref<JHashMap<K, V>> create();
};

} // namespace jni
} // namespace facebook
