require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-objc-runtime"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => "10.0" }
  s.source       = { :git => "https://github.com/shirakaba/react-native-objc-runtime.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,mm}", "cpp/**/*.{h,cpp,mm}"

  # @see https://github.com/mrousavy/react-native-vision-camera/blob/main/VisionCamera.podspec
  s.pod_target_xcconfig = {
    # > If you are trying to instantiate a class from a static library, you must add the "-ObjC"
    # > flag to the "Other Linker Flags" build setting.
    # @see https://stackoverflow.com/questions/2227085/nsclassfromstring-returns-nil
    "OTHER_LDFLAGS" = ["$(inherited)", "-ObjC", "-lc++"]
    "DEFINES_MODULE" => "YES",
    "USE_HEADERMAP" => "YES",
    "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/ReactCommon\" \"$(PODS_TARGET_SRCROOT)\" \"$(PODS_ROOT)/Headers/Private/React-Core\""
  }
  s.requires_arc = true

  s.dependency "React-callinvoker"
  s.dependency "React"
  s.dependency "React-Core"
end
