// Forked from: https://github.com/mrousavy/react-native-vision-camera/blob/b7bfa5ef0ad9a1c0add3d3508d7a4e0c65d2f6da/ios/Frame%20Processor/FrameHostObject.h

#pragma once

#import <jsi/jsi.h>

using namespace facebook;

class JSI_EXPORT HostObjectObjc: public jsi::HostObject {

public:
  jsi::Value get(jsi::Runtime&, const jsi::PropNameID& name) override;
  std::vector<jsi::PropNameID> getPropertyNames(jsi::Runtime& rt) override;
  void close();
  
private:
  void assertIsObjcStrong(jsi::Runtime& runtime, const std::string& accessedPropName);
};
