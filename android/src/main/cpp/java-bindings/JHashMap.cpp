//
// From https://github.com/mrousavy/react-native-vision-camera/blob/7206a794a9e1a2da4def7fdf4d8a70c9eb7f43ff/android/src/main/cpp/java-bindings/JHashMap.cpp
//
// Created by Marc Rousavy on 25.06.21.
//

#include "JHashMap.h"

#include <jni.h>
#include <fbjni/fbjni.h>


namespace facebook {
namespace jni {

template <typename K, typename V>
local_ref<JHashMap<K, V>> JHashMap<K, V>::create() {
  return JHashMap<K, V>::newInstance();
}

} // namespace jni
} // namespace facebook
