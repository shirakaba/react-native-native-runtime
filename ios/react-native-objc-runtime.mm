#import "react-native-objc-runtime.h"
#import "HostObjectObjc.h"
#import "JSIUtils.h"
#import <jsi/jsi.h>

#include <iostream>
#include <functional>
#include <sstream>


using namespace facebook;

namespace ObjcRuntimeJsi {
void install(jsi::Runtime& jsiRuntime) {
  std::cout << "Initialising Obj-C JSI" << "\n";

  jsi::Object object = jsi::Object::createFromHostObject(jsiRuntime, std::make_shared<HostObjectObjc>());
  jsiRuntime.global().setProperty(jsiRuntime, "objc", std::move(object));
}

void uninstall(jsi::Runtime& jsiRuntime) {
  // We seemingly can't remove the property altogether, but let's at least try to set it to undefined.
  jsiRuntime.global().setProperty(jsiRuntime, "objc", jsi::Value::undefined());
}
} // namespace ObjcRuntime
