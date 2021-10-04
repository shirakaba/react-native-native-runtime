#include <jni.h>
#include "example.h"

extern "C"
JNIEXPORT jint JNICALL
Java_com_reactnativeobjcruntime_ObjcRuntimeModule_nativeMultiply(JNIEnv *env, jclass type, jint a, jint b) {
    return example::multiply(a, b);
}
