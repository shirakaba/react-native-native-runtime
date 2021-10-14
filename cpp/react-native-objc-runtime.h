#ifndef OBJC_RUNTIME_H
#define OBJC_RUNTIME_H

#include <jsi/jsilib.h>
#include <jsi/jsi.h>

namespace ObjcRuntimeJsi {

void install(facebook::jsi::Runtime &jsiRuntime);
void uninstall(facebook::jsi::Runtime &jsiRuntime);

} // namespace example

#endif /* OBJC_RUNTIME_H */
