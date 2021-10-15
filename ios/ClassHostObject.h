// Forked from: https://github.com/mrousavy/react-native-vision-camera/blob/b7bfa5ef0ad9a1c0add3d3508d7a4e0c65d2f6da/ios/Frame%20Processor/FrameHostObject.h
// See also: https://github.com/facebook/react-native/blob/1465c8f3874cdee8c325ab4a4916fda0b3e43bdb/Libraries/Blob/RCTBlobCollector.h

#pragma once

#import <jsi/jsi.h>

using namespace facebook;

class JSI_EXPORT ClassHostObject: public jsi::HostObject {
public:
  ClassHostObject(Class clazz);
  ~ClassHostObject();

public:
  jsi::Value get(jsi::Runtime&, const jsi::PropNameID& name) override;
  std::vector<jsi::PropNameID> getPropertyNames(jsi::Runtime& rt) override;

  Class clazz_;
};
