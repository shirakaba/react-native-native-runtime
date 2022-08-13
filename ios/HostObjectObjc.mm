
#import <Foundation/Foundation.h>

// Forked from https://github.com/mrousavy/react-native-vision-camera/blob/b7bfa5ef0ad9a1c0add3d3508d7a4e0c65d2f6da/ios/Frame%20Processor/FrameHostObject.mm

#import <objc/runtime.h>
#import <stdio.h>
#import <stdlib.h>
#import "HostObjectObjc.h"
#import "HostObjectClass.h"
#import "HostObjectClassInstance.h"
#import "HostObjectSelector.h"
#import "HostObjectProtocol.h"
#import "JSIUtils.h"
#import <Foundation/Foundation.h>
#import <React/RCTBridge.h>
#import <React/RCTBridge+Private.h>
#import <ReactCommon/RCTTurboModule.h>
#import <ReactCommon/CallInvoker.h>
#import <React/RCTBridge.h>
#import <ReactCommon/TurboModuleUtils.h>
#import <jsi/jsi.h>
#import <dlfcn.h>
#include <any>

std::vector<jsi::PropNameID> HostObjectObjc::getPropertyNames(jsi::Runtime& rt) {
  std::vector<jsi::PropNameID> result;
  result.push_back(jsi::PropNameID::forUtf8(rt, std::string("toString")));
  
  return result;
}

jsi::Value HostObjectObjc::get(jsi::Runtime& runtime, const jsi::PropNameID& propName) {
  auto name = propName.utf8(runtime);
  NSString* nameNSString = [NSString stringWithUTF8String:name.c_str()];

  if (name == "toString") {
    auto toString = [this] (jsi::Runtime& runtime, const jsi::Value&, const jsi::Value*, size_t) -> jsi::Value {
      NSString* string = [NSString stringWithFormat:@"[object HostObjectObjc]"];
      return jsi::String::createFromUtf8(runtime, string.UTF8String);
    };
    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "toString"), 0, toString);
  }
  
  if (name == "whatever") {
    return convertObjCObjectToJSIValue(runtime, nameNSString);
  }
  
  if (name == "NSASCIIStringEncoding") {
    
    return HostObjectSelector(NSSelectorFromString(@"mySelector"));
    // return convertObjCObjectToJSIValue(runtime, NSASCIIStringEncoding);
  }
  
//  auto valueCase = NSMakeRange(123, 123);
//  void* ans1 = &valueCase;
//
//  NSString* pointerCase = [NSString stringWithString:@"yo"];
//  void* ans2 = &pointerCase;
//
//  if (name == "initWithString") {
//    auto initWithString = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      void* arg1 = ((HostObjectAnyType)arguments[0]).value;
//      void* arg2 = ((HostObjectAnyType)arguments[1]).value;
//      std::any mine = [NSString stringWithFormat:@"[object HostObjectObjc]"];
//
////      NSString* arg1 = convertJSIValueToObjCObject(runtime, arguments[0], <#std::shared_ptr<CallInvoker> jsInvoker#>);
////      NSURL* arg2 = convertJSIValueToObjCObject(runtime, arguments[1], <#std::shared_ptr<CallInvoker> jsInvoker#>);
//
//      return HostObjectClassInstance([[NSURL alloc] initWithString:(__bridge NSString*)mine relativeToURL:(__bridge NSURL*)arg2]);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "initWithString"), 2, initWithString);
//  }
  
  
//  if (name == "NSActivityAutomaticTerminationDisabled") {
//    return convertObjCObjectToJSIValue(runtime, NSActivityAutomaticTerminationDisabled);
//  }
//  if (name == "NSActivityBackground") {
//    return convertObjCObjectToJSIValue(runtime, NSActivityBackground);
//  }
//  if (name == "NSActivityIdleDisplaySleepDisabled") {
//    return convertObjCObjectToJSIValue(runtime, NSActivityIdleDisplaySleepDisabled);
//  }
//  if (name == "NSActivityIdleSystemSleepDisabled") {
//    return convertObjCObjectToJSIValue(runtime, NSActivityIdleSystemSleepDisabled);
//  }
//  if (name == "NSActivityLatencyCritical") {
//    return convertObjCObjectToJSIValue(runtime, NSActivityLatencyCritical);
//  }
//  if (name == "NSActivityOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"IdleDisplaySleepDisabled": NSActivityIdleDisplaySleepDisabled,
//        @"IdleSystemSleepDisabled": NSActivityIdleSystemSleepDisabled,
//        @"SuddenTerminationDisabled": NSActivitySuddenTerminationDisabled,
//        @"AutomaticTerminationDisabled": NSActivityAutomaticTerminationDisabled,
//        @"UserInitiated": NSActivityUserInitiated,
//        @"UserInitiatedAllowingIdleSystemSleep": NSActivityUserInitiatedAllowingIdleSystemSleep,
//        @"Background": NSActivityBackground,
//        @"LatencyCritical": NSActivityLatencyCritical
//      }
//    );
//  }
//  if (name == "NSActivityIdleDisplaySleepDisabled") {
//    return convertObjCObjectToJSIValue(runtime, NSActivityIdleDisplaySleepDisabled);
//  }
//  if (name == "NSActivityIdleSystemSleepDisabled") {
//    return convertObjCObjectToJSIValue(runtime, NSActivityIdleSystemSleepDisabled);
//  }
//  if (name == "NSActivitySuddenTerminationDisabled") {
//    return convertObjCObjectToJSIValue(runtime, NSActivitySuddenTerminationDisabled);
//  }
//  if (name == "NSActivityAutomaticTerminationDisabled") {
//    return convertObjCObjectToJSIValue(runtime, NSActivityAutomaticTerminationDisabled);
//  }
//  if (name == "NSActivityUserInitiated") {
//    return convertObjCObjectToJSIValue(runtime, NSActivityUserInitiated);
//  }
//  if (name == "NSActivityUserInitiatedAllowingIdleSystemSleep") {
//    return convertObjCObjectToJSIValue(runtime, NSActivityUserInitiatedAllowingIdleSystemSleep);
//  }
//  if (name == "NSActivityBackground") {
//    return convertObjCObjectToJSIValue(runtime, NSActivityBackground);
//  }
//  if (name == "NSActivityLatencyCritical") {
//    return convertObjCObjectToJSIValue(runtime, NSActivityLatencyCritical);
//  }
//  if (name == "NSActivitySuddenTerminationDisabled") {
//    return convertObjCObjectToJSIValue(runtime, NSActivitySuddenTerminationDisabled);
//  }
//  if (name == "NSActivityUserInitiated") {
//    return convertObjCObjectToJSIValue(runtime, NSActivityUserInitiated);
//  }
//  if (name == "NSActivityUserInitiatedAllowingIdleSystemSleep") {
//    return convertObjCObjectToJSIValue(runtime, NSActivityUserInitiatedAllowingIdleSystemSleep);
//  }
//  if (name == "NSAdminApplicationDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSAdminApplicationDirectory);
//  }
//  if (name == "NSAggregateExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSAggregateExpressionType);
//  }
//  if (name == "NSAllApplicationsDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSAllApplicationsDirectory);
//  }
//  if (name == "NSAllDomainsMask") {
//    return convertObjCObjectToJSIValue(runtime, NSAllDomainsMask);
//  }
//  if (name == "NSAllHashTableObjects") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSAllHashTableObjects(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSAllHashTableObjects"), 1, func);
//  }
//  if (name == "NSAllLibrariesDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSAllLibrariesDirectory);
//  }
//  if (name == "NSAllMapTableKeys") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSAllMapTableKeys(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSAllMapTableKeys"), 1, func);
//  }
//  if (name == "NSAllMapTableValues") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSAllMapTableValues(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSAllMapTableValues"), 1, func);
//  }
//  if (name == "NSAllPredicateModifier") {
//    return convertObjCObjectToJSIValue(runtime, NSAllPredicateModifier);
//  }
//  if (name == "NSAllocateMemoryPages") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSAllocateMemoryPages(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSAllocateMemoryPages"), 1, func);
//  }
//  if (name == "NSAllocateObject") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSAllocateObject(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSAllocateObject"), 3, func);
//  }
//  if (name == "NSAlternateDescriptionAttributeName") {
//    return convertObjCObjectToJSIValue(runtime, NSAlternateDescriptionAttributeName);
//  }
//  if (name == "NSAnchoredSearch") {
//    return convertObjCObjectToJSIValue(runtime, NSAnchoredSearch);
//  }
//  if (name == "NSAndPredicateType") {
//    return convertObjCObjectToJSIValue(runtime, NSAndPredicateType);
//  }
//  if (name == "NSAnyKeyExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSAnyKeyExpressionType);
//  }
//  if (name == "NSAnyPredicateModifier") {
//    return convertObjCObjectToJSIValue(runtime, NSAnyPredicateModifier);
//  }
//  if (name == "NSApplicationDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSApplicationDirectory);
//  }
//  if (name == "NSApplicationSupportDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSApplicationSupportDirectory);
//  }
//  if (name == "NSArgumentDomain") {
//    return convertObjCObjectToJSIValue(runtime, NSArgumentDomain);
//  }
//  // TODO: NSArray (Interface)
//  // TODO: NSAssertionHandler (Interface)
//  if (name == "NSAssertionHandlerKey") {
//    return convertObjCObjectToJSIValue(runtime, NSAssertionHandlerKey);
//  }
//  if (name == "NSAtomicWrite") {
//    return convertObjCObjectToJSIValue(runtime, NSAtomicWrite);
//  }
//  // TODO: NSAttributedString (Interface)
//  if (name == "NSAttributedStringEnumerationLongestEffectiveRangeNotRequired") {
//    return convertObjCObjectToJSIValue(runtime, NSAttributedStringEnumerationLongestEffectiveRangeNotRequired);
//  }
//  if (name == "NSAttributedStringEnumerationOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Reverse": NSAttributedStringEnumerationReverse,
//        @"LongestEffectiveRangeNotRequired": NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
//      }
//    );
//  }
//  if (name == "NSAttributedStringEnumerationReverse") {
//    return convertObjCObjectToJSIValue(runtime, NSAttributedStringEnumerationReverse);
//  }
//  if (name == "NSAttributedStringEnumerationLongestEffectiveRangeNotRequired") {
//    return convertObjCObjectToJSIValue(runtime, NSAttributedStringEnumerationLongestEffectiveRangeNotRequired);
//  }
//  if (name == "NSAttributedStringEnumerationReverse") {
//    return convertObjCObjectToJSIValue(runtime, NSAttributedStringEnumerationReverse);
//  }
//  if (name == "NSAttributedStringFormattingApplyReplacementIndexAttribute") {
//    return convertObjCObjectToJSIValue(runtime, NSAttributedStringFormattingApplyReplacementIndexAttribute);
//  }
//  if (name == "NSAttributedStringFormattingInsertArgumentAttributesWithoutMerging") {
//    return convertObjCObjectToJSIValue(runtime, NSAttributedStringFormattingInsertArgumentAttributesWithoutMerging);
//  }
//  if (name == "NSAttributedStringFormattingOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"InsertArgumentAttributesWithoutMerging": NSAttributedStringFormattingInsertArgumentAttributesWithoutMerging,
//        @"ApplyReplacementIndexAttribute": NSAttributedStringFormattingApplyReplacementIndexAttribute
//      }
//    );
//  }
//  if (name == "NSAttributedStringFormattingInsertArgumentAttributesWithoutMerging") {
//    return convertObjCObjectToJSIValue(runtime, NSAttributedStringFormattingInsertArgumentAttributesWithoutMerging);
//  }
//  if (name == "NSAttributedStringFormattingApplyReplacementIndexAttribute") {
//    return convertObjCObjectToJSIValue(runtime, NSAttributedStringFormattingApplyReplacementIndexAttribute);
//  }
//  if (name == "NSAttributedStringMarkdownInterpretedSyntax") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Full": NSAttributedStringMarkdownInterpretedSyntaxFull,
//        @"InlineOnly": NSAttributedStringMarkdownInterpretedSyntaxInlineOnly,
//        @"InlineOnlyPreservingWhitespace": NSAttributedStringMarkdownInterpretedSyntaxInlineOnlyPreservingWhitespace
//      }
//    );
//  }
//  if (name == "NSAttributedStringMarkdownInterpretedSyntaxFull") {
//    return convertObjCObjectToJSIValue(runtime, NSAttributedStringMarkdownInterpretedSyntaxFull);
//  }
//  if (name == "NSAttributedStringMarkdownInterpretedSyntaxInlineOnly") {
//    return convertObjCObjectToJSIValue(runtime, NSAttributedStringMarkdownInterpretedSyntaxInlineOnly);
//  }
//  if (name == "NSAttributedStringMarkdownInterpretedSyntaxInlineOnlyPreservingWhitespace") {
//    return convertObjCObjectToJSIValue(runtime, NSAttributedStringMarkdownInterpretedSyntaxInlineOnlyPreservingWhitespace);
//  }
//  if (name == "NSAttributedStringMarkdownInterpretedSyntaxFull") {
//    return convertObjCObjectToJSIValue(runtime, NSAttributedStringMarkdownInterpretedSyntaxFull);
//  }
//  if (name == "NSAttributedStringMarkdownInterpretedSyntaxInlineOnly") {
//    return convertObjCObjectToJSIValue(runtime, NSAttributedStringMarkdownInterpretedSyntaxInlineOnly);
//  }
//  if (name == "NSAttributedStringMarkdownInterpretedSyntaxInlineOnlyPreservingWhitespace") {
//    return convertObjCObjectToJSIValue(runtime, NSAttributedStringMarkdownInterpretedSyntaxInlineOnlyPreservingWhitespace);
//  }
//  if (name == "NSAttributedStringMarkdownParsingFailurePolicy") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"ReturnError": NSAttributedStringMarkdownParsingFailureReturnError,
//        @"ReturnPartiallyParsedIfPossible": NSAttributedStringMarkdownParsingFailureReturnPartiallyParsedIfPossible
//      }
//    );
//  }
//  if (name == "NSAttributedStringMarkdownParsingFailureReturnError") {
//    return convertObjCObjectToJSIValue(runtime, NSAttributedStringMarkdownParsingFailureReturnError);
//  }
//  if (name == "NSAttributedStringMarkdownParsingFailureReturnPartiallyParsedIfPossible") {
//    return convertObjCObjectToJSIValue(runtime, NSAttributedStringMarkdownParsingFailureReturnPartiallyParsedIfPossible);
//  }
//  if (name == "NSAttributedStringMarkdownParsingFailureReturnError") {
//    return convertObjCObjectToJSIValue(runtime, NSAttributedStringMarkdownParsingFailureReturnError);
//  }
//  if (name == "NSAttributedStringMarkdownParsingFailureReturnPartiallyParsedIfPossible") {
//    return convertObjCObjectToJSIValue(runtime, NSAttributedStringMarkdownParsingFailureReturnPartiallyParsedIfPossible);
//  }
//  // TODO: NSAttributedStringMarkdownParsingOptions (Interface)
//  // TODO: NSAutoreleasePool (Interface)
//  if (name == "NSAutosavedInformationDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSAutosavedInformationDirectory);
//  }
//  if (name == "NSAverageKeyValueOperator") {
//    return convertObjCObjectToJSIValue(runtime, NSAverageKeyValueOperator);
//  }
//  if (name == "NSBackwardsSearch") {
//    return convertObjCObjectToJSIValue(runtime, NSBackwardsSearch);
//  }
//  if (name == "NSBeginsWithPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSBeginsWithPredicateOperatorType);
//  }
//  if (name == "NSBetweenPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSBetweenPredicateOperatorType);
//  }
//  if (name == "NSBinarySearchingFirstEqual") {
//    return convertObjCObjectToJSIValue(runtime, NSBinarySearchingFirstEqual);
//  }
//  if (name == "NSBinarySearchingInsertionIndex") {
//    return convertObjCObjectToJSIValue(runtime, NSBinarySearchingInsertionIndex);
//  }
//  if (name == "NSBinarySearchingLastEqual") {
//    return convertObjCObjectToJSIValue(runtime, NSBinarySearchingLastEqual);
//  }
//  if (name == "NSBinarySearchingOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"FirstEqual": NSBinarySearchingFirstEqual,
//        @"LastEqual": NSBinarySearchingLastEqual,
//        @"InsertionIndex": NSBinarySearchingInsertionIndex
//      }
//    );
//  }
//  if (name == "NSBinarySearchingFirstEqual") {
//    return convertObjCObjectToJSIValue(runtime, NSBinarySearchingFirstEqual);
//  }
//  if (name == "NSBinarySearchingLastEqual") {
//    return convertObjCObjectToJSIValue(runtime, NSBinarySearchingLastEqual);
//  }
//  if (name == "NSBinarySearchingInsertionIndex") {
//    return convertObjCObjectToJSIValue(runtime, NSBinarySearchingInsertionIndex);
//  }
//  if (name == "NSBlockExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSBlockExpressionType);
//  }
//  // TODO: NSBlockOperation (Interface)
//  if (name == "NSBuddhistCalendar") {
//    return convertObjCObjectToJSIValue(runtime, NSBuddhistCalendar);
//  }
//  // TODO: NSBundle (Interface)
//  if (name == "NSBundleDidLoadNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSBundleDidLoadNotification);
//  }
//  if (name == "NSBundleErrorMaximum") {
//    return convertObjCObjectToJSIValue(runtime, NSBundleErrorMaximum);
//  }
//  if (name == "NSBundleErrorMinimum") {
//    return convertObjCObjectToJSIValue(runtime, NSBundleErrorMinimum);
//  }
//  if (name == "NSBundleExecutableArchitectureARM64") {
//    return convertObjCObjectToJSIValue(runtime, NSBundleExecutableArchitectureARM64);
//  }
//  if (name == "NSBundleExecutableArchitectureI386") {
//    return convertObjCObjectToJSIValue(runtime, NSBundleExecutableArchitectureI386);
//  }
//  if (name == "NSBundleExecutableArchitecturePPC") {
//    return convertObjCObjectToJSIValue(runtime, NSBundleExecutableArchitecturePPC);
//  }
//  if (name == "NSBundleExecutableArchitecturePPC64") {
//    return convertObjCObjectToJSIValue(runtime, NSBundleExecutableArchitecturePPC64);
//  }
//  if (name == "NSBundleExecutableArchitectureX86_64") {
//    return convertObjCObjectToJSIValue(runtime, NSBundleExecutableArchitectureX86_64);
//  }
//  if (name == "NSBundleOnDemandResourceExceededMaximumSizeError") {
//    return convertObjCObjectToJSIValue(runtime, NSBundleOnDemandResourceExceededMaximumSizeError);
//  }
//  if (name == "NSBundleOnDemandResourceInvalidTagError") {
//    return convertObjCObjectToJSIValue(runtime, NSBundleOnDemandResourceInvalidTagError);
//  }
//  if (name == "NSBundleOnDemandResourceOutOfSpaceError") {
//    return convertObjCObjectToJSIValue(runtime, NSBundleOnDemandResourceOutOfSpaceError);
//  }
//  // TODO: NSBundleResourceRequest (Interface)
//  if (name == "NSBundleResourceRequestLoadingPriorityUrgent") {
//    return convertObjCObjectToJSIValue(runtime, NSBundleResourceRequestLoadingPriorityUrgent);
//  }
//  if (name == "NSBundleResourceRequestLowDiskSpaceNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSBundleResourceRequestLowDiskSpaceNotification);
//  }
//  // TODO: NSByteCountFormatter (Interface)
//  if (name == "NSByteCountFormatterCountStyle") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"File": NSByteCountFormatterCountStyleFile,
//        @"Memory": NSByteCountFormatterCountStyleMemory,
//        @"Decimal": NSByteCountFormatterCountStyleDecimal,
//        @"Binary": NSByteCountFormatterCountStyleBinary
//      }
//    );
//  }
//  if (name == "NSByteCountFormatterCountStyleFile") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterCountStyleFile);
//  }
//  if (name == "NSByteCountFormatterCountStyleMemory") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterCountStyleMemory);
//  }
//  if (name == "NSByteCountFormatterCountStyleDecimal") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterCountStyleDecimal);
//  }
//  if (name == "NSByteCountFormatterCountStyleBinary") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterCountStyleBinary);
//  }
//  if (name == "NSByteCountFormatterCountStyleBinary") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterCountStyleBinary);
//  }
//  if (name == "NSByteCountFormatterCountStyleDecimal") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterCountStyleDecimal);
//  }
//  if (name == "NSByteCountFormatterCountStyleFile") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterCountStyleFile);
//  }
//  if (name == "NSByteCountFormatterCountStyleMemory") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterCountStyleMemory);
//  }
//  if (name == "NSByteCountFormatterUnits") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"UseDefault": NSByteCountFormatterUseDefault,
//        @"UseBytes": NSByteCountFormatterUseBytes,
//        @"UseKB": NSByteCountFormatterUseKB,
//        @"UseMB": NSByteCountFormatterUseMB,
//        @"UseGB": NSByteCountFormatterUseGB,
//        @"UseTB": NSByteCountFormatterUseTB,
//        @"UsePB": NSByteCountFormatterUsePB,
//        @"UseEB": NSByteCountFormatterUseEB,
//        @"UseZB": NSByteCountFormatterUseZB,
//        @"UseYBOrHigher": NSByteCountFormatterUseYBOrHigher,
//        @"UseAll": NSByteCountFormatterUseAll
//      }
//    );
//  }
//  if (name == "NSByteCountFormatterUseDefault") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterUseDefault);
//  }
//  if (name == "NSByteCountFormatterUseBytes") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterUseBytes);
//  }
//  if (name == "NSByteCountFormatterUseKB") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterUseKB);
//  }
//  if (name == "NSByteCountFormatterUseMB") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterUseMB);
//  }
//  if (name == "NSByteCountFormatterUseGB") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterUseGB);
//  }
//  if (name == "NSByteCountFormatterUseTB") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterUseTB);
//  }
//  if (name == "NSByteCountFormatterUsePB") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterUsePB);
//  }
//  if (name == "NSByteCountFormatterUseEB") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterUseEB);
//  }
//  if (name == "NSByteCountFormatterUseZB") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterUseZB);
//  }
//  if (name == "NSByteCountFormatterUseYBOrHigher") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterUseYBOrHigher);
//  }
//  if (name == "NSByteCountFormatterUseAll") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterUseAll);
//  }
//  if (name == "NSByteCountFormatterUseAll") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterUseAll);
//  }
//  if (name == "NSByteCountFormatterUseBytes") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterUseBytes);
//  }
//  if (name == "NSByteCountFormatterUseDefault") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterUseDefault);
//  }
//  if (name == "NSByteCountFormatterUseEB") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterUseEB);
//  }
//  if (name == "NSByteCountFormatterUseGB") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterUseGB);
//  }
//  if (name == "NSByteCountFormatterUseKB") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterUseKB);
//  }
//  if (name == "NSByteCountFormatterUseMB") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterUseMB);
//  }
//  if (name == "NSByteCountFormatterUsePB") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterUsePB);
//  }
//  if (name == "NSByteCountFormatterUseTB") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterUseTB);
//  }
//  if (name == "NSByteCountFormatterUseYBOrHigher") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterUseYBOrHigher);
//  }
//  if (name == "NSByteCountFormatterUseZB") {
//    return convertObjCObjectToJSIValue(runtime, NSByteCountFormatterUseZB);
//  }
//  // TODO: NSCache (Interface)
//  // TODO: NSCacheDelegate (Protocol)
//  // TODO: NSCachedURLResponse (Interface)
//  if (name == "NSCachesDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSCachesDirectory);
//  }
//  if (name == "NSCalculationDivideByZero") {
//    return convertObjCObjectToJSIValue(runtime, NSCalculationDivideByZero);
//  }
//  if (name == "NSCalculationError") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"NoError": NSCalculationNoError,
//        @"LossOfPrecision": NSCalculationLossOfPrecision,
//        @"Underflow": NSCalculationUnderflow,
//        @"Overflow": NSCalculationOverflow,
//        @"DivideByZero": NSCalculationDivideByZero
//      }
//    );
//  }
//  if (name == "NSCalculationNoError") {
//    return convertObjCObjectToJSIValue(runtime, NSCalculationNoError);
//  }
//  if (name == "NSCalculationLossOfPrecision") {
//    return convertObjCObjectToJSIValue(runtime, NSCalculationLossOfPrecision);
//  }
//  if (name == "NSCalculationUnderflow") {
//    return convertObjCObjectToJSIValue(runtime, NSCalculationUnderflow);
//  }
//  if (name == "NSCalculationOverflow") {
//    return convertObjCObjectToJSIValue(runtime, NSCalculationOverflow);
//  }
//  if (name == "NSCalculationDivideByZero") {
//    return convertObjCObjectToJSIValue(runtime, NSCalculationDivideByZero);
//  }
//  if (name == "NSCalculationLossOfPrecision") {
//    return convertObjCObjectToJSIValue(runtime, NSCalculationLossOfPrecision);
//  }
//  if (name == "NSCalculationNoError") {
//    return convertObjCObjectToJSIValue(runtime, NSCalculationNoError);
//  }
//  if (name == "NSCalculationOverflow") {
//    return convertObjCObjectToJSIValue(runtime, NSCalculationOverflow);
//  }
//  if (name == "NSCalculationUnderflow") {
//    return convertObjCObjectToJSIValue(runtime, NSCalculationUnderflow);
//  }
//  // TODO: NSCalendar (Interface)
//  if (name == "NSCalendarCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarCalendarUnit);
//  }
//  if (name == "NSCalendarDayChangedNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarDayChangedNotification);
//  }
//  if (name == "NSCalendarIdentifierBuddhist") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarIdentifierBuddhist);
//  }
//  if (name == "NSCalendarIdentifierChinese") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarIdentifierChinese);
//  }
//  if (name == "NSCalendarIdentifierCoptic") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarIdentifierCoptic);
//  }
//  if (name == "NSCalendarIdentifierEthiopicAmeteAlem") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarIdentifierEthiopicAmeteAlem);
//  }
//  if (name == "NSCalendarIdentifierEthiopicAmeteMihret") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarIdentifierEthiopicAmeteMihret);
//  }
//  if (name == "NSCalendarIdentifierGregorian") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarIdentifierGregorian);
//  }
//  if (name == "NSCalendarIdentifierHebrew") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarIdentifierHebrew);
//  }
//  if (name == "NSCalendarIdentifierISO8601") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarIdentifierISO8601);
//  }
//  if (name == "NSCalendarIdentifierIndian") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarIdentifierIndian);
//  }
//  if (name == "NSCalendarIdentifierIslamic") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarIdentifierIslamic);
//  }
//  if (name == "NSCalendarIdentifierIslamicCivil") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarIdentifierIslamicCivil);
//  }
//  if (name == "NSCalendarIdentifierIslamicTabular") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarIdentifierIslamicTabular);
//  }
//  if (name == "NSCalendarIdentifierIslamicUmmAlQura") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarIdentifierIslamicUmmAlQura);
//  }
//  if (name == "NSCalendarIdentifierJapanese") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarIdentifierJapanese);
//  }
//  if (name == "NSCalendarIdentifierPersian") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarIdentifierPersian);
//  }
//  if (name == "NSCalendarIdentifierRepublicOfChina") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarIdentifierRepublicOfChina);
//  }
//  if (name == "NSCalendarMatchFirst") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarMatchFirst);
//  }
//  if (name == "NSCalendarMatchLast") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarMatchLast);
//  }
//  if (name == "NSCalendarMatchNextTime") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarMatchNextTime);
//  }
//  if (name == "NSCalendarMatchNextTimePreservingSmallerUnits") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarMatchNextTimePreservingSmallerUnits);
//  }
//  if (name == "NSCalendarMatchPreviousTimePreservingSmallerUnits") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarMatchPreviousTimePreservingSmallerUnits);
//  }
//  if (name == "NSCalendarMatchStrictly") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarMatchStrictly);
//  }
//  if (name == "NSCalendarOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"WrapComponents": NSCalendarWrapComponents,
//        @"MatchStrictly": NSCalendarMatchStrictly,
//        @"SearchBackwards": NSCalendarSearchBackwards,
//        @"MatchPreviousTimePreservingSmallerUnits": NSCalendarMatchPreviousTimePreservingSmallerUnits,
//        @"MatchNextTimePreservingSmallerUnits": NSCalendarMatchNextTimePreservingSmallerUnits,
//        @"MatchNextTime": NSCalendarMatchNextTime,
//        @"MatchFirst": NSCalendarMatchFirst,
//        @"MatchLast": NSCalendarMatchLast
//      }
//    );
//  }
//  if (name == "NSCalendarWrapComponents") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarWrapComponents);
//  }
//  if (name == "NSCalendarMatchStrictly") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarMatchStrictly);
//  }
//  if (name == "NSCalendarSearchBackwards") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarSearchBackwards);
//  }
//  if (name == "NSCalendarMatchPreviousTimePreservingSmallerUnits") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarMatchPreviousTimePreservingSmallerUnits);
//  }
//  if (name == "NSCalendarMatchNextTimePreservingSmallerUnits") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarMatchNextTimePreservingSmallerUnits);
//  }
//  if (name == "NSCalendarMatchNextTime") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarMatchNextTime);
//  }
//  if (name == "NSCalendarMatchFirst") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarMatchFirst);
//  }
//  if (name == "NSCalendarMatchLast") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarMatchLast);
//  }
//  if (name == "NSCalendarSearchBackwards") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarSearchBackwards);
//  }
//  if (name == "NSCalendarUnit") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"CalendarUnitEra": NSCalendarUnitEra,
//        @"CalendarUnitYear": NSCalendarUnitYear,
//        @"CalendarUnitMonth": NSCalendarUnitMonth,
//        @"CalendarUnitDay": NSCalendarUnitDay,
//        @"CalendarUnitHour": NSCalendarUnitHour,
//        @"CalendarUnitMinute": NSCalendarUnitMinute,
//        @"CalendarUnitSecond": NSCalendarUnitSecond,
//        @"CalendarUnitWeekday": NSCalendarUnitWeekday,
//        @"CalendarUnitWeekdayOrdinal": NSCalendarUnitWeekdayOrdinal,
//        @"CalendarUnitQuarter": NSCalendarUnitQuarter,
//        @"CalendarUnitWeekOfMonth": NSCalendarUnitWeekOfMonth,
//        @"CalendarUnitWeekOfYear": NSCalendarUnitWeekOfYear,
//        @"CalendarUnitYearForWeekOfYear": NSCalendarUnitYearForWeekOfYear,
//        @"CalendarUnitNanosecond": NSCalendarUnitNanosecond,
//        @"CalendarUnitCalendar": NSCalendarUnitCalendar,
//        @"CalendarUnitTimeZone": NSCalendarUnitTimeZone,
//        @"EraCalendarUnit": NSEraCalendarUnit,
//        @"YearCalendarUnit": NSYearCalendarUnit,
//        @"MonthCalendarUnit": NSMonthCalendarUnit,
//        @"DayCalendarUnit": NSDayCalendarUnit,
//        @"HourCalendarUnit": NSHourCalendarUnit,
//        @"MinuteCalendarUnit": NSMinuteCalendarUnit,
//        @"SecondCalendarUnit": NSSecondCalendarUnit,
//        @"WeekCalendarUnit": NSWeekCalendarUnit,
//        @"WeekdayCalendarUnit": NSWeekdayCalendarUnit,
//        @"WeekdayOrdinalCalendarUnit": NSWeekdayOrdinalCalendarUnit,
//        @"QuarterCalendarUnit": NSQuarterCalendarUnit,
//        @"WeekOfMonthCalendarUnit": NSWeekOfMonthCalendarUnit,
//        @"WeekOfYearCalendarUnit": NSWeekOfYearCalendarUnit,
//        @"YearForWeekOfYearCalendarUnit": NSYearForWeekOfYearCalendarUnit,
//        @"CalendarCalendarUnit": NSCalendarCalendarUnit,
//        @"TimeZoneCalendarUnit": NSTimeZoneCalendarUnit
//      }
//    );
//  }
//  if (name == "NSCalendarUnitEra") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitEra);
//  }
//  if (name == "NSCalendarUnitYear") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitYear);
//  }
//  if (name == "NSCalendarUnitMonth") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitMonth);
//  }
//  if (name == "NSCalendarUnitDay") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitDay);
//  }
//  if (name == "NSCalendarUnitHour") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitHour);
//  }
//  if (name == "NSCalendarUnitMinute") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitMinute);
//  }
//  if (name == "NSCalendarUnitSecond") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitSecond);
//  }
//  if (name == "NSCalendarUnitWeekday") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitWeekday);
//  }
//  if (name == "NSCalendarUnitWeekdayOrdinal") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitWeekdayOrdinal);
//  }
//  if (name == "NSCalendarUnitQuarter") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitQuarter);
//  }
//  if (name == "NSCalendarUnitWeekOfMonth") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitWeekOfMonth);
//  }
//  if (name == "NSCalendarUnitWeekOfYear") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitWeekOfYear);
//  }
//  if (name == "NSCalendarUnitYearForWeekOfYear") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitYearForWeekOfYear);
//  }
//  if (name == "NSCalendarUnitNanosecond") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitNanosecond);
//  }
//  if (name == "NSCalendarUnitCalendar") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitCalendar);
//  }
//  if (name == "NSCalendarUnitTimeZone") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitTimeZone);
//  }
//  if (name == "NSEraCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSEraCalendarUnit);
//  }
//  if (name == "NSYearCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSYearCalendarUnit);
//  }
//  if (name == "NSMonthCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSMonthCalendarUnit);
//  }
//  if (name == "NSDayCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSDayCalendarUnit);
//  }
//  if (name == "NSHourCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSHourCalendarUnit);
//  }
//  if (name == "NSMinuteCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSMinuteCalendarUnit);
//  }
//  if (name == "NSSecondCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSSecondCalendarUnit);
//  }
//  if (name == "NSWeekCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSWeekCalendarUnit);
//  }
//  if (name == "NSWeekdayCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSWeekdayCalendarUnit);
//  }
//  if (name == "NSWeekdayOrdinalCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSWeekdayOrdinalCalendarUnit);
//  }
//  if (name == "NSQuarterCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSQuarterCalendarUnit);
//  }
//  if (name == "NSWeekOfMonthCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSWeekOfMonthCalendarUnit);
//  }
//  if (name == "NSWeekOfYearCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSWeekOfYearCalendarUnit);
//  }
//  if (name == "NSYearForWeekOfYearCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSYearForWeekOfYearCalendarUnit);
//  }
//  if (name == "NSCalendarCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarCalendarUnit);
//  }
//  if (name == "NSTimeZoneCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSTimeZoneCalendarUnit);
//  }
//  if (name == "NSCalendarUnitCalendar") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitCalendar);
//  }
//  if (name == "NSCalendarUnitDay") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitDay);
//  }
//  if (name == "NSCalendarUnitEra") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitEra);
//  }
//  if (name == "NSCalendarUnitHour") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitHour);
//  }
//  if (name == "NSCalendarUnitMinute") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitMinute);
//  }
//  if (name == "NSCalendarUnitMonth") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitMonth);
//  }
//  if (name == "NSCalendarUnitNanosecond") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitNanosecond);
//  }
//  if (name == "NSCalendarUnitQuarter") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitQuarter);
//  }
//  if (name == "NSCalendarUnitSecond") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitSecond);
//  }
//  if (name == "NSCalendarUnitTimeZone") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitTimeZone);
//  }
//  if (name == "NSCalendarUnitWeekOfMonth") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitWeekOfMonth);
//  }
//  if (name == "NSCalendarUnitWeekOfYear") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitWeekOfYear);
//  }
//  if (name == "NSCalendarUnitWeekday") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitWeekday);
//  }
//  if (name == "NSCalendarUnitWeekdayOrdinal") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitWeekdayOrdinal);
//  }
//  if (name == "NSCalendarUnitYear") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitYear);
//  }
//  if (name == "NSCalendarUnitYearForWeekOfYear") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarUnitYearForWeekOfYear);
//  }
//  if (name == "NSCalendarWrapComponents") {
//    return convertObjCObjectToJSIValue(runtime, NSCalendarWrapComponents);
//  }
//  if (name == "NSCaseInsensitivePredicateOption") {
//    return convertObjCObjectToJSIValue(runtime, NSCaseInsensitivePredicateOption);
//  }
//  if (name == "NSCaseInsensitiveSearch") {
//    return convertObjCObjectToJSIValue(runtime, NSCaseInsensitiveSearch);
//  }
//  if (name == "NSCharacterConversionException") {
//    return convertObjCObjectToJSIValue(runtime, NSCharacterConversionException);
//  }
//  // TODO: NSCharacterSet (Interface)
//  if (name == "NSChineseCalendar") {
//    return convertObjCObjectToJSIValue(runtime, NSChineseCalendar);
//  }
//  if (name == "NSClassFromString") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSClassFromString(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSClassFromString"), 1, func);
//  }
//  if (name == "NSCloudSharingConflictError") {
//    return convertObjCObjectToJSIValue(runtime, NSCloudSharingConflictError);
//  }
//  if (name == "NSCloudSharingErrorMaximum") {
//    return convertObjCObjectToJSIValue(runtime, NSCloudSharingErrorMaximum);
//  }
//  if (name == "NSCloudSharingErrorMinimum") {
//    return convertObjCObjectToJSIValue(runtime, NSCloudSharingErrorMinimum);
//  }
//  if (name == "NSCloudSharingNetworkFailureError") {
//    return convertObjCObjectToJSIValue(runtime, NSCloudSharingNetworkFailureError);
//  }
//  if (name == "NSCloudSharingNoPermissionError") {
//    return convertObjCObjectToJSIValue(runtime, NSCloudSharingNoPermissionError);
//  }
//  if (name == "NSCloudSharingOtherError") {
//    return convertObjCObjectToJSIValue(runtime, NSCloudSharingOtherError);
//  }
//  if (name == "NSCloudSharingQuotaExceededError") {
//    return convertObjCObjectToJSIValue(runtime, NSCloudSharingQuotaExceededError);
//  }
//  if (name == "NSCloudSharingTooManyParticipantsError") {
//    return convertObjCObjectToJSIValue(runtime, NSCloudSharingTooManyParticipantsError);
//  }
//  if (name == "NSCocoaErrorDomain") {
//    return convertObjCObjectToJSIValue(runtime, NSCocoaErrorDomain);
//  }
//  // TODO: NSCoder (Interface)
//  if (name == "NSCoderErrorMaximum") {
//    return convertObjCObjectToJSIValue(runtime, NSCoderErrorMaximum);
//  }
//  if (name == "NSCoderErrorMinimum") {
//    return convertObjCObjectToJSIValue(runtime, NSCoderErrorMinimum);
//  }
//  if (name == "NSCoderInvalidValueError") {
//    return convertObjCObjectToJSIValue(runtime, NSCoderInvalidValueError);
//  }
//  if (name == "NSCoderReadCorruptError") {
//    return convertObjCObjectToJSIValue(runtime, NSCoderReadCorruptError);
//  }
//  if (name == "NSCoderValueNotFoundError") {
//    return convertObjCObjectToJSIValue(runtime, NSCoderValueNotFoundError);
//  }
//  // TODO: NSCoding (Protocol)
//  if (name == "NSCollectionChangeInsert") {
//    return convertObjCObjectToJSIValue(runtime, NSCollectionChangeInsert);
//  }
//  if (name == "NSCollectionChangeRemove") {
//    return convertObjCObjectToJSIValue(runtime, NSCollectionChangeRemove);
//  }
//  if (name == "NSCollectionChangeType") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Insert": NSCollectionChangeInsert,
//        @"Remove": NSCollectionChangeRemove
//      }
//    );
//  }
//  if (name == "NSCollectionChangeInsert") {
//    return convertObjCObjectToJSIValue(runtime, NSCollectionChangeInsert);
//  }
//  if (name == "NSCollectionChangeRemove") {
//    return convertObjCObjectToJSIValue(runtime, NSCollectionChangeRemove);
//  }
//  if (name == "NSCompareHashTables") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSCompareHashTables(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSCompareHashTables"), 2, func);
//  }
//  if (name == "NSCompareMapTables") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSCompareMapTables(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSCompareMapTables"), 2, func);
//  }
//  // TODO: NSComparisonPredicate (Interface)
//  if (name == "NSComparisonPredicateModifier") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"DirectPredicateModifier": NSDirectPredicateModifier,
//        @"AllPredicateModifier": NSAllPredicateModifier,
//        @"AnyPredicateModifier": NSAnyPredicateModifier
//      }
//    );
//  }
//  if (name == "NSDirectPredicateModifier") {
//    return convertObjCObjectToJSIValue(runtime, NSDirectPredicateModifier);
//  }
//  if (name == "NSAllPredicateModifier") {
//    return convertObjCObjectToJSIValue(runtime, NSAllPredicateModifier);
//  }
//  if (name == "NSAnyPredicateModifier") {
//    return convertObjCObjectToJSIValue(runtime, NSAnyPredicateModifier);
//  }
//  if (name == "NSComparisonPredicateOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"CaseInsensitivePredicateOption": NSCaseInsensitivePredicateOption,
//        @"DiacriticInsensitivePredicateOption": NSDiacriticInsensitivePredicateOption,
//        @"NormalizedPredicateOption": NSNormalizedPredicateOption
//      }
//    );
//  }
//  if (name == "NSCaseInsensitivePredicateOption") {
//    return convertObjCObjectToJSIValue(runtime, NSCaseInsensitivePredicateOption);
//  }
//  if (name == "NSDiacriticInsensitivePredicateOption") {
//    return convertObjCObjectToJSIValue(runtime, NSDiacriticInsensitivePredicateOption);
//  }
//  if (name == "NSNormalizedPredicateOption") {
//    return convertObjCObjectToJSIValue(runtime, NSNormalizedPredicateOption);
//  }
//  if (name == "NSComparisonResult") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"OrderedAscending": NSOrderedAscending,
//        @"OrderedSame": NSOrderedSame,
//        @"OrderedDescending": NSOrderedDescending
//      }
//    );
//  }
//  if (name == "NSOrderedAscending") {
//    return convertObjCObjectToJSIValue(runtime, NSOrderedAscending);
//  }
//  if (name == "NSOrderedSame") {
//    return convertObjCObjectToJSIValue(runtime, NSOrderedSame);
//  }
//  if (name == "NSOrderedDescending") {
//    return convertObjCObjectToJSIValue(runtime, NSOrderedDescending);
//  }
//  // TODO: NSCompoundPredicate (Interface)
//  if (name == "NSCompoundPredicateType") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"NotPredicateType": NSNotPredicateType,
//        @"AndPredicateType": NSAndPredicateType,
//        @"OrPredicateType": NSOrPredicateType
//      }
//    );
//  }
//  if (name == "NSNotPredicateType") {
//    return convertObjCObjectToJSIValue(runtime, NSNotPredicateType);
//  }
//  if (name == "NSAndPredicateType") {
//    return convertObjCObjectToJSIValue(runtime, NSAndPredicateType);
//  }
//  if (name == "NSOrPredicateType") {
//    return convertObjCObjectToJSIValue(runtime, NSOrPredicateType);
//  }
//  if (name == "NSCompressionErrorMaximum") {
//    return convertObjCObjectToJSIValue(runtime, NSCompressionErrorMaximum);
//  }
//  if (name == "NSCompressionErrorMinimum") {
//    return convertObjCObjectToJSIValue(runtime, NSCompressionErrorMinimum);
//  }
//  if (name == "NSCompressionFailedError") {
//    return convertObjCObjectToJSIValue(runtime, NSCompressionFailedError);
//  }
//  // TODO: NSCondition (Interface)
//  // TODO: NSConditionLock (Interface)
//  if (name == "NSConditionalExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSConditionalExpressionType);
//  }
//  // TODO: NSConstantString (Interface)
//  if (name == "NSConstantValueExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSConstantValueExpressionType);
//  }
//  if (name == "NSContainsPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSContainsPredicateOperatorType);
//  }
//  if (name == "NSCopyHashTableWithZone") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSCopyHashTableWithZone(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSCopyHashTableWithZone"), 2, func);
//  }
//  if (name == "NSCopyMapTableWithZone") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSCopyMapTableWithZone(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSCopyMapTableWithZone"), 2, func);
//  }
//  if (name == "NSCopyMemoryPages") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSCopyMemoryPages(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSCopyMemoryPages"), 3, func);
//  }
//  if (name == "NSCopyObject") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSCopyObject(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSCopyObject"), 3, func);
//  }
//  // TODO: NSCopying (Protocol)
//  if (name == "NSCoreServiceDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSCoreServiceDirectory);
//  }
//  if (name == "NSCountHashTable") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSCountHashTable(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSCountHashTable"), 1, func);
//  }
//  if (name == "NSCountKeyValueOperator") {
//    return convertObjCObjectToJSIValue(runtime, NSCountKeyValueOperator);
//  }
//  if (name == "NSCountMapTable") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSCountMapTable(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSCountMapTable"), 1, func);
//  }
//  // TODO: NSCountedSet (Interface)
//  if (name == "NSCreateHashTable") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSCreateHashTable(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSCreateHashTable"), 2, func);
//  }
//  if (name == "NSCreateHashTableWithZone") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSCreateHashTableWithZone(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSCreateHashTableWithZone"), 3, func);
//  }
//  if (name == "NSCreateMapTable") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSCreateMapTable(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSCreateMapTable"), 3, func);
//  }
//  if (name == "NSCreateMapTableWithZone") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSCreateMapTableWithZone(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2]),
//        convertJSIValueToObjCObject(arguments[3])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSCreateMapTableWithZone"), 4, func);
//  }
//  if (name == "NSCreateZone") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSCreateZone(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSCreateZone"), 3, func);
//  }
//  if (name == "NSCurrentLocaleDidChangeNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSCurrentLocaleDidChangeNotification);
//  }
//  if (name == "NSCustomSelectorPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSCustomSelectorPredicateOperatorType);
//  }
//  // TODO: NSData (Interface)
//  if (name == "NSDataBase64DecodingIgnoreUnknownCharacters") {
//    return convertObjCObjectToJSIValue(runtime, NSDataBase64DecodingIgnoreUnknownCharacters);
//  }
//  if (name == "NSDataBase64DecodingOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"IgnoreUnknownCharacters": NSDataBase64DecodingIgnoreUnknownCharacters
//      }
//    );
//  }
//  if (name == "NSDataBase64DecodingIgnoreUnknownCharacters") {
//    return convertObjCObjectToJSIValue(runtime, NSDataBase64DecodingIgnoreUnknownCharacters);
//  }
//  if (name == "NSDataBase64Encoding64CharacterLineLength") {
//    return convertObjCObjectToJSIValue(runtime, NSDataBase64Encoding64CharacterLineLength);
//  }
//  if (name == "NSDataBase64Encoding76CharacterLineLength") {
//    return convertObjCObjectToJSIValue(runtime, NSDataBase64Encoding76CharacterLineLength);
//  }
//  if (name == "NSDataBase64EncodingEndLineWithCarriageReturn") {
//    return convertObjCObjectToJSIValue(runtime, NSDataBase64EncodingEndLineWithCarriageReturn);
//  }
//  if (name == "NSDataBase64EncodingEndLineWithLineFeed") {
//    return convertObjCObjectToJSIValue(runtime, NSDataBase64EncodingEndLineWithLineFeed);
//  }
//  if (name == "NSDataBase64EncodingOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Encoding64CharacterLineLength": NSDataBase64Encoding64CharacterLineLength,
//        @"Encoding76CharacterLineLength": NSDataBase64Encoding76CharacterLineLength,
//        @"EncodingEndLineWithCarriageReturn": NSDataBase64EncodingEndLineWithCarriageReturn,
//        @"EncodingEndLineWithLineFeed": NSDataBase64EncodingEndLineWithLineFeed
//      }
//    );
//  }
//  if (name == "NSDataBase64Encoding64CharacterLineLength") {
//    return convertObjCObjectToJSIValue(runtime, NSDataBase64Encoding64CharacterLineLength);
//  }
//  if (name == "NSDataBase64Encoding76CharacterLineLength") {
//    return convertObjCObjectToJSIValue(runtime, NSDataBase64Encoding76CharacterLineLength);
//  }
//  if (name == "NSDataBase64EncodingEndLineWithCarriageReturn") {
//    return convertObjCObjectToJSIValue(runtime, NSDataBase64EncodingEndLineWithCarriageReturn);
//  }
//  if (name == "NSDataBase64EncodingEndLineWithLineFeed") {
//    return convertObjCObjectToJSIValue(runtime, NSDataBase64EncodingEndLineWithLineFeed);
//  }
//  if (name == "NSDataCompressionAlgorithm") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"LZFSE": NSDataCompressionAlgorithmLZFSE,
//        @"LZ4": NSDataCompressionAlgorithmLZ4,
//        @"LZMA": NSDataCompressionAlgorithmLZMA,
//        @"Zlib": NSDataCompressionAlgorithmZlib
//      }
//    );
//  }
//  if (name == "NSDataCompressionAlgorithmLZFSE") {
//    return convertObjCObjectToJSIValue(runtime, NSDataCompressionAlgorithmLZFSE);
//  }
//  if (name == "NSDataCompressionAlgorithmLZ4") {
//    return convertObjCObjectToJSIValue(runtime, NSDataCompressionAlgorithmLZ4);
//  }
//  if (name == "NSDataCompressionAlgorithmLZMA") {
//    return convertObjCObjectToJSIValue(runtime, NSDataCompressionAlgorithmLZMA);
//  }
//  if (name == "NSDataCompressionAlgorithmZlib") {
//    return convertObjCObjectToJSIValue(runtime, NSDataCompressionAlgorithmZlib);
//  }
//  if (name == "NSDataCompressionAlgorithmLZ4") {
//    return convertObjCObjectToJSIValue(runtime, NSDataCompressionAlgorithmLZ4);
//  }
//  if (name == "NSDataCompressionAlgorithmLZFSE") {
//    return convertObjCObjectToJSIValue(runtime, NSDataCompressionAlgorithmLZFSE);
//  }
//  if (name == "NSDataCompressionAlgorithmLZMA") {
//    return convertObjCObjectToJSIValue(runtime, NSDataCompressionAlgorithmLZMA);
//  }
//  if (name == "NSDataCompressionAlgorithmZlib") {
//    return convertObjCObjectToJSIValue(runtime, NSDataCompressionAlgorithmZlib);
//  }
//  // TODO: NSDataDetector (Interface)
//  if (name == "NSDataReadingMapped") {
//    return convertObjCObjectToJSIValue(runtime, NSDataReadingMapped);
//  }
//  if (name == "NSDataReadingMappedAlways") {
//    return convertObjCObjectToJSIValue(runtime, NSDataReadingMappedAlways);
//  }
//  if (name == "NSDataReadingMappedIfSafe") {
//    return convertObjCObjectToJSIValue(runtime, NSDataReadingMappedIfSafe);
//  }
//  if (name == "NSDataReadingOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"DataReadingMappedIfSafe": NSDataReadingMappedIfSafe,
//        @"DataReadingUncached": NSDataReadingUncached,
//        @"DataReadingMappedAlways": NSDataReadingMappedAlways,
//        @"DataReadingMapped": NSDataReadingMapped,
//        @"MappedRead": NSMappedRead,
//        @"UncachedRead": NSUncachedRead
//      }
//    );
//  }
//  if (name == "NSDataReadingMappedIfSafe") {
//    return convertObjCObjectToJSIValue(runtime, NSDataReadingMappedIfSafe);
//  }
//  if (name == "NSDataReadingUncached") {
//    return convertObjCObjectToJSIValue(runtime, NSDataReadingUncached);
//  }
//  if (name == "NSDataReadingMappedAlways") {
//    return convertObjCObjectToJSIValue(runtime, NSDataReadingMappedAlways);
//  }
//  if (name == "NSDataReadingMapped") {
//    return convertObjCObjectToJSIValue(runtime, NSDataReadingMapped);
//  }
//  if (name == "NSMappedRead") {
//    return convertObjCObjectToJSIValue(runtime, NSMappedRead);
//  }
//  if (name == "NSUncachedRead") {
//    return convertObjCObjectToJSIValue(runtime, NSUncachedRead);
//  }
//  if (name == "NSDataReadingUncached") {
//    return convertObjCObjectToJSIValue(runtime, NSDataReadingUncached);
//  }
//  if (name == "NSDataSearchAnchored") {
//    return convertObjCObjectToJSIValue(runtime, NSDataSearchAnchored);
//  }
//  if (name == "NSDataSearchBackwards") {
//    return convertObjCObjectToJSIValue(runtime, NSDataSearchBackwards);
//  }
//  if (name == "NSDataSearchOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Backwards": NSDataSearchBackwards,
//        @"Anchored": NSDataSearchAnchored
//      }
//    );
//  }
//  if (name == "NSDataSearchBackwards") {
//    return convertObjCObjectToJSIValue(runtime, NSDataSearchBackwards);
//  }
//  if (name == "NSDataSearchAnchored") {
//    return convertObjCObjectToJSIValue(runtime, NSDataSearchAnchored);
//  }
//  if (name == "NSDataWritingAtomic") {
//    return convertObjCObjectToJSIValue(runtime, NSDataWritingAtomic);
//  }
//  if (name == "NSDataWritingFileProtectionComplete") {
//    return convertObjCObjectToJSIValue(runtime, NSDataWritingFileProtectionComplete);
//  }
//  if (name == "NSDataWritingFileProtectionCompleteUnlessOpen") {
//    return convertObjCObjectToJSIValue(runtime, NSDataWritingFileProtectionCompleteUnlessOpen);
//  }
//  if (name == "NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication") {
//    return convertObjCObjectToJSIValue(runtime, NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication);
//  }
//  if (name == "NSDataWritingFileProtectionMask") {
//    return convertObjCObjectToJSIValue(runtime, NSDataWritingFileProtectionMask);
//  }
//  if (name == "NSDataWritingFileProtectionNone") {
//    return convertObjCObjectToJSIValue(runtime, NSDataWritingFileProtectionNone);
//  }
//  if (name == "NSDataWritingOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"DataWritingAtomic": NSDataWritingAtomic,
//        @"DataWritingWithoutOverwriting": NSDataWritingWithoutOverwriting,
//        @"DataWritingFileProtectionNone": NSDataWritingFileProtectionNone,
//        @"DataWritingFileProtectionComplete": NSDataWritingFileProtectionComplete,
//        @"DataWritingFileProtectionCompleteUnlessOpen": NSDataWritingFileProtectionCompleteUnlessOpen,
//        @"DataWritingFileProtectionCompleteUntilFirstUserAuthentication": NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication,
//        @"DataWritingFileProtectionMask": NSDataWritingFileProtectionMask,
//        @"AtomicWrite": NSAtomicWrite
//      }
//    );
//  }
//  if (name == "NSDataWritingAtomic") {
//    return convertObjCObjectToJSIValue(runtime, NSDataWritingAtomic);
//  }
//  if (name == "NSDataWritingWithoutOverwriting") {
//    return convertObjCObjectToJSIValue(runtime, NSDataWritingWithoutOverwriting);
//  }
//  if (name == "NSDataWritingFileProtectionNone") {
//    return convertObjCObjectToJSIValue(runtime, NSDataWritingFileProtectionNone);
//  }
//  if (name == "NSDataWritingFileProtectionComplete") {
//    return convertObjCObjectToJSIValue(runtime, NSDataWritingFileProtectionComplete);
//  }
//  if (name == "NSDataWritingFileProtectionCompleteUnlessOpen") {
//    return convertObjCObjectToJSIValue(runtime, NSDataWritingFileProtectionCompleteUnlessOpen);
//  }
//  if (name == "NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication") {
//    return convertObjCObjectToJSIValue(runtime, NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication);
//  }
//  if (name == "NSDataWritingFileProtectionMask") {
//    return convertObjCObjectToJSIValue(runtime, NSDataWritingFileProtectionMask);
//  }
//  if (name == "NSAtomicWrite") {
//    return convertObjCObjectToJSIValue(runtime, NSAtomicWrite);
//  }
//  if (name == "NSDataWritingWithoutOverwriting") {
//    return convertObjCObjectToJSIValue(runtime, NSDataWritingWithoutOverwriting);
//  }
//  // TODO: NSDate (Interface)
//  if (name == "NSDateComponentUndefined") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentUndefined);
//  }
//  // TODO: NSDateComponents (Interface)
//  // TODO: NSDateComponentsFormatter (Interface)
//  if (name == "NSDateComponentsFormatterUnitsStyle") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Positional": NSDateComponentsFormatterUnitsStylePositional,
//        @"Abbreviated": NSDateComponentsFormatterUnitsStyleAbbreviated,
//        @"Short": NSDateComponentsFormatterUnitsStyleShort,
//        @"Full": NSDateComponentsFormatterUnitsStyleFull,
//        @"SpellOut": NSDateComponentsFormatterUnitsStyleSpellOut,
//        @"Brief": NSDateComponentsFormatterUnitsStyleBrief
//      }
//    );
//  }
//  if (name == "NSDateComponentsFormatterUnitsStylePositional") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterUnitsStylePositional);
//  }
//  if (name == "NSDateComponentsFormatterUnitsStyleAbbreviated") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterUnitsStyleAbbreviated);
//  }
//  if (name == "NSDateComponentsFormatterUnitsStyleShort") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterUnitsStyleShort);
//  }
//  if (name == "NSDateComponentsFormatterUnitsStyleFull") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterUnitsStyleFull);
//  }
//  if (name == "NSDateComponentsFormatterUnitsStyleSpellOut") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterUnitsStyleSpellOut);
//  }
//  if (name == "NSDateComponentsFormatterUnitsStyleBrief") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterUnitsStyleBrief);
//  }
//  if (name == "NSDateComponentsFormatterUnitsStyleAbbreviated") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterUnitsStyleAbbreviated);
//  }
//  if (name == "NSDateComponentsFormatterUnitsStyleBrief") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterUnitsStyleBrief);
//  }
//  if (name == "NSDateComponentsFormatterUnitsStyleFull") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterUnitsStyleFull);
//  }
//  if (name == "NSDateComponentsFormatterUnitsStylePositional") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterUnitsStylePositional);
//  }
//  if (name == "NSDateComponentsFormatterUnitsStyleShort") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterUnitsStyleShort);
//  }
//  if (name == "NSDateComponentsFormatterUnitsStyleSpellOut") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterUnitsStyleSpellOut);
//  }
//  if (name == "NSDateComponentsFormatterZeroFormattingBehavior") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"None": NSDateComponentsFormatterZeroFormattingBehaviorNone,
//        @"Default": NSDateComponentsFormatterZeroFormattingBehaviorDefault,
//        @"DropLeading": NSDateComponentsFormatterZeroFormattingBehaviorDropLeading,
//        @"DropMiddle": NSDateComponentsFormatterZeroFormattingBehaviorDropMiddle,
//        @"DropTrailing": NSDateComponentsFormatterZeroFormattingBehaviorDropTrailing,
//        @"DropAll": NSDateComponentsFormatterZeroFormattingBehaviorDropAll,
//        @"Pad": NSDateComponentsFormatterZeroFormattingBehaviorPad
//      }
//    );
//  }
//  if (name == "NSDateComponentsFormatterZeroFormattingBehaviorNone") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterZeroFormattingBehaviorNone);
//  }
//  if (name == "NSDateComponentsFormatterZeroFormattingBehaviorDefault") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterZeroFormattingBehaviorDefault);
//  }
//  if (name == "NSDateComponentsFormatterZeroFormattingBehaviorDropLeading") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterZeroFormattingBehaviorDropLeading);
//  }
//  if (name == "NSDateComponentsFormatterZeroFormattingBehaviorDropMiddle") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterZeroFormattingBehaviorDropMiddle);
//  }
//  if (name == "NSDateComponentsFormatterZeroFormattingBehaviorDropTrailing") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterZeroFormattingBehaviorDropTrailing);
//  }
//  if (name == "NSDateComponentsFormatterZeroFormattingBehaviorDropAll") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterZeroFormattingBehaviorDropAll);
//  }
//  if (name == "NSDateComponentsFormatterZeroFormattingBehaviorPad") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterZeroFormattingBehaviorPad);
//  }
//  if (name == "NSDateComponentsFormatterZeroFormattingBehaviorDefault") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterZeroFormattingBehaviorDefault);
//  }
//  if (name == "NSDateComponentsFormatterZeroFormattingBehaviorDropAll") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterZeroFormattingBehaviorDropAll);
//  }
//  if (name == "NSDateComponentsFormatterZeroFormattingBehaviorDropLeading") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterZeroFormattingBehaviorDropLeading);
//  }
//  if (name == "NSDateComponentsFormatterZeroFormattingBehaviorDropMiddle") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterZeroFormattingBehaviorDropMiddle);
//  }
//  if (name == "NSDateComponentsFormatterZeroFormattingBehaviorDropTrailing") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterZeroFormattingBehaviorDropTrailing);
//  }
//  if (name == "NSDateComponentsFormatterZeroFormattingBehaviorNone") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterZeroFormattingBehaviorNone);
//  }
//  if (name == "NSDateComponentsFormatterZeroFormattingBehaviorPad") {
//    return convertObjCObjectToJSIValue(runtime, NSDateComponentsFormatterZeroFormattingBehaviorPad);
//  }
//  // TODO: NSDateFormatter (Interface)
//  if (name == "NSDateFormatterBehavior") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"BehaviorDefault": NSDateFormatterBehaviorDefault,
//        @"Behavior10_4": NSDateFormatterBehavior10_4
//      }
//    );
//  }
//  if (name == "NSDateFormatterBehaviorDefault") {
//    return convertObjCObjectToJSIValue(runtime, NSDateFormatterBehaviorDefault);
//  }
//  if (name == "NSDateFormatterBehavior10_4") {
//    return convertObjCObjectToJSIValue(runtime, NSDateFormatterBehavior10_4);
//  }
//  if (name == "NSDateFormatterBehavior10_4") {
//    return convertObjCObjectToJSIValue(runtime, NSDateFormatterBehavior10_4);
//  }
//  if (name == "NSDateFormatterBehaviorDefault") {
//    return convertObjCObjectToJSIValue(runtime, NSDateFormatterBehaviorDefault);
//  }
//  if (name == "NSDateFormatterFullStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSDateFormatterFullStyle);
//  }
//  if (name == "NSDateFormatterLongStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSDateFormatterLongStyle);
//  }
//  if (name == "NSDateFormatterMediumStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSDateFormatterMediumStyle);
//  }
//  if (name == "NSDateFormatterNoStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSDateFormatterNoStyle);
//  }
//  if (name == "NSDateFormatterShortStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSDateFormatterShortStyle);
//  }
//  if (name == "NSDateFormatterStyle") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"NoStyle": NSDateFormatterNoStyle,
//        @"ShortStyle": NSDateFormatterShortStyle,
//        @"MediumStyle": NSDateFormatterMediumStyle,
//        @"LongStyle": NSDateFormatterLongStyle,
//        @"FullStyle": NSDateFormatterFullStyle
//      }
//    );
//  }
//  if (name == "NSDateFormatterNoStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSDateFormatterNoStyle);
//  }
//  if (name == "NSDateFormatterShortStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSDateFormatterShortStyle);
//  }
//  if (name == "NSDateFormatterMediumStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSDateFormatterMediumStyle);
//  }
//  if (name == "NSDateFormatterLongStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSDateFormatterLongStyle);
//  }
//  if (name == "NSDateFormatterFullStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSDateFormatterFullStyle);
//  }
//  // TODO: NSDateInterval (Interface)
//  // TODO: NSDateIntervalFormatter (Interface)
//  if (name == "NSDateIntervalFormatterFullStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSDateIntervalFormatterFullStyle);
//  }
//  if (name == "NSDateIntervalFormatterLongStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSDateIntervalFormatterLongStyle);
//  }
//  if (name == "NSDateIntervalFormatterMediumStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSDateIntervalFormatterMediumStyle);
//  }
//  if (name == "NSDateIntervalFormatterNoStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSDateIntervalFormatterNoStyle);
//  }
//  if (name == "NSDateIntervalFormatterShortStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSDateIntervalFormatterShortStyle);
//  }
//  if (name == "NSDateIntervalFormatterStyle") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"NoStyle": NSDateIntervalFormatterNoStyle,
//        @"ShortStyle": NSDateIntervalFormatterShortStyle,
//        @"MediumStyle": NSDateIntervalFormatterMediumStyle,
//        @"LongStyle": NSDateIntervalFormatterLongStyle,
//        @"FullStyle": NSDateIntervalFormatterFullStyle
//      }
//    );
//  }
//  if (name == "NSDateIntervalFormatterNoStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSDateIntervalFormatterNoStyle);
//  }
//  if (name == "NSDateIntervalFormatterShortStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSDateIntervalFormatterShortStyle);
//  }
//  if (name == "NSDateIntervalFormatterMediumStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSDateIntervalFormatterMediumStyle);
//  }
//  if (name == "NSDateIntervalFormatterLongStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSDateIntervalFormatterLongStyle);
//  }
//  if (name == "NSDateIntervalFormatterFullStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSDateIntervalFormatterFullStyle);
//  }
//  if (name == "NSDayCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSDayCalendarUnit);
//  }
//  if (name == "NSDeallocateMemoryPages") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSDeallocateMemoryPages(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSDeallocateMemoryPages"), 2, func);
//  }
//  if (name == "NSDeallocateObject") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSDeallocateObject(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSDeallocateObject"), 1, func);
//  }
//  if (name == "NSDebugDescriptionErrorKey") {
//    return convertObjCObjectToJSIValue(runtime, NSDebugDescriptionErrorKey);
//  }
//  // TODO: NSDecimal (Struct)
//  if (name == "NSDecimalAdd") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSDecimalAdd(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2]),
//        convertJSIValueToObjCObject(arguments[3])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSDecimalAdd"), 4, func);
//  }
//  if (name == "NSDecimalCompact") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSDecimalCompact(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSDecimalCompact"), 1, func);
//  }
//  if (name == "NSDecimalCompare") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSDecimalCompare(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSDecimalCompare"), 2, func);
//  }
//  if (name == "NSDecimalCopy") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSDecimalCopy(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSDecimalCopy"), 2, func);
//  }
//  if (name == "NSDecimalDivide") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSDecimalDivide(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2]),
//        convertJSIValueToObjCObject(arguments[3])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSDecimalDivide"), 4, func);
//  }
//  if (name == "NSDecimalMultiply") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSDecimalMultiply(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2]),
//        convertJSIValueToObjCObject(arguments[3])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSDecimalMultiply"), 4, func);
//  }
//  if (name == "NSDecimalMultiplyByPowerOf10") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSDecimalMultiplyByPowerOf10(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2]),
//        convertJSIValueToObjCObject(arguments[3])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSDecimalMultiplyByPowerOf10"), 4, func);
//  }
//  if (name == "NSDecimalNormalize") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSDecimalNormalize(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSDecimalNormalize"), 3, func);
//  }
//  // TODO: NSDecimalNumber (Interface)
//  // TODO: NSDecimalNumberBehaviors (Protocol)
//  if (name == "NSDecimalNumberDivideByZeroException") {
//    return convertObjCObjectToJSIValue(runtime, NSDecimalNumberDivideByZeroException);
//  }
//  if (name == "NSDecimalNumberExactnessException") {
//    return convertObjCObjectToJSIValue(runtime, NSDecimalNumberExactnessException);
//  }
//  // TODO: NSDecimalNumberHandler (Interface)
//  if (name == "NSDecimalNumberOverflowException") {
//    return convertObjCObjectToJSIValue(runtime, NSDecimalNumberOverflowException);
//  }
//  if (name == "NSDecimalNumberUnderflowException") {
//    return convertObjCObjectToJSIValue(runtime, NSDecimalNumberUnderflowException);
//  }
//  if (name == "NSDecimalPower") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSDecimalPower(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2]),
//        convertJSIValueToObjCObject(arguments[3])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSDecimalPower"), 4, func);
//  }
//  if (name == "NSDecimalRound") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSDecimalRound(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2]),
//        convertJSIValueToObjCObject(arguments[3])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSDecimalRound"), 4, func);
//  }
//  if (name == "NSDecimalString") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSDecimalString(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSDecimalString"), 2, func);
//  }
//  if (name == "NSDecimalSubtract") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSDecimalSubtract(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2]),
//        convertJSIValueToObjCObject(arguments[3])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSDecimalSubtract"), 4, func);
//  }
//  if (name == "NSDecodingFailurePolicy") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"RaiseException": NSDecodingFailurePolicyRaiseException,
//        @"SetErrorAndReturn": NSDecodingFailurePolicySetErrorAndReturn
//      }
//    );
//  }
//  if (name == "NSDecodingFailurePolicyRaiseException") {
//    return convertObjCObjectToJSIValue(runtime, NSDecodingFailurePolicyRaiseException);
//  }
//  if (name == "NSDecodingFailurePolicySetErrorAndReturn") {
//    return convertObjCObjectToJSIValue(runtime, NSDecodingFailurePolicySetErrorAndReturn);
//  }
//  if (name == "NSDecodingFailurePolicyRaiseException") {
//    return convertObjCObjectToJSIValue(runtime, NSDecodingFailurePolicyRaiseException);
//  }
//  if (name == "NSDecodingFailurePolicySetErrorAndReturn") {
//    return convertObjCObjectToJSIValue(runtime, NSDecodingFailurePolicySetErrorAndReturn);
//  }
//  if (name == "NSDecompressionFailedError") {
//    return convertObjCObjectToJSIValue(runtime, NSDecompressionFailedError);
//  }
//  if (name == "NSDecrementExtraRefCountWasZero") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSDecrementExtraRefCountWasZero(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSDecrementExtraRefCountWasZero"), 1, func);
//  }
//  if (name == "NSDefaultMallocZone") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSDefaultMallocZone();
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSDefaultMallocZone"), 0, func);
//  }
//  if (name == "NSDefaultRunLoopMode") {
//    return convertObjCObjectToJSIValue(runtime, NSDefaultRunLoopMode);
//  }
//  if (name == "NSDemoApplicationDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSDemoApplicationDirectory);
//  }
//  if (name == "NSDesktopDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSDesktopDirectory);
//  }
//  if (name == "NSDestinationInvalidException") {
//    return convertObjCObjectToJSIValue(runtime, NSDestinationInvalidException);
//  }
//  if (name == "NSDeveloperApplicationDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSDeveloperApplicationDirectory);
//  }
//  if (name == "NSDeveloperDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSDeveloperDirectory);
//  }
//  if (name == "NSDiacriticInsensitivePredicateOption") {
//    return convertObjCObjectToJSIValue(runtime, NSDiacriticInsensitivePredicateOption);
//  }
//  if (name == "NSDiacriticInsensitiveSearch") {
//    return convertObjCObjectToJSIValue(runtime, NSDiacriticInsensitiveSearch);
//  }
//  // TODO: NSDictionary (Interface)
//  if (name == "NSDidBecomeSingleThreadedNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSDidBecomeSingleThreadedNotification);
//  }
//  // TODO: NSDimension (Interface)
//  if (name == "NSDirectPredicateModifier") {
//    return convertObjCObjectToJSIValue(runtime, NSDirectPredicateModifier);
//  }
//  if (name == "NSDirectoryEnumerationIncludesDirectoriesPostOrder") {
//    return convertObjCObjectToJSIValue(runtime, NSDirectoryEnumerationIncludesDirectoriesPostOrder);
//  }
//  if (name == "NSDirectoryEnumerationOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"SkipsSubdirectoryDescendants": NSDirectoryEnumerationSkipsSubdirectoryDescendants,
//        @"SkipsPackageDescendants": NSDirectoryEnumerationSkipsPackageDescendants,
//        @"SkipsHiddenFiles": NSDirectoryEnumerationSkipsHiddenFiles,
//        @"IncludesDirectoriesPostOrder": NSDirectoryEnumerationIncludesDirectoriesPostOrder,
//        @"ProducesRelativePathURLs": NSDirectoryEnumerationProducesRelativePathURLs
//      }
//    );
//  }
//  if (name == "NSDirectoryEnumerationSkipsSubdirectoryDescendants") {
//    return convertObjCObjectToJSIValue(runtime, NSDirectoryEnumerationSkipsSubdirectoryDescendants);
//  }
//  if (name == "NSDirectoryEnumerationSkipsPackageDescendants") {
//    return convertObjCObjectToJSIValue(runtime, NSDirectoryEnumerationSkipsPackageDescendants);
//  }
//  if (name == "NSDirectoryEnumerationSkipsHiddenFiles") {
//    return convertObjCObjectToJSIValue(runtime, NSDirectoryEnumerationSkipsHiddenFiles);
//  }
//  if (name == "NSDirectoryEnumerationIncludesDirectoriesPostOrder") {
//    return convertObjCObjectToJSIValue(runtime, NSDirectoryEnumerationIncludesDirectoriesPostOrder);
//  }
//  if (name == "NSDirectoryEnumerationProducesRelativePathURLs") {
//    return convertObjCObjectToJSIValue(runtime, NSDirectoryEnumerationProducesRelativePathURLs);
//  }
//  if (name == "NSDirectoryEnumerationProducesRelativePathURLs") {
//    return convertObjCObjectToJSIValue(runtime, NSDirectoryEnumerationProducesRelativePathURLs);
//  }
//  if (name == "NSDirectoryEnumerationSkipsHiddenFiles") {
//    return convertObjCObjectToJSIValue(runtime, NSDirectoryEnumerationSkipsHiddenFiles);
//  }
//  if (name == "NSDirectoryEnumerationSkipsPackageDescendants") {
//    return convertObjCObjectToJSIValue(runtime, NSDirectoryEnumerationSkipsPackageDescendants);
//  }
//  if (name == "NSDirectoryEnumerationSkipsSubdirectoryDescendants") {
//    return convertObjCObjectToJSIValue(runtime, NSDirectoryEnumerationSkipsSubdirectoryDescendants);
//  }
//  // TODO: NSDirectoryEnumerator (Interface)
//  // TODO: NSDiscardableContent (Protocol)
//  if (name == "NSDistinctUnionOfArraysKeyValueOperator") {
//    return convertObjCObjectToJSIValue(runtime, NSDistinctUnionOfArraysKeyValueOperator);
//  }
//  if (name == "NSDistinctUnionOfObjectsKeyValueOperator") {
//    return convertObjCObjectToJSIValue(runtime, NSDistinctUnionOfObjectsKeyValueOperator);
//  }
//  if (name == "NSDistinctUnionOfSetsKeyValueOperator") {
//    return convertObjCObjectToJSIValue(runtime, NSDistinctUnionOfSetsKeyValueOperator);
//  }
//  if (name == "NSDocumentDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSDocumentDirectory);
//  }
//  if (name == "NSDocumentationDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSDocumentationDirectory);
//  }
//  if (name == "NSDownloadsDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSDownloadsDirectory);
//  }
//  if (name == "NSEndHashTableEnumeration") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSEndHashTableEnumeration(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSEndHashTableEnumeration"), 1, func);
//  }
//  if (name == "NSEndMapTableEnumeration") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSEndMapTableEnumeration(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSEndMapTableEnumeration"), 1, func);
//  }
//  if (name == "NSEndsWithPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSEndsWithPredicateOperatorType);
//  }
//  // TODO: NSEnergyFormatter (Interface)
//  if (name == "NSEnergyFormatterUnit") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Joule": NSEnergyFormatterUnitJoule,
//        @"Kilojoule": NSEnergyFormatterUnitKilojoule,
//        @"Calorie": NSEnergyFormatterUnitCalorie,
//        @"Kilocalorie": NSEnergyFormatterUnitKilocalorie
//      }
//    );
//  }
//  if (name == "NSEnergyFormatterUnitJoule") {
//    return convertObjCObjectToJSIValue(runtime, NSEnergyFormatterUnitJoule);
//  }
//  if (name == "NSEnergyFormatterUnitKilojoule") {
//    return convertObjCObjectToJSIValue(runtime, NSEnergyFormatterUnitKilojoule);
//  }
//  if (name == "NSEnergyFormatterUnitCalorie") {
//    return convertObjCObjectToJSIValue(runtime, NSEnergyFormatterUnitCalorie);
//  }
//  if (name == "NSEnergyFormatterUnitKilocalorie") {
//    return convertObjCObjectToJSIValue(runtime, NSEnergyFormatterUnitKilocalorie);
//  }
//  if (name == "NSEnergyFormatterUnitCalorie") {
//    return convertObjCObjectToJSIValue(runtime, NSEnergyFormatterUnitCalorie);
//  }
//  if (name == "NSEnergyFormatterUnitJoule") {
//    return convertObjCObjectToJSIValue(runtime, NSEnergyFormatterUnitJoule);
//  }
//  if (name == "NSEnergyFormatterUnitKilocalorie") {
//    return convertObjCObjectToJSIValue(runtime, NSEnergyFormatterUnitKilocalorie);
//  }
//  if (name == "NSEnergyFormatterUnitKilojoule") {
//    return convertObjCObjectToJSIValue(runtime, NSEnergyFormatterUnitKilojoule);
//  }
//  if (name == "NSEnumerateHashTable") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSEnumerateHashTable(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSEnumerateHashTable"), 1, func);
//  }
//  if (name == "NSEnumerateMapTable") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSEnumerateMapTable(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSEnumerateMapTable"), 1, func);
//  }
//  if (name == "NSEnumerationConcurrent") {
//    return convertObjCObjectToJSIValue(runtime, NSEnumerationConcurrent);
//  }
//  if (name == "NSEnumerationOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Concurrent": NSEnumerationConcurrent,
//        @"Reverse": NSEnumerationReverse
//      }
//    );
//  }
//  if (name == "NSEnumerationConcurrent") {
//    return convertObjCObjectToJSIValue(runtime, NSEnumerationConcurrent);
//  }
//  if (name == "NSEnumerationReverse") {
//    return convertObjCObjectToJSIValue(runtime, NSEnumerationReverse);
//  }
//  if (name == "NSEnumerationReverse") {
//    return convertObjCObjectToJSIValue(runtime, NSEnumerationReverse);
//  }
//  // TODO: NSEnumerator (Interface)
//  if (name == "NSEqualToPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSEqualToPredicateOperatorType);
//  }
//  if (name == "NSEraCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSEraCalendarUnit);
//  }
//  // TODO: NSError (Interface)
//  if (name == "NSErrorFailingURLStringKey") {
//    return convertObjCObjectToJSIValue(runtime, NSErrorFailingURLStringKey);
//  }
//  if (name == "NSEvaluatedObjectExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSEvaluatedObjectExpressionType);
//  }
//  // TODO: NSException (Interface)
//  if (name == "NSExecutableArchitectureMismatchError") {
//    return convertObjCObjectToJSIValue(runtime, NSExecutableArchitectureMismatchError);
//  }
//  if (name == "NSExecutableErrorMaximum") {
//    return convertObjCObjectToJSIValue(runtime, NSExecutableErrorMaximum);
//  }
//  if (name == "NSExecutableErrorMinimum") {
//    return convertObjCObjectToJSIValue(runtime, NSExecutableErrorMinimum);
//  }
//  if (name == "NSExecutableLinkError") {
//    return convertObjCObjectToJSIValue(runtime, NSExecutableLinkError);
//  }
//  if (name == "NSExecutableLoadError") {
//    return convertObjCObjectToJSIValue(runtime, NSExecutableLoadError);
//  }
//  if (name == "NSExecutableNotLoadableError") {
//    return convertObjCObjectToJSIValue(runtime, NSExecutableNotLoadableError);
//  }
//  if (name == "NSExecutableRuntimeMismatchError") {
//    return convertObjCObjectToJSIValue(runtime, NSExecutableRuntimeMismatchError);
//  }
//  // TODO: NSExpression (Interface)
//  if (name == "NSExpressionType") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"ConstantValueExpressionType": NSConstantValueExpressionType,
//        @"EvaluatedObjectExpressionType": NSEvaluatedObjectExpressionType,
//        @"VariableExpressionType": NSVariableExpressionType,
//        @"KeyPathExpressionType": NSKeyPathExpressionType,
//        @"FunctionExpressionType": NSFunctionExpressionType,
//        @"UnionSetExpressionType": NSUnionSetExpressionType,
//        @"IntersectSetExpressionType": NSIntersectSetExpressionType,
//        @"MinusSetExpressionType": NSMinusSetExpressionType,
//        @"SubqueryExpressionType": NSSubqueryExpressionType,
//        @"AggregateExpressionType": NSAggregateExpressionType,
//        @"AnyKeyExpressionType": NSAnyKeyExpressionType,
//        @"BlockExpressionType": NSBlockExpressionType,
//        @"ConditionalExpressionType": NSConditionalExpressionType
//      }
//    );
//  }
//  if (name == "NSConstantValueExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSConstantValueExpressionType);
//  }
//  if (name == "NSEvaluatedObjectExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSEvaluatedObjectExpressionType);
//  }
//  if (name == "NSVariableExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSVariableExpressionType);
//  }
//  if (name == "NSKeyPathExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyPathExpressionType);
//  }
//  if (name == "NSFunctionExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSFunctionExpressionType);
//  }
//  if (name == "NSUnionSetExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSUnionSetExpressionType);
//  }
//  if (name == "NSIntersectSetExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSIntersectSetExpressionType);
//  }
//  if (name == "NSMinusSetExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSMinusSetExpressionType);
//  }
//  if (name == "NSSubqueryExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSSubqueryExpressionType);
//  }
//  if (name == "NSAggregateExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSAggregateExpressionType);
//  }
//  if (name == "NSAnyKeyExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSAnyKeyExpressionType);
//  }
//  if (name == "NSBlockExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSBlockExpressionType);
//  }
//  if (name == "NSConditionalExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSConditionalExpressionType);
//  }
//  // TODO: NSExtensionContext (Interface)
//  if (name == "NSExtensionHostDidBecomeActiveNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSExtensionHostDidBecomeActiveNotification);
//  }
//  if (name == "NSExtensionHostDidEnterBackgroundNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSExtensionHostDidEnterBackgroundNotification);
//  }
//  if (name == "NSExtensionHostWillEnterForegroundNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSExtensionHostWillEnterForegroundNotification);
//  }
//  if (name == "NSExtensionHostWillResignActiveNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSExtensionHostWillResignActiveNotification);
//  }
//  // TODO: NSExtensionItem (Interface)
//  if (name == "NSExtensionItemAttachmentsKey") {
//    return convertObjCObjectToJSIValue(runtime, NSExtensionItemAttachmentsKey);
//  }
//  if (name == "NSExtensionItemAttributedContentTextKey") {
//    return convertObjCObjectToJSIValue(runtime, NSExtensionItemAttributedContentTextKey);
//  }
//  if (name == "NSExtensionItemAttributedTitleKey") {
//    return convertObjCObjectToJSIValue(runtime, NSExtensionItemAttributedTitleKey);
//  }
//  if (name == "NSExtensionItemsAndErrorsKey") {
//    return convertObjCObjectToJSIValue(runtime, NSExtensionItemsAndErrorsKey);
//  }
//  if (name == "NSExtensionJavaScriptFinalizeArgumentKey") {
//    return convertObjCObjectToJSIValue(runtime, NSExtensionJavaScriptFinalizeArgumentKey);
//  }
//  if (name == "NSExtensionJavaScriptPreprocessingResultsKey") {
//    return convertObjCObjectToJSIValue(runtime, NSExtensionJavaScriptPreprocessingResultsKey);
//  }
//  // TODO: NSExtensionRequestHandling (Protocol)
//  if (name == "NSExtraRefCount") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSExtraRefCount(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSExtraRefCount"), 1, func);
//  }
//  // TODO: NSFastEnumeration (Protocol)
//  // TODO: NSFastEnumerationState (Struct)
//  if (name == "NSFeatureUnsupportedError") {
//    return convertObjCObjectToJSIValue(runtime, NSFeatureUnsupportedError);
//  }
//  // TODO: NSFileAccessIntent (Interface)
//  if (name == "NSFileAppendOnly") {
//    return convertObjCObjectToJSIValue(runtime, NSFileAppendOnly);
//  }
//  if (name == "NSFileBusy") {
//    return convertObjCObjectToJSIValue(runtime, NSFileBusy);
//  }
//  // TODO: NSFileCoordinator (Interface)
//  if (name == "NSFileCoordinatorReadingForUploading") {
//    return convertObjCObjectToJSIValue(runtime, NSFileCoordinatorReadingForUploading);
//  }
//  if (name == "NSFileCoordinatorReadingImmediatelyAvailableMetadataOnly") {
//    return convertObjCObjectToJSIValue(runtime, NSFileCoordinatorReadingImmediatelyAvailableMetadataOnly);
//  }
//  if (name == "NSFileCoordinatorReadingOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"WithoutChanges": NSFileCoordinatorReadingWithoutChanges,
//        @"ResolvesSymbolicLink": NSFileCoordinatorReadingResolvesSymbolicLink,
//        @"ImmediatelyAvailableMetadataOnly": NSFileCoordinatorReadingImmediatelyAvailableMetadataOnly,
//        @"ForUploading": NSFileCoordinatorReadingForUploading
//      }
//    );
//  }
//  if (name == "NSFileCoordinatorReadingWithoutChanges") {
//    return convertObjCObjectToJSIValue(runtime, NSFileCoordinatorReadingWithoutChanges);
//  }
//  if (name == "NSFileCoordinatorReadingResolvesSymbolicLink") {
//    return convertObjCObjectToJSIValue(runtime, NSFileCoordinatorReadingResolvesSymbolicLink);
//  }
//  if (name == "NSFileCoordinatorReadingImmediatelyAvailableMetadataOnly") {
//    return convertObjCObjectToJSIValue(runtime, NSFileCoordinatorReadingImmediatelyAvailableMetadataOnly);
//  }
//  if (name == "NSFileCoordinatorReadingForUploading") {
//    return convertObjCObjectToJSIValue(runtime, NSFileCoordinatorReadingForUploading);
//  }
//  if (name == "NSFileCoordinatorReadingResolvesSymbolicLink") {
//    return convertObjCObjectToJSIValue(runtime, NSFileCoordinatorReadingResolvesSymbolicLink);
//  }
//  if (name == "NSFileCoordinatorReadingWithoutChanges") {
//    return convertObjCObjectToJSIValue(runtime, NSFileCoordinatorReadingWithoutChanges);
//  }
//  if (name == "NSFileCoordinatorWritingContentIndependentMetadataOnly") {
//    return convertObjCObjectToJSIValue(runtime, NSFileCoordinatorWritingContentIndependentMetadataOnly);
//  }
//  if (name == "NSFileCoordinatorWritingForDeleting") {
//    return convertObjCObjectToJSIValue(runtime, NSFileCoordinatorWritingForDeleting);
//  }
//  if (name == "NSFileCoordinatorWritingForMerging") {
//    return convertObjCObjectToJSIValue(runtime, NSFileCoordinatorWritingForMerging);
//  }
//  if (name == "NSFileCoordinatorWritingForMoving") {
//    return convertObjCObjectToJSIValue(runtime, NSFileCoordinatorWritingForMoving);
//  }
//  if (name == "NSFileCoordinatorWritingForReplacing") {
//    return convertObjCObjectToJSIValue(runtime, NSFileCoordinatorWritingForReplacing);
//  }
//  if (name == "NSFileCoordinatorWritingOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"ForDeleting": NSFileCoordinatorWritingForDeleting,
//        @"ForMoving": NSFileCoordinatorWritingForMoving,
//        @"ForMerging": NSFileCoordinatorWritingForMerging,
//        @"ForReplacing": NSFileCoordinatorWritingForReplacing,
//        @"ContentIndependentMetadataOnly": NSFileCoordinatorWritingContentIndependentMetadataOnly
//      }
//    );
//  }
//  if (name == "NSFileCoordinatorWritingForDeleting") {
//    return convertObjCObjectToJSIValue(runtime, NSFileCoordinatorWritingForDeleting);
//  }
//  if (name == "NSFileCoordinatorWritingForMoving") {
//    return convertObjCObjectToJSIValue(runtime, NSFileCoordinatorWritingForMoving);
//  }
//  if (name == "NSFileCoordinatorWritingForMerging") {
//    return convertObjCObjectToJSIValue(runtime, NSFileCoordinatorWritingForMerging);
//  }
//  if (name == "NSFileCoordinatorWritingForReplacing") {
//    return convertObjCObjectToJSIValue(runtime, NSFileCoordinatorWritingForReplacing);
//  }
//  if (name == "NSFileCoordinatorWritingContentIndependentMetadataOnly") {
//    return convertObjCObjectToJSIValue(runtime, NSFileCoordinatorWritingContentIndependentMetadataOnly);
//  }
//  if (name == "NSFileCreationDate") {
//    return convertObjCObjectToJSIValue(runtime, NSFileCreationDate);
//  }
//  if (name == "NSFileDeviceIdentifier") {
//    return convertObjCObjectToJSIValue(runtime, NSFileDeviceIdentifier);
//  }
//  if (name == "NSFileErrorMaximum") {
//    return convertObjCObjectToJSIValue(runtime, NSFileErrorMaximum);
//  }
//  if (name == "NSFileErrorMinimum") {
//    return convertObjCObjectToJSIValue(runtime, NSFileErrorMinimum);
//  }
//  if (name == "NSFileExtensionHidden") {
//    return convertObjCObjectToJSIValue(runtime, NSFileExtensionHidden);
//  }
//  if (name == "NSFileGroupOwnerAccountID") {
//    return convertObjCObjectToJSIValue(runtime, NSFileGroupOwnerAccountID);
//  }
//  if (name == "NSFileGroupOwnerAccountName") {
//    return convertObjCObjectToJSIValue(runtime, NSFileGroupOwnerAccountName);
//  }
//  if (name == "NSFileHFSCreatorCode") {
//    return convertObjCObjectToJSIValue(runtime, NSFileHFSCreatorCode);
//  }
//  if (name == "NSFileHFSTypeCode") {
//    return convertObjCObjectToJSIValue(runtime, NSFileHFSTypeCode);
//  }
//  // TODO: NSFileHandle (Interface)
//  if (name == "NSFileHandleConnectionAcceptedNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSFileHandleConnectionAcceptedNotification);
//  }
//  if (name == "NSFileHandleDataAvailableNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSFileHandleDataAvailableNotification);
//  }
//  if (name == "NSFileHandleNotificationDataItem") {
//    return convertObjCObjectToJSIValue(runtime, NSFileHandleNotificationDataItem);
//  }
//  if (name == "NSFileHandleNotificationFileHandleItem") {
//    return convertObjCObjectToJSIValue(runtime, NSFileHandleNotificationFileHandleItem);
//  }
//  if (name == "NSFileHandleNotificationMonitorModes") {
//    return convertObjCObjectToJSIValue(runtime, NSFileHandleNotificationMonitorModes);
//  }
//  if (name == "NSFileHandleOperationException") {
//    return convertObjCObjectToJSIValue(runtime, NSFileHandleOperationException);
//  }
//  if (name == "NSFileHandleReadCompletionNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSFileHandleReadCompletionNotification);
//  }
//  if (name == "NSFileHandleReadToEndOfFileCompletionNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSFileHandleReadToEndOfFileCompletionNotification);
//  }
//  if (name == "NSFileImmutable") {
//    return convertObjCObjectToJSIValue(runtime, NSFileImmutable);
//  }
//  if (name == "NSFileLockingError") {
//    return convertObjCObjectToJSIValue(runtime, NSFileLockingError);
//  }
//  // TODO: NSFileManager (Interface)
//  // TODO: NSFileManagerDelegate (Protocol)
//  if (name == "NSFileManagerItemReplacementOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"UsingNewMetadataOnly": NSFileManagerItemReplacementUsingNewMetadataOnly,
//        @"WithoutDeletingBackupItem": NSFileManagerItemReplacementWithoutDeletingBackupItem
//      }
//    );
//  }
//  if (name == "NSFileManagerItemReplacementUsingNewMetadataOnly") {
//    return convertObjCObjectToJSIValue(runtime, NSFileManagerItemReplacementUsingNewMetadataOnly);
//  }
//  if (name == "NSFileManagerItemReplacementWithoutDeletingBackupItem") {
//    return convertObjCObjectToJSIValue(runtime, NSFileManagerItemReplacementWithoutDeletingBackupItem);
//  }
//  if (name == "NSFileManagerItemReplacementUsingNewMetadataOnly") {
//    return convertObjCObjectToJSIValue(runtime, NSFileManagerItemReplacementUsingNewMetadataOnly);
//  }
//  if (name == "NSFileManagerItemReplacementWithoutDeletingBackupItem") {
//    return convertObjCObjectToJSIValue(runtime, NSFileManagerItemReplacementWithoutDeletingBackupItem);
//  }
//  if (name == "NSFileManagerUnmountAllPartitionsAndEjectDisk") {
//    return convertObjCObjectToJSIValue(runtime, NSFileManagerUnmountAllPartitionsAndEjectDisk);
//  }
//  if (name == "NSFileManagerUnmountWithoutUI") {
//    return convertObjCObjectToJSIValue(runtime, NSFileManagerUnmountWithoutUI);
//  }
//  if (name == "NSFileModificationDate") {
//    return convertObjCObjectToJSIValue(runtime, NSFileModificationDate);
//  }
//  if (name == "NSFileNoSuchFileError") {
//    return convertObjCObjectToJSIValue(runtime, NSFileNoSuchFileError);
//  }
//  if (name == "NSFileOwnerAccountID") {
//    return convertObjCObjectToJSIValue(runtime, NSFileOwnerAccountID);
//  }
//  if (name == "NSFileOwnerAccountName") {
//    return convertObjCObjectToJSIValue(runtime, NSFileOwnerAccountName);
//  }
//  if (name == "NSFilePathErrorKey") {
//    return convertObjCObjectToJSIValue(runtime, NSFilePathErrorKey);
//  }
//  if (name == "NSFilePosixPermissions") {
//    return convertObjCObjectToJSIValue(runtime, NSFilePosixPermissions);
//  }
//  // TODO: NSFilePresenter (Protocol)
//  if (name == "NSFileProtectionComplete") {
//    return convertObjCObjectToJSIValue(runtime, NSFileProtectionComplete);
//  }
//  if (name == "NSFileProtectionCompleteUnlessOpen") {
//    return convertObjCObjectToJSIValue(runtime, NSFileProtectionCompleteUnlessOpen);
//  }
//  if (name == "NSFileProtectionCompleteUntilFirstUserAuthentication") {
//    return convertObjCObjectToJSIValue(runtime, NSFileProtectionCompleteUntilFirstUserAuthentication);
//  }
//  if (name == "NSFileProtectionKey") {
//    return convertObjCObjectToJSIValue(runtime, NSFileProtectionKey);
//  }
//  if (name == "NSFileProtectionNone") {
//    return convertObjCObjectToJSIValue(runtime, NSFileProtectionNone);
//  }
//  // TODO: NSFileProviderService (Interface)
//  if (name == "NSFileReadCorruptFileError") {
//    return convertObjCObjectToJSIValue(runtime, NSFileReadCorruptFileError);
//  }
//  if (name == "NSFileReadInapplicableStringEncodingError") {
//    return convertObjCObjectToJSIValue(runtime, NSFileReadInapplicableStringEncodingError);
//  }
//  if (name == "NSFileReadInvalidFileNameError") {
//    return convertObjCObjectToJSIValue(runtime, NSFileReadInvalidFileNameError);
//  }
//  if (name == "NSFileReadNoPermissionError") {
//    return convertObjCObjectToJSIValue(runtime, NSFileReadNoPermissionError);
//  }
//  if (name == "NSFileReadNoSuchFileError") {
//    return convertObjCObjectToJSIValue(runtime, NSFileReadNoSuchFileError);
//  }
//  if (name == "NSFileReadTooLargeError") {
//    return convertObjCObjectToJSIValue(runtime, NSFileReadTooLargeError);
//  }
//  if (name == "NSFileReadUnknownError") {
//    return convertObjCObjectToJSIValue(runtime, NSFileReadUnknownError);
//  }
//  if (name == "NSFileReadUnknownStringEncodingError") {
//    return convertObjCObjectToJSIValue(runtime, NSFileReadUnknownStringEncodingError);
//  }
//  if (name == "NSFileReadUnsupportedSchemeError") {
//    return convertObjCObjectToJSIValue(runtime, NSFileReadUnsupportedSchemeError);
//  }
//  if (name == "NSFileReferenceCount") {
//    return convertObjCObjectToJSIValue(runtime, NSFileReferenceCount);
//  }
//  // TODO: NSFileSecurity (Interface)
//  if (name == "NSFileSize") {
//    return convertObjCObjectToJSIValue(runtime, NSFileSize);
//  }
//  if (name == "NSFileSystemFileNumber") {
//    return convertObjCObjectToJSIValue(runtime, NSFileSystemFileNumber);
//  }
//  if (name == "NSFileSystemFreeNodes") {
//    return convertObjCObjectToJSIValue(runtime, NSFileSystemFreeNodes);
//  }
//  if (name == "NSFileSystemFreeSize") {
//    return convertObjCObjectToJSIValue(runtime, NSFileSystemFreeSize);
//  }
//  if (name == "NSFileSystemNodes") {
//    return convertObjCObjectToJSIValue(runtime, NSFileSystemNodes);
//  }
//  if (name == "NSFileSystemNumber") {
//    return convertObjCObjectToJSIValue(runtime, NSFileSystemNumber);
//  }
//  if (name == "NSFileSystemSize") {
//    return convertObjCObjectToJSIValue(runtime, NSFileSystemSize);
//  }
//  if (name == "NSFileType") {
//    return convertObjCObjectToJSIValue(runtime, NSFileType);
//  }
//  if (name == "NSFileTypeBlockSpecial") {
//    return convertObjCObjectToJSIValue(runtime, NSFileTypeBlockSpecial);
//  }
//  if (name == "NSFileTypeCharacterSpecial") {
//    return convertObjCObjectToJSIValue(runtime, NSFileTypeCharacterSpecial);
//  }
//  if (name == "NSFileTypeDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSFileTypeDirectory);
//  }
//  if (name == "NSFileTypeRegular") {
//    return convertObjCObjectToJSIValue(runtime, NSFileTypeRegular);
//  }
//  if (name == "NSFileTypeSocket") {
//    return convertObjCObjectToJSIValue(runtime, NSFileTypeSocket);
//  }
//  if (name == "NSFileTypeSymbolicLink") {
//    return convertObjCObjectToJSIValue(runtime, NSFileTypeSymbolicLink);
//  }
//  if (name == "NSFileTypeUnknown") {
//    return convertObjCObjectToJSIValue(runtime, NSFileTypeUnknown);
//  }
//  // TODO: NSFileVersion (Interface)
//  if (name == "NSFileVersionAddingByMoving") {
//    return convertObjCObjectToJSIValue(runtime, NSFileVersionAddingByMoving);
//  }
//  if (name == "NSFileVersionAddingOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"ByMoving": NSFileVersionAddingByMoving
//      }
//    );
//  }
//  if (name == "NSFileVersionAddingByMoving") {
//    return convertObjCObjectToJSIValue(runtime, NSFileVersionAddingByMoving);
//  }
//  if (name == "NSFileVersionReplacingByMoving") {
//    return convertObjCObjectToJSIValue(runtime, NSFileVersionReplacingByMoving);
//  }
//  if (name == "NSFileVersionReplacingOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"ByMoving": NSFileVersionReplacingByMoving
//      }
//    );
//  }
//  if (name == "NSFileVersionReplacingByMoving") {
//    return convertObjCObjectToJSIValue(runtime, NSFileVersionReplacingByMoving);
//  }
//  // TODO: NSFileWrapper (Interface)
//  if (name == "NSFileWrapperReadingImmediate") {
//    return convertObjCObjectToJSIValue(runtime, NSFileWrapperReadingImmediate);
//  }
//  if (name == "NSFileWrapperReadingOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Immediate": NSFileWrapperReadingImmediate,
//        @"WithoutMapping": NSFileWrapperReadingWithoutMapping
//      }
//    );
//  }
//  if (name == "NSFileWrapperReadingImmediate") {
//    return convertObjCObjectToJSIValue(runtime, NSFileWrapperReadingImmediate);
//  }
//  if (name == "NSFileWrapperReadingWithoutMapping") {
//    return convertObjCObjectToJSIValue(runtime, NSFileWrapperReadingWithoutMapping);
//  }
//  if (name == "NSFileWrapperReadingWithoutMapping") {
//    return convertObjCObjectToJSIValue(runtime, NSFileWrapperReadingWithoutMapping);
//  }
//  if (name == "NSFileWrapperWritingAtomic") {
//    return convertObjCObjectToJSIValue(runtime, NSFileWrapperWritingAtomic);
//  }
//  if (name == "NSFileWrapperWritingOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Atomic": NSFileWrapperWritingAtomic,
//        @"WithNameUpdating": NSFileWrapperWritingWithNameUpdating
//      }
//    );
//  }
//  if (name == "NSFileWrapperWritingAtomic") {
//    return convertObjCObjectToJSIValue(runtime, NSFileWrapperWritingAtomic);
//  }
//  if (name == "NSFileWrapperWritingWithNameUpdating") {
//    return convertObjCObjectToJSIValue(runtime, NSFileWrapperWritingWithNameUpdating);
//  }
//  if (name == "NSFileWrapperWritingWithNameUpdating") {
//    return convertObjCObjectToJSIValue(runtime, NSFileWrapperWritingWithNameUpdating);
//  }
//  if (name == "NSFileWriteFileExistsError") {
//    return convertObjCObjectToJSIValue(runtime, NSFileWriteFileExistsError);
//  }
//  if (name == "NSFileWriteInapplicableStringEncodingError") {
//    return convertObjCObjectToJSIValue(runtime, NSFileWriteInapplicableStringEncodingError);
//  }
//  if (name == "NSFileWriteInvalidFileNameError") {
//    return convertObjCObjectToJSIValue(runtime, NSFileWriteInvalidFileNameError);
//  }
//  if (name == "NSFileWriteNoPermissionError") {
//    return convertObjCObjectToJSIValue(runtime, NSFileWriteNoPermissionError);
//  }
//  if (name == "NSFileWriteOutOfSpaceError") {
//    return convertObjCObjectToJSIValue(runtime, NSFileWriteOutOfSpaceError);
//  }
//  if (name == "NSFileWriteUnknownError") {
//    return convertObjCObjectToJSIValue(runtime, NSFileWriteUnknownError);
//  }
//  if (name == "NSFileWriteUnsupportedSchemeError") {
//    return convertObjCObjectToJSIValue(runtime, NSFileWriteUnsupportedSchemeError);
//  }
//  if (name == "NSFileWriteVolumeReadOnlyError") {
//    return convertObjCObjectToJSIValue(runtime, NSFileWriteVolumeReadOnlyError);
//  }
//  if (name == "NSForcedOrderingSearch") {
//    return convertObjCObjectToJSIValue(runtime, NSForcedOrderingSearch);
//  }
//  // TODO: NSFormatter (Interface)
//  if (name == "NSFormattingContext") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Unknown": NSFormattingContextUnknown,
//        @"Dynamic": NSFormattingContextDynamic,
//        @"Standalone": NSFormattingContextStandalone,
//        @"ListItem": NSFormattingContextListItem,
//        @"BeginningOfSentence": NSFormattingContextBeginningOfSentence,
//        @"MiddleOfSentence": NSFormattingContextMiddleOfSentence
//      }
//    );
//  }
//  if (name == "NSFormattingContextUnknown") {
//    return convertObjCObjectToJSIValue(runtime, NSFormattingContextUnknown);
//  }
//  if (name == "NSFormattingContextDynamic") {
//    return convertObjCObjectToJSIValue(runtime, NSFormattingContextDynamic);
//  }
//  if (name == "NSFormattingContextStandalone") {
//    return convertObjCObjectToJSIValue(runtime, NSFormattingContextStandalone);
//  }
//  if (name == "NSFormattingContextListItem") {
//    return convertObjCObjectToJSIValue(runtime, NSFormattingContextListItem);
//  }
//  if (name == "NSFormattingContextBeginningOfSentence") {
//    return convertObjCObjectToJSIValue(runtime, NSFormattingContextBeginningOfSentence);
//  }
//  if (name == "NSFormattingContextMiddleOfSentence") {
//    return convertObjCObjectToJSIValue(runtime, NSFormattingContextMiddleOfSentence);
//  }
//  if (name == "NSFormattingContextBeginningOfSentence") {
//    return convertObjCObjectToJSIValue(runtime, NSFormattingContextBeginningOfSentence);
//  }
//  if (name == "NSFormattingContextDynamic") {
//    return convertObjCObjectToJSIValue(runtime, NSFormattingContextDynamic);
//  }
//  if (name == "NSFormattingContextListItem") {
//    return convertObjCObjectToJSIValue(runtime, NSFormattingContextListItem);
//  }
//  if (name == "NSFormattingContextMiddleOfSentence") {
//    return convertObjCObjectToJSIValue(runtime, NSFormattingContextMiddleOfSentence);
//  }
//  if (name == "NSFormattingContextStandalone") {
//    return convertObjCObjectToJSIValue(runtime, NSFormattingContextStandalone);
//  }
//  if (name == "NSFormattingContextUnknown") {
//    return convertObjCObjectToJSIValue(runtime, NSFormattingContextUnknown);
//  }
//  if (name == "NSFormattingError") {
//    return convertObjCObjectToJSIValue(runtime, NSFormattingError);
//  }
//  if (name == "NSFormattingErrorMaximum") {
//    return convertObjCObjectToJSIValue(runtime, NSFormattingErrorMaximum);
//  }
//  if (name == "NSFormattingErrorMinimum") {
//    return convertObjCObjectToJSIValue(runtime, NSFormattingErrorMinimum);
//  }
//  if (name == "NSFormattingUnitStyle") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Short": NSFormattingUnitStyleShort,
//        @"Medium": NSFormattingUnitStyleMedium,
//        @"Long": NSFormattingUnitStyleLong
//      }
//    );
//  }
//  if (name == "NSFormattingUnitStyleShort") {
//    return convertObjCObjectToJSIValue(runtime, NSFormattingUnitStyleShort);
//  }
//  if (name == "NSFormattingUnitStyleMedium") {
//    return convertObjCObjectToJSIValue(runtime, NSFormattingUnitStyleMedium);
//  }
//  if (name == "NSFormattingUnitStyleLong") {
//    return convertObjCObjectToJSIValue(runtime, NSFormattingUnitStyleLong);
//  }
//  if (name == "NSFormattingUnitStyleLong") {
//    return convertObjCObjectToJSIValue(runtime, NSFormattingUnitStyleLong);
//  }
//  if (name == "NSFormattingUnitStyleMedium") {
//    return convertObjCObjectToJSIValue(runtime, NSFormattingUnitStyleMedium);
//  }
//  if (name == "NSFormattingUnitStyleShort") {
//    return convertObjCObjectToJSIValue(runtime, NSFormattingUnitStyleShort);
//  }
//  if (name == "NSFoundationVersionNumber") {
//    return convertObjCObjectToJSIValue(runtime, NSFoundationVersionNumber);
//  }
//  if (name == "NSFreeHashTable") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSFreeHashTable(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSFreeHashTable"), 1, func);
//  }
//  if (name == "NSFreeMapTable") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSFreeMapTable(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSFreeMapTable"), 1, func);
//  }
//  if (name == "NSFullUserName") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSFullUserName();
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSFullUserName"), 0, func);
//  }
//  if (name == "NSFunctionExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSFunctionExpressionType);
//  }
//  if (name == "NSGenericException") {
//    return convertObjCObjectToJSIValue(runtime, NSGenericException);
//  }
//  if (name == "NSGetSizeAndAlignment") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSGetSizeAndAlignment(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSGetSizeAndAlignment"), 3, func);
//  }
//  if (name == "NSGetUncaughtExceptionHandler") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSGetUncaughtExceptionHandler();
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSGetUncaughtExceptionHandler"), 0, func);
//  }
//  if (name == "NSGlobalDomain") {
//    return convertObjCObjectToJSIValue(runtime, NSGlobalDomain);
//  }
//  if (name == "NSGrammaticalGender") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"NotSet": NSGrammaticalGenderNotSet,
//        @"Feminine": NSGrammaticalGenderFeminine,
//        @"Masculine": NSGrammaticalGenderMasculine,
//        @"Neuter": NSGrammaticalGenderNeuter
//      }
//    );
//  }
//  if (name == "NSGrammaticalGenderNotSet") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalGenderNotSet);
//  }
//  if (name == "NSGrammaticalGenderFeminine") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalGenderFeminine);
//  }
//  if (name == "NSGrammaticalGenderMasculine") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalGenderMasculine);
//  }
//  if (name == "NSGrammaticalGenderNeuter") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalGenderNeuter);
//  }
//  if (name == "NSGrammaticalGenderFeminine") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalGenderFeminine);
//  }
//  if (name == "NSGrammaticalGenderMasculine") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalGenderMasculine);
//  }
//  if (name == "NSGrammaticalGenderNeuter") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalGenderNeuter);
//  }
//  if (name == "NSGrammaticalGenderNotSet") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalGenderNotSet);
//  }
//  if (name == "NSGrammaticalNumber") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"NotSet": NSGrammaticalNumberNotSet,
//        @"Singular": NSGrammaticalNumberSingular,
//        @"Zero": NSGrammaticalNumberZero,
//        @"Plural": NSGrammaticalNumberPlural,
//        @"PluralTwo": NSGrammaticalNumberPluralTwo,
//        @"PluralFew": NSGrammaticalNumberPluralFew,
//        @"PluralMany": NSGrammaticalNumberPluralMany
//      }
//    );
//  }
//  if (name == "NSGrammaticalNumberNotSet") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalNumberNotSet);
//  }
//  if (name == "NSGrammaticalNumberSingular") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalNumberSingular);
//  }
//  if (name == "NSGrammaticalNumberZero") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalNumberZero);
//  }
//  if (name == "NSGrammaticalNumberPlural") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalNumberPlural);
//  }
//  if (name == "NSGrammaticalNumberPluralTwo") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalNumberPluralTwo);
//  }
//  if (name == "NSGrammaticalNumberPluralFew") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalNumberPluralFew);
//  }
//  if (name == "NSGrammaticalNumberPluralMany") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalNumberPluralMany);
//  }
//  if (name == "NSGrammaticalNumberNotSet") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalNumberNotSet);
//  }
//  if (name == "NSGrammaticalNumberPlural") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalNumberPlural);
//  }
//  if (name == "NSGrammaticalNumberPluralFew") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalNumberPluralFew);
//  }
//  if (name == "NSGrammaticalNumberPluralMany") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalNumberPluralMany);
//  }
//  if (name == "NSGrammaticalNumberPluralTwo") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalNumberPluralTwo);
//  }
//  if (name == "NSGrammaticalNumberSingular") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalNumberSingular);
//  }
//  if (name == "NSGrammaticalNumberZero") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalNumberZero);
//  }
//  if (name == "NSGrammaticalPartOfSpeech") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"NotSet": NSGrammaticalPartOfSpeechNotSet,
//        @"Determiner": NSGrammaticalPartOfSpeechDeterminer,
//        @"Pronoun": NSGrammaticalPartOfSpeechPronoun,
//        @"Letter": NSGrammaticalPartOfSpeechLetter,
//        @"Adverb": NSGrammaticalPartOfSpeechAdverb,
//        @"Particle": NSGrammaticalPartOfSpeechParticle,
//        @"Adjective": NSGrammaticalPartOfSpeechAdjective,
//        @"Adposition": NSGrammaticalPartOfSpeechAdposition,
//        @"Verb": NSGrammaticalPartOfSpeechVerb,
//        @"Noun": NSGrammaticalPartOfSpeechNoun,
//        @"Conjunction": NSGrammaticalPartOfSpeechConjunction,
//        @"Numeral": NSGrammaticalPartOfSpeechNumeral,
//        @"Interjection": NSGrammaticalPartOfSpeechInterjection,
//        @"Preposition": NSGrammaticalPartOfSpeechPreposition,
//        @"Abbreviation": NSGrammaticalPartOfSpeechAbbreviation
//      }
//    );
//  }
//  if (name == "NSGrammaticalPartOfSpeechNotSet") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechNotSet);
//  }
//  if (name == "NSGrammaticalPartOfSpeechDeterminer") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechDeterminer);
//  }
//  if (name == "NSGrammaticalPartOfSpeechPronoun") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechPronoun);
//  }
//  if (name == "NSGrammaticalPartOfSpeechLetter") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechLetter);
//  }
//  if (name == "NSGrammaticalPartOfSpeechAdverb") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechAdverb);
//  }
//  if (name == "NSGrammaticalPartOfSpeechParticle") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechParticle);
//  }
//  if (name == "NSGrammaticalPartOfSpeechAdjective") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechAdjective);
//  }
//  if (name == "NSGrammaticalPartOfSpeechAdposition") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechAdposition);
//  }
//  if (name == "NSGrammaticalPartOfSpeechVerb") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechVerb);
//  }
//  if (name == "NSGrammaticalPartOfSpeechNoun") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechNoun);
//  }
//  if (name == "NSGrammaticalPartOfSpeechConjunction") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechConjunction);
//  }
//  if (name == "NSGrammaticalPartOfSpeechNumeral") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechNumeral);
//  }
//  if (name == "NSGrammaticalPartOfSpeechInterjection") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechInterjection);
//  }
//  if (name == "NSGrammaticalPartOfSpeechPreposition") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechPreposition);
//  }
//  if (name == "NSGrammaticalPartOfSpeechAbbreviation") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechAbbreviation);
//  }
//  if (name == "NSGrammaticalPartOfSpeechAbbreviation") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechAbbreviation);
//  }
//  if (name == "NSGrammaticalPartOfSpeechAdjective") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechAdjective);
//  }
//  if (name == "NSGrammaticalPartOfSpeechAdposition") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechAdposition);
//  }
//  if (name == "NSGrammaticalPartOfSpeechAdverb") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechAdverb);
//  }
//  if (name == "NSGrammaticalPartOfSpeechConjunction") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechConjunction);
//  }
//  if (name == "NSGrammaticalPartOfSpeechDeterminer") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechDeterminer);
//  }
//  if (name == "NSGrammaticalPartOfSpeechInterjection") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechInterjection);
//  }
//  if (name == "NSGrammaticalPartOfSpeechLetter") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechLetter);
//  }
//  if (name == "NSGrammaticalPartOfSpeechNotSet") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechNotSet);
//  }
//  if (name == "NSGrammaticalPartOfSpeechNoun") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechNoun);
//  }
//  if (name == "NSGrammaticalPartOfSpeechNumeral") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechNumeral);
//  }
//  if (name == "NSGrammaticalPartOfSpeechParticle") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechParticle);
//  }
//  if (name == "NSGrammaticalPartOfSpeechPreposition") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechPreposition);
//  }
//  if (name == "NSGrammaticalPartOfSpeechPronoun") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechPronoun);
//  }
//  if (name == "NSGrammaticalPartOfSpeechVerb") {
//    return convertObjCObjectToJSIValue(runtime, NSGrammaticalPartOfSpeechVerb);
//  }
//  if (name == "NSGreaterThanOrEqualToPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSGreaterThanOrEqualToPredicateOperatorType);
//  }
//  if (name == "NSGreaterThanPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSGreaterThanPredicateOperatorType);
//  }
//  if (name == "NSGregorianCalendar") {
//    return convertObjCObjectToJSIValue(runtime, NSGregorianCalendar);
//  }
//  if (name == "NSHPUXOperatingSystem") {
//    return convertObjCObjectToJSIValue(runtime, NSHPUXOperatingSystem);
//  }
//  // TODO: NSHTTPCookie (Interface)
//  if (name == "NSHTTPCookieAcceptPolicy") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Always": NSHTTPCookieAcceptPolicyAlways,
//        @"Never": NSHTTPCookieAcceptPolicyNever,
//        @"OnlyFromMainDocumentDomain": NSHTTPCookieAcceptPolicyOnlyFromMainDocumentDomain
//      }
//    );
//  }
//  if (name == "NSHTTPCookieAcceptPolicyAlways") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookieAcceptPolicyAlways);
//  }
//  if (name == "NSHTTPCookieAcceptPolicyNever") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookieAcceptPolicyNever);
//  }
//  if (name == "NSHTTPCookieAcceptPolicyOnlyFromMainDocumentDomain") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookieAcceptPolicyOnlyFromMainDocumentDomain);
//  }
//  if (name == "NSHTTPCookieAcceptPolicyAlways") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookieAcceptPolicyAlways);
//  }
//  if (name == "NSHTTPCookieAcceptPolicyNever") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookieAcceptPolicyNever);
//  }
//  if (name == "NSHTTPCookieAcceptPolicyOnlyFromMainDocumentDomain") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookieAcceptPolicyOnlyFromMainDocumentDomain);
//  }
//  if (name == "NSHTTPCookieComment") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookieComment);
//  }
//  if (name == "NSHTTPCookieCommentURL") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookieCommentURL);
//  }
//  if (name == "NSHTTPCookieDiscard") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookieDiscard);
//  }
//  if (name == "NSHTTPCookieDomain") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookieDomain);
//  }
//  if (name == "NSHTTPCookieExpires") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookieExpires);
//  }
//  if (name == "NSHTTPCookieManagerAcceptPolicyChangedNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookieManagerAcceptPolicyChangedNotification);
//  }
//  if (name == "NSHTTPCookieManagerCookiesChangedNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookieManagerCookiesChangedNotification);
//  }
//  if (name == "NSHTTPCookieMaximumAge") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookieMaximumAge);
//  }
//  if (name == "NSHTTPCookieName") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookieName);
//  }
//  if (name == "NSHTTPCookieOriginURL") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookieOriginURL);
//  }
//  if (name == "NSHTTPCookiePath") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookiePath);
//  }
//  if (name == "NSHTTPCookiePort") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookiePort);
//  }
//  if (name == "NSHTTPCookieSameSiteLax") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookieSameSiteLax);
//  }
//  if (name == "NSHTTPCookieSameSitePolicy") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookieSameSitePolicy);
//  }
//  if (name == "NSHTTPCookieSameSiteStrict") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookieSameSiteStrict);
//  }
//  if (name == "NSHTTPCookieSecure") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookieSecure);
//  }
//  // TODO: NSHTTPCookieStorage (Interface)
//  if (name == "NSHTTPCookieValue") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookieValue);
//  }
//  if (name == "NSHTTPCookieVersion") {
//    return convertObjCObjectToJSIValue(runtime, NSHTTPCookieVersion);
//  }
//  // TODO: NSHTTPURLResponse (Interface)
//  // TODO: NSHashEnumerator (Struct)
//  if (name == "NSHashGet") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSHashGet(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSHashGet"), 2, func);
//  }
//  if (name == "NSHashInsert") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSHashInsert(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSHashInsert"), 2, func);
//  }
//  if (name == "NSHashInsertIfAbsent") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSHashInsertIfAbsent(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSHashInsertIfAbsent"), 2, func);
//  }
//  if (name == "NSHashInsertKnownAbsent") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSHashInsertKnownAbsent(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSHashInsertKnownAbsent"), 2, func);
//  }
//  if (name == "NSHashRemove") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSHashRemove(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSHashRemove"), 2, func);
//  }
//  // TODO: NSHashTable (Interface)
//  // TODO: NSHashTableCallBacks (Struct)
//  if (name == "NSHashTableCopyIn") {
//    return convertObjCObjectToJSIValue(runtime, NSHashTableCopyIn);
//  }
//  if (name == "NSHashTableObjectPointerPersonality") {
//    return convertObjCObjectToJSIValue(runtime, NSHashTableObjectPointerPersonality);
//  }
//  if (name == "NSHashTableStrongMemory") {
//    return convertObjCObjectToJSIValue(runtime, NSHashTableStrongMemory);
//  }
//  if (name == "NSHashTableWeakMemory") {
//    return convertObjCObjectToJSIValue(runtime, NSHashTableWeakMemory);
//  }
//  if (name == "NSHebrewCalendar") {
//    return convertObjCObjectToJSIValue(runtime, NSHebrewCalendar);
//  }
//  if (name == "NSHelpAnchorErrorKey") {
//    return convertObjCObjectToJSIValue(runtime, NSHelpAnchorErrorKey);
//  }
//  if (name == "NSHomeDirectory") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSHomeDirectory();
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSHomeDirectory"), 0, func);
//  }
//  if (name == "NSHomeDirectoryForUser") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSHomeDirectoryForUser(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSHomeDirectoryForUser"), 1, func);
//  }
//  if (name == "NSHourCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSHourCalendarUnit);
//  }
//  if (name == "NSISO2022JPStringEncoding") {
//    return convertObjCObjectToJSIValue(runtime, NSISO2022JPStringEncoding);
//  }
//  if (name == "NSISO8601Calendar") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601Calendar);
//  }
//  if (name == "NSISO8601DateFormatOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"WithYear": NSISO8601DateFormatWithYear,
//        @"WithMonth": NSISO8601DateFormatWithMonth,
//        @"WithWeekOfYear": NSISO8601DateFormatWithWeekOfYear,
//        @"WithDay": NSISO8601DateFormatWithDay,
//        @"WithTime": NSISO8601DateFormatWithTime,
//        @"WithTimeZone": NSISO8601DateFormatWithTimeZone,
//        @"WithSpaceBetweenDateAndTime": NSISO8601DateFormatWithSpaceBetweenDateAndTime,
//        @"WithDashSeparatorInDate": NSISO8601DateFormatWithDashSeparatorInDate,
//        @"WithColonSeparatorInTime": NSISO8601DateFormatWithColonSeparatorInTime,
//        @"WithColonSeparatorInTimeZone": NSISO8601DateFormatWithColonSeparatorInTimeZone,
//        @"WithFractionalSeconds": NSISO8601DateFormatWithFractionalSeconds,
//        @"WithFullDate": NSISO8601DateFormatWithFullDate,
//        @"WithFullTime": NSISO8601DateFormatWithFullTime,
//        @"WithInternetDateTime": NSISO8601DateFormatWithInternetDateTime
//      }
//    );
//  }
//  if (name == "NSISO8601DateFormatWithYear") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithYear);
//  }
//  if (name == "NSISO8601DateFormatWithMonth") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithMonth);
//  }
//  if (name == "NSISO8601DateFormatWithWeekOfYear") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithWeekOfYear);
//  }
//  if (name == "NSISO8601DateFormatWithDay") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithDay);
//  }
//  if (name == "NSISO8601DateFormatWithTime") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithTime);
//  }
//  if (name == "NSISO8601DateFormatWithTimeZone") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithTimeZone);
//  }
//  if (name == "NSISO8601DateFormatWithSpaceBetweenDateAndTime") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithSpaceBetweenDateAndTime);
//  }
//  if (name == "NSISO8601DateFormatWithDashSeparatorInDate") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithDashSeparatorInDate);
//  }
//  if (name == "NSISO8601DateFormatWithColonSeparatorInTime") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithColonSeparatorInTime);
//  }
//  if (name == "NSISO8601DateFormatWithColonSeparatorInTimeZone") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithColonSeparatorInTimeZone);
//  }
//  if (name == "NSISO8601DateFormatWithFractionalSeconds") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithFractionalSeconds);
//  }
//  if (name == "NSISO8601DateFormatWithFullDate") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithFullDate);
//  }
//  if (name == "NSISO8601DateFormatWithFullTime") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithFullTime);
//  }
//  if (name == "NSISO8601DateFormatWithInternetDateTime") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithInternetDateTime);
//  }
//  if (name == "NSISO8601DateFormatWithColonSeparatorInTime") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithColonSeparatorInTime);
//  }
//  if (name == "NSISO8601DateFormatWithColonSeparatorInTimeZone") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithColonSeparatorInTimeZone);
//  }
//  if (name == "NSISO8601DateFormatWithDashSeparatorInDate") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithDashSeparatorInDate);
//  }
//  if (name == "NSISO8601DateFormatWithDay") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithDay);
//  }
//  if (name == "NSISO8601DateFormatWithFractionalSeconds") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithFractionalSeconds);
//  }
//  if (name == "NSISO8601DateFormatWithFullDate") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithFullDate);
//  }
//  if (name == "NSISO8601DateFormatWithFullTime") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithFullTime);
//  }
//  if (name == "NSISO8601DateFormatWithInternetDateTime") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithInternetDateTime);
//  }
//  if (name == "NSISO8601DateFormatWithMonth") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithMonth);
//  }
//  if (name == "NSISO8601DateFormatWithSpaceBetweenDateAndTime") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithSpaceBetweenDateAndTime);
//  }
//  if (name == "NSISO8601DateFormatWithTime") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithTime);
//  }
//  if (name == "NSISO8601DateFormatWithTimeZone") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithTimeZone);
//  }
//  if (name == "NSISO8601DateFormatWithWeekOfYear") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithWeekOfYear);
//  }
//  if (name == "NSISO8601DateFormatWithYear") {
//    return convertObjCObjectToJSIValue(runtime, NSISO8601DateFormatWithYear);
//  }
//  // TODO: NSISO8601DateFormatter (Interface)
//  if (name == "NSISOLatin1StringEncoding") {
//    return convertObjCObjectToJSIValue(runtime, NSISOLatin1StringEncoding);
//  }
//  if (name == "NSISOLatin2StringEncoding") {
//    return convertObjCObjectToJSIValue(runtime, NSISOLatin2StringEncoding);
//  }
//  if (name == "NSImageURLAttributeName") {
//    return convertObjCObjectToJSIValue(runtime, NSImageURLAttributeName);
//  }
//  if (name == "NSInPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSInPredicateOperatorType);
//  }
//  if (name == "NSInconsistentArchiveException") {
//    return convertObjCObjectToJSIValue(runtime, NSInconsistentArchiveException);
//  }
//  if (name == "NSIncrementExtraRefCount") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSIncrementExtraRefCount(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSIncrementExtraRefCount"), 1, func);
//  }
//  // TODO: NSIndexPath (Interface)
//  // TODO: NSIndexSet (Interface)
//  if (name == "NSIndianCalendar") {
//    return convertObjCObjectToJSIValue(runtime, NSIndianCalendar);
//  }
//  // TODO: NSInflectionRule (Interface)
//  if (name == "NSInflectionRuleAttributeName") {
//    return convertObjCObjectToJSIValue(runtime, NSInflectionRuleAttributeName);
//  }
//  // TODO: NSInflectionRuleExplicit (Interface)
//  if (name == "NSInlinePresentationIntent") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Emphasized": NSInlinePresentationIntentEmphasized,
//        @"StronglyEmphasized": NSInlinePresentationIntentStronglyEmphasized,
//        @"Code": NSInlinePresentationIntentCode,
//        @"Strikethrough": NSInlinePresentationIntentStrikethrough,
//        @"SoftBreak": NSInlinePresentationIntentSoftBreak,
//        @"LineBreak": NSInlinePresentationIntentLineBreak
//      }
//    );
//  }
//  if (name == "NSInlinePresentationIntentEmphasized") {
//    return convertObjCObjectToJSIValue(runtime, NSInlinePresentationIntentEmphasized);
//  }
//  if (name == "NSInlinePresentationIntentStronglyEmphasized") {
//    return convertObjCObjectToJSIValue(runtime, NSInlinePresentationIntentStronglyEmphasized);
//  }
//  if (name == "NSInlinePresentationIntentCode") {
//    return convertObjCObjectToJSIValue(runtime, NSInlinePresentationIntentCode);
//  }
//  if (name == "NSInlinePresentationIntentStrikethrough") {
//    return convertObjCObjectToJSIValue(runtime, NSInlinePresentationIntentStrikethrough);
//  }
//  if (name == "NSInlinePresentationIntentSoftBreak") {
//    return convertObjCObjectToJSIValue(runtime, NSInlinePresentationIntentSoftBreak);
//  }
//  if (name == "NSInlinePresentationIntentLineBreak") {
//    return convertObjCObjectToJSIValue(runtime, NSInlinePresentationIntentLineBreak);
//  }
//  if (name == "NSInlinePresentationIntentAttributeName") {
//    return convertObjCObjectToJSIValue(runtime, NSInlinePresentationIntentAttributeName);
//  }
//  if (name == "NSInlinePresentationIntentCode") {
//    return convertObjCObjectToJSIValue(runtime, NSInlinePresentationIntentCode);
//  }
//  if (name == "NSInlinePresentationIntentEmphasized") {
//    return convertObjCObjectToJSIValue(runtime, NSInlinePresentationIntentEmphasized);
//  }
//  if (name == "NSInlinePresentationIntentLineBreak") {
//    return convertObjCObjectToJSIValue(runtime, NSInlinePresentationIntentLineBreak);
//  }
//  if (name == "NSInlinePresentationIntentSoftBreak") {
//    return convertObjCObjectToJSIValue(runtime, NSInlinePresentationIntentSoftBreak);
//  }
//  if (name == "NSInlinePresentationIntentStrikethrough") {
//    return convertObjCObjectToJSIValue(runtime, NSInlinePresentationIntentStrikethrough);
//  }
//  if (name == "NSInlinePresentationIntentStronglyEmphasized") {
//    return convertObjCObjectToJSIValue(runtime, NSInlinePresentationIntentStronglyEmphasized);
//  }
//  if (name == "NSInputMethodsDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSInputMethodsDirectory);
//  }
//  // TODO: NSInputStream (Interface)
//  if (name == "NSIntMapKeyCallBacks") {
//    return convertObjCObjectToJSIValue(runtime, NSIntMapKeyCallBacks);
//  }
//  if (name == "NSIntMapValueCallBacks") {
//    return convertObjCObjectToJSIValue(runtime, NSIntMapValueCallBacks);
//  }
//  if (name == "NSInternalInconsistencyException") {
//    return convertObjCObjectToJSIValue(runtime, NSInternalInconsistencyException);
//  }
//  if (name == "NSIntersectSetExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSIntersectSetExpressionType);
//  }
//  if (name == "NSIntersectionRange") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSIntersectionRange(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSIntersectionRange"), 2, func);
//  }
//  if (name == "NSInvalidArchiveOperationException") {
//    return convertObjCObjectToJSIValue(runtime, NSInvalidArchiveOperationException);
//  }
//  if (name == "NSInvalidArgumentException") {
//    return convertObjCObjectToJSIValue(runtime, NSInvalidArgumentException);
//  }
//  if (name == "NSInvalidReceivePortException") {
//    return convertObjCObjectToJSIValue(runtime, NSInvalidReceivePortException);
//  }
//  if (name == "NSInvalidSendPortException") {
//    return convertObjCObjectToJSIValue(runtime, NSInvalidSendPortException);
//  }
//  if (name == "NSInvalidUnarchiveOperationException") {
//    return convertObjCObjectToJSIValue(runtime, NSInvalidUnarchiveOperationException);
//  }
//  // TODO: NSInvocation (Interface)
//  // TODO: NSInvocationOperation (Interface)
//  if (name == "NSInvocationOperationCancelledException") {
//    return convertObjCObjectToJSIValue(runtime, NSInvocationOperationCancelledException);
//  }
//  if (name == "NSInvocationOperationVoidResultException") {
//    return convertObjCObjectToJSIValue(runtime, NSInvocationOperationVoidResultException);
//  }
//  if (name == "NSIsNilTransformerName") {
//    return convertObjCObjectToJSIValue(runtime, NSIsNilTransformerName);
//  }
//  if (name == "NSIsNotNilTransformerName") {
//    return convertObjCObjectToJSIValue(runtime, NSIsNotNilTransformerName);
//  }
//  if (name == "NSIslamicCalendar") {
//    return convertObjCObjectToJSIValue(runtime, NSIslamicCalendar);
//  }
//  if (name == "NSIslamicCivilCalendar") {
//    return convertObjCObjectToJSIValue(runtime, NSIslamicCivilCalendar);
//  }
//  // TODO: NSItemProvider (Interface)
//  if (name == "NSItemProviderErrorCode") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"UnknownError": NSItemProviderUnknownError,
//        @"ItemUnavailableError": NSItemProviderItemUnavailableError,
//        @"UnexpectedValueClassError": NSItemProviderUnexpectedValueClassError,
//        @"UnavailableCoercionError": NSItemProviderUnavailableCoercionError
//      }
//    );
//  }
//  if (name == "NSItemProviderUnknownError") {
//    return convertObjCObjectToJSIValue(runtime, NSItemProviderUnknownError);
//  }
//  if (name == "NSItemProviderItemUnavailableError") {
//    return convertObjCObjectToJSIValue(runtime, NSItemProviderItemUnavailableError);
//  }
//  if (name == "NSItemProviderUnexpectedValueClassError") {
//    return convertObjCObjectToJSIValue(runtime, NSItemProviderUnexpectedValueClassError);
//  }
//  if (name == "NSItemProviderUnavailableCoercionError") {
//    return convertObjCObjectToJSIValue(runtime, NSItemProviderUnavailableCoercionError);
//  }
//  if (name == "NSItemProviderErrorDomain") {
//    return convertObjCObjectToJSIValue(runtime, NSItemProviderErrorDomain);
//  }
//  if (name == "NSItemProviderFileOptionOpenInPlace") {
//    return convertObjCObjectToJSIValue(runtime, NSItemProviderFileOptionOpenInPlace);
//  }
//  if (name == "NSItemProviderFileOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"OpenInPlace": NSItemProviderFileOptionOpenInPlace
//      }
//    );
//  }
//  if (name == "NSItemProviderFileOptionOpenInPlace") {
//    return convertObjCObjectToJSIValue(runtime, NSItemProviderFileOptionOpenInPlace);
//  }
//  if (name == "NSItemProviderItemUnavailableError") {
//    return convertObjCObjectToJSIValue(runtime, NSItemProviderItemUnavailableError);
//  }
//  if (name == "NSItemProviderPreferredImageSizeKey") {
//    return convertObjCObjectToJSIValue(runtime, NSItemProviderPreferredImageSizeKey);
//  }
//  // TODO: NSItemProviderReading (Protocol)
//  if (name == "NSItemProviderRepresentationVisibility") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"All": NSItemProviderRepresentationVisibilityAll,
//        @"Team": NSItemProviderRepresentationVisibilityTeam,
//        @"Group": NSItemProviderRepresentationVisibilityGroup,
//        @"OwnProcess": NSItemProviderRepresentationVisibilityOwnProcess
//      }
//    );
//  }
//  if (name == "NSItemProviderRepresentationVisibilityAll") {
//    return convertObjCObjectToJSIValue(runtime, NSItemProviderRepresentationVisibilityAll);
//  }
//  if (name == "NSItemProviderRepresentationVisibilityTeam") {
//    return convertObjCObjectToJSIValue(runtime, NSItemProviderRepresentationVisibilityTeam);
//  }
//  if (name == "NSItemProviderRepresentationVisibilityGroup") {
//    return convertObjCObjectToJSIValue(runtime, NSItemProviderRepresentationVisibilityGroup);
//  }
//  if (name == "NSItemProviderRepresentationVisibilityOwnProcess") {
//    return convertObjCObjectToJSIValue(runtime, NSItemProviderRepresentationVisibilityOwnProcess);
//  }
//  if (name == "NSItemProviderRepresentationVisibilityAll") {
//    return convertObjCObjectToJSIValue(runtime, NSItemProviderRepresentationVisibilityAll);
//  }
//  if (name == "NSItemProviderRepresentationVisibilityOwnProcess") {
//    return convertObjCObjectToJSIValue(runtime, NSItemProviderRepresentationVisibilityOwnProcess);
//  }
//  if (name == "NSItemProviderRepresentationVisibilityTeam") {
//    return convertObjCObjectToJSIValue(runtime, NSItemProviderRepresentationVisibilityTeam);
//  }
//  if (name == "NSItemProviderUnavailableCoercionError") {
//    return convertObjCObjectToJSIValue(runtime, NSItemProviderUnavailableCoercionError);
//  }
//  if (name == "NSItemProviderUnexpectedValueClassError") {
//    return convertObjCObjectToJSIValue(runtime, NSItemProviderUnexpectedValueClassError);
//  }
//  if (name == "NSItemProviderUnknownError") {
//    return convertObjCObjectToJSIValue(runtime, NSItemProviderUnknownError);
//  }
//  // TODO: NSItemProviderWriting (Protocol)
//  if (name == "NSItemReplacementDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSItemReplacementDirectory);
//  }
//  if (name == "NSJSONReadingAllowFragments") {
//    return convertObjCObjectToJSIValue(runtime, NSJSONReadingAllowFragments);
//  }
//  if (name == "NSJSONReadingFragmentsAllowed") {
//    return convertObjCObjectToJSIValue(runtime, NSJSONReadingFragmentsAllowed);
//  }
//  if (name == "NSJSONReadingJSON5Allowed") {
//    return convertObjCObjectToJSIValue(runtime, NSJSONReadingJSON5Allowed);
//  }
//  if (name == "NSJSONReadingMutableContainers") {
//    return convertObjCObjectToJSIValue(runtime, NSJSONReadingMutableContainers);
//  }
//  if (name == "NSJSONReadingMutableLeaves") {
//    return convertObjCObjectToJSIValue(runtime, NSJSONReadingMutableLeaves);
//  }
//  if (name == "NSJSONReadingOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"MutableContainers": NSJSONReadingMutableContainers,
//        @"MutableLeaves": NSJSONReadingMutableLeaves,
//        @"FragmentsAllowed": NSJSONReadingFragmentsAllowed,
//        @"JSON5Allowed": NSJSONReadingJSON5Allowed,
//        @"TopLevelDictionaryAssumed": NSJSONReadingTopLevelDictionaryAssumed,
//        @"AllowFragments": NSJSONReadingAllowFragments
//      }
//    );
//  }
//  if (name == "NSJSONReadingMutableContainers") {
//    return convertObjCObjectToJSIValue(runtime, NSJSONReadingMutableContainers);
//  }
//  if (name == "NSJSONReadingMutableLeaves") {
//    return convertObjCObjectToJSIValue(runtime, NSJSONReadingMutableLeaves);
//  }
//  if (name == "NSJSONReadingFragmentsAllowed") {
//    return convertObjCObjectToJSIValue(runtime, NSJSONReadingFragmentsAllowed);
//  }
//  if (name == "NSJSONReadingJSON5Allowed") {
//    return convertObjCObjectToJSIValue(runtime, NSJSONReadingJSON5Allowed);
//  }
//  if (name == "NSJSONReadingTopLevelDictionaryAssumed") {
//    return convertObjCObjectToJSIValue(runtime, NSJSONReadingTopLevelDictionaryAssumed);
//  }
//  if (name == "NSJSONReadingAllowFragments") {
//    return convertObjCObjectToJSIValue(runtime, NSJSONReadingAllowFragments);
//  }
//  if (name == "NSJSONReadingTopLevelDictionaryAssumed") {
//    return convertObjCObjectToJSIValue(runtime, NSJSONReadingTopLevelDictionaryAssumed);
//  }
//  // TODO: NSJSONSerialization (Interface)
//  if (name == "NSJSONWritingFragmentsAllowed") {
//    return convertObjCObjectToJSIValue(runtime, NSJSONWritingFragmentsAllowed);
//  }
//  if (name == "NSJSONWritingOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"PrettyPrinted": NSJSONWritingPrettyPrinted,
//        @"SortedKeys": NSJSONWritingSortedKeys,
//        @"FragmentsAllowed": NSJSONWritingFragmentsAllowed,
//        @"WithoutEscapingSlashes": NSJSONWritingWithoutEscapingSlashes
//      }
//    );
//  }
//  if (name == "NSJSONWritingPrettyPrinted") {
//    return convertObjCObjectToJSIValue(runtime, NSJSONWritingPrettyPrinted);
//  }
//  if (name == "NSJSONWritingSortedKeys") {
//    return convertObjCObjectToJSIValue(runtime, NSJSONWritingSortedKeys);
//  }
//  if (name == "NSJSONWritingFragmentsAllowed") {
//    return convertObjCObjectToJSIValue(runtime, NSJSONWritingFragmentsAllowed);
//  }
//  if (name == "NSJSONWritingWithoutEscapingSlashes") {
//    return convertObjCObjectToJSIValue(runtime, NSJSONWritingWithoutEscapingSlashes);
//  }
//  if (name == "NSJSONWritingPrettyPrinted") {
//    return convertObjCObjectToJSIValue(runtime, NSJSONWritingPrettyPrinted);
//  }
//  if (name == "NSJSONWritingSortedKeys") {
//    return convertObjCObjectToJSIValue(runtime, NSJSONWritingSortedKeys);
//  }
//  if (name == "NSJSONWritingWithoutEscapingSlashes") {
//    return convertObjCObjectToJSIValue(runtime, NSJSONWritingWithoutEscapingSlashes);
//  }
//  if (name == "NSJapaneseCalendar") {
//    return convertObjCObjectToJSIValue(runtime, NSJapaneseCalendar);
//  }
//  if (name == "NSJapaneseEUCStringEncoding") {
//    return convertObjCObjectToJSIValue(runtime, NSJapaneseEUCStringEncoding);
//  }
//  if (name == "NSKeyPathExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyPathExpressionType);
//  }
//  if (name == "NSKeyValueChange") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Setting": NSKeyValueChangeSetting,
//        @"Insertion": NSKeyValueChangeInsertion,
//        @"Removal": NSKeyValueChangeRemoval,
//        @"Replacement": NSKeyValueChangeReplacement
//      }
//    );
//  }
//  if (name == "NSKeyValueChangeSetting") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueChangeSetting);
//  }
//  if (name == "NSKeyValueChangeInsertion") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueChangeInsertion);
//  }
//  if (name == "NSKeyValueChangeRemoval") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueChangeRemoval);
//  }
//  if (name == "NSKeyValueChangeReplacement") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueChangeReplacement);
//  }
//  if (name == "NSKeyValueChangeIndexesKey") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueChangeIndexesKey);
//  }
//  if (name == "NSKeyValueChangeInsertion") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueChangeInsertion);
//  }
//  if (name == "NSKeyValueChangeKindKey") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueChangeKindKey);
//  }
//  if (name == "NSKeyValueChangeNewKey") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueChangeNewKey);
//  }
//  if (name == "NSKeyValueChangeNotificationIsPriorKey") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueChangeNotificationIsPriorKey);
//  }
//  if (name == "NSKeyValueChangeOldKey") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueChangeOldKey);
//  }
//  if (name == "NSKeyValueChangeRemoval") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueChangeRemoval);
//  }
//  if (name == "NSKeyValueChangeReplacement") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueChangeReplacement);
//  }
//  if (name == "NSKeyValueChangeSetting") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueChangeSetting);
//  }
//  if (name == "NSKeyValueIntersectSetMutation") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueIntersectSetMutation);
//  }
//  if (name == "NSKeyValueMinusSetMutation") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueMinusSetMutation);
//  }
//  if (name == "NSKeyValueObservingOptionInitial") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueObservingOptionInitial);
//  }
//  if (name == "NSKeyValueObservingOptionNew") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueObservingOptionNew);
//  }
//  if (name == "NSKeyValueObservingOptionOld") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueObservingOptionOld);
//  }
//  if (name == "NSKeyValueObservingOptionPrior") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueObservingOptionPrior);
//  }
//  if (name == "NSKeyValueObservingOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"New": NSKeyValueObservingOptionNew,
//        @"Old": NSKeyValueObservingOptionOld,
//        @"Initial": NSKeyValueObservingOptionInitial,
//        @"Prior": NSKeyValueObservingOptionPrior
//      }
//    );
//  }
//  if (name == "NSKeyValueObservingOptionNew") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueObservingOptionNew);
//  }
//  if (name == "NSKeyValueObservingOptionOld") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueObservingOptionOld);
//  }
//  if (name == "NSKeyValueObservingOptionInitial") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueObservingOptionInitial);
//  }
//  if (name == "NSKeyValueObservingOptionPrior") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueObservingOptionPrior);
//  }
//  if (name == "NSKeyValueSetMutationKind") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"UnionSetMutation": NSKeyValueUnionSetMutation,
//        @"MinusSetMutation": NSKeyValueMinusSetMutation,
//        @"IntersectSetMutation": NSKeyValueIntersectSetMutation,
//        @"SetSetMutation": NSKeyValueSetSetMutation
//      }
//    );
//  }
//  if (name == "NSKeyValueUnionSetMutation") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueUnionSetMutation);
//  }
//  if (name == "NSKeyValueMinusSetMutation") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueMinusSetMutation);
//  }
//  if (name == "NSKeyValueIntersectSetMutation") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueIntersectSetMutation);
//  }
//  if (name == "NSKeyValueSetSetMutation") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueSetSetMutation);
//  }
//  if (name == "NSKeyValueSetSetMutation") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueSetSetMutation);
//  }
//  if (name == "NSKeyValueUnionSetMutation") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueUnionSetMutation);
//  }
//  if (name == "NSKeyValueValidationError") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyValueValidationError);
//  }
//  if (name == "NSKeyedArchiveRootObjectKey") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyedArchiveRootObjectKey);
//  }
//  // TODO: NSKeyedArchiver (Interface)
//  // TODO: NSKeyedArchiverDelegate (Protocol)
//  if (name == "NSKeyedUnarchiveFromDataTransformerName") {
//    return convertObjCObjectToJSIValue(runtime, NSKeyedUnarchiveFromDataTransformerName);
//  }
//  // TODO: NSKeyedUnarchiver (Interface)
//  // TODO: NSKeyedUnarchiverDelegate (Protocol)
//  if (name == "NSLanguageIdentifierAttributeName") {
//    return convertObjCObjectToJSIValue(runtime, NSLanguageIdentifierAttributeName);
//  }
//  // TODO: NSLengthFormatter (Interface)
//  if (name == "NSLengthFormatterUnit") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Millimeter": NSLengthFormatterUnitMillimeter,
//        @"Centimeter": NSLengthFormatterUnitCentimeter,
//        @"Meter": NSLengthFormatterUnitMeter,
//        @"Kilometer": NSLengthFormatterUnitKilometer,
//        @"Inch": NSLengthFormatterUnitInch,
//        @"Foot": NSLengthFormatterUnitFoot,
//        @"Yard": NSLengthFormatterUnitYard,
//        @"Mile": NSLengthFormatterUnitMile
//      }
//    );
//  }
//  if (name == "NSLengthFormatterUnitMillimeter") {
//    return convertObjCObjectToJSIValue(runtime, NSLengthFormatterUnitMillimeter);
//  }
//  if (name == "NSLengthFormatterUnitCentimeter") {
//    return convertObjCObjectToJSIValue(runtime, NSLengthFormatterUnitCentimeter);
//  }
//  if (name == "NSLengthFormatterUnitMeter") {
//    return convertObjCObjectToJSIValue(runtime, NSLengthFormatterUnitMeter);
//  }
//  if (name == "NSLengthFormatterUnitKilometer") {
//    return convertObjCObjectToJSIValue(runtime, NSLengthFormatterUnitKilometer);
//  }
//  if (name == "NSLengthFormatterUnitInch") {
//    return convertObjCObjectToJSIValue(runtime, NSLengthFormatterUnitInch);
//  }
//  if (name == "NSLengthFormatterUnitFoot") {
//    return convertObjCObjectToJSIValue(runtime, NSLengthFormatterUnitFoot);
//  }
//  if (name == "NSLengthFormatterUnitYard") {
//    return convertObjCObjectToJSIValue(runtime, NSLengthFormatterUnitYard);
//  }
//  if (name == "NSLengthFormatterUnitMile") {
//    return convertObjCObjectToJSIValue(runtime, NSLengthFormatterUnitMile);
//  }
//  if (name == "NSLengthFormatterUnitCentimeter") {
//    return convertObjCObjectToJSIValue(runtime, NSLengthFormatterUnitCentimeter);
//  }
//  if (name == "NSLengthFormatterUnitFoot") {
//    return convertObjCObjectToJSIValue(runtime, NSLengthFormatterUnitFoot);
//  }
//  if (name == "NSLengthFormatterUnitInch") {
//    return convertObjCObjectToJSIValue(runtime, NSLengthFormatterUnitInch);
//  }
//  if (name == "NSLengthFormatterUnitKilometer") {
//    return convertObjCObjectToJSIValue(runtime, NSLengthFormatterUnitKilometer);
//  }
//  if (name == "NSLengthFormatterUnitMeter") {
//    return convertObjCObjectToJSIValue(runtime, NSLengthFormatterUnitMeter);
//  }
//  if (name == "NSLengthFormatterUnitMile") {
//    return convertObjCObjectToJSIValue(runtime, NSLengthFormatterUnitMile);
//  }
//  if (name == "NSLengthFormatterUnitMillimeter") {
//    return convertObjCObjectToJSIValue(runtime, NSLengthFormatterUnitMillimeter);
//  }
//  if (name == "NSLengthFormatterUnitYard") {
//    return convertObjCObjectToJSIValue(runtime, NSLengthFormatterUnitYard);
//  }
//  if (name == "NSLessThanOrEqualToPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSLessThanOrEqualToPredicateOperatorType);
//  }
//  if (name == "NSLessThanPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSLessThanPredicateOperatorType);
//  }
//  if (name == "NSLibraryDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSLibraryDirectory);
//  }
//  if (name == "NSLikePredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSLikePredicateOperatorType);
//  }
//  if (name == "NSLinguisticTagAdjective") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagAdjective);
//  }
//  if (name == "NSLinguisticTagAdverb") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagAdverb);
//  }
//  if (name == "NSLinguisticTagClassifier") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagClassifier);
//  }
//  if (name == "NSLinguisticTagCloseParenthesis") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagCloseParenthesis);
//  }
//  if (name == "NSLinguisticTagCloseQuote") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagCloseQuote);
//  }
//  if (name == "NSLinguisticTagConjunction") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagConjunction);
//  }
//  if (name == "NSLinguisticTagDash") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagDash);
//  }
//  if (name == "NSLinguisticTagDeterminer") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagDeterminer);
//  }
//  if (name == "NSLinguisticTagIdiom") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagIdiom);
//  }
//  if (name == "NSLinguisticTagInterjection") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagInterjection);
//  }
//  if (name == "NSLinguisticTagNoun") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagNoun);
//  }
//  if (name == "NSLinguisticTagNumber") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagNumber);
//  }
//  if (name == "NSLinguisticTagOpenParenthesis") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagOpenParenthesis);
//  }
//  if (name == "NSLinguisticTagOpenQuote") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagOpenQuote);
//  }
//  if (name == "NSLinguisticTagOrganizationName") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagOrganizationName);
//  }
//  if (name == "NSLinguisticTagOther") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagOther);
//  }
//  if (name == "NSLinguisticTagOtherPunctuation") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagOtherPunctuation);
//  }
//  if (name == "NSLinguisticTagOtherWhitespace") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagOtherWhitespace);
//  }
//  if (name == "NSLinguisticTagOtherWord") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagOtherWord);
//  }
//  if (name == "NSLinguisticTagParagraphBreak") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagParagraphBreak);
//  }
//  if (name == "NSLinguisticTagParticle") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagParticle);
//  }
//  if (name == "NSLinguisticTagPersonalName") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagPersonalName);
//  }
//  if (name == "NSLinguisticTagPlaceName") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagPlaceName);
//  }
//  if (name == "NSLinguisticTagPreposition") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagPreposition);
//  }
//  if (name == "NSLinguisticTagPronoun") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagPronoun);
//  }
//  if (name == "NSLinguisticTagPunctuation") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagPunctuation);
//  }
//  if (name == "NSLinguisticTagSchemeLanguage") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagSchemeLanguage);
//  }
//  if (name == "NSLinguisticTagSchemeLemma") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagSchemeLemma);
//  }
//  if (name == "NSLinguisticTagSchemeLexicalClass") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagSchemeLexicalClass);
//  }
//  if (name == "NSLinguisticTagSchemeNameType") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagSchemeNameType);
//  }
//  if (name == "NSLinguisticTagSchemeNameTypeOrLexicalClass") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagSchemeNameTypeOrLexicalClass);
//  }
//  if (name == "NSLinguisticTagSchemeScript") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagSchemeScript);
//  }
//  if (name == "NSLinguisticTagSchemeTokenType") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagSchemeTokenType);
//  }
//  if (name == "NSLinguisticTagSentenceTerminator") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagSentenceTerminator);
//  }
//  if (name == "NSLinguisticTagVerb") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagVerb);
//  }
//  if (name == "NSLinguisticTagWhitespace") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagWhitespace);
//  }
//  if (name == "NSLinguisticTagWord") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagWord);
//  }
//  if (name == "NSLinguisticTagWordJoiner") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTagWordJoiner);
//  }
//  // TODO: NSLinguisticTagger (Interface)
//  if (name == "NSLinguisticTaggerJoinNames") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTaggerJoinNames);
//  }
//  if (name == "NSLinguisticTaggerOmitOther") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTaggerOmitOther);
//  }
//  if (name == "NSLinguisticTaggerOmitPunctuation") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTaggerOmitPunctuation);
//  }
//  if (name == "NSLinguisticTaggerOmitWhitespace") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTaggerOmitWhitespace);
//  }
//  if (name == "NSLinguisticTaggerOmitWords") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTaggerOmitWords);
//  }
//  if (name == "NSLinguisticTaggerOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"OmitWords": NSLinguisticTaggerOmitWords,
//        @"OmitPunctuation": NSLinguisticTaggerOmitPunctuation,
//        @"OmitWhitespace": NSLinguisticTaggerOmitWhitespace,
//        @"OmitOther": NSLinguisticTaggerOmitOther,
//        @"JoinNames": NSLinguisticTaggerJoinNames
//      }
//    );
//  }
//  if (name == "NSLinguisticTaggerOmitWords") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTaggerOmitWords);
//  }
//  if (name == "NSLinguisticTaggerOmitPunctuation") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTaggerOmitPunctuation);
//  }
//  if (name == "NSLinguisticTaggerOmitWhitespace") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTaggerOmitWhitespace);
//  }
//  if (name == "NSLinguisticTaggerOmitOther") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTaggerOmitOther);
//  }
//  if (name == "NSLinguisticTaggerJoinNames") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTaggerJoinNames);
//  }
//  if (name == "NSLinguisticTaggerUnit") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Word": NSLinguisticTaggerUnitWord,
//        @"Sentence": NSLinguisticTaggerUnitSentence,
//        @"Paragraph": NSLinguisticTaggerUnitParagraph,
//        @"Document": NSLinguisticTaggerUnitDocument
//      }
//    );
//  }
//  if (name == "NSLinguisticTaggerUnitWord") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTaggerUnitWord);
//  }
//  if (name == "NSLinguisticTaggerUnitSentence") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTaggerUnitSentence);
//  }
//  if (name == "NSLinguisticTaggerUnitParagraph") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTaggerUnitParagraph);
//  }
//  if (name == "NSLinguisticTaggerUnitDocument") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTaggerUnitDocument);
//  }
//  if (name == "NSLinguisticTaggerUnitDocument") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTaggerUnitDocument);
//  }
//  if (name == "NSLinguisticTaggerUnitParagraph") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTaggerUnitParagraph);
//  }
//  if (name == "NSLinguisticTaggerUnitSentence") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTaggerUnitSentence);
//  }
//  if (name == "NSLinguisticTaggerUnitWord") {
//    return convertObjCObjectToJSIValue(runtime, NSLinguisticTaggerUnitWord);
//  }
//  // TODO: NSListFormatter (Interface)
//  if (name == "NSLiteralSearch") {
//    return convertObjCObjectToJSIValue(runtime, NSLiteralSearch);
//  }
//  if (name == "NSLoadedClasses") {
//    return convertObjCObjectToJSIValue(runtime, NSLoadedClasses);
//  }
//  if (name == "NSLocalDomainMask") {
//    return convertObjCObjectToJSIValue(runtime, NSLocalDomainMask);
//  }
//  // TODO: NSLocale (Interface)
//  if (name == "NSLocaleAlternateQuotationBeginDelimiterKey") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleAlternateQuotationBeginDelimiterKey);
//  }
//  if (name == "NSLocaleAlternateQuotationEndDelimiterKey") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleAlternateQuotationEndDelimiterKey);
//  }
//  if (name == "NSLocaleCalendar") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleCalendar);
//  }
//  if (name == "NSLocaleCollationIdentifier") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleCollationIdentifier);
//  }
//  if (name == "NSLocaleCollatorIdentifier") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleCollatorIdentifier);
//  }
//  if (name == "NSLocaleCountryCode") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleCountryCode);
//  }
//  if (name == "NSLocaleCurrencyCode") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleCurrencyCode);
//  }
//  if (name == "NSLocaleCurrencySymbol") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleCurrencySymbol);
//  }
//  if (name == "NSLocaleDecimalSeparator") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleDecimalSeparator);
//  }
//  if (name == "NSLocaleExemplarCharacterSet") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleExemplarCharacterSet);
//  }
//  if (name == "NSLocaleGroupingSeparator") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleGroupingSeparator);
//  }
//  if (name == "NSLocaleIdentifier") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleIdentifier);
//  }
//  if (name == "NSLocaleLanguageCode") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleLanguageCode);
//  }
//  if (name == "NSLocaleLanguageDirection") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Unknown": NSLocaleLanguageDirectionUnknown,
//        @"LeftToRight": NSLocaleLanguageDirectionLeftToRight,
//        @"RightToLeft": NSLocaleLanguageDirectionRightToLeft,
//        @"TopToBottom": NSLocaleLanguageDirectionTopToBottom,
//        @"BottomToTop": NSLocaleLanguageDirectionBottomToTop
//      }
//    );
//  }
//  if (name == "NSLocaleLanguageDirectionUnknown") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleLanguageDirectionUnknown);
//  }
//  if (name == "NSLocaleLanguageDirectionLeftToRight") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleLanguageDirectionLeftToRight);
//  }
//  if (name == "NSLocaleLanguageDirectionRightToLeft") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleLanguageDirectionRightToLeft);
//  }
//  if (name == "NSLocaleLanguageDirectionTopToBottom") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleLanguageDirectionTopToBottom);
//  }
//  if (name == "NSLocaleLanguageDirectionBottomToTop") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleLanguageDirectionBottomToTop);
//  }
//  if (name == "NSLocaleLanguageDirectionBottomToTop") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleLanguageDirectionBottomToTop);
//  }
//  if (name == "NSLocaleLanguageDirectionLeftToRight") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleLanguageDirectionLeftToRight);
//  }
//  if (name == "NSLocaleLanguageDirectionRightToLeft") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleLanguageDirectionRightToLeft);
//  }
//  if (name == "NSLocaleLanguageDirectionTopToBottom") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleLanguageDirectionTopToBottom);
//  }
//  if (name == "NSLocaleLanguageDirectionUnknown") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleLanguageDirectionUnknown);
//  }
//  if (name == "NSLocaleMeasurementSystem") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleMeasurementSystem);
//  }
//  if (name == "NSLocaleQuotationBeginDelimiterKey") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleQuotationBeginDelimiterKey);
//  }
//  if (name == "NSLocaleQuotationEndDelimiterKey") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleQuotationEndDelimiterKey);
//  }
//  if (name == "NSLocaleScriptCode") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleScriptCode);
//  }
//  if (name == "NSLocaleUsesMetricSystem") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleUsesMetricSystem);
//  }
//  if (name == "NSLocaleVariantCode") {
//    return convertObjCObjectToJSIValue(runtime, NSLocaleVariantCode);
//  }
//  if (name == "NSLocalizedDescriptionKey") {
//    return convertObjCObjectToJSIValue(runtime, NSLocalizedDescriptionKey);
//  }
//  if (name == "NSLocalizedFailureErrorKey") {
//    return convertObjCObjectToJSIValue(runtime, NSLocalizedFailureErrorKey);
//  }
//  if (name == "NSLocalizedFailureReasonErrorKey") {
//    return convertObjCObjectToJSIValue(runtime, NSLocalizedFailureReasonErrorKey);
//  }
//  if (name == "NSLocalizedRecoveryOptionsErrorKey") {
//    return convertObjCObjectToJSIValue(runtime, NSLocalizedRecoveryOptionsErrorKey);
//  }
//  if (name == "NSLocalizedRecoverySuggestionErrorKey") {
//    return convertObjCObjectToJSIValue(runtime, NSLocalizedRecoverySuggestionErrorKey);
//  }
//  // TODO: NSLock (Interface)
//  // TODO: NSLocking (Protocol)
//  if (name == "NSLogPageSize") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSLogPageSize();
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSLogPageSize"), 0, func);
//  }
//  if (name == "NSMACHOperatingSystem") {
//    return convertObjCObjectToJSIValue(runtime, NSMACHOperatingSystem);
//  }
//  if (name == "NSMacOSRomanStringEncoding") {
//    return convertObjCObjectToJSIValue(runtime, NSMacOSRomanStringEncoding);
//  }
//  if (name == "NSMachErrorDomain") {
//    return convertObjCObjectToJSIValue(runtime, NSMachErrorDomain);
//  }
//  // TODO: NSMachPort (Interface)
//  if (name == "NSMachPortDeallocateNone") {
//    return convertObjCObjectToJSIValue(runtime, NSMachPortDeallocateNone);
//  }
//  if (name == "NSMachPortDeallocateReceiveRight") {
//    return convertObjCObjectToJSIValue(runtime, NSMachPortDeallocateReceiveRight);
//  }
//  if (name == "NSMachPortDeallocateSendRight") {
//    return convertObjCObjectToJSIValue(runtime, NSMachPortDeallocateSendRight);
//  }
//  // TODO: NSMachPortDelegate (Protocol)
//  if (name == "NSMachPortOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"DeallocateNone": NSMachPortDeallocateNone,
//        @"DeallocateSendRight": NSMachPortDeallocateSendRight,
//        @"DeallocateReceiveRight": NSMachPortDeallocateReceiveRight
//      }
//    );
//  }
//  if (name == "NSMachPortDeallocateNone") {
//    return convertObjCObjectToJSIValue(runtime, NSMachPortDeallocateNone);
//  }
//  if (name == "NSMachPortDeallocateSendRight") {
//    return convertObjCObjectToJSIValue(runtime, NSMachPortDeallocateSendRight);
//  }
//  if (name == "NSMachPortDeallocateReceiveRight") {
//    return convertObjCObjectToJSIValue(runtime, NSMachPortDeallocateReceiveRight);
//  }
//  if (name == "NSMakeCollectable") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSMakeCollectable(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSMakeCollectable"), 1, func);
//  }
//  if (name == "NSMallocException") {
//    return convertObjCObjectToJSIValue(runtime, NSMallocException);
//  }
//  // TODO: NSMapEnumerator (Struct)
//  if (name == "NSMapGet") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSMapGet(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSMapGet"), 2, func);
//  }
//  if (name == "NSMapInsert") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSMapInsert(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSMapInsert"), 3, func);
//  }
//  if (name == "NSMapInsertIfAbsent") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSMapInsertIfAbsent(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSMapInsertIfAbsent"), 3, func);
//  }
//  if (name == "NSMapInsertKnownAbsent") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSMapInsertKnownAbsent(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSMapInsertKnownAbsent"), 3, func);
//  }
//  if (name == "NSMapMember") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSMapMember(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2]),
//        convertJSIValueToObjCObject(arguments[3])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSMapMember"), 4, func);
//  }
//  if (name == "NSMapRemove") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSMapRemove(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSMapRemove"), 2, func);
//  }
//  // TODO: NSMapTable (Interface)
//  if (name == "NSMapTableCopyIn") {
//    return convertObjCObjectToJSIValue(runtime, NSMapTableCopyIn);
//  }
//  // TODO: NSMapTableKeyCallBacks (Struct)
//  if (name == "NSMapTableObjectPointerPersonality") {
//    return convertObjCObjectToJSIValue(runtime, NSMapTableObjectPointerPersonality);
//  }
//  if (name == "NSMapTableStrongMemory") {
//    return convertObjCObjectToJSIValue(runtime, NSMapTableStrongMemory);
//  }
//  // TODO: NSMapTableValueCallBacks (Struct)
//  if (name == "NSMapTableWeakMemory") {
//    return convertObjCObjectToJSIValue(runtime, NSMapTableWeakMemory);
//  }
//  if (name == "NSMappedRead") {
//    return convertObjCObjectToJSIValue(runtime, NSMappedRead);
//  }
//  // TODO: NSMassFormatter (Interface)
//  if (name == "NSMassFormatterUnit") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Gram": NSMassFormatterUnitGram,
//        @"Kilogram": NSMassFormatterUnitKilogram,
//        @"Ounce": NSMassFormatterUnitOunce,
//        @"Pound": NSMassFormatterUnitPound,
//        @"Stone": NSMassFormatterUnitStone
//      }
//    );
//  }
//  if (name == "NSMassFormatterUnitGram") {
//    return convertObjCObjectToJSIValue(runtime, NSMassFormatterUnitGram);
//  }
//  if (name == "NSMassFormatterUnitKilogram") {
//    return convertObjCObjectToJSIValue(runtime, NSMassFormatterUnitKilogram);
//  }
//  if (name == "NSMassFormatterUnitOunce") {
//    return convertObjCObjectToJSIValue(runtime, NSMassFormatterUnitOunce);
//  }
//  if (name == "NSMassFormatterUnitPound") {
//    return convertObjCObjectToJSIValue(runtime, NSMassFormatterUnitPound);
//  }
//  if (name == "NSMassFormatterUnitStone") {
//    return convertObjCObjectToJSIValue(runtime, NSMassFormatterUnitStone);
//  }
//  if (name == "NSMassFormatterUnitGram") {
//    return convertObjCObjectToJSIValue(runtime, NSMassFormatterUnitGram);
//  }
//  if (name == "NSMassFormatterUnitKilogram") {
//    return convertObjCObjectToJSIValue(runtime, NSMassFormatterUnitKilogram);
//  }
//  if (name == "NSMassFormatterUnitOunce") {
//    return convertObjCObjectToJSIValue(runtime, NSMassFormatterUnitOunce);
//  }
//  if (name == "NSMassFormatterUnitPound") {
//    return convertObjCObjectToJSIValue(runtime, NSMassFormatterUnitPound);
//  }
//  if (name == "NSMassFormatterUnitStone") {
//    return convertObjCObjectToJSIValue(runtime, NSMassFormatterUnitStone);
//  }
//  if (name == "NSMatchesPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSMatchesPredicateOperatorType);
//  }
//  if (name == "NSMatchingAnchored") {
//    return convertObjCObjectToJSIValue(runtime, NSMatchingAnchored);
//  }
//  if (name == "NSMatchingCompleted") {
//    return convertObjCObjectToJSIValue(runtime, NSMatchingCompleted);
//  }
//  if (name == "NSMatchingFlags") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Progress": NSMatchingProgress,
//        @"Completed": NSMatchingCompleted,
//        @"HitEnd": NSMatchingHitEnd,
//        @"RequiredEnd": NSMatchingRequiredEnd,
//        @"InternalError": NSMatchingInternalError
//      }
//    );
//  }
//  if (name == "NSMatchingProgress") {
//    return convertObjCObjectToJSIValue(runtime, NSMatchingProgress);
//  }
//  if (name == "NSMatchingCompleted") {
//    return convertObjCObjectToJSIValue(runtime, NSMatchingCompleted);
//  }
//  if (name == "NSMatchingHitEnd") {
//    return convertObjCObjectToJSIValue(runtime, NSMatchingHitEnd);
//  }
//  if (name == "NSMatchingRequiredEnd") {
//    return convertObjCObjectToJSIValue(runtime, NSMatchingRequiredEnd);
//  }
//  if (name == "NSMatchingInternalError") {
//    return convertObjCObjectToJSIValue(runtime, NSMatchingInternalError);
//  }
//  if (name == "NSMatchingHitEnd") {
//    return convertObjCObjectToJSIValue(runtime, NSMatchingHitEnd);
//  }
//  if (name == "NSMatchingInternalError") {
//    return convertObjCObjectToJSIValue(runtime, NSMatchingInternalError);
//  }
//  if (name == "NSMatchingOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"ReportProgress": NSMatchingReportProgress,
//        @"ReportCompletion": NSMatchingReportCompletion,
//        @"Anchored": NSMatchingAnchored,
//        @"WithTransparentBounds": NSMatchingWithTransparentBounds,
//        @"WithoutAnchoringBounds": NSMatchingWithoutAnchoringBounds
//      }
//    );
//  }
//  if (name == "NSMatchingReportProgress") {
//    return convertObjCObjectToJSIValue(runtime, NSMatchingReportProgress);
//  }
//  if (name == "NSMatchingReportCompletion") {
//    return convertObjCObjectToJSIValue(runtime, NSMatchingReportCompletion);
//  }
//  if (name == "NSMatchingAnchored") {
//    return convertObjCObjectToJSIValue(runtime, NSMatchingAnchored);
//  }
//  if (name == "NSMatchingWithTransparentBounds") {
//    return convertObjCObjectToJSIValue(runtime, NSMatchingWithTransparentBounds);
//  }
//  if (name == "NSMatchingWithoutAnchoringBounds") {
//    return convertObjCObjectToJSIValue(runtime, NSMatchingWithoutAnchoringBounds);
//  }
//  if (name == "NSMatchingProgress") {
//    return convertObjCObjectToJSIValue(runtime, NSMatchingProgress);
//  }
//  if (name == "NSMatchingReportCompletion") {
//    return convertObjCObjectToJSIValue(runtime, NSMatchingReportCompletion);
//  }
//  if (name == "NSMatchingReportProgress") {
//    return convertObjCObjectToJSIValue(runtime, NSMatchingReportProgress);
//  }
//  if (name == "NSMatchingRequiredEnd") {
//    return convertObjCObjectToJSIValue(runtime, NSMatchingRequiredEnd);
//  }
//  if (name == "NSMatchingWithTransparentBounds") {
//    return convertObjCObjectToJSIValue(runtime, NSMatchingWithTransparentBounds);
//  }
//  if (name == "NSMatchingWithoutAnchoringBounds") {
//    return convertObjCObjectToJSIValue(runtime, NSMatchingWithoutAnchoringBounds);
//  }
//  if (name == "NSMaximumKeyValueOperator") {
//    return convertObjCObjectToJSIValue(runtime, NSMaximumKeyValueOperator);
//  }
//  // TODO: NSMeasurement (Interface)
//  // TODO: NSMeasurementFormatter (Interface)
//  if (name == "NSMeasurementFormatterUnitOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"ProvidedUnit": NSMeasurementFormatterUnitOptionsProvidedUnit,
//        @"NaturalScale": NSMeasurementFormatterUnitOptionsNaturalScale,
//        @"TemperatureWithoutUnit": NSMeasurementFormatterUnitOptionsTemperatureWithoutUnit
//      }
//    );
//  }
//  if (name == "NSMeasurementFormatterUnitOptionsProvidedUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSMeasurementFormatterUnitOptionsProvidedUnit);
//  }
//  if (name == "NSMeasurementFormatterUnitOptionsNaturalScale") {
//    return convertObjCObjectToJSIValue(runtime, NSMeasurementFormatterUnitOptionsNaturalScale);
//  }
//  if (name == "NSMeasurementFormatterUnitOptionsTemperatureWithoutUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSMeasurementFormatterUnitOptionsTemperatureWithoutUnit);
//  }
//  if (name == "NSMeasurementFormatterUnitOptionsNaturalScale") {
//    return convertObjCObjectToJSIValue(runtime, NSMeasurementFormatterUnitOptionsNaturalScale);
//  }
//  if (name == "NSMeasurementFormatterUnitOptionsProvidedUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSMeasurementFormatterUnitOptionsProvidedUnit);
//  }
//  if (name == "NSMeasurementFormatterUnitOptionsTemperatureWithoutUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSMeasurementFormatterUnitOptionsTemperatureWithoutUnit);
//  }
//  // TODO: NSMessagePort (Interface)
//  // TODO: NSMetadataItem (Interface)
//  if (name == "NSMetadataItemContentTypeKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataItemContentTypeKey);
//  }
//  if (name == "NSMetadataItemContentTypeTreeKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataItemContentTypeTreeKey);
//  }
//  if (name == "NSMetadataItemDisplayNameKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataItemDisplayNameKey);
//  }
//  if (name == "NSMetadataItemFSContentChangeDateKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataItemFSContentChangeDateKey);
//  }
//  if (name == "NSMetadataItemFSCreationDateKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataItemFSCreationDateKey);
//  }
//  if (name == "NSMetadataItemFSNameKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataItemFSNameKey);
//  }
//  if (name == "NSMetadataItemFSSizeKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataItemFSSizeKey);
//  }
//  if (name == "NSMetadataItemIsUbiquitousKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataItemIsUbiquitousKey);
//  }
//  if (name == "NSMetadataItemPathKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataItemPathKey);
//  }
//  if (name == "NSMetadataItemURLKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataItemURLKey);
//  }
//  // TODO: NSMetadataQuery (Interface)
//  if (name == "NSMetadataQueryAccessibleUbiquitousExternalDocumentsScope") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataQueryAccessibleUbiquitousExternalDocumentsScope);
//  }
//  // TODO: NSMetadataQueryAttributeValueTuple (Interface)
//  // TODO: NSMetadataQueryDelegate (Protocol)
//  if (name == "NSMetadataQueryDidFinishGatheringNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataQueryDidFinishGatheringNotification);
//  }
//  if (name == "NSMetadataQueryDidStartGatheringNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataQueryDidStartGatheringNotification);
//  }
//  if (name == "NSMetadataQueryDidUpdateNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataQueryDidUpdateNotification);
//  }
//  if (name == "NSMetadataQueryGatheringProgressNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataQueryGatheringProgressNotification);
//  }
//  if (name == "NSMetadataQueryResultContentRelevanceAttribute") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataQueryResultContentRelevanceAttribute);
//  }
//  // TODO: NSMetadataQueryResultGroup (Interface)
//  if (name == "NSMetadataQueryUbiquitousDataScope") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataQueryUbiquitousDataScope);
//  }
//  if (name == "NSMetadataQueryUbiquitousDocumentsScope") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataQueryUbiquitousDocumentsScope);
//  }
//  if (name == "NSMetadataQueryUpdateAddedItemsKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataQueryUpdateAddedItemsKey);
//  }
//  if (name == "NSMetadataQueryUpdateChangedItemsKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataQueryUpdateChangedItemsKey);
//  }
//  if (name == "NSMetadataQueryUpdateRemovedItemsKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataQueryUpdateRemovedItemsKey);
//  }
//  if (name == "NSMetadataUbiquitousItemContainerDisplayNameKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousItemContainerDisplayNameKey);
//  }
//  if (name == "NSMetadataUbiquitousItemDownloadRequestedKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousItemDownloadRequestedKey);
//  }
//  if (name == "NSMetadataUbiquitousItemDownloadingErrorKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousItemDownloadingErrorKey);
//  }
//  if (name == "NSMetadataUbiquitousItemDownloadingStatusCurrent") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousItemDownloadingStatusCurrent);
//  }
//  if (name == "NSMetadataUbiquitousItemDownloadingStatusDownloaded") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousItemDownloadingStatusDownloaded);
//  }
//  if (name == "NSMetadataUbiquitousItemDownloadingStatusKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousItemDownloadingStatusKey);
//  }
//  if (name == "NSMetadataUbiquitousItemDownloadingStatusNotDownloaded") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousItemDownloadingStatusNotDownloaded);
//  }
//  if (name == "NSMetadataUbiquitousItemHasUnresolvedConflictsKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousItemHasUnresolvedConflictsKey);
//  }
//  if (name == "NSMetadataUbiquitousItemIsDownloadedKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousItemIsDownloadedKey);
//  }
//  if (name == "NSMetadataUbiquitousItemIsDownloadingKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousItemIsDownloadingKey);
//  }
//  if (name == "NSMetadataUbiquitousItemIsExternalDocumentKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousItemIsExternalDocumentKey);
//  }
//  if (name == "NSMetadataUbiquitousItemIsSharedKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousItemIsSharedKey);
//  }
//  if (name == "NSMetadataUbiquitousItemIsUploadedKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousItemIsUploadedKey);
//  }
//  if (name == "NSMetadataUbiquitousItemIsUploadingKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousItemIsUploadingKey);
//  }
//  if (name == "NSMetadataUbiquitousItemPercentDownloadedKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousItemPercentDownloadedKey);
//  }
//  if (name == "NSMetadataUbiquitousItemPercentUploadedKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousItemPercentUploadedKey);
//  }
//  if (name == "NSMetadataUbiquitousItemURLInLocalContainerKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousItemURLInLocalContainerKey);
//  }
//  if (name == "NSMetadataUbiquitousItemUploadingErrorKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousItemUploadingErrorKey);
//  }
//  if (name == "NSMetadataUbiquitousSharedItemCurrentUserPermissionsKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousSharedItemCurrentUserPermissionsKey);
//  }
//  if (name == "NSMetadataUbiquitousSharedItemCurrentUserRoleKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousSharedItemCurrentUserRoleKey);
//  }
//  if (name == "NSMetadataUbiquitousSharedItemMostRecentEditorNameComponentsKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousSharedItemMostRecentEditorNameComponentsKey);
//  }
//  if (name == "NSMetadataUbiquitousSharedItemOwnerNameComponentsKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousSharedItemOwnerNameComponentsKey);
//  }
//  if (name == "NSMetadataUbiquitousSharedItemPermissionsReadOnly") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousSharedItemPermissionsReadOnly);
//  }
//  if (name == "NSMetadataUbiquitousSharedItemPermissionsReadWrite") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousSharedItemPermissionsReadWrite);
//  }
//  if (name == "NSMetadataUbiquitousSharedItemRoleOwner") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousSharedItemRoleOwner);
//  }
//  if (name == "NSMetadataUbiquitousSharedItemRoleParticipant") {
//    return convertObjCObjectToJSIValue(runtime, NSMetadataUbiquitousSharedItemRoleParticipant);
//  }
//  // TODO: NSMethodSignature (Interface)
//  if (name == "NSMinimumKeyValueOperator") {
//    return convertObjCObjectToJSIValue(runtime, NSMinimumKeyValueOperator);
//  }
//  if (name == "NSMinusSetExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSMinusSetExpressionType);
//  }
//  if (name == "NSMinuteCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSMinuteCalendarUnit);
//  }
//  if (name == "NSMonthCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSMonthCalendarUnit);
//  }
//  // TODO: NSMorphology (Interface)
//  if (name == "NSMorphologyAttributeName") {
//    return convertObjCObjectToJSIValue(runtime, NSMorphologyAttributeName);
//  }
//  // TODO: NSMorphologyCustomPronoun (Interface)
//  if (name == "NSMoviesDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSMoviesDirectory);
//  }
//  if (name == "NSMultipleUnderlyingErrorsKey") {
//    return convertObjCObjectToJSIValue(runtime, NSMultipleUnderlyingErrorsKey);
//  }
//  if (name == "NSMusicDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSMusicDirectory);
//  }
//  // TODO: NSMutableArray (Interface)
//  // TODO: NSMutableAttributedString (Interface)
//  // TODO: NSMutableCharacterSet (Interface)
//  // TODO: NSMutableCopying (Protocol)
//  // TODO: NSMutableData (Interface)
//  // TODO: NSMutableDictionary (Interface)
//  // TODO: NSMutableIndexSet (Interface)
//  // TODO: NSMutableOrderedSet (Interface)
//  // TODO: NSMutableSet (Interface)
//  // TODO: NSMutableString (Interface)
//  // TODO: NSMutableURLRequest (Interface)
//  if (name == "NSNEXTSTEPStringEncoding") {
//    return convertObjCObjectToJSIValue(runtime, NSNEXTSTEPStringEncoding);
//  }
//  if (name == "NSNegateBooleanTransformerName") {
//    return convertObjCObjectToJSIValue(runtime, NSNegateBooleanTransformerName);
//  }
//  // TODO: NSNetService (Interface)
//  // TODO: NSNetServiceBrowser (Interface)
//  // TODO: NSNetServiceBrowserDelegate (Protocol)
//  // TODO: NSNetServiceDelegate (Protocol)
//  if (name == "NSNetServiceListenForConnections") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServiceListenForConnections);
//  }
//  if (name == "NSNetServiceNoAutoRename") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServiceNoAutoRename);
//  }
//  if (name == "NSNetServiceOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"NoAutoRename": NSNetServiceNoAutoRename,
//        @"ListenForConnections": NSNetServiceListenForConnections
//      }
//    );
//  }
//  if (name == "NSNetServiceNoAutoRename") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServiceNoAutoRename);
//  }
//  if (name == "NSNetServiceListenForConnections") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServiceListenForConnections);
//  }
//  if (name == "NSNetServicesActivityInProgress") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServicesActivityInProgress);
//  }
//  if (name == "NSNetServicesBadArgumentError") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServicesBadArgumentError);
//  }
//  if (name == "NSNetServicesCancelledError") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServicesCancelledError);
//  }
//  if (name == "NSNetServicesCollisionError") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServicesCollisionError);
//  }
//  if (name == "NSNetServicesError") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"UnknownError": NSNetServicesUnknownError,
//        @"CollisionError": NSNetServicesCollisionError,
//        @"NotFoundError": NSNetServicesNotFoundError,
//        @"ActivityInProgress": NSNetServicesActivityInProgress,
//        @"BadArgumentError": NSNetServicesBadArgumentError,
//        @"CancelledError": NSNetServicesCancelledError,
//        @"InvalidError": NSNetServicesInvalidError,
//        @"TimeoutError": NSNetServicesTimeoutError,
//        @"MissingRequiredConfigurationError": NSNetServicesMissingRequiredConfigurationError
//      }
//    );
//  }
//  if (name == "NSNetServicesUnknownError") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServicesUnknownError);
//  }
//  if (name == "NSNetServicesCollisionError") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServicesCollisionError);
//  }
//  if (name == "NSNetServicesNotFoundError") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServicesNotFoundError);
//  }
//  if (name == "NSNetServicesActivityInProgress") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServicesActivityInProgress);
//  }
//  if (name == "NSNetServicesBadArgumentError") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServicesBadArgumentError);
//  }
//  if (name == "NSNetServicesCancelledError") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServicesCancelledError);
//  }
//  if (name == "NSNetServicesInvalidError") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServicesInvalidError);
//  }
//  if (name == "NSNetServicesTimeoutError") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServicesTimeoutError);
//  }
//  if (name == "NSNetServicesMissingRequiredConfigurationError") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServicesMissingRequiredConfigurationError);
//  }
//  if (name == "NSNetServicesErrorCode") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServicesErrorCode);
//  }
//  if (name == "NSNetServicesErrorDomain") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServicesErrorDomain);
//  }
//  if (name == "NSNetServicesInvalidError") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServicesInvalidError);
//  }
//  if (name == "NSNetServicesMissingRequiredConfigurationError") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServicesMissingRequiredConfigurationError);
//  }
//  if (name == "NSNetServicesNotFoundError") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServicesNotFoundError);
//  }
//  if (name == "NSNetServicesTimeoutError") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServicesTimeoutError);
//  }
//  if (name == "NSNetServicesUnknownError") {
//    return convertObjCObjectToJSIValue(runtime, NSNetServicesUnknownError);
//  }
//  if (name == "NSNetworkDomainMask") {
//    return convertObjCObjectToJSIValue(runtime, NSNetworkDomainMask);
//  }
//  if (name == "NSNextHashEnumeratorItem") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSNextHashEnumeratorItem(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSNextHashEnumeratorItem"), 1, func);
//  }
//  if (name == "NSNextMapEnumeratorPair") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSNextMapEnumeratorPair(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSNextMapEnumeratorPair"), 3, func);
//  }
//  if (name == "NSNonLossyASCIIStringEncoding") {
//    return convertObjCObjectToJSIValue(runtime, NSNonLossyASCIIStringEncoding);
//  }
//  if (name == "NSNonOwnedPointerHashCallBacks") {
//    return convertObjCObjectToJSIValue(runtime, NSNonOwnedPointerHashCallBacks);
//  }
//  if (name == "NSNonOwnedPointerMapKeyCallBacks") {
//    return convertObjCObjectToJSIValue(runtime, NSNonOwnedPointerMapKeyCallBacks);
//  }
//  if (name == "NSNonOwnedPointerMapValueCallBacks") {
//    return convertObjCObjectToJSIValue(runtime, NSNonOwnedPointerMapValueCallBacks);
//  }
//  if (name == "NSNonOwnedPointerOrNullMapKeyCallBacks") {
//    return convertObjCObjectToJSIValue(runtime, NSNonOwnedPointerOrNullMapKeyCallBacks);
//  }
//  if (name == "NSNonRetainedObjectHashCallBacks") {
//    return convertObjCObjectToJSIValue(runtime, NSNonRetainedObjectHashCallBacks);
//  }
//  if (name == "NSNonRetainedObjectMapKeyCallBacks") {
//    return convertObjCObjectToJSIValue(runtime, NSNonRetainedObjectMapKeyCallBacks);
//  }
//  if (name == "NSNonRetainedObjectMapValueCallBacks") {
//    return convertObjCObjectToJSIValue(runtime, NSNonRetainedObjectMapValueCallBacks);
//  }
//  if (name == "NSNormalizedPredicateOption") {
//    return convertObjCObjectToJSIValue(runtime, NSNormalizedPredicateOption);
//  }
//  if (name == "NSNotEqualToPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSNotEqualToPredicateOperatorType);
//  }
//  if (name == "NSNotFound") {
//    return convertObjCObjectToJSIValue(runtime, NSNotFound);
//  }
//  if (name == "NSNotPredicateType") {
//    return convertObjCObjectToJSIValue(runtime, NSNotPredicateType);
//  }
//  // TODO: NSNotification (Interface)
//  // TODO: NSNotificationCenter (Interface)
//  if (name == "NSNotificationCoalescing") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"NoCoalescing": NSNotificationNoCoalescing,
//        @"CoalescingOnName": NSNotificationCoalescingOnName,
//        @"CoalescingOnSender": NSNotificationCoalescingOnSender
//      }
//    );
//  }
//  if (name == "NSNotificationNoCoalescing") {
//    return convertObjCObjectToJSIValue(runtime, NSNotificationNoCoalescing);
//  }
//  if (name == "NSNotificationCoalescingOnName") {
//    return convertObjCObjectToJSIValue(runtime, NSNotificationCoalescingOnName);
//  }
//  if (name == "NSNotificationCoalescingOnSender") {
//    return convertObjCObjectToJSIValue(runtime, NSNotificationCoalescingOnSender);
//  }
//  if (name == "NSNotificationCoalescingOnName") {
//    return convertObjCObjectToJSIValue(runtime, NSNotificationCoalescingOnName);
//  }
//  if (name == "NSNotificationCoalescingOnSender") {
//    return convertObjCObjectToJSIValue(runtime, NSNotificationCoalescingOnSender);
//  }
//  if (name == "NSNotificationNoCoalescing") {
//    return convertObjCObjectToJSIValue(runtime, NSNotificationNoCoalescing);
//  }
//  // TODO: NSNotificationQueue (Interface)
//  // TODO: NSNull (Interface)
//  // TODO: NSNumber (Interface)
//  // TODO: NSNumberFormatter (Interface)
//  if (name == "NSNumberFormatterBehavior") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"BehaviorDefault": NSNumberFormatterBehaviorDefault,
//        @"Behavior10_4": NSNumberFormatterBehavior10_4
//      }
//    );
//  }
//  if (name == "NSNumberFormatterBehaviorDefault") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterBehaviorDefault);
//  }
//  if (name == "NSNumberFormatterBehavior10_4") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterBehavior10_4);
//  }
//  if (name == "NSNumberFormatterBehavior10_4") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterBehavior10_4);
//  }
//  if (name == "NSNumberFormatterBehaviorDefault") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterBehaviorDefault);
//  }
//  if (name == "NSNumberFormatterCurrencyAccountingStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterCurrencyAccountingStyle);
//  }
//  if (name == "NSNumberFormatterCurrencyISOCodeStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterCurrencyISOCodeStyle);
//  }
//  if (name == "NSNumberFormatterCurrencyPluralStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterCurrencyPluralStyle);
//  }
//  if (name == "NSNumberFormatterCurrencyStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterCurrencyStyle);
//  }
//  if (name == "NSNumberFormatterDecimalStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterDecimalStyle);
//  }
//  if (name == "NSNumberFormatterNoStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterNoStyle);
//  }
//  if (name == "NSNumberFormatterOrdinalStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterOrdinalStyle);
//  }
//  if (name == "NSNumberFormatterPadAfterPrefix") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterPadAfterPrefix);
//  }
//  if (name == "NSNumberFormatterPadAfterSuffix") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterPadAfterSuffix);
//  }
//  if (name == "NSNumberFormatterPadBeforePrefix") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterPadBeforePrefix);
//  }
//  if (name == "NSNumberFormatterPadBeforeSuffix") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterPadBeforeSuffix);
//  }
//  if (name == "NSNumberFormatterPadPosition") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"BeforePrefix": NSNumberFormatterPadBeforePrefix,
//        @"AfterPrefix": NSNumberFormatterPadAfterPrefix,
//        @"BeforeSuffix": NSNumberFormatterPadBeforeSuffix,
//        @"AfterSuffix": NSNumberFormatterPadAfterSuffix
//      }
//    );
//  }
//  if (name == "NSNumberFormatterPadBeforePrefix") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterPadBeforePrefix);
//  }
//  if (name == "NSNumberFormatterPadAfterPrefix") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterPadAfterPrefix);
//  }
//  if (name == "NSNumberFormatterPadBeforeSuffix") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterPadBeforeSuffix);
//  }
//  if (name == "NSNumberFormatterPadAfterSuffix") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterPadAfterSuffix);
//  }
//  if (name == "NSNumberFormatterPercentStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterPercentStyle);
//  }
//  if (name == "NSNumberFormatterRoundCeiling") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterRoundCeiling);
//  }
//  if (name == "NSNumberFormatterRoundDown") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterRoundDown);
//  }
//  if (name == "NSNumberFormatterRoundFloor") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterRoundFloor);
//  }
//  if (name == "NSNumberFormatterRoundHalfDown") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterRoundHalfDown);
//  }
//  if (name == "NSNumberFormatterRoundHalfEven") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterRoundHalfEven);
//  }
//  if (name == "NSNumberFormatterRoundHalfUp") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterRoundHalfUp);
//  }
//  if (name == "NSNumberFormatterRoundUp") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterRoundUp);
//  }
//  if (name == "NSNumberFormatterRoundingMode") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Ceiling": NSNumberFormatterRoundCeiling,
//        @"Floor": NSNumberFormatterRoundFloor,
//        @"Down": NSNumberFormatterRoundDown,
//        @"Up": NSNumberFormatterRoundUp,
//        @"HalfEven": NSNumberFormatterRoundHalfEven,
//        @"HalfDown": NSNumberFormatterRoundHalfDown,
//        @"HalfUp": NSNumberFormatterRoundHalfUp
//      }
//    );
//  }
//  if (name == "NSNumberFormatterRoundCeiling") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterRoundCeiling);
//  }
//  if (name == "NSNumberFormatterRoundFloor") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterRoundFloor);
//  }
//  if (name == "NSNumberFormatterRoundDown") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterRoundDown);
//  }
//  if (name == "NSNumberFormatterRoundUp") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterRoundUp);
//  }
//  if (name == "NSNumberFormatterRoundHalfEven") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterRoundHalfEven);
//  }
//  if (name == "NSNumberFormatterRoundHalfDown") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterRoundHalfDown);
//  }
//  if (name == "NSNumberFormatterRoundHalfUp") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterRoundHalfUp);
//  }
//  if (name == "NSNumberFormatterScientificStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterScientificStyle);
//  }
//  if (name == "NSNumberFormatterSpellOutStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterSpellOutStyle);
//  }
//  if (name == "NSNumberFormatterStyle") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"NoStyle": NSNumberFormatterNoStyle,
//        @"DecimalStyle": NSNumberFormatterDecimalStyle,
//        @"CurrencyStyle": NSNumberFormatterCurrencyStyle,
//        @"PercentStyle": NSNumberFormatterPercentStyle,
//        @"ScientificStyle": NSNumberFormatterScientificStyle,
//        @"SpellOutStyle": NSNumberFormatterSpellOutStyle,
//        @"OrdinalStyle": NSNumberFormatterOrdinalStyle,
//        @"CurrencyISOCodeStyle": NSNumberFormatterCurrencyISOCodeStyle,
//        @"CurrencyPluralStyle": NSNumberFormatterCurrencyPluralStyle,
//        @"CurrencyAccountingStyle": NSNumberFormatterCurrencyAccountingStyle
//      }
//    );
//  }
//  if (name == "NSNumberFormatterNoStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterNoStyle);
//  }
//  if (name == "NSNumberFormatterDecimalStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterDecimalStyle);
//  }
//  if (name == "NSNumberFormatterCurrencyStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterCurrencyStyle);
//  }
//  if (name == "NSNumberFormatterPercentStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterPercentStyle);
//  }
//  if (name == "NSNumberFormatterScientificStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterScientificStyle);
//  }
//  if (name == "NSNumberFormatterSpellOutStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterSpellOutStyle);
//  }
//  if (name == "NSNumberFormatterOrdinalStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterOrdinalStyle);
//  }
//  if (name == "NSNumberFormatterCurrencyISOCodeStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterCurrencyISOCodeStyle);
//  }
//  if (name == "NSNumberFormatterCurrencyPluralStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterCurrencyPluralStyle);
//  }
//  if (name == "NSNumberFormatterCurrencyAccountingStyle") {
//    return convertObjCObjectToJSIValue(runtime, NSNumberFormatterCurrencyAccountingStyle);
//  }
//  if (name == "NSNumericSearch") {
//    return convertObjCObjectToJSIValue(runtime, NSNumericSearch);
//  }
//  if (name == "NSOSF1OperatingSystem") {
//    return convertObjCObjectToJSIValue(runtime, NSOSF1OperatingSystem);
//  }
//  if (name == "NSOSStatusErrorDomain") {
//    return convertObjCObjectToJSIValue(runtime, NSOSStatusErrorDomain);
//  }
//  if (name == "NSObjectHashCallBacks") {
//    return convertObjCObjectToJSIValue(runtime, NSObjectHashCallBacks);
//  }
//  if (name == "NSObjectInaccessibleException") {
//    return convertObjCObjectToJSIValue(runtime, NSObjectInaccessibleException);
//  }
//  if (name == "NSObjectMapKeyCallBacks") {
//    return convertObjCObjectToJSIValue(runtime, NSObjectMapKeyCallBacks);
//  }
//  if (name == "NSObjectMapValueCallBacks") {
//    return convertObjCObjectToJSIValue(runtime, NSObjectMapValueCallBacks);
//  }
//  if (name == "NSObjectNotAvailableException") {
//    return convertObjCObjectToJSIValue(runtime, NSObjectNotAvailableException);
//  }
//  if (name == "NSOldStyleException") {
//    return convertObjCObjectToJSIValue(runtime, NSOldStyleException);
//  }
//  if (name == "NSOpenStepRootDirectory") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSOpenStepRootDirectory();
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSOpenStepRootDirectory"), 0, func);
//  }
//  if (name == "NSOpenStepUnicodeReservedBase") {
//    return convertObjCObjectToJSIValue(runtime, NSOpenStepUnicodeReservedBase);
//  }
//  // TODO: NSOperatingSystemVersion (Struct)
//  // TODO: NSOperation (Interface)
//  // TODO: NSOperationQueue (Interface)
//  if (name == "NSOperationQueueDefaultMaxConcurrentOperationCount") {
//    return convertObjCObjectToJSIValue(runtime, NSOperationQueueDefaultMaxConcurrentOperationCount);
//  }
//  if (name == "NSOperationQueuePriority") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"VeryLow": NSOperationQueuePriorityVeryLow,
//        @"Low": NSOperationQueuePriorityLow,
//        @"Normal": NSOperationQueuePriorityNormal,
//        @"High": NSOperationQueuePriorityHigh,
//        @"VeryHigh": NSOperationQueuePriorityVeryHigh
//      }
//    );
//  }
//  if (name == "NSOperationQueuePriorityVeryLow") {
//    return convertObjCObjectToJSIValue(runtime, NSOperationQueuePriorityVeryLow);
//  }
//  if (name == "NSOperationQueuePriorityLow") {
//    return convertObjCObjectToJSIValue(runtime, NSOperationQueuePriorityLow);
//  }
//  if (name == "NSOperationQueuePriorityNormal") {
//    return convertObjCObjectToJSIValue(runtime, NSOperationQueuePriorityNormal);
//  }
//  if (name == "NSOperationQueuePriorityHigh") {
//    return convertObjCObjectToJSIValue(runtime, NSOperationQueuePriorityHigh);
//  }
//  if (name == "NSOperationQueuePriorityVeryHigh") {
//    return convertObjCObjectToJSIValue(runtime, NSOperationQueuePriorityVeryHigh);
//  }
//  if (name == "NSOperationQueuePriorityHigh") {
//    return convertObjCObjectToJSIValue(runtime, NSOperationQueuePriorityHigh);
//  }
//  if (name == "NSOperationQueuePriorityLow") {
//    return convertObjCObjectToJSIValue(runtime, NSOperationQueuePriorityLow);
//  }
//  if (name == "NSOperationQueuePriorityNormal") {
//    return convertObjCObjectToJSIValue(runtime, NSOperationQueuePriorityNormal);
//  }
//  if (name == "NSOperationQueuePriorityVeryHigh") {
//    return convertObjCObjectToJSIValue(runtime, NSOperationQueuePriorityVeryHigh);
//  }
//  if (name == "NSOperationQueuePriorityVeryLow") {
//    return convertObjCObjectToJSIValue(runtime, NSOperationQueuePriorityVeryLow);
//  }
//  if (name == "NSOrPredicateType") {
//    return convertObjCObjectToJSIValue(runtime, NSOrPredicateType);
//  }
//  if (name == "NSOrderedAscending") {
//    return convertObjCObjectToJSIValue(runtime, NSOrderedAscending);
//  }
//  // TODO: NSOrderedCollectionChange (Interface)
//  // TODO: NSOrderedCollectionDifference (Interface)
//  if (name == "NSOrderedCollectionDifferenceCalculationInferMoves") {
//    return convertObjCObjectToJSIValue(runtime, NSOrderedCollectionDifferenceCalculationInferMoves);
//  }
//  if (name == "NSOrderedCollectionDifferenceCalculationOmitInsertedObjects") {
//    return convertObjCObjectToJSIValue(runtime, NSOrderedCollectionDifferenceCalculationOmitInsertedObjects);
//  }
//  if (name == "NSOrderedCollectionDifferenceCalculationOmitRemovedObjects") {
//    return convertObjCObjectToJSIValue(runtime, NSOrderedCollectionDifferenceCalculationOmitRemovedObjects);
//  }
//  if (name == "NSOrderedCollectionDifferenceCalculationOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"OmitInsertedObjects": NSOrderedCollectionDifferenceCalculationOmitInsertedObjects,
//        @"OmitRemovedObjects": NSOrderedCollectionDifferenceCalculationOmitRemovedObjects,
//        @"InferMoves": NSOrderedCollectionDifferenceCalculationInferMoves
//      }
//    );
//  }
//  if (name == "NSOrderedCollectionDifferenceCalculationOmitInsertedObjects") {
//    return convertObjCObjectToJSIValue(runtime, NSOrderedCollectionDifferenceCalculationOmitInsertedObjects);
//  }
//  if (name == "NSOrderedCollectionDifferenceCalculationOmitRemovedObjects") {
//    return convertObjCObjectToJSIValue(runtime, NSOrderedCollectionDifferenceCalculationOmitRemovedObjects);
//  }
//  if (name == "NSOrderedCollectionDifferenceCalculationInferMoves") {
//    return convertObjCObjectToJSIValue(runtime, NSOrderedCollectionDifferenceCalculationInferMoves);
//  }
//  if (name == "NSOrderedDescending") {
//    return convertObjCObjectToJSIValue(runtime, NSOrderedDescending);
//  }
//  if (name == "NSOrderedSame") {
//    return convertObjCObjectToJSIValue(runtime, NSOrderedSame);
//  }
//  // TODO: NSOrderedSet (Interface)
//  // TODO: NSOrthography (Interface)
//  // TODO: NSOutputStream (Interface)
//  if (name == "NSOwnedObjectIdentityHashCallBacks") {
//    return convertObjCObjectToJSIValue(runtime, NSOwnedObjectIdentityHashCallBacks);
//  }
//  if (name == "NSOwnedPointerHashCallBacks") {
//    return convertObjCObjectToJSIValue(runtime, NSOwnedPointerHashCallBacks);
//  }
//  if (name == "NSOwnedPointerMapKeyCallBacks") {
//    return convertObjCObjectToJSIValue(runtime, NSOwnedPointerMapKeyCallBacks);
//  }
//  if (name == "NSOwnedPointerMapValueCallBacks") {
//    return convertObjCObjectToJSIValue(runtime, NSOwnedPointerMapValueCallBacks);
//  }
//  if (name == "NSPOSIXErrorDomain") {
//    return convertObjCObjectToJSIValue(runtime, NSPOSIXErrorDomain);
//  }
//  if (name == "NSPageSize") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSPageSize();
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSPageSize"), 0, func);
//  }
//  if (name == "NSParseErrorException") {
//    return convertObjCObjectToJSIValue(runtime, NSParseErrorException);
//  }
//  if (name == "NSPersianCalendar") {
//    return convertObjCObjectToJSIValue(runtime, NSPersianCalendar);
//  }
//  if (name == "NSPersonNameComponentDelimiter") {
//    return convertObjCObjectToJSIValue(runtime, NSPersonNameComponentDelimiter);
//  }
//  if (name == "NSPersonNameComponentFamilyName") {
//    return convertObjCObjectToJSIValue(runtime, NSPersonNameComponentFamilyName);
//  }
//  if (name == "NSPersonNameComponentGivenName") {
//    return convertObjCObjectToJSIValue(runtime, NSPersonNameComponentGivenName);
//  }
//  if (name == "NSPersonNameComponentKey") {
//    return convertObjCObjectToJSIValue(runtime, NSPersonNameComponentKey);
//  }
//  if (name == "NSPersonNameComponentMiddleName") {
//    return convertObjCObjectToJSIValue(runtime, NSPersonNameComponentMiddleName);
//  }
//  if (name == "NSPersonNameComponentNickname") {
//    return convertObjCObjectToJSIValue(runtime, NSPersonNameComponentNickname);
//  }
//  if (name == "NSPersonNameComponentPrefix") {
//    return convertObjCObjectToJSIValue(runtime, NSPersonNameComponentPrefix);
//  }
//  if (name == "NSPersonNameComponentSuffix") {
//    return convertObjCObjectToJSIValue(runtime, NSPersonNameComponentSuffix);
//  }
//  // TODO: NSPersonNameComponents (Interface)
//  // TODO: NSPersonNameComponentsFormatter (Interface)
//  if (name == "NSPersonNameComponentsFormatterOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Phonetic": NSPersonNameComponentsFormatterPhonetic
//      }
//    );
//  }
//  if (name == "NSPersonNameComponentsFormatterPhonetic") {
//    return convertObjCObjectToJSIValue(runtime, NSPersonNameComponentsFormatterPhonetic);
//  }
//  if (name == "NSPersonNameComponentsFormatterPhonetic") {
//    return convertObjCObjectToJSIValue(runtime, NSPersonNameComponentsFormatterPhonetic);
//  }
//  if (name == "NSPersonNameComponentsFormatterStyle") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Default": NSPersonNameComponentsFormatterStyleDefault,
//        @"Short": NSPersonNameComponentsFormatterStyleShort,
//        @"Medium": NSPersonNameComponentsFormatterStyleMedium,
//        @"Long": NSPersonNameComponentsFormatterStyleLong,
//        @"Abbreviated": NSPersonNameComponentsFormatterStyleAbbreviated
//      }
//    );
//  }
//  if (name == "NSPersonNameComponentsFormatterStyleDefault") {
//    return convertObjCObjectToJSIValue(runtime, NSPersonNameComponentsFormatterStyleDefault);
//  }
//  if (name == "NSPersonNameComponentsFormatterStyleShort") {
//    return convertObjCObjectToJSIValue(runtime, NSPersonNameComponentsFormatterStyleShort);
//  }
//  if (name == "NSPersonNameComponentsFormatterStyleMedium") {
//    return convertObjCObjectToJSIValue(runtime, NSPersonNameComponentsFormatterStyleMedium);
//  }
//  if (name == "NSPersonNameComponentsFormatterStyleLong") {
//    return convertObjCObjectToJSIValue(runtime, NSPersonNameComponentsFormatterStyleLong);
//  }
//  if (name == "NSPersonNameComponentsFormatterStyleAbbreviated") {
//    return convertObjCObjectToJSIValue(runtime, NSPersonNameComponentsFormatterStyleAbbreviated);
//  }
//  if (name == "NSPersonNameComponentsFormatterStyleAbbreviated") {
//    return convertObjCObjectToJSIValue(runtime, NSPersonNameComponentsFormatterStyleAbbreviated);
//  }
//  if (name == "NSPersonNameComponentsFormatterStyleDefault") {
//    return convertObjCObjectToJSIValue(runtime, NSPersonNameComponentsFormatterStyleDefault);
//  }
//  if (name == "NSPersonNameComponentsFormatterStyleLong") {
//    return convertObjCObjectToJSIValue(runtime, NSPersonNameComponentsFormatterStyleLong);
//  }
//  if (name == "NSPersonNameComponentsFormatterStyleMedium") {
//    return convertObjCObjectToJSIValue(runtime, NSPersonNameComponentsFormatterStyleMedium);
//  }
//  if (name == "NSPersonNameComponentsFormatterStyleShort") {
//    return convertObjCObjectToJSIValue(runtime, NSPersonNameComponentsFormatterStyleShort);
//  }
//  if (name == "NSPicturesDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSPicturesDirectory);
//  }
//  // TODO: NSPipe (Interface)
//  // TODO: NSPointerArray (Interface)
//  // TODO: NSPointerFunctions (Interface)
//  if (name == "NSPointerFunctionsCStringPersonality") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsCStringPersonality);
//  }
//  if (name == "NSPointerFunctionsCopyIn") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsCopyIn);
//  }
//  if (name == "NSPointerFunctionsIntegerPersonality") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsIntegerPersonality);
//  }
//  if (name == "NSPointerFunctionsMachVirtualMemory") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsMachVirtualMemory);
//  }
//  if (name == "NSPointerFunctionsMallocMemory") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsMallocMemory);
//  }
//  if (name == "NSPointerFunctionsObjectPersonality") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsObjectPersonality);
//  }
//  if (name == "NSPointerFunctionsObjectPointerPersonality") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsObjectPointerPersonality);
//  }
//  if (name == "NSPointerFunctionsOpaqueMemory") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsOpaqueMemory);
//  }
//  if (name == "NSPointerFunctionsOpaquePersonality") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsOpaquePersonality);
//  }
//  if (name == "NSPointerFunctionsOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"StrongMemory": NSPointerFunctionsStrongMemory,
//        @"ZeroingWeakMemory": NSPointerFunctionsZeroingWeakMemory,
//        @"OpaqueMemory": NSPointerFunctionsOpaqueMemory,
//        @"MallocMemory": NSPointerFunctionsMallocMemory,
//        @"MachVirtualMemory": NSPointerFunctionsMachVirtualMemory,
//        @"WeakMemory": NSPointerFunctionsWeakMemory,
//        @"ObjectPersonality": NSPointerFunctionsObjectPersonality,
//        @"OpaquePersonality": NSPointerFunctionsOpaquePersonality,
//        @"ObjectPointerPersonality": NSPointerFunctionsObjectPointerPersonality,
//        @"CStringPersonality": NSPointerFunctionsCStringPersonality,
//        @"StructPersonality": NSPointerFunctionsStructPersonality,
//        @"IntegerPersonality": NSPointerFunctionsIntegerPersonality,
//        @"CopyIn": NSPointerFunctionsCopyIn
//      }
//    );
//  }
//  if (name == "NSPointerFunctionsStrongMemory") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsStrongMemory);
//  }
//  if (name == "NSPointerFunctionsZeroingWeakMemory") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsZeroingWeakMemory);
//  }
//  if (name == "NSPointerFunctionsOpaqueMemory") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsOpaqueMemory);
//  }
//  if (name == "NSPointerFunctionsMallocMemory") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsMallocMemory);
//  }
//  if (name == "NSPointerFunctionsMachVirtualMemory") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsMachVirtualMemory);
//  }
//  if (name == "NSPointerFunctionsWeakMemory") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsWeakMemory);
//  }
//  if (name == "NSPointerFunctionsObjectPersonality") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsObjectPersonality);
//  }
//  if (name == "NSPointerFunctionsOpaquePersonality") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsOpaquePersonality);
//  }
//  if (name == "NSPointerFunctionsObjectPointerPersonality") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsObjectPointerPersonality);
//  }
//  if (name == "NSPointerFunctionsCStringPersonality") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsCStringPersonality);
//  }
//  if (name == "NSPointerFunctionsStructPersonality") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsStructPersonality);
//  }
//  if (name == "NSPointerFunctionsIntegerPersonality") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsIntegerPersonality);
//  }
//  if (name == "NSPointerFunctionsCopyIn") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsCopyIn);
//  }
//  if (name == "NSPointerFunctionsStrongMemory") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsStrongMemory);
//  }
//  if (name == "NSPointerFunctionsStructPersonality") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsStructPersonality);
//  }
//  if (name == "NSPointerFunctionsWeakMemory") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerFunctionsWeakMemory);
//  }
//  if (name == "NSPointerToStructHashCallBacks") {
//    return convertObjCObjectToJSIValue(runtime, NSPointerToStructHashCallBacks);
//  }
//  // TODO: NSPort (Interface)
//  // TODO: NSPortDelegate (Protocol)
//  if (name == "NSPortDidBecomeInvalidNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSPortDidBecomeInvalidNotification);
//  }
//  if (name == "NSPortReceiveException") {
//    return convertObjCObjectToJSIValue(runtime, NSPortReceiveException);
//  }
//  if (name == "NSPortSendException") {
//    return convertObjCObjectToJSIValue(runtime, NSPortSendException);
//  }
//  if (name == "NSPortTimeoutException") {
//    return convertObjCObjectToJSIValue(runtime, NSPortTimeoutException);
//  }
//  if (name == "NSPostASAP") {
//    return convertObjCObjectToJSIValue(runtime, NSPostASAP);
//  }
//  if (name == "NSPostNow") {
//    return convertObjCObjectToJSIValue(runtime, NSPostNow);
//  }
//  if (name == "NSPostWhenIdle") {
//    return convertObjCObjectToJSIValue(runtime, NSPostWhenIdle);
//  }
//  if (name == "NSPostingStyle") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"WhenIdle": NSPostWhenIdle,
//        @"ASAP": NSPostASAP,
//        @"Now": NSPostNow
//      }
//    );
//  }
//  if (name == "NSPostWhenIdle") {
//    return convertObjCObjectToJSIValue(runtime, NSPostWhenIdle);
//  }
//  if (name == "NSPostASAP") {
//    return convertObjCObjectToJSIValue(runtime, NSPostASAP);
//  }
//  if (name == "NSPostNow") {
//    return convertObjCObjectToJSIValue(runtime, NSPostNow);
//  }
//  // TODO: NSPredicate (Interface)
//  if (name == "NSPredicateOperatorType") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"LessThanPredicateOperatorType": NSLessThanPredicateOperatorType,
//        @"LessThanOrEqualToPredicateOperatorType": NSLessThanOrEqualToPredicateOperatorType,
//        @"GreaterThanPredicateOperatorType": NSGreaterThanPredicateOperatorType,
//        @"GreaterThanOrEqualToPredicateOperatorType": NSGreaterThanOrEqualToPredicateOperatorType,
//        @"EqualToPredicateOperatorType": NSEqualToPredicateOperatorType,
//        @"NotEqualToPredicateOperatorType": NSNotEqualToPredicateOperatorType,
//        @"MatchesPredicateOperatorType": NSMatchesPredicateOperatorType,
//        @"LikePredicateOperatorType": NSLikePredicateOperatorType,
//        @"BeginsWithPredicateOperatorType": NSBeginsWithPredicateOperatorType,
//        @"EndsWithPredicateOperatorType": NSEndsWithPredicateOperatorType,
//        @"InPredicateOperatorType": NSInPredicateOperatorType,
//        @"CustomSelectorPredicateOperatorType": NSCustomSelectorPredicateOperatorType,
//        @"ContainsPredicateOperatorType": NSContainsPredicateOperatorType,
//        @"BetweenPredicateOperatorType": NSBetweenPredicateOperatorType
//      }
//    );
//  }
//  if (name == "NSLessThanPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSLessThanPredicateOperatorType);
//  }
//  if (name == "NSLessThanOrEqualToPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSLessThanOrEqualToPredicateOperatorType);
//  }
//  if (name == "NSGreaterThanPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSGreaterThanPredicateOperatorType);
//  }
//  if (name == "NSGreaterThanOrEqualToPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSGreaterThanOrEqualToPredicateOperatorType);
//  }
//  if (name == "NSEqualToPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSEqualToPredicateOperatorType);
//  }
//  if (name == "NSNotEqualToPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSNotEqualToPredicateOperatorType);
//  }
//  if (name == "NSMatchesPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSMatchesPredicateOperatorType);
//  }
//  if (name == "NSLikePredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSLikePredicateOperatorType);
//  }
//  if (name == "NSBeginsWithPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSBeginsWithPredicateOperatorType);
//  }
//  if (name == "NSEndsWithPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSEndsWithPredicateOperatorType);
//  }
//  if (name == "NSInPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSInPredicateOperatorType);
//  }
//  if (name == "NSCustomSelectorPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSCustomSelectorPredicateOperatorType);
//  }
//  if (name == "NSContainsPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSContainsPredicateOperatorType);
//  }
//  if (name == "NSBetweenPredicateOperatorType") {
//    return convertObjCObjectToJSIValue(runtime, NSBetweenPredicateOperatorType);
//  }
//  if (name == "NSPreferencePanesDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSPreferencePanesDirectory);
//  }
//  // TODO: NSPresentationIntent (Interface)
//  if (name == "NSPresentationIntentAttributeName") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentAttributeName);
//  }
//  if (name == "NSPresentationIntentKind") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Paragraph": NSPresentationIntentKindParagraph,
//        @"Header": NSPresentationIntentKindHeader,
//        @"OrderedList": NSPresentationIntentKindOrderedList,
//        @"UnorderedList": NSPresentationIntentKindUnorderedList,
//        @"ListItem": NSPresentationIntentKindListItem,
//        @"CodeBlock": NSPresentationIntentKindCodeBlock,
//        @"BlockQuote": NSPresentationIntentKindBlockQuote,
//        @"ThematicBreak": NSPresentationIntentKindThematicBreak,
//        @"Table": NSPresentationIntentKindTable,
//        @"TableHeaderRow": NSPresentationIntentKindTableHeaderRow,
//        @"TableRow": NSPresentationIntentKindTableRow,
//        @"TableCell": NSPresentationIntentKindTableCell
//      }
//    );
//  }
//  if (name == "NSPresentationIntentKindParagraph") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindParagraph);
//  }
//  if (name == "NSPresentationIntentKindHeader") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindHeader);
//  }
//  if (name == "NSPresentationIntentKindOrderedList") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindOrderedList);
//  }
//  if (name == "NSPresentationIntentKindUnorderedList") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindUnorderedList);
//  }
//  if (name == "NSPresentationIntentKindListItem") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindListItem);
//  }
//  if (name == "NSPresentationIntentKindCodeBlock") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindCodeBlock);
//  }
//  if (name == "NSPresentationIntentKindBlockQuote") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindBlockQuote);
//  }
//  if (name == "NSPresentationIntentKindThematicBreak") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindThematicBreak);
//  }
//  if (name == "NSPresentationIntentKindTable") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindTable);
//  }
//  if (name == "NSPresentationIntentKindTableHeaderRow") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindTableHeaderRow);
//  }
//  if (name == "NSPresentationIntentKindTableRow") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindTableRow);
//  }
//  if (name == "NSPresentationIntentKindTableCell") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindTableCell);
//  }
//  if (name == "NSPresentationIntentKindBlockQuote") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindBlockQuote);
//  }
//  if (name == "NSPresentationIntentKindCodeBlock") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindCodeBlock);
//  }
//  if (name == "NSPresentationIntentKindHeader") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindHeader);
//  }
//  if (name == "NSPresentationIntentKindListItem") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindListItem);
//  }
//  if (name == "NSPresentationIntentKindOrderedList") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindOrderedList);
//  }
//  if (name == "NSPresentationIntentKindParagraph") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindParagraph);
//  }
//  if (name == "NSPresentationIntentKindTable") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindTable);
//  }
//  if (name == "NSPresentationIntentKindTableCell") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindTableCell);
//  }
//  if (name == "NSPresentationIntentKindTableHeaderRow") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindTableHeaderRow);
//  }
//  if (name == "NSPresentationIntentKindTableRow") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindTableRow);
//  }
//  if (name == "NSPresentationIntentKindThematicBreak") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindThematicBreak);
//  }
//  if (name == "NSPresentationIntentKindUnorderedList") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentKindUnorderedList);
//  }
//  if (name == "NSPresentationIntentTableColumnAlignment") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Left": NSPresentationIntentTableColumnAlignmentLeft,
//        @"Center": NSPresentationIntentTableColumnAlignmentCenter,
//        @"Right": NSPresentationIntentTableColumnAlignmentRight
//      }
//    );
//  }
//  if (name == "NSPresentationIntentTableColumnAlignmentLeft") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentTableColumnAlignmentLeft);
//  }
//  if (name == "NSPresentationIntentTableColumnAlignmentCenter") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentTableColumnAlignmentCenter);
//  }
//  if (name == "NSPresentationIntentTableColumnAlignmentRight") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentTableColumnAlignmentRight);
//  }
//  if (name == "NSPresentationIntentTableColumnAlignmentCenter") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentTableColumnAlignmentCenter);
//  }
//  if (name == "NSPresentationIntentTableColumnAlignmentLeft") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentTableColumnAlignmentLeft);
//  }
//  if (name == "NSPresentationIntentTableColumnAlignmentRight") {
//    return convertObjCObjectToJSIValue(runtime, NSPresentationIntentTableColumnAlignmentRight);
//  }
//  if (name == "NSPrinterDescriptionDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSPrinterDescriptionDirectory);
//  }
//  // TODO: NSProcessInfo (Interface)
//  if (name == "NSProcessInfoPowerStateDidChangeNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSProcessInfoPowerStateDidChangeNotification);
//  }
//  if (name == "NSProcessInfoThermalState") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Nominal": NSProcessInfoThermalStateNominal,
//        @"Fair": NSProcessInfoThermalStateFair,
//        @"Serious": NSProcessInfoThermalStateSerious,
//        @"Critical": NSProcessInfoThermalStateCritical
//      }
//    );
//  }
//  if (name == "NSProcessInfoThermalStateNominal") {
//    return convertObjCObjectToJSIValue(runtime, NSProcessInfoThermalStateNominal);
//  }
//  if (name == "NSProcessInfoThermalStateFair") {
//    return convertObjCObjectToJSIValue(runtime, NSProcessInfoThermalStateFair);
//  }
//  if (name == "NSProcessInfoThermalStateSerious") {
//    return convertObjCObjectToJSIValue(runtime, NSProcessInfoThermalStateSerious);
//  }
//  if (name == "NSProcessInfoThermalStateCritical") {
//    return convertObjCObjectToJSIValue(runtime, NSProcessInfoThermalStateCritical);
//  }
//  if (name == "NSProcessInfoThermalStateCritical") {
//    return convertObjCObjectToJSIValue(runtime, NSProcessInfoThermalStateCritical);
//  }
//  if (name == "NSProcessInfoThermalStateDidChangeNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSProcessInfoThermalStateDidChangeNotification);
//  }
//  if (name == "NSProcessInfoThermalStateFair") {
//    return convertObjCObjectToJSIValue(runtime, NSProcessInfoThermalStateFair);
//  }
//  if (name == "NSProcessInfoThermalStateNominal") {
//    return convertObjCObjectToJSIValue(runtime, NSProcessInfoThermalStateNominal);
//  }
//  if (name == "NSProcessInfoThermalStateSerious") {
//    return convertObjCObjectToJSIValue(runtime, NSProcessInfoThermalStateSerious);
//  }
//  // TODO: NSProgress (Interface)
//  if (name == "NSProgressEstimatedTimeRemainingKey") {
//    return convertObjCObjectToJSIValue(runtime, NSProgressEstimatedTimeRemainingKey);
//  }
//  if (name == "NSProgressFileCompletedCountKey") {
//    return convertObjCObjectToJSIValue(runtime, NSProgressFileCompletedCountKey);
//  }
//  if (name == "NSProgressFileOperationKindCopying") {
//    return convertObjCObjectToJSIValue(runtime, NSProgressFileOperationKindCopying);
//  }
//  if (name == "NSProgressFileOperationKindDecompressingAfterDownloading") {
//    return convertObjCObjectToJSIValue(runtime, NSProgressFileOperationKindDecompressingAfterDownloading);
//  }
//  if (name == "NSProgressFileOperationKindDownloading") {
//    return convertObjCObjectToJSIValue(runtime, NSProgressFileOperationKindDownloading);
//  }
//  if (name == "NSProgressFileOperationKindDuplicating") {
//    return convertObjCObjectToJSIValue(runtime, NSProgressFileOperationKindDuplicating);
//  }
//  if (name == "NSProgressFileOperationKindKey") {
//    return convertObjCObjectToJSIValue(runtime, NSProgressFileOperationKindKey);
//  }
//  if (name == "NSProgressFileOperationKindReceiving") {
//    return convertObjCObjectToJSIValue(runtime, NSProgressFileOperationKindReceiving);
//  }
//  if (name == "NSProgressFileOperationKindUploading") {
//    return convertObjCObjectToJSIValue(runtime, NSProgressFileOperationKindUploading);
//  }
//  if (name == "NSProgressFileTotalCountKey") {
//    return convertObjCObjectToJSIValue(runtime, NSProgressFileTotalCountKey);
//  }
//  if (name == "NSProgressFileURLKey") {
//    return convertObjCObjectToJSIValue(runtime, NSProgressFileURLKey);
//  }
//  if (name == "NSProgressKindFile") {
//    return convertObjCObjectToJSIValue(runtime, NSProgressKindFile);
//  }
//  // TODO: NSProgressReporting (Protocol)
//  if (name == "NSProgressThroughputKey") {
//    return convertObjCObjectToJSIValue(runtime, NSProgressThroughputKey);
//  }
//  if (name == "NSPropertyListBinaryFormat_v1_0") {
//    return convertObjCObjectToJSIValue(runtime, NSPropertyListBinaryFormat_v1_0);
//  }
//  if (name == "NSPropertyListErrorMaximum") {
//    return convertObjCObjectToJSIValue(runtime, NSPropertyListErrorMaximum);
//  }
//  if (name == "NSPropertyListErrorMinimum") {
//    return convertObjCObjectToJSIValue(runtime, NSPropertyListErrorMinimum);
//  }
//  if (name == "NSPropertyListFormat") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"OpenStepFormat": NSPropertyListOpenStepFormat,
//        @"XMLFormat_v1_0": NSPropertyListXMLFormat_v1_0,
//        @"BinaryFormat_v1_0": NSPropertyListBinaryFormat_v1_0
//      }
//    );
//  }
//  if (name == "NSPropertyListOpenStepFormat") {
//    return convertObjCObjectToJSIValue(runtime, NSPropertyListOpenStepFormat);
//  }
//  if (name == "NSPropertyListXMLFormat_v1_0") {
//    return convertObjCObjectToJSIValue(runtime, NSPropertyListXMLFormat_v1_0);
//  }
//  if (name == "NSPropertyListBinaryFormat_v1_0") {
//    return convertObjCObjectToJSIValue(runtime, NSPropertyListBinaryFormat_v1_0);
//  }
//  if (name == "NSPropertyListImmutable") {
//    return convertObjCObjectToJSIValue(runtime, NSPropertyListImmutable);
//  }
//  if (name == "NSPropertyListMutabilityOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Immutable": NSPropertyListImmutable,
//        @"MutableContainers": NSPropertyListMutableContainers,
//        @"MutableContainersAndLeaves": NSPropertyListMutableContainersAndLeaves
//      }
//    );
//  }
//  if (name == "NSPropertyListImmutable") {
//    return convertObjCObjectToJSIValue(runtime, NSPropertyListImmutable);
//  }
//  if (name == "NSPropertyListMutableContainers") {
//    return convertObjCObjectToJSIValue(runtime, NSPropertyListMutableContainers);
//  }
//  if (name == "NSPropertyListMutableContainersAndLeaves") {
//    return convertObjCObjectToJSIValue(runtime, NSPropertyListMutableContainersAndLeaves);
//  }
//  if (name == "NSPropertyListMutableContainers") {
//    return convertObjCObjectToJSIValue(runtime, NSPropertyListMutableContainers);
//  }
//  if (name == "NSPropertyListMutableContainersAndLeaves") {
//    return convertObjCObjectToJSIValue(runtime, NSPropertyListMutableContainersAndLeaves);
//  }
//  if (name == "NSPropertyListOpenStepFormat") {
//    return convertObjCObjectToJSIValue(runtime, NSPropertyListOpenStepFormat);
//  }
//  if (name == "NSPropertyListReadCorruptError") {
//    return convertObjCObjectToJSIValue(runtime, NSPropertyListReadCorruptError);
//  }
//  if (name == "NSPropertyListReadStreamError") {
//    return convertObjCObjectToJSIValue(runtime, NSPropertyListReadStreamError);
//  }
//  if (name == "NSPropertyListReadUnknownVersionError") {
//    return convertObjCObjectToJSIValue(runtime, NSPropertyListReadUnknownVersionError);
//  }
//  // TODO: NSPropertyListSerialization (Interface)
//  if (name == "NSPropertyListWriteInvalidError") {
//    return convertObjCObjectToJSIValue(runtime, NSPropertyListWriteInvalidError);
//  }
//  if (name == "NSPropertyListWriteStreamError") {
//    return convertObjCObjectToJSIValue(runtime, NSPropertyListWriteStreamError);
//  }
//  if (name == "NSPropertyListXMLFormat_v1_0") {
//    return convertObjCObjectToJSIValue(runtime, NSPropertyListXMLFormat_v1_0);
//  }
//  if (name == "NSProprietaryStringEncoding") {
//    return convertObjCObjectToJSIValue(runtime, NSProprietaryStringEncoding);
//  }
//  if (name == "NSProtocolFromString") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSProtocolFromString(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSProtocolFromString"), 1, func);
//  }
//  // TODO: NSProxy (Interface)
//  // TODO: NSPurgeableData (Interface)
//  if (name == "NSQualityOfService") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"UserInteractive": NSQualityOfServiceUserInteractive,
//        @"UserInitiated": NSQualityOfServiceUserInitiated,
//        @"Utility": NSQualityOfServiceUtility,
//        @"Background": NSQualityOfServiceBackground,
//        @"Default": NSQualityOfServiceDefault
//      }
//    );
//  }
//  if (name == "NSQualityOfServiceUserInteractive") {
//    return convertObjCObjectToJSIValue(runtime, NSQualityOfServiceUserInteractive);
//  }
//  if (name == "NSQualityOfServiceUserInitiated") {
//    return convertObjCObjectToJSIValue(runtime, NSQualityOfServiceUserInitiated);
//  }
//  if (name == "NSQualityOfServiceUtility") {
//    return convertObjCObjectToJSIValue(runtime, NSQualityOfServiceUtility);
//  }
//  if (name == "NSQualityOfServiceBackground") {
//    return convertObjCObjectToJSIValue(runtime, NSQualityOfServiceBackground);
//  }
//  if (name == "NSQualityOfServiceDefault") {
//    return convertObjCObjectToJSIValue(runtime, NSQualityOfServiceDefault);
//  }
//  if (name == "NSQualityOfServiceBackground") {
//    return convertObjCObjectToJSIValue(runtime, NSQualityOfServiceBackground);
//  }
//  if (name == "NSQualityOfServiceDefault") {
//    return convertObjCObjectToJSIValue(runtime, NSQualityOfServiceDefault);
//  }
//  if (name == "NSQualityOfServiceUserInitiated") {
//    return convertObjCObjectToJSIValue(runtime, NSQualityOfServiceUserInitiated);
//  }
//  if (name == "NSQualityOfServiceUserInteractive") {
//    return convertObjCObjectToJSIValue(runtime, NSQualityOfServiceUserInteractive);
//  }
//  if (name == "NSQualityOfServiceUtility") {
//    return convertObjCObjectToJSIValue(runtime, NSQualityOfServiceUtility);
//  }
//  if (name == "NSQuarterCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSQuarterCalendarUnit);
//  }
//  // TODO: NSRange (Struct)
//  if (name == "NSRangeException") {
//    return convertObjCObjectToJSIValue(runtime, NSRangeException);
//  }
//  if (name == "NSRangeFromString") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSRangeFromString(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSRangeFromString"), 1, func);
//  }
//  if (name == "NSRealMemoryAvailable") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSRealMemoryAvailable();
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSRealMemoryAvailable"), 0, func);
//  }
//  if (name == "NSRecoveryAttempterErrorKey") {
//    return convertObjCObjectToJSIValue(runtime, NSRecoveryAttempterErrorKey);
//  }
//  // TODO: NSRecursiveLock (Interface)
//  if (name == "NSRecycleZone") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSRecycleZone(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSRecycleZone"), 1, func);
//  }
//  if (name == "NSRegistrationDomain") {
//    return convertObjCObjectToJSIValue(runtime, NSRegistrationDomain);
//  }
//  // TODO: NSRegularExpression (Interface)
//  if (name == "NSRegularExpressionAllowCommentsAndWhitespace") {
//    return convertObjCObjectToJSIValue(runtime, NSRegularExpressionAllowCommentsAndWhitespace);
//  }
//  if (name == "NSRegularExpressionAnchorsMatchLines") {
//    return convertObjCObjectToJSIValue(runtime, NSRegularExpressionAnchorsMatchLines);
//  }
//  if (name == "NSRegularExpressionCaseInsensitive") {
//    return convertObjCObjectToJSIValue(runtime, NSRegularExpressionCaseInsensitive);
//  }
//  if (name == "NSRegularExpressionDotMatchesLineSeparators") {
//    return convertObjCObjectToJSIValue(runtime, NSRegularExpressionDotMatchesLineSeparators);
//  }
//  if (name == "NSRegularExpressionIgnoreMetacharacters") {
//    return convertObjCObjectToJSIValue(runtime, NSRegularExpressionIgnoreMetacharacters);
//  }
//  if (name == "NSRegularExpressionOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"CaseInsensitive": NSRegularExpressionCaseInsensitive,
//        @"AllowCommentsAndWhitespace": NSRegularExpressionAllowCommentsAndWhitespace,
//        @"IgnoreMetacharacters": NSRegularExpressionIgnoreMetacharacters,
//        @"DotMatchesLineSeparators": NSRegularExpressionDotMatchesLineSeparators,
//        @"AnchorsMatchLines": NSRegularExpressionAnchorsMatchLines,
//        @"UseUnixLineSeparators": NSRegularExpressionUseUnixLineSeparators,
//        @"UseUnicodeWordBoundaries": NSRegularExpressionUseUnicodeWordBoundaries
//      }
//    );
//  }
//  if (name == "NSRegularExpressionCaseInsensitive") {
//    return convertObjCObjectToJSIValue(runtime, NSRegularExpressionCaseInsensitive);
//  }
//  if (name == "NSRegularExpressionAllowCommentsAndWhitespace") {
//    return convertObjCObjectToJSIValue(runtime, NSRegularExpressionAllowCommentsAndWhitespace);
//  }
//  if (name == "NSRegularExpressionIgnoreMetacharacters") {
//    return convertObjCObjectToJSIValue(runtime, NSRegularExpressionIgnoreMetacharacters);
//  }
//  if (name == "NSRegularExpressionDotMatchesLineSeparators") {
//    return convertObjCObjectToJSIValue(runtime, NSRegularExpressionDotMatchesLineSeparators);
//  }
//  if (name == "NSRegularExpressionAnchorsMatchLines") {
//    return convertObjCObjectToJSIValue(runtime, NSRegularExpressionAnchorsMatchLines);
//  }
//  if (name == "NSRegularExpressionUseUnixLineSeparators") {
//    return convertObjCObjectToJSIValue(runtime, NSRegularExpressionUseUnixLineSeparators);
//  }
//  if (name == "NSRegularExpressionUseUnicodeWordBoundaries") {
//    return convertObjCObjectToJSIValue(runtime, NSRegularExpressionUseUnicodeWordBoundaries);
//  }
//  if (name == "NSRegularExpressionSearch") {
//    return convertObjCObjectToJSIValue(runtime, NSRegularExpressionSearch);
//  }
//  if (name == "NSRegularExpressionUseUnicodeWordBoundaries") {
//    return convertObjCObjectToJSIValue(runtime, NSRegularExpressionUseUnicodeWordBoundaries);
//  }
//  if (name == "NSRegularExpressionUseUnixLineSeparators") {
//    return convertObjCObjectToJSIValue(runtime, NSRegularExpressionUseUnixLineSeparators);
//  }
//  // TODO: NSRelativeDateTimeFormatter (Interface)
//  if (name == "NSRelativeDateTimeFormatterStyle") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Numeric": NSRelativeDateTimeFormatterStyleNumeric,
//        @"Named": NSRelativeDateTimeFormatterStyleNamed
//      }
//    );
//  }
//  if (name == "NSRelativeDateTimeFormatterStyleNumeric") {
//    return convertObjCObjectToJSIValue(runtime, NSRelativeDateTimeFormatterStyleNumeric);
//  }
//  if (name == "NSRelativeDateTimeFormatterStyleNamed") {
//    return convertObjCObjectToJSIValue(runtime, NSRelativeDateTimeFormatterStyleNamed);
//  }
//  if (name == "NSRelativeDateTimeFormatterStyleNamed") {
//    return convertObjCObjectToJSIValue(runtime, NSRelativeDateTimeFormatterStyleNamed);
//  }
//  if (name == "NSRelativeDateTimeFormatterStyleNumeric") {
//    return convertObjCObjectToJSIValue(runtime, NSRelativeDateTimeFormatterStyleNumeric);
//  }
//  if (name == "NSRelativeDateTimeFormatterUnitsStyle") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Full": NSRelativeDateTimeFormatterUnitsStyleFull,
//        @"SpellOut": NSRelativeDateTimeFormatterUnitsStyleSpellOut,
//        @"Short": NSRelativeDateTimeFormatterUnitsStyleShort,
//        @"Abbreviated": NSRelativeDateTimeFormatterUnitsStyleAbbreviated
//      }
//    );
//  }
//  if (name == "NSRelativeDateTimeFormatterUnitsStyleFull") {
//    return convertObjCObjectToJSIValue(runtime, NSRelativeDateTimeFormatterUnitsStyleFull);
//  }
//  if (name == "NSRelativeDateTimeFormatterUnitsStyleSpellOut") {
//    return convertObjCObjectToJSIValue(runtime, NSRelativeDateTimeFormatterUnitsStyleSpellOut);
//  }
//  if (name == "NSRelativeDateTimeFormatterUnitsStyleShort") {
//    return convertObjCObjectToJSIValue(runtime, NSRelativeDateTimeFormatterUnitsStyleShort);
//  }
//  if (name == "NSRelativeDateTimeFormatterUnitsStyleAbbreviated") {
//    return convertObjCObjectToJSIValue(runtime, NSRelativeDateTimeFormatterUnitsStyleAbbreviated);
//  }
//  if (name == "NSRelativeDateTimeFormatterUnitsStyleAbbreviated") {
//    return convertObjCObjectToJSIValue(runtime, NSRelativeDateTimeFormatterUnitsStyleAbbreviated);
//  }
//  if (name == "NSRelativeDateTimeFormatterUnitsStyleFull") {
//    return convertObjCObjectToJSIValue(runtime, NSRelativeDateTimeFormatterUnitsStyleFull);
//  }
//  if (name == "NSRelativeDateTimeFormatterUnitsStyleShort") {
//    return convertObjCObjectToJSIValue(runtime, NSRelativeDateTimeFormatterUnitsStyleShort);
//  }
//  if (name == "NSRelativeDateTimeFormatterUnitsStyleSpellOut") {
//    return convertObjCObjectToJSIValue(runtime, NSRelativeDateTimeFormatterUnitsStyleSpellOut);
//  }
//  if (name == "NSReplacementIndexAttributeName") {
//    return convertObjCObjectToJSIValue(runtime, NSReplacementIndexAttributeName);
//  }
//  if (name == "NSRepublicOfChinaCalendar") {
//    return convertObjCObjectToJSIValue(runtime, NSRepublicOfChinaCalendar);
//  }
//  if (name == "NSResetHashTable") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSResetHashTable(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSResetHashTable"), 1, func);
//  }
//  if (name == "NSResetMapTable") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSResetMapTable(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSResetMapTable"), 1, func);
//  }
//  if (name == "NSRoundBankers") {
//    return convertObjCObjectToJSIValue(runtime, NSRoundBankers);
//  }
//  if (name == "NSRoundDown") {
//    return convertObjCObjectToJSIValue(runtime, NSRoundDown);
//  }
//  if (name == "NSRoundDownToMultipleOfPageSize") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSRoundDownToMultipleOfPageSize(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSRoundDownToMultipleOfPageSize"), 1, func);
//  }
//  if (name == "NSRoundPlain") {
//    return convertObjCObjectToJSIValue(runtime, NSRoundPlain);
//  }
//  if (name == "NSRoundUp") {
//    return convertObjCObjectToJSIValue(runtime, NSRoundUp);
//  }
//  if (name == "NSRoundUpToMultipleOfPageSize") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSRoundUpToMultipleOfPageSize(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSRoundUpToMultipleOfPageSize"), 1, func);
//  }
//  if (name == "NSRoundingMode") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Plain": NSRoundPlain,
//        @"Down": NSRoundDown,
//        @"Up": NSRoundUp,
//        @"Bankers": NSRoundBankers
//      }
//    );
//  }
//  if (name == "NSRoundPlain") {
//    return convertObjCObjectToJSIValue(runtime, NSRoundPlain);
//  }
//  if (name == "NSRoundDown") {
//    return convertObjCObjectToJSIValue(runtime, NSRoundDown);
//  }
//  if (name == "NSRoundUp") {
//    return convertObjCObjectToJSIValue(runtime, NSRoundUp);
//  }
//  if (name == "NSRoundBankers") {
//    return convertObjCObjectToJSIValue(runtime, NSRoundBankers);
//  }
//  // TODO: NSRunLoop (Interface)
//  if (name == "NSRunLoopCommonModes") {
//    return convertObjCObjectToJSIValue(runtime, NSRunLoopCommonModes);
//  }
//  // TODO: NSScanner (Interface)
//  if (name == "NSSearchPathDirectory") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"ApplicationDirectory": NSApplicationDirectory,
//        @"DemoApplicationDirectory": NSDemoApplicationDirectory,
//        @"DeveloperApplicationDirectory": NSDeveloperApplicationDirectory,
//        @"AdminApplicationDirectory": NSAdminApplicationDirectory,
//        @"LibraryDirectory": NSLibraryDirectory,
//        @"DeveloperDirectory": NSDeveloperDirectory,
//        @"UserDirectory": NSUserDirectory,
//        @"DocumentationDirectory": NSDocumentationDirectory,
//        @"DocumentDirectory": NSDocumentDirectory,
//        @"CoreServiceDirectory": NSCoreServiceDirectory,
//        @"AutosavedInformationDirectory": NSAutosavedInformationDirectory,
//        @"DesktopDirectory": NSDesktopDirectory,
//        @"CachesDirectory": NSCachesDirectory,
//        @"ApplicationSupportDirectory": NSApplicationSupportDirectory,
//        @"DownloadsDirectory": NSDownloadsDirectory,
//        @"InputMethodsDirectory": NSInputMethodsDirectory,
//        @"MoviesDirectory": NSMoviesDirectory,
//        @"MusicDirectory": NSMusicDirectory,
//        @"PicturesDirectory": NSPicturesDirectory,
//        @"PrinterDescriptionDirectory": NSPrinterDescriptionDirectory,
//        @"SharedPublicDirectory": NSSharedPublicDirectory,
//        @"PreferencePanesDirectory": NSPreferencePanesDirectory,
//        @"ApplicationScriptsDirectory": NSApplicationScriptsDirectory,
//        @"ItemReplacementDirectory": NSItemReplacementDirectory,
//        @"AllApplicationsDirectory": NSAllApplicationsDirectory,
//        @"AllLibrariesDirectory": NSAllLibrariesDirectory,
//        @"TrashDirectory": NSTrashDirectory
//      }
//    );
//  }
//  if (name == "NSApplicationDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSApplicationDirectory);
//  }
//  if (name == "NSDemoApplicationDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSDemoApplicationDirectory);
//  }
//  if (name == "NSDeveloperApplicationDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSDeveloperApplicationDirectory);
//  }
//  if (name == "NSAdminApplicationDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSAdminApplicationDirectory);
//  }
//  if (name == "NSLibraryDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSLibraryDirectory);
//  }
//  if (name == "NSDeveloperDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSDeveloperDirectory);
//  }
//  if (name == "NSUserDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSUserDirectory);
//  }
//  if (name == "NSDocumentationDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSDocumentationDirectory);
//  }
//  if (name == "NSDocumentDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSDocumentDirectory);
//  }
//  if (name == "NSCoreServiceDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSCoreServiceDirectory);
//  }
//  if (name == "NSAutosavedInformationDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSAutosavedInformationDirectory);
//  }
//  if (name == "NSDesktopDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSDesktopDirectory);
//  }
//  if (name == "NSCachesDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSCachesDirectory);
//  }
//  if (name == "NSApplicationSupportDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSApplicationSupportDirectory);
//  }
//  if (name == "NSDownloadsDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSDownloadsDirectory);
//  }
//  if (name == "NSInputMethodsDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSInputMethodsDirectory);
//  }
//  if (name == "NSMoviesDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSMoviesDirectory);
//  }
//  if (name == "NSMusicDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSMusicDirectory);
//  }
//  if (name == "NSPicturesDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSPicturesDirectory);
//  }
//  if (name == "NSPrinterDescriptionDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSPrinterDescriptionDirectory);
//  }
//  if (name == "NSSharedPublicDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSSharedPublicDirectory);
//  }
//  if (name == "NSPreferencePanesDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSPreferencePanesDirectory);
//  }
//  if (name == "NSApplicationScriptsDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSApplicationScriptsDirectory);
//  }
//  if (name == "NSItemReplacementDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSItemReplacementDirectory);
//  }
//  if (name == "NSAllApplicationsDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSAllApplicationsDirectory);
//  }
//  if (name == "NSAllLibrariesDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSAllLibrariesDirectory);
//  }
//  if (name == "NSTrashDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSTrashDirectory);
//  }
//  if (name == "NSSearchPathDomainMask") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"UserDomainMask": NSUserDomainMask,
//        @"LocalDomainMask": NSLocalDomainMask,
//        @"NetworkDomainMask": NSNetworkDomainMask,
//        @"SystemDomainMask": NSSystemDomainMask,
//        @"AllDomainsMask": NSAllDomainsMask
//      }
//    );
//  }
//  if (name == "NSUserDomainMask") {
//    return convertObjCObjectToJSIValue(runtime, NSUserDomainMask);
//  }
//  if (name == "NSLocalDomainMask") {
//    return convertObjCObjectToJSIValue(runtime, NSLocalDomainMask);
//  }
//  if (name == "NSNetworkDomainMask") {
//    return convertObjCObjectToJSIValue(runtime, NSNetworkDomainMask);
//  }
//  if (name == "NSSystemDomainMask") {
//    return convertObjCObjectToJSIValue(runtime, NSSystemDomainMask);
//  }
//  if (name == "NSAllDomainsMask") {
//    return convertObjCObjectToJSIValue(runtime, NSAllDomainsMask);
//  }
//  if (name == "NSSearchPathForDirectoriesInDomains") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSSearchPathForDirectoriesInDomains(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSSearchPathForDirectoriesInDomains"), 3, func);
//  }
//  if (name == "NSSecondCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSSecondCalendarUnit);
//  }
//  // TODO: NSSecureCoding (Protocol)
//  // TODO: NSSecureUnarchiveFromDataTransformer (Interface)
//  if (name == "NSSecureUnarchiveFromDataTransformerName") {
//    return convertObjCObjectToJSIValue(runtime, NSSecureUnarchiveFromDataTransformerName);
//  }
//  if (name == "NSSelectorFromString") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSSelectorFromString(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSSelectorFromString"), 1, func);
//  }
//  // TODO: NSSet (Interface)
//  if (name == "NSSetUncaughtExceptionHandler") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSSetUncaughtExceptionHandler(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSSetUncaughtExceptionHandler"), 1, func);
//  }
//  if (name == "NSSetZoneName") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSSetZoneName(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSSetZoneName"), 2, func);
//  }
//  if (name == "NSSharedPublicDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSSharedPublicDirectory);
//  }
//  if (name == "NSShiftJISStringEncoding") {
//    return convertObjCObjectToJSIValue(runtime, NSShiftJISStringEncoding);
//  }
//  if (name == "NSShouldRetainWithZone") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSShouldRetainWithZone(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSShouldRetainWithZone"), 2, func);
//  }
//  // TODO: NSSimpleCString (Interface)
//  // TODO: NSSocketPort (Interface)
//  if (name == "NSSolarisOperatingSystem") {
//    return convertObjCObjectToJSIValue(runtime, NSSolarisOperatingSystem);
//  }
//  if (name == "NSSortConcurrent") {
//    return convertObjCObjectToJSIValue(runtime, NSSortConcurrent);
//  }
//  // TODO: NSSortDescriptor (Interface)
//  if (name == "NSSortOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Concurrent": NSSortConcurrent,
//        @"Stable": NSSortStable
//      }
//    );
//  }
//  if (name == "NSSortConcurrent") {
//    return convertObjCObjectToJSIValue(runtime, NSSortConcurrent);
//  }
//  if (name == "NSSortStable") {
//    return convertObjCObjectToJSIValue(runtime, NSSortStable);
//  }
//  if (name == "NSSortStable") {
//    return convertObjCObjectToJSIValue(runtime, NSSortStable);
//  }
//  // TODO: NSStream (Interface)
//  if (name == "NSStreamDataWrittenToMemoryStreamKey") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamDataWrittenToMemoryStreamKey);
//  }
//  // TODO: NSStreamDelegate (Protocol)
//  if (name == "NSStreamEvent") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"None": NSStreamEventNone,
//        @"OpenCompleted": NSStreamEventOpenCompleted,
//        @"HasBytesAvailable": NSStreamEventHasBytesAvailable,
//        @"HasSpaceAvailable": NSStreamEventHasSpaceAvailable,
//        @"ErrorOccurred": NSStreamEventErrorOccurred,
//        @"EndEncountered": NSStreamEventEndEncountered
//      }
//    );
//  }
//  if (name == "NSStreamEventNone") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamEventNone);
//  }
//  if (name == "NSStreamEventOpenCompleted") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamEventOpenCompleted);
//  }
//  if (name == "NSStreamEventHasBytesAvailable") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamEventHasBytesAvailable);
//  }
//  if (name == "NSStreamEventHasSpaceAvailable") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamEventHasSpaceAvailable);
//  }
//  if (name == "NSStreamEventErrorOccurred") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamEventErrorOccurred);
//  }
//  if (name == "NSStreamEventEndEncountered") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamEventEndEncountered);
//  }
//  if (name == "NSStreamEventEndEncountered") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamEventEndEncountered);
//  }
//  if (name == "NSStreamEventErrorOccurred") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamEventErrorOccurred);
//  }
//  if (name == "NSStreamEventHasBytesAvailable") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamEventHasBytesAvailable);
//  }
//  if (name == "NSStreamEventHasSpaceAvailable") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamEventHasSpaceAvailable);
//  }
//  if (name == "NSStreamEventNone") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamEventNone);
//  }
//  if (name == "NSStreamEventOpenCompleted") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamEventOpenCompleted);
//  }
//  if (name == "NSStreamFileCurrentOffsetKey") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamFileCurrentOffsetKey);
//  }
//  if (name == "NSStreamNetworkServiceType") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamNetworkServiceType);
//  }
//  if (name == "NSStreamNetworkServiceTypeBackground") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamNetworkServiceTypeBackground);
//  }
//  if (name == "NSStreamNetworkServiceTypeCallSignaling") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamNetworkServiceTypeCallSignaling);
//  }
//  if (name == "NSStreamNetworkServiceTypeVideo") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamNetworkServiceTypeVideo);
//  }
//  if (name == "NSStreamNetworkServiceTypeVoIP") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamNetworkServiceTypeVoIP);
//  }
//  if (name == "NSStreamNetworkServiceTypeVoice") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamNetworkServiceTypeVoice);
//  }
//  if (name == "NSStreamSOCKSErrorDomain") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamSOCKSErrorDomain);
//  }
//  if (name == "NSStreamSOCKSProxyConfigurationKey") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamSOCKSProxyConfigurationKey);
//  }
//  if (name == "NSStreamSOCKSProxyHostKey") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamSOCKSProxyHostKey);
//  }
//  if (name == "NSStreamSOCKSProxyPasswordKey") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamSOCKSProxyPasswordKey);
//  }
//  if (name == "NSStreamSOCKSProxyPortKey") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamSOCKSProxyPortKey);
//  }
//  if (name == "NSStreamSOCKSProxyUserKey") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamSOCKSProxyUserKey);
//  }
//  if (name == "NSStreamSOCKSProxyVersion4") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamSOCKSProxyVersion4);
//  }
//  if (name == "NSStreamSOCKSProxyVersion5") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamSOCKSProxyVersion5);
//  }
//  if (name == "NSStreamSOCKSProxyVersionKey") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamSOCKSProxyVersionKey);
//  }
//  if (name == "NSStreamSocketSSLErrorDomain") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamSocketSSLErrorDomain);
//  }
//  if (name == "NSStreamSocketSecurityLevelKey") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamSocketSecurityLevelKey);
//  }
//  if (name == "NSStreamSocketSecurityLevelNegotiatedSSL") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamSocketSecurityLevelNegotiatedSSL);
//  }
//  if (name == "NSStreamSocketSecurityLevelNone") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamSocketSecurityLevelNone);
//  }
//  if (name == "NSStreamSocketSecurityLevelSSLv2") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamSocketSecurityLevelSSLv2);
//  }
//  if (name == "NSStreamSocketSecurityLevelSSLv3") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamSocketSecurityLevelSSLv3);
//  }
//  if (name == "NSStreamSocketSecurityLevelTLSv1") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamSocketSecurityLevelTLSv1);
//  }
//  if (name == "NSStreamStatus") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"NotOpen": NSStreamStatusNotOpen,
//        @"Opening": NSStreamStatusOpening,
//        @"Open": NSStreamStatusOpen,
//        @"Reading": NSStreamStatusReading,
//        @"Writing": NSStreamStatusWriting,
//        @"AtEnd": NSStreamStatusAtEnd,
//        @"Closed": NSStreamStatusClosed,
//        @"Error": NSStreamStatusError
//      }
//    );
//  }
//  if (name == "NSStreamStatusNotOpen") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamStatusNotOpen);
//  }
//  if (name == "NSStreamStatusOpening") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamStatusOpening);
//  }
//  if (name == "NSStreamStatusOpen") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamStatusOpen);
//  }
//  if (name == "NSStreamStatusReading") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamStatusReading);
//  }
//  if (name == "NSStreamStatusWriting") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamStatusWriting);
//  }
//  if (name == "NSStreamStatusAtEnd") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamStatusAtEnd);
//  }
//  if (name == "NSStreamStatusClosed") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamStatusClosed);
//  }
//  if (name == "NSStreamStatusError") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamStatusError);
//  }
//  if (name == "NSStreamStatusAtEnd") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamStatusAtEnd);
//  }
//  if (name == "NSStreamStatusClosed") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamStatusClosed);
//  }
//  if (name == "NSStreamStatusError") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamStatusError);
//  }
//  if (name == "NSStreamStatusNotOpen") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamStatusNotOpen);
//  }
//  if (name == "NSStreamStatusOpen") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamStatusOpen);
//  }
//  if (name == "NSStreamStatusOpening") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamStatusOpening);
//  }
//  if (name == "NSStreamStatusReading") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamStatusReading);
//  }
//  if (name == "NSStreamStatusWriting") {
//    return convertObjCObjectToJSIValue(runtime, NSStreamStatusWriting);
//  }
//  // TODO: NSString (Interface)
//  if (name == "NSStringCompareOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"CaseInsensitiveSearch": NSCaseInsensitiveSearch,
//        @"LiteralSearch": NSLiteralSearch,
//        @"BackwardsSearch": NSBackwardsSearch,
//        @"AnchoredSearch": NSAnchoredSearch,
//        @"NumericSearch": NSNumericSearch,
//        @"DiacriticInsensitiveSearch": NSDiacriticInsensitiveSearch,
//        @"WidthInsensitiveSearch": NSWidthInsensitiveSearch,
//        @"ForcedOrderingSearch": NSForcedOrderingSearch,
//        @"RegularExpressionSearch": NSRegularExpressionSearch
//      }
//    );
//  }
//  if (name == "NSCaseInsensitiveSearch") {
//    return convertObjCObjectToJSIValue(runtime, NSCaseInsensitiveSearch);
//  }
//  if (name == "NSLiteralSearch") {
//    return convertObjCObjectToJSIValue(runtime, NSLiteralSearch);
//  }
//  if (name == "NSBackwardsSearch") {
//    return convertObjCObjectToJSIValue(runtime, NSBackwardsSearch);
//  }
//  if (name == "NSAnchoredSearch") {
//    return convertObjCObjectToJSIValue(runtime, NSAnchoredSearch);
//  }
//  if (name == "NSNumericSearch") {
//    return convertObjCObjectToJSIValue(runtime, NSNumericSearch);
//  }
//  if (name == "NSDiacriticInsensitiveSearch") {
//    return convertObjCObjectToJSIValue(runtime, NSDiacriticInsensitiveSearch);
//  }
//  if (name == "NSWidthInsensitiveSearch") {
//    return convertObjCObjectToJSIValue(runtime, NSWidthInsensitiveSearch);
//  }
//  if (name == "NSForcedOrderingSearch") {
//    return convertObjCObjectToJSIValue(runtime, NSForcedOrderingSearch);
//  }
//  if (name == "NSRegularExpressionSearch") {
//    return convertObjCObjectToJSIValue(runtime, NSRegularExpressionSearch);
//  }
//  if (name == "NSStringEncodingConversionAllowLossy") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEncodingConversionAllowLossy);
//  }
//  if (name == "NSStringEncodingConversionExternalRepresentation") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEncodingConversionExternalRepresentation);
//  }
//  if (name == "NSStringEncodingConversionOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"AllowLossy": NSStringEncodingConversionAllowLossy,
//        @"ExternalRepresentation": NSStringEncodingConversionExternalRepresentation
//      }
//    );
//  }
//  if (name == "NSStringEncodingConversionAllowLossy") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEncodingConversionAllowLossy);
//  }
//  if (name == "NSStringEncodingConversionExternalRepresentation") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEncodingConversionExternalRepresentation);
//  }
//  if (name == "NSStringEncodingDetectionAllowLossyKey") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEncodingDetectionAllowLossyKey);
//  }
//  if (name == "NSStringEncodingDetectionDisallowedEncodingsKey") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEncodingDetectionDisallowedEncodingsKey);
//  }
//  if (name == "NSStringEncodingDetectionFromWindowsKey") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEncodingDetectionFromWindowsKey);
//  }
//  if (name == "NSStringEncodingDetectionLikelyLanguageKey") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEncodingDetectionLikelyLanguageKey);
//  }
//  if (name == "NSStringEncodingDetectionLossySubstitutionKey") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEncodingDetectionLossySubstitutionKey);
//  }
//  if (name == "NSStringEncodingDetectionSuggestedEncodingsKey") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEncodingDetectionSuggestedEncodingsKey);
//  }
//  if (name == "NSStringEncodingDetectionUseOnlySuggestedEncodingsKey") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEncodingDetectionUseOnlySuggestedEncodingsKey);
//  }
//  if (name == "NSStringEncodingErrorKey") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEncodingErrorKey);
//  }
//  if (name == "NSStringEnumerationByCaretPositions") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEnumerationByCaretPositions);
//  }
//  if (name == "NSStringEnumerationByComposedCharacterSequences") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEnumerationByComposedCharacterSequences);
//  }
//  if (name == "NSStringEnumerationByDeletionClusters") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEnumerationByDeletionClusters);
//  }
//  if (name == "NSStringEnumerationByLines") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEnumerationByLines);
//  }
//  if (name == "NSStringEnumerationByParagraphs") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEnumerationByParagraphs);
//  }
//  if (name == "NSStringEnumerationBySentences") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEnumerationBySentences);
//  }
//  if (name == "NSStringEnumerationByWords") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEnumerationByWords);
//  }
//  if (name == "NSStringEnumerationLocalized") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEnumerationLocalized);
//  }
//  if (name == "NSStringEnumerationOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"ByLines": NSStringEnumerationByLines,
//        @"ByParagraphs": NSStringEnumerationByParagraphs,
//        @"ByComposedCharacterSequences": NSStringEnumerationByComposedCharacterSequences,
//        @"ByWords": NSStringEnumerationByWords,
//        @"BySentences": NSStringEnumerationBySentences,
//        @"ByCaretPositions": NSStringEnumerationByCaretPositions,
//        @"ByDeletionClusters": NSStringEnumerationByDeletionClusters,
//        @"Reverse": NSStringEnumerationReverse,
//        @"SubstringNotRequired": NSStringEnumerationSubstringNotRequired,
//        @"Localized": NSStringEnumerationLocalized
//      }
//    );
//  }
//  if (name == "NSStringEnumerationByLines") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEnumerationByLines);
//  }
//  if (name == "NSStringEnumerationByParagraphs") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEnumerationByParagraphs);
//  }
//  if (name == "NSStringEnumerationByComposedCharacterSequences") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEnumerationByComposedCharacterSequences);
//  }
//  if (name == "NSStringEnumerationByWords") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEnumerationByWords);
//  }
//  if (name == "NSStringEnumerationBySentences") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEnumerationBySentences);
//  }
//  if (name == "NSStringEnumerationByCaretPositions") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEnumerationByCaretPositions);
//  }
//  if (name == "NSStringEnumerationByDeletionClusters") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEnumerationByDeletionClusters);
//  }
//  if (name == "NSStringEnumerationReverse") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEnumerationReverse);
//  }
//  if (name == "NSStringEnumerationSubstringNotRequired") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEnumerationSubstringNotRequired);
//  }
//  if (name == "NSStringEnumerationLocalized") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEnumerationLocalized);
//  }
//  if (name == "NSStringEnumerationReverse") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEnumerationReverse);
//  }
//  if (name == "NSStringEnumerationSubstringNotRequired") {
//    return convertObjCObjectToJSIValue(runtime, NSStringEnumerationSubstringNotRequired);
//  }
//  if (name == "NSStringFromClass") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSStringFromClass(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSStringFromClass"), 1, func);
//  }
//  if (name == "NSStringFromHashTable") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSStringFromHashTable(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSStringFromHashTable"), 1, func);
//  }
//  if (name == "NSStringFromMapTable") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSStringFromMapTable(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSStringFromMapTable"), 1, func);
//  }
//  if (name == "NSStringFromProtocol") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSStringFromProtocol(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSStringFromProtocol"), 1, func);
//  }
//  if (name == "NSStringFromRange") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSStringFromRange(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSStringFromRange"), 1, func);
//  }
//  if (name == "NSStringFromSelector") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSStringFromSelector(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSStringFromSelector"), 1, func);
//  }
//  if (name == "NSStringTransformFullwidthToHalfwidth") {
//    return convertObjCObjectToJSIValue(runtime, NSStringTransformFullwidthToHalfwidth);
//  }
//  if (name == "NSStringTransformHiraganaToKatakana") {
//    return convertObjCObjectToJSIValue(runtime, NSStringTransformHiraganaToKatakana);
//  }
//  if (name == "NSStringTransformLatinToArabic") {
//    return convertObjCObjectToJSIValue(runtime, NSStringTransformLatinToArabic);
//  }
//  if (name == "NSStringTransformLatinToCyrillic") {
//    return convertObjCObjectToJSIValue(runtime, NSStringTransformLatinToCyrillic);
//  }
//  if (name == "NSStringTransformLatinToGreek") {
//    return convertObjCObjectToJSIValue(runtime, NSStringTransformLatinToGreek);
//  }
//  if (name == "NSStringTransformLatinToHangul") {
//    return convertObjCObjectToJSIValue(runtime, NSStringTransformLatinToHangul);
//  }
//  if (name == "NSStringTransformLatinToHebrew") {
//    return convertObjCObjectToJSIValue(runtime, NSStringTransformLatinToHebrew);
//  }
//  if (name == "NSStringTransformLatinToHiragana") {
//    return convertObjCObjectToJSIValue(runtime, NSStringTransformLatinToHiragana);
//  }
//  if (name == "NSStringTransformLatinToKatakana") {
//    return convertObjCObjectToJSIValue(runtime, NSStringTransformLatinToKatakana);
//  }
//  if (name == "NSStringTransformLatinToThai") {
//    return convertObjCObjectToJSIValue(runtime, NSStringTransformLatinToThai);
//  }
//  if (name == "NSStringTransformMandarinToLatin") {
//    return convertObjCObjectToJSIValue(runtime, NSStringTransformMandarinToLatin);
//  }
//  if (name == "NSStringTransformStripCombiningMarks") {
//    return convertObjCObjectToJSIValue(runtime, NSStringTransformStripCombiningMarks);
//  }
//  if (name == "NSStringTransformStripDiacritics") {
//    return convertObjCObjectToJSIValue(runtime, NSStringTransformStripDiacritics);
//  }
//  if (name == "NSStringTransformToLatin") {
//    return convertObjCObjectToJSIValue(runtime, NSStringTransformToLatin);
//  }
//  if (name == "NSStringTransformToUnicodeName") {
//    return convertObjCObjectToJSIValue(runtime, NSStringTransformToUnicodeName);
//  }
//  if (name == "NSStringTransformToXMLHex") {
//    return convertObjCObjectToJSIValue(runtime, NSStringTransformToXMLHex);
//  }
//  if (name == "NSSubqueryExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSSubqueryExpressionType);
//  }
//  if (name == "NSSumKeyValueOperator") {
//    return convertObjCObjectToJSIValue(runtime, NSSumKeyValueOperator);
//  }
//  if (name == "NSSunOSOperatingSystem") {
//    return convertObjCObjectToJSIValue(runtime, NSSunOSOperatingSystem);
//  }
//  // TODO: NSSwappedDouble (Struct)
//  // TODO: NSSwappedFloat (Struct)
//  if (name == "NSSymbolStringEncoding") {
//    return convertObjCObjectToJSIValue(runtime, NSSymbolStringEncoding);
//  }
//  if (name == "NSSystemClockDidChangeNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSSystemClockDidChangeNotification);
//  }
//  if (name == "NSSystemDomainMask") {
//    return convertObjCObjectToJSIValue(runtime, NSSystemDomainMask);
//  }
//  if (name == "NSSystemTimeZoneDidChangeNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSSystemTimeZoneDidChangeNotification);
//  }
//  if (name == "NSTemporaryDirectory") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSTemporaryDirectory();
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSTemporaryDirectory"), 0, func);
//  }
//  if (name == "NSTextCheckingAirlineKey") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingAirlineKey);
//  }
//  if (name == "NSTextCheckingAllCustomTypes") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingAllCustomTypes);
//  }
//  if (name == "NSTextCheckingAllSystemTypes") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingAllSystemTypes);
//  }
//  if (name == "NSTextCheckingAllTypes") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingAllTypes);
//  }
//  if (name == "NSTextCheckingCityKey") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingCityKey);
//  }
//  if (name == "NSTextCheckingCountryKey") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingCountryKey);
//  }
//  if (name == "NSTextCheckingFlightKey") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingFlightKey);
//  }
//  if (name == "NSTextCheckingJobTitleKey") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingJobTitleKey);
//  }
//  if (name == "NSTextCheckingNameKey") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingNameKey);
//  }
//  if (name == "NSTextCheckingOrganizationKey") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingOrganizationKey);
//  }
//  if (name == "NSTextCheckingPhoneKey") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingPhoneKey);
//  }
//  // TODO: NSTextCheckingResult (Interface)
//  if (name == "NSTextCheckingStateKey") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingStateKey);
//  }
//  if (name == "NSTextCheckingStreetKey") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingStreetKey);
//  }
//  if (name == "NSTextCheckingType") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Orthography": NSTextCheckingTypeOrthography,
//        @"Spelling": NSTextCheckingTypeSpelling,
//        @"Grammar": NSTextCheckingTypeGrammar,
//        @"Date": NSTextCheckingTypeDate,
//        @"Address": NSTextCheckingTypeAddress,
//        @"Link": NSTextCheckingTypeLink,
//        @"Quote": NSTextCheckingTypeQuote,
//        @"Dash": NSTextCheckingTypeDash,
//        @"Replacement": NSTextCheckingTypeReplacement,
//        @"Correction": NSTextCheckingTypeCorrection,
//        @"RegularExpression": NSTextCheckingTypeRegularExpression,
//        @"PhoneNumber": NSTextCheckingTypePhoneNumber,
//        @"TransitInformation": NSTextCheckingTypeTransitInformation
//      }
//    );
//  }
//  if (name == "NSTextCheckingTypeOrthography") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeOrthography);
//  }
//  if (name == "NSTextCheckingTypeSpelling") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeSpelling);
//  }
//  if (name == "NSTextCheckingTypeGrammar") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeGrammar);
//  }
//  if (name == "NSTextCheckingTypeDate") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeDate);
//  }
//  if (name == "NSTextCheckingTypeAddress") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeAddress);
//  }
//  if (name == "NSTextCheckingTypeLink") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeLink);
//  }
//  if (name == "NSTextCheckingTypeQuote") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeQuote);
//  }
//  if (name == "NSTextCheckingTypeDash") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeDash);
//  }
//  if (name == "NSTextCheckingTypeReplacement") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeReplacement);
//  }
//  if (name == "NSTextCheckingTypeCorrection") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeCorrection);
//  }
//  if (name == "NSTextCheckingTypeRegularExpression") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeRegularExpression);
//  }
//  if (name == "NSTextCheckingTypePhoneNumber") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypePhoneNumber);
//  }
//  if (name == "NSTextCheckingTypeTransitInformation") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeTransitInformation);
//  }
//  if (name == "NSTextCheckingTypeAddress") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeAddress);
//  }
//  if (name == "NSTextCheckingTypeCorrection") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeCorrection);
//  }
//  if (name == "NSTextCheckingTypeDash") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeDash);
//  }
//  if (name == "NSTextCheckingTypeDate") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeDate);
//  }
//  if (name == "NSTextCheckingTypeGrammar") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeGrammar);
//  }
//  if (name == "NSTextCheckingTypeLink") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeLink);
//  }
//  if (name == "NSTextCheckingTypeOrthography") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeOrthography);
//  }
//  if (name == "NSTextCheckingTypePhoneNumber") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypePhoneNumber);
//  }
//  if (name == "NSTextCheckingTypeQuote") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeQuote);
//  }
//  if (name == "NSTextCheckingTypeRegularExpression") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeRegularExpression);
//  }
//  if (name == "NSTextCheckingTypeReplacement") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeReplacement);
//  }
//  if (name == "NSTextCheckingTypeSpelling") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeSpelling);
//  }
//  if (name == "NSTextCheckingTypeTransitInformation") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingTypeTransitInformation);
//  }
//  if (name == "NSTextCheckingZIPKey") {
//    return convertObjCObjectToJSIValue(runtime, NSTextCheckingZIPKey);
//  }
//  // TODO: NSThread (Interface)
//  if (name == "NSThreadWillExitNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSThreadWillExitNotification);
//  }
//  if (name == "NSThumbnail1024x1024SizeKey") {
//    return convertObjCObjectToJSIValue(runtime, NSThumbnail1024x1024SizeKey);
//  }
//  // TODO: NSTimeZone (Interface)
//  if (name == "NSTimeZoneCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSTimeZoneCalendarUnit);
//  }
//  if (name == "NSTimeZoneNameStyle") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Standard": NSTimeZoneNameStyleStandard,
//        @"ShortStandard": NSTimeZoneNameStyleShortStandard,
//        @"DaylightSaving": NSTimeZoneNameStyleDaylightSaving,
//        @"ShortDaylightSaving": NSTimeZoneNameStyleShortDaylightSaving,
//        @"Generic": NSTimeZoneNameStyleGeneric,
//        @"ShortGeneric": NSTimeZoneNameStyleShortGeneric
//      }
//    );
//  }
//  if (name == "NSTimeZoneNameStyleStandard") {
//    return convertObjCObjectToJSIValue(runtime, NSTimeZoneNameStyleStandard);
//  }
//  if (name == "NSTimeZoneNameStyleShortStandard") {
//    return convertObjCObjectToJSIValue(runtime, NSTimeZoneNameStyleShortStandard);
//  }
//  if (name == "NSTimeZoneNameStyleDaylightSaving") {
//    return convertObjCObjectToJSIValue(runtime, NSTimeZoneNameStyleDaylightSaving);
//  }
//  if (name == "NSTimeZoneNameStyleShortDaylightSaving") {
//    return convertObjCObjectToJSIValue(runtime, NSTimeZoneNameStyleShortDaylightSaving);
//  }
//  if (name == "NSTimeZoneNameStyleGeneric") {
//    return convertObjCObjectToJSIValue(runtime, NSTimeZoneNameStyleGeneric);
//  }
//  if (name == "NSTimeZoneNameStyleShortGeneric") {
//    return convertObjCObjectToJSIValue(runtime, NSTimeZoneNameStyleShortGeneric);
//  }
//  if (name == "NSTimeZoneNameStyleDaylightSaving") {
//    return convertObjCObjectToJSIValue(runtime, NSTimeZoneNameStyleDaylightSaving);
//  }
//  if (name == "NSTimeZoneNameStyleGeneric") {
//    return convertObjCObjectToJSIValue(runtime, NSTimeZoneNameStyleGeneric);
//  }
//  if (name == "NSTimeZoneNameStyleShortDaylightSaving") {
//    return convertObjCObjectToJSIValue(runtime, NSTimeZoneNameStyleShortDaylightSaving);
//  }
//  if (name == "NSTimeZoneNameStyleShortGeneric") {
//    return convertObjCObjectToJSIValue(runtime, NSTimeZoneNameStyleShortGeneric);
//  }
//  if (name == "NSTimeZoneNameStyleShortStandard") {
//    return convertObjCObjectToJSIValue(runtime, NSTimeZoneNameStyleShortStandard);
//  }
//  if (name == "NSTimeZoneNameStyleStandard") {
//    return convertObjCObjectToJSIValue(runtime, NSTimeZoneNameStyleStandard);
//  }
//  // TODO: NSTimer (Interface)
//  if (name == "NSTrashDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSTrashDirectory);
//  }
//  // TODO: NSURL (Interface)
//  if (name == "NSURLAddedToDirectoryDateKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLAddedToDirectoryDateKey);
//  }
//  if (name == "NSURLAttributeModificationDateKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLAttributeModificationDateKey);
//  }
//  // TODO: NSURLAuthenticationChallenge (Interface)
//  // TODO: NSURLAuthenticationChallengeSender (Protocol)
//  if (name == "NSURLAuthenticationMethodClientCertificate") {
//    return convertObjCObjectToJSIValue(runtime, NSURLAuthenticationMethodClientCertificate);
//  }
//  if (name == "NSURLAuthenticationMethodDefault") {
//    return convertObjCObjectToJSIValue(runtime, NSURLAuthenticationMethodDefault);
//  }
//  if (name == "NSURLAuthenticationMethodHTMLForm") {
//    return convertObjCObjectToJSIValue(runtime, NSURLAuthenticationMethodHTMLForm);
//  }
//  if (name == "NSURLAuthenticationMethodHTTPBasic") {
//    return convertObjCObjectToJSIValue(runtime, NSURLAuthenticationMethodHTTPBasic);
//  }
//  if (name == "NSURLAuthenticationMethodHTTPDigest") {
//    return convertObjCObjectToJSIValue(runtime, NSURLAuthenticationMethodHTTPDigest);
//  }
//  if (name == "NSURLAuthenticationMethodNTLM") {
//    return convertObjCObjectToJSIValue(runtime, NSURLAuthenticationMethodNTLM);
//  }
//  if (name == "NSURLAuthenticationMethodNegotiate") {
//    return convertObjCObjectToJSIValue(runtime, NSURLAuthenticationMethodNegotiate);
//  }
//  if (name == "NSURLAuthenticationMethodServerTrust") {
//    return convertObjCObjectToJSIValue(runtime, NSURLAuthenticationMethodServerTrust);
//  }
//  if (name == "NSURLBookmarkCreationMinimalBookmark") {
//    return convertObjCObjectToJSIValue(runtime, NSURLBookmarkCreationMinimalBookmark);
//  }
//  if (name == "NSURLBookmarkCreationOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"PreferFileIDResolution": NSURLBookmarkCreationPreferFileIDResolution,
//        @"MinimalBookmark": NSURLBookmarkCreationMinimalBookmark,
//        @"SuitableForBookmarkFile": NSURLBookmarkCreationSuitableForBookmarkFile,
//        @"WithSecurityScope": NSURLBookmarkCreationWithSecurityScope,
//        @"SecurityScopeAllowOnlyReadAccess": NSURLBookmarkCreationSecurityScopeAllowOnlyReadAccess
//      }
//    );
//  }
//  if (name == "NSURLBookmarkCreationPreferFileIDResolution") {
//    return convertObjCObjectToJSIValue(runtime, NSURLBookmarkCreationPreferFileIDResolution);
//  }
//  if (name == "NSURLBookmarkCreationMinimalBookmark") {
//    return convertObjCObjectToJSIValue(runtime, NSURLBookmarkCreationMinimalBookmark);
//  }
//  if (name == "NSURLBookmarkCreationSuitableForBookmarkFile") {
//    return convertObjCObjectToJSIValue(runtime, NSURLBookmarkCreationSuitableForBookmarkFile);
//  }
//  if (name == "NSURLBookmarkCreationWithSecurityScope") {
//    return convertObjCObjectToJSIValue(runtime, NSURLBookmarkCreationWithSecurityScope);
//  }
//  if (name == "NSURLBookmarkCreationSecurityScopeAllowOnlyReadAccess") {
//    return convertObjCObjectToJSIValue(runtime, NSURLBookmarkCreationSecurityScopeAllowOnlyReadAccess);
//  }
//  if (name == "NSURLBookmarkCreationPreferFileIDResolution") {
//    return convertObjCObjectToJSIValue(runtime, NSURLBookmarkCreationPreferFileIDResolution);
//  }
//  if (name == "NSURLBookmarkCreationSuitableForBookmarkFile") {
//    return convertObjCObjectToJSIValue(runtime, NSURLBookmarkCreationSuitableForBookmarkFile);
//  }
//  if (name == "NSURLBookmarkResolutionOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"WithoutUI": NSURLBookmarkResolutionWithoutUI,
//        @"WithoutMounting": NSURLBookmarkResolutionWithoutMounting,
//        @"WithSecurityScope": NSURLBookmarkResolutionWithSecurityScope
//      }
//    );
//  }
//  if (name == "NSURLBookmarkResolutionWithoutUI") {
//    return convertObjCObjectToJSIValue(runtime, NSURLBookmarkResolutionWithoutUI);
//  }
//  if (name == "NSURLBookmarkResolutionWithoutMounting") {
//    return convertObjCObjectToJSIValue(runtime, NSURLBookmarkResolutionWithoutMounting);
//  }
//  if (name == "NSURLBookmarkResolutionWithSecurityScope") {
//    return convertObjCObjectToJSIValue(runtime, NSURLBookmarkResolutionWithSecurityScope);
//  }
//  if (name == "NSURLBookmarkResolutionWithoutMounting") {
//    return convertObjCObjectToJSIValue(runtime, NSURLBookmarkResolutionWithoutMounting);
//  }
//  if (name == "NSURLBookmarkResolutionWithoutUI") {
//    return convertObjCObjectToJSIValue(runtime, NSURLBookmarkResolutionWithoutUI);
//  }
//  // TODO: NSURLCache (Interface)
//  if (name == "NSURLCacheStorageAllowed") {
//    return convertObjCObjectToJSIValue(runtime, NSURLCacheStorageAllowed);
//  }
//  if (name == "NSURLCacheStorageAllowedInMemoryOnly") {
//    return convertObjCObjectToJSIValue(runtime, NSURLCacheStorageAllowedInMemoryOnly);
//  }
//  if (name == "NSURLCacheStorageNotAllowed") {
//    return convertObjCObjectToJSIValue(runtime, NSURLCacheStorageNotAllowed);
//  }
//  if (name == "NSURLCacheStoragePolicy") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Allowed": NSURLCacheStorageAllowed,
//        @"AllowedInMemoryOnly": NSURLCacheStorageAllowedInMemoryOnly,
//        @"NotAllowed": NSURLCacheStorageNotAllowed
//      }
//    );
//  }
//  if (name == "NSURLCacheStorageAllowed") {
//    return convertObjCObjectToJSIValue(runtime, NSURLCacheStorageAllowed);
//  }
//  if (name == "NSURLCacheStorageAllowedInMemoryOnly") {
//    return convertObjCObjectToJSIValue(runtime, NSURLCacheStorageAllowedInMemoryOnly);
//  }
//  if (name == "NSURLCacheStorageNotAllowed") {
//    return convertObjCObjectToJSIValue(runtime, NSURLCacheStorageNotAllowed);
//  }
//  if (name == "NSURLCanonicalPathKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLCanonicalPathKey);
//  }
//  // TODO: NSURLComponents (Interface)
//  // TODO: NSURLConnection (Interface)
//  // TODO: NSURLConnectionDataDelegate (Protocol)
//  // TODO: NSURLConnectionDelegate (Protocol)
//  // TODO: NSURLConnectionDownloadDelegate (Protocol)
//  if (name == "NSURLContentAccessDateKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLContentAccessDateKey);
//  }
//  if (name == "NSURLContentModificationDateKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLContentModificationDateKey);
//  }
//  if (name == "NSURLContentTypeKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLContentTypeKey);
//  }
//  if (name == "NSURLCreationDateKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLCreationDateKey);
//  }
//  // TODO: NSURLCredential (Interface)
//  if (name == "NSURLCredentialPersistence") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"None": NSURLCredentialPersistenceNone,
//        @"ForSession": NSURLCredentialPersistenceForSession,
//        @"Permanent": NSURLCredentialPersistencePermanent,
//        @"Synchronizable": NSURLCredentialPersistenceSynchronizable
//      }
//    );
//  }
//  if (name == "NSURLCredentialPersistenceNone") {
//    return convertObjCObjectToJSIValue(runtime, NSURLCredentialPersistenceNone);
//  }
//  if (name == "NSURLCredentialPersistenceForSession") {
//    return convertObjCObjectToJSIValue(runtime, NSURLCredentialPersistenceForSession);
//  }
//  if (name == "NSURLCredentialPersistencePermanent") {
//    return convertObjCObjectToJSIValue(runtime, NSURLCredentialPersistencePermanent);
//  }
//  if (name == "NSURLCredentialPersistenceSynchronizable") {
//    return convertObjCObjectToJSIValue(runtime, NSURLCredentialPersistenceSynchronizable);
//  }
//  if (name == "NSURLCredentialPersistenceForSession") {
//    return convertObjCObjectToJSIValue(runtime, NSURLCredentialPersistenceForSession);
//  }
//  if (name == "NSURLCredentialPersistenceNone") {
//    return convertObjCObjectToJSIValue(runtime, NSURLCredentialPersistenceNone);
//  }
//  if (name == "NSURLCredentialPersistencePermanent") {
//    return convertObjCObjectToJSIValue(runtime, NSURLCredentialPersistencePermanent);
//  }
//  if (name == "NSURLCredentialPersistenceSynchronizable") {
//    return convertObjCObjectToJSIValue(runtime, NSURLCredentialPersistenceSynchronizable);
//  }
//  // TODO: NSURLCredentialStorage (Interface)
//  if (name == "NSURLCredentialStorageChangedNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSURLCredentialStorageChangedNotification);
//  }
//  if (name == "NSURLCredentialStorageRemoveSynchronizableCredentials") {
//    return convertObjCObjectToJSIValue(runtime, NSURLCredentialStorageRemoveSynchronizableCredentials);
//  }
//  if (name == "NSURLCustomIconKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLCustomIconKey);
//  }
//  if (name == "NSURLDocumentIdentifierKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLDocumentIdentifierKey);
//  }
//  if (name == "NSURLEffectiveIconKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLEffectiveIconKey);
//  }
//  if (name == "NSURLErrorAppTransportSecurityRequiresSecureConnection") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorAppTransportSecurityRequiresSecureConnection);
//  }
//  if (name == "NSURLErrorBackgroundSessionInUseByAnotherProcess") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorBackgroundSessionInUseByAnotherProcess);
//  }
//  if (name == "NSURLErrorBackgroundSessionRequiresSharedContainer") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorBackgroundSessionRequiresSharedContainer);
//  }
//  if (name == "NSURLErrorBackgroundSessionWasDisconnected") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorBackgroundSessionWasDisconnected);
//  }
//  if (name == "NSURLErrorBackgroundTaskCancelledReasonKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorBackgroundTaskCancelledReasonKey);
//  }
//  if (name == "NSURLErrorBadServerResponse") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorBadServerResponse);
//  }
//  if (name == "NSURLErrorBadURL") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorBadURL);
//  }
//  if (name == "NSURLErrorCallIsActive") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorCallIsActive);
//  }
//  if (name == "NSURLErrorCancelled") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorCancelled);
//  }
//  if (name == "NSURLErrorCancelledReasonBackgroundUpdatesDisabled") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorCancelledReasonBackgroundUpdatesDisabled);
//  }
//  if (name == "NSURLErrorCancelledReasonInsufficientSystemResources") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorCancelledReasonInsufficientSystemResources);
//  }
//  if (name == "NSURLErrorCancelledReasonUserForceQuitApplication") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorCancelledReasonUserForceQuitApplication);
//  }
//  if (name == "NSURLErrorCannotCloseFile") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorCannotCloseFile);
//  }
//  if (name == "NSURLErrorCannotConnectToHost") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorCannotConnectToHost);
//  }
//  if (name == "NSURLErrorCannotCreateFile") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorCannotCreateFile);
//  }
//  if (name == "NSURLErrorCannotDecodeContentData") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorCannotDecodeContentData);
//  }
//  if (name == "NSURLErrorCannotDecodeRawData") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorCannotDecodeRawData);
//  }
//  if (name == "NSURLErrorCannotFindHost") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorCannotFindHost);
//  }
//  if (name == "NSURLErrorCannotLoadFromNetwork") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorCannotLoadFromNetwork);
//  }
//  if (name == "NSURLErrorCannotMoveFile") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorCannotMoveFile);
//  }
//  if (name == "NSURLErrorCannotOpenFile") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorCannotOpenFile);
//  }
//  if (name == "NSURLErrorCannotParseResponse") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorCannotParseResponse);
//  }
//  if (name == "NSURLErrorCannotRemoveFile") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorCannotRemoveFile);
//  }
//  if (name == "NSURLErrorCannotWriteToFile") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorCannotWriteToFile);
//  }
//  if (name == "NSURLErrorClientCertificateRejected") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorClientCertificateRejected);
//  }
//  if (name == "NSURLErrorClientCertificateRequired") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorClientCertificateRequired);
//  }
//  if (name == "NSURLErrorDNSLookupFailed") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorDNSLookupFailed);
//  }
//  if (name == "NSURLErrorDataLengthExceedsMaximum") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorDataLengthExceedsMaximum);
//  }
//  if (name == "NSURLErrorDataNotAllowed") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorDataNotAllowed);
//  }
//  if (name == "NSURLErrorDomain") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorDomain);
//  }
//  if (name == "NSURLErrorDownloadDecodingFailedMidStream") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorDownloadDecodingFailedMidStream);
//  }
//  if (name == "NSURLErrorDownloadDecodingFailedToComplete") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorDownloadDecodingFailedToComplete);
//  }
//  if (name == "NSURLErrorFailingURLErrorKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorFailingURLErrorKey);
//  }
//  if (name == "NSURLErrorFailingURLPeerTrustErrorKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorFailingURLPeerTrustErrorKey);
//  }
//  if (name == "NSURLErrorFailingURLStringErrorKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorFailingURLStringErrorKey);
//  }
//  if (name == "NSURLErrorFileDoesNotExist") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorFileDoesNotExist);
//  }
//  if (name == "NSURLErrorFileIsDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorFileIsDirectory);
//  }
//  if (name == "NSURLErrorFileOutsideSafeArea") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorFileOutsideSafeArea);
//  }
//  if (name == "NSURLErrorHTTPTooManyRedirects") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorHTTPTooManyRedirects);
//  }
//  if (name == "NSURLErrorInternationalRoamingOff") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorInternationalRoamingOff);
//  }
//  if (name == "NSURLErrorKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorKey);
//  }
//  if (name == "NSURLErrorNetworkConnectionLost") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorNetworkConnectionLost);
//  }
//  if (name == "NSURLErrorNetworkUnavailableReason") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Cellular": NSURLErrorNetworkUnavailableReasonCellular,
//        @"Expensive": NSURLErrorNetworkUnavailableReasonExpensive,
//        @"Constrained": NSURLErrorNetworkUnavailableReasonConstrained
//      }
//    );
//  }
//  if (name == "NSURLErrorNetworkUnavailableReasonCellular") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorNetworkUnavailableReasonCellular);
//  }
//  if (name == "NSURLErrorNetworkUnavailableReasonExpensive") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorNetworkUnavailableReasonExpensive);
//  }
//  if (name == "NSURLErrorNetworkUnavailableReasonConstrained") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorNetworkUnavailableReasonConstrained);
//  }
//  if (name == "NSURLErrorNetworkUnavailableReasonCellular") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorNetworkUnavailableReasonCellular);
//  }
//  if (name == "NSURLErrorNetworkUnavailableReasonConstrained") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorNetworkUnavailableReasonConstrained);
//  }
//  if (name == "NSURLErrorNetworkUnavailableReasonExpensive") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorNetworkUnavailableReasonExpensive);
//  }
//  if (name == "NSURLErrorNetworkUnavailableReasonKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorNetworkUnavailableReasonKey);
//  }
//  if (name == "NSURLErrorNoPermissionsToReadFile") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorNoPermissionsToReadFile);
//  }
//  if (name == "NSURLErrorNotConnectedToInternet") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorNotConnectedToInternet);
//  }
//  if (name == "NSURLErrorRedirectToNonExistentLocation") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorRedirectToNonExistentLocation);
//  }
//  if (name == "NSURLErrorRequestBodyStreamExhausted") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorRequestBodyStreamExhausted);
//  }
//  if (name == "NSURLErrorResourceUnavailable") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorResourceUnavailable);
//  }
//  if (name == "NSURLErrorSecureConnectionFailed") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorSecureConnectionFailed);
//  }
//  if (name == "NSURLErrorServerCertificateHasBadDate") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorServerCertificateHasBadDate);
//  }
//  if (name == "NSURLErrorServerCertificateHasUnknownRoot") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorServerCertificateHasUnknownRoot);
//  }
//  if (name == "NSURLErrorServerCertificateNotYetValid") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorServerCertificateNotYetValid);
//  }
//  if (name == "NSURLErrorServerCertificateUntrusted") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorServerCertificateUntrusted);
//  }
//  if (name == "NSURLErrorTimedOut") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorTimedOut);
//  }
//  if (name == "NSURLErrorUnknown") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorUnknown);
//  }
//  if (name == "NSURLErrorUnsupportedURL") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorUnsupportedURL);
//  }
//  if (name == "NSURLErrorUserAuthenticationRequired") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorUserAuthenticationRequired);
//  }
//  if (name == "NSURLErrorUserCancelledAuthentication") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorUserCancelledAuthentication);
//  }
//  if (name == "NSURLErrorZeroByteResource") {
//    return convertObjCObjectToJSIValue(runtime, NSURLErrorZeroByteResource);
//  }
//  if (name == "NSURLFileAllocatedSizeKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLFileAllocatedSizeKey);
//  }
//  if (name == "NSURLFileContentIdentifierKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLFileContentIdentifierKey);
//  }
//  if (name == "NSURLFileProtectionComplete") {
//    return convertObjCObjectToJSIValue(runtime, NSURLFileProtectionComplete);
//  }
//  if (name == "NSURLFileProtectionCompleteUnlessOpen") {
//    return convertObjCObjectToJSIValue(runtime, NSURLFileProtectionCompleteUnlessOpen);
//  }
//  if (name == "NSURLFileProtectionCompleteUntilFirstUserAuthentication") {
//    return convertObjCObjectToJSIValue(runtime, NSURLFileProtectionCompleteUntilFirstUserAuthentication);
//  }
//  if (name == "NSURLFileProtectionKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLFileProtectionKey);
//  }
//  if (name == "NSURLFileProtectionNone") {
//    return convertObjCObjectToJSIValue(runtime, NSURLFileProtectionNone);
//  }
//  if (name == "NSURLFileResourceIdentifierKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLFileResourceIdentifierKey);
//  }
//  if (name == "NSURLFileResourceTypeBlockSpecial") {
//    return convertObjCObjectToJSIValue(runtime, NSURLFileResourceTypeBlockSpecial);
//  }
//  if (name == "NSURLFileResourceTypeCharacterSpecial") {
//    return convertObjCObjectToJSIValue(runtime, NSURLFileResourceTypeCharacterSpecial);
//  }
//  if (name == "NSURLFileResourceTypeDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSURLFileResourceTypeDirectory);
//  }
//  if (name == "NSURLFileResourceTypeKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLFileResourceTypeKey);
//  }
//  if (name == "NSURLFileResourceTypeNamedPipe") {
//    return convertObjCObjectToJSIValue(runtime, NSURLFileResourceTypeNamedPipe);
//  }
//  if (name == "NSURLFileResourceTypeRegular") {
//    return convertObjCObjectToJSIValue(runtime, NSURLFileResourceTypeRegular);
//  }
//  if (name == "NSURLFileResourceTypeSocket") {
//    return convertObjCObjectToJSIValue(runtime, NSURLFileResourceTypeSocket);
//  }
//  if (name == "NSURLFileResourceTypeSymbolicLink") {
//    return convertObjCObjectToJSIValue(runtime, NSURLFileResourceTypeSymbolicLink);
//  }
//  if (name == "NSURLFileResourceTypeUnknown") {
//    return convertObjCObjectToJSIValue(runtime, NSURLFileResourceTypeUnknown);
//  }
//  if (name == "NSURLFileScheme") {
//    return convertObjCObjectToJSIValue(runtime, NSURLFileScheme);
//  }
//  if (name == "NSURLFileSecurityKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLFileSecurityKey);
//  }
//  if (name == "NSURLFileSizeKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLFileSizeKey);
//  }
//  if (name == "NSURLGenerationIdentifierKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLGenerationIdentifierKey);
//  }
//  if (name == "NSURLHasHiddenExtensionKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLHasHiddenExtensionKey);
//  }
//  if (name == "NSURLIsAliasFileKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLIsAliasFileKey);
//  }
//  if (name == "NSURLIsApplicationKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLIsApplicationKey);
//  }
//  if (name == "NSURLIsDirectoryKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLIsDirectoryKey);
//  }
//  if (name == "NSURLIsExcludedFromBackupKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLIsExcludedFromBackupKey);
//  }
//  if (name == "NSURLIsExecutableKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLIsExecutableKey);
//  }
//  if (name == "NSURLIsHiddenKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLIsHiddenKey);
//  }
//  if (name == "NSURLIsMountTriggerKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLIsMountTriggerKey);
//  }
//  if (name == "NSURLIsPackageKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLIsPackageKey);
//  }
//  if (name == "NSURLIsPurgeableKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLIsPurgeableKey);
//  }
//  if (name == "NSURLIsReadableKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLIsReadableKey);
//  }
//  if (name == "NSURLIsRegularFileKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLIsRegularFileKey);
//  }
//  if (name == "NSURLIsSparseKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLIsSparseKey);
//  }
//  if (name == "NSURLIsSymbolicLinkKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLIsSymbolicLinkKey);
//  }
//  if (name == "NSURLIsSystemImmutableKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLIsSystemImmutableKey);
//  }
//  if (name == "NSURLIsUbiquitousItemKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLIsUbiquitousItemKey);
//  }
//  if (name == "NSURLIsUserImmutableKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLIsUserImmutableKey);
//  }
//  if (name == "NSURLIsVolumeKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLIsVolumeKey);
//  }
//  if (name == "NSURLIsWritableKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLIsWritableKey);
//  }
//  if (name == "NSURLKeysOfUnsetValuesKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLKeysOfUnsetValuesKey);
//  }
//  if (name == "NSURLLabelColorKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLLabelColorKey);
//  }
//  if (name == "NSURLLabelNumberKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLLabelNumberKey);
//  }
//  if (name == "NSURLLinkCountKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLLinkCountKey);
//  }
//  if (name == "NSURLLocalizedLabelKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLLocalizedLabelKey);
//  }
//  if (name == "NSURLLocalizedNameKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLLocalizedNameKey);
//  }
//  if (name == "NSURLLocalizedTypeDescriptionKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLLocalizedTypeDescriptionKey);
//  }
//  if (name == "NSURLMayHaveExtendedAttributesKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLMayHaveExtendedAttributesKey);
//  }
//  if (name == "NSURLMayShareFileContentKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLMayShareFileContentKey);
//  }
//  if (name == "NSURLNameKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLNameKey);
//  }
//  if (name == "NSURLNetworkServiceTypeAVStreaming") {
//    return convertObjCObjectToJSIValue(runtime, NSURLNetworkServiceTypeAVStreaming);
//  }
//  if (name == "NSURLNetworkServiceTypeBackground") {
//    return convertObjCObjectToJSIValue(runtime, NSURLNetworkServiceTypeBackground);
//  }
//  if (name == "NSURLNetworkServiceTypeCallSignaling") {
//    return convertObjCObjectToJSIValue(runtime, NSURLNetworkServiceTypeCallSignaling);
//  }
//  if (name == "NSURLNetworkServiceTypeDefault") {
//    return convertObjCObjectToJSIValue(runtime, NSURLNetworkServiceTypeDefault);
//  }
//  if (name == "NSURLNetworkServiceTypeResponsiveAV") {
//    return convertObjCObjectToJSIValue(runtime, NSURLNetworkServiceTypeResponsiveAV);
//  }
//  if (name == "NSURLNetworkServiceTypeResponsiveData") {
//    return convertObjCObjectToJSIValue(runtime, NSURLNetworkServiceTypeResponsiveData);
//  }
//  if (name == "NSURLNetworkServiceTypeVideo") {
//    return convertObjCObjectToJSIValue(runtime, NSURLNetworkServiceTypeVideo);
//  }
//  if (name == "NSURLNetworkServiceTypeVoIP") {
//    return convertObjCObjectToJSIValue(runtime, NSURLNetworkServiceTypeVoIP);
//  }
//  if (name == "NSURLNetworkServiceTypeVoice") {
//    return convertObjCObjectToJSIValue(runtime, NSURLNetworkServiceTypeVoice);
//  }
//  if (name == "NSURLParentDirectoryURLKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLParentDirectoryURLKey);
//  }
//  if (name == "NSURLPathKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLPathKey);
//  }
//  if (name == "NSURLPreferredIOBlockSizeKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLPreferredIOBlockSizeKey);
//  }
//  // TODO: NSURLProtectionSpace (Interface)
//  if (name == "NSURLProtectionSpaceFTP") {
//    return convertObjCObjectToJSIValue(runtime, NSURLProtectionSpaceFTP);
//  }
//  if (name == "NSURLProtectionSpaceFTPProxy") {
//    return convertObjCObjectToJSIValue(runtime, NSURLProtectionSpaceFTPProxy);
//  }
//  if (name == "NSURLProtectionSpaceHTTP") {
//    return convertObjCObjectToJSIValue(runtime, NSURLProtectionSpaceHTTP);
//  }
//  if (name == "NSURLProtectionSpaceHTTPProxy") {
//    return convertObjCObjectToJSIValue(runtime, NSURLProtectionSpaceHTTPProxy);
//  }
//  if (name == "NSURLProtectionSpaceHTTPS") {
//    return convertObjCObjectToJSIValue(runtime, NSURLProtectionSpaceHTTPS);
//  }
//  if (name == "NSURLProtectionSpaceHTTPSProxy") {
//    return convertObjCObjectToJSIValue(runtime, NSURLProtectionSpaceHTTPSProxy);
//  }
//  if (name == "NSURLProtectionSpaceSOCKSProxy") {
//    return convertObjCObjectToJSIValue(runtime, NSURLProtectionSpaceSOCKSProxy);
//  }
//  // TODO: NSURLProtocol (Interface)
//  // TODO: NSURLProtocolClient (Protocol)
//  // TODO: NSURLQueryItem (Interface)
//  if (name == "NSURLRelationship") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Contains": NSURLRelationshipContains,
//        @"Same": NSURLRelationshipSame,
//        @"Other": NSURLRelationshipOther
//      }
//    );
//  }
//  if (name == "NSURLRelationshipContains") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRelationshipContains);
//  }
//  if (name == "NSURLRelationshipSame") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRelationshipSame);
//  }
//  if (name == "NSURLRelationshipOther") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRelationshipOther);
//  }
//  if (name == "NSURLRelationshipContains") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRelationshipContains);
//  }
//  if (name == "NSURLRelationshipOther") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRelationshipOther);
//  }
//  if (name == "NSURLRelationshipSame") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRelationshipSame);
//  }
//  // TODO: NSURLRequest (Interface)
//  if (name == "NSURLRequestAttribution") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Developer": NSURLRequestAttributionDeveloper,
//        @"User": NSURLRequestAttributionUser
//      }
//    );
//  }
//  if (name == "NSURLRequestAttributionDeveloper") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRequestAttributionDeveloper);
//  }
//  if (name == "NSURLRequestAttributionUser") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRequestAttributionUser);
//  }
//  if (name == "NSURLRequestAttributionDeveloper") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRequestAttributionDeveloper);
//  }
//  if (name == "NSURLRequestAttributionUser") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRequestAttributionUser);
//  }
//  if (name == "NSURLRequestCachePolicy") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"UseProtocolCachePolicy": NSURLRequestUseProtocolCachePolicy,
//        @"ReloadIgnoringLocalCacheData": NSURLRequestReloadIgnoringLocalCacheData,
//        @"ReloadIgnoringLocalAndRemoteCacheData": NSURLRequestReloadIgnoringLocalAndRemoteCacheData,
//        @"ReloadIgnoringCacheData": NSURLRequestReloadIgnoringCacheData,
//        @"ReturnCacheDataElseLoad": NSURLRequestReturnCacheDataElseLoad,
//        @"ReturnCacheDataDontLoad": NSURLRequestReturnCacheDataDontLoad,
//        @"ReloadRevalidatingCacheData": NSURLRequestReloadRevalidatingCacheData
//      }
//    );
//  }
//  if (name == "NSURLRequestUseProtocolCachePolicy") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRequestUseProtocolCachePolicy);
//  }
//  if (name == "NSURLRequestReloadIgnoringLocalCacheData") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRequestReloadIgnoringLocalCacheData);
//  }
//  if (name == "NSURLRequestReloadIgnoringLocalAndRemoteCacheData") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRequestReloadIgnoringLocalAndRemoteCacheData);
//  }
//  if (name == "NSURLRequestReloadIgnoringCacheData") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRequestReloadIgnoringCacheData);
//  }
//  if (name == "NSURLRequestReturnCacheDataElseLoad") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRequestReturnCacheDataElseLoad);
//  }
//  if (name == "NSURLRequestReturnCacheDataDontLoad") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRequestReturnCacheDataDontLoad);
//  }
//  if (name == "NSURLRequestReloadRevalidatingCacheData") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRequestReloadRevalidatingCacheData);
//  }
//  if (name == "NSURLRequestNetworkServiceType") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"NetworkServiceTypeDefault": NSURLNetworkServiceTypeDefault,
//        @"NetworkServiceTypeVoIP": NSURLNetworkServiceTypeVoIP,
//        @"NetworkServiceTypeVideo": NSURLNetworkServiceTypeVideo,
//        @"NetworkServiceTypeBackground": NSURLNetworkServiceTypeBackground,
//        @"NetworkServiceTypeVoice": NSURLNetworkServiceTypeVoice,
//        @"NetworkServiceTypeResponsiveData": NSURLNetworkServiceTypeResponsiveData,
//        @"NetworkServiceTypeAVStreaming": NSURLNetworkServiceTypeAVStreaming,
//        @"NetworkServiceTypeResponsiveAV": NSURLNetworkServiceTypeResponsiveAV,
//        @"NetworkServiceTypeCallSignaling": NSURLNetworkServiceTypeCallSignaling
//      }
//    );
//  }
//  if (name == "NSURLNetworkServiceTypeDefault") {
//    return convertObjCObjectToJSIValue(runtime, NSURLNetworkServiceTypeDefault);
//  }
//  if (name == "NSURLNetworkServiceTypeVoIP") {
//    return convertObjCObjectToJSIValue(runtime, NSURLNetworkServiceTypeVoIP);
//  }
//  if (name == "NSURLNetworkServiceTypeVideo") {
//    return convertObjCObjectToJSIValue(runtime, NSURLNetworkServiceTypeVideo);
//  }
//  if (name == "NSURLNetworkServiceTypeBackground") {
//    return convertObjCObjectToJSIValue(runtime, NSURLNetworkServiceTypeBackground);
//  }
//  if (name == "NSURLNetworkServiceTypeVoice") {
//    return convertObjCObjectToJSIValue(runtime, NSURLNetworkServiceTypeVoice);
//  }
//  if (name == "NSURLNetworkServiceTypeResponsiveData") {
//    return convertObjCObjectToJSIValue(runtime, NSURLNetworkServiceTypeResponsiveData);
//  }
//  if (name == "NSURLNetworkServiceTypeAVStreaming") {
//    return convertObjCObjectToJSIValue(runtime, NSURLNetworkServiceTypeAVStreaming);
//  }
//  if (name == "NSURLNetworkServiceTypeResponsiveAV") {
//    return convertObjCObjectToJSIValue(runtime, NSURLNetworkServiceTypeResponsiveAV);
//  }
//  if (name == "NSURLNetworkServiceTypeCallSignaling") {
//    return convertObjCObjectToJSIValue(runtime, NSURLNetworkServiceTypeCallSignaling);
//  }
//  if (name == "NSURLRequestReloadIgnoringCacheData") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRequestReloadIgnoringCacheData);
//  }
//  if (name == "NSURLRequestReloadIgnoringLocalAndRemoteCacheData") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRequestReloadIgnoringLocalAndRemoteCacheData);
//  }
//  if (name == "NSURLRequestReloadIgnoringLocalCacheData") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRequestReloadIgnoringLocalCacheData);
//  }
//  if (name == "NSURLRequestReloadRevalidatingCacheData") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRequestReloadRevalidatingCacheData);
//  }
//  if (name == "NSURLRequestReturnCacheDataDontLoad") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRequestReturnCacheDataDontLoad);
//  }
//  if (name == "NSURLRequestReturnCacheDataElseLoad") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRequestReturnCacheDataElseLoad);
//  }
//  if (name == "NSURLRequestUseProtocolCachePolicy") {
//    return convertObjCObjectToJSIValue(runtime, NSURLRequestUseProtocolCachePolicy);
//  }
//  // TODO: NSURLResponse (Interface)
//  // TODO: NSURLSession (Interface)
//  if (name == "NSURLSessionAuthChallengeCancelAuthenticationChallenge") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionAuthChallengeCancelAuthenticationChallenge);
//  }
//  if (name == "NSURLSessionAuthChallengeDisposition") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"UseCredential": NSURLSessionAuthChallengeUseCredential,
//        @"PerformDefaultHandling": NSURLSessionAuthChallengePerformDefaultHandling,
//        @"CancelAuthenticationChallenge": NSURLSessionAuthChallengeCancelAuthenticationChallenge,
//        @"RejectProtectionSpace": NSURLSessionAuthChallengeRejectProtectionSpace
//      }
//    );
//  }
//  if (name == "NSURLSessionAuthChallengeUseCredential") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionAuthChallengeUseCredential);
//  }
//  if (name == "NSURLSessionAuthChallengePerformDefaultHandling") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionAuthChallengePerformDefaultHandling);
//  }
//  if (name == "NSURLSessionAuthChallengeCancelAuthenticationChallenge") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionAuthChallengeCancelAuthenticationChallenge);
//  }
//  if (name == "NSURLSessionAuthChallengeRejectProtectionSpace") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionAuthChallengeRejectProtectionSpace);
//  }
//  if (name == "NSURLSessionAuthChallengePerformDefaultHandling") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionAuthChallengePerformDefaultHandling);
//  }
//  if (name == "NSURLSessionAuthChallengeRejectProtectionSpace") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionAuthChallengeRejectProtectionSpace);
//  }
//  if (name == "NSURLSessionAuthChallengeUseCredential") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionAuthChallengeUseCredential);
//  }
//  // TODO: NSURLSessionConfiguration (Interface)
//  // TODO: NSURLSessionDataDelegate (Protocol)
//  // TODO: NSURLSessionDataTask (Interface)
//  if (name == "NSURLSessionDelayedRequestCancel") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionDelayedRequestCancel);
//  }
//  if (name == "NSURLSessionDelayedRequestContinueLoading") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionDelayedRequestContinueLoading);
//  }
//  if (name == "NSURLSessionDelayedRequestDisposition") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"ContinueLoading": NSURLSessionDelayedRequestContinueLoading,
//        @"UseNewRequest": NSURLSessionDelayedRequestUseNewRequest,
//        @"Cancel": NSURLSessionDelayedRequestCancel
//      }
//    );
//  }
//  if (name == "NSURLSessionDelayedRequestContinueLoading") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionDelayedRequestContinueLoading);
//  }
//  if (name == "NSURLSessionDelayedRequestUseNewRequest") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionDelayedRequestUseNewRequest);
//  }
//  if (name == "NSURLSessionDelayedRequestCancel") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionDelayedRequestCancel);
//  }
//  if (name == "NSURLSessionDelayedRequestUseNewRequest") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionDelayedRequestUseNewRequest);
//  }
//  // TODO: NSURLSessionDelegate (Protocol)
//  // TODO: NSURLSessionDownloadDelegate (Protocol)
//  // TODO: NSURLSessionDownloadTask (Interface)
//  if (name == "NSURLSessionDownloadTaskResumeData") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionDownloadTaskResumeData);
//  }
//  if (name == "NSURLSessionMultipathServiceType") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"None": NSURLSessionMultipathServiceTypeNone,
//        @"Handover": NSURLSessionMultipathServiceTypeHandover,
//        @"Interactive": NSURLSessionMultipathServiceTypeInteractive,
//        @"Aggregate": NSURLSessionMultipathServiceTypeAggregate
//      }
//    );
//  }
//  if (name == "NSURLSessionMultipathServiceTypeNone") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionMultipathServiceTypeNone);
//  }
//  if (name == "NSURLSessionMultipathServiceTypeHandover") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionMultipathServiceTypeHandover);
//  }
//  if (name == "NSURLSessionMultipathServiceTypeInteractive") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionMultipathServiceTypeInteractive);
//  }
//  if (name == "NSURLSessionMultipathServiceTypeAggregate") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionMultipathServiceTypeAggregate);
//  }
//  if (name == "NSURLSessionMultipathServiceTypeAggregate") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionMultipathServiceTypeAggregate);
//  }
//  if (name == "NSURLSessionMultipathServiceTypeHandover") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionMultipathServiceTypeHandover);
//  }
//  if (name == "NSURLSessionMultipathServiceTypeInteractive") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionMultipathServiceTypeInteractive);
//  }
//  if (name == "NSURLSessionMultipathServiceTypeNone") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionMultipathServiceTypeNone);
//  }
//  if (name == "NSURLSessionResponseAllow") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionResponseAllow);
//  }
//  if (name == "NSURLSessionResponseBecomeDownload") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionResponseBecomeDownload);
//  }
//  if (name == "NSURLSessionResponseBecomeStream") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionResponseBecomeStream);
//  }
//  if (name == "NSURLSessionResponseCancel") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionResponseCancel);
//  }
//  if (name == "NSURLSessionResponseDisposition") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Cancel": NSURLSessionResponseCancel,
//        @"Allow": NSURLSessionResponseAllow,
//        @"BecomeDownload": NSURLSessionResponseBecomeDownload,
//        @"BecomeStream": NSURLSessionResponseBecomeStream
//      }
//    );
//  }
//  if (name == "NSURLSessionResponseCancel") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionResponseCancel);
//  }
//  if (name == "NSURLSessionResponseAllow") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionResponseAllow);
//  }
//  if (name == "NSURLSessionResponseBecomeDownload") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionResponseBecomeDownload);
//  }
//  if (name == "NSURLSessionResponseBecomeStream") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionResponseBecomeStream);
//  }
//  // TODO: NSURLSessionStreamDelegate (Protocol)
//  // TODO: NSURLSessionStreamTask (Interface)
//  // TODO: NSURLSessionTask (Interface)
//  // TODO: NSURLSessionTaskDelegate (Protocol)
//  // TODO: NSURLSessionTaskMetrics (Interface)
//  if (name == "NSURLSessionTaskMetricsDomainResolutionProtocol") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Unknown": NSURLSessionTaskMetricsDomainResolutionProtocolUnknown,
//        @"UDP": NSURLSessionTaskMetricsDomainResolutionProtocolUDP,
//        @"TCP": NSURLSessionTaskMetricsDomainResolutionProtocolTCP,
//        @"TLS": NSURLSessionTaskMetricsDomainResolutionProtocolTLS,
//        @"HTTPS": NSURLSessionTaskMetricsDomainResolutionProtocolHTTPS
//      }
//    );
//  }
//  if (name == "NSURLSessionTaskMetricsDomainResolutionProtocolUnknown") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskMetricsDomainResolutionProtocolUnknown);
//  }
//  if (name == "NSURLSessionTaskMetricsDomainResolutionProtocolUDP") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskMetricsDomainResolutionProtocolUDP);
//  }
//  if (name == "NSURLSessionTaskMetricsDomainResolutionProtocolTCP") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskMetricsDomainResolutionProtocolTCP);
//  }
//  if (name == "NSURLSessionTaskMetricsDomainResolutionProtocolTLS") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskMetricsDomainResolutionProtocolTLS);
//  }
//  if (name == "NSURLSessionTaskMetricsDomainResolutionProtocolHTTPS") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskMetricsDomainResolutionProtocolHTTPS);
//  }
//  if (name == "NSURLSessionTaskMetricsDomainResolutionProtocolHTTPS") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskMetricsDomainResolutionProtocolHTTPS);
//  }
//  if (name == "NSURLSessionTaskMetricsDomainResolutionProtocolTCP") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskMetricsDomainResolutionProtocolTCP);
//  }
//  if (name == "NSURLSessionTaskMetricsDomainResolutionProtocolTLS") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskMetricsDomainResolutionProtocolTLS);
//  }
//  if (name == "NSURLSessionTaskMetricsDomainResolutionProtocolUDP") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskMetricsDomainResolutionProtocolUDP);
//  }
//  if (name == "NSURLSessionTaskMetricsDomainResolutionProtocolUnknown") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskMetricsDomainResolutionProtocolUnknown);
//  }
//  if (name == "NSURLSessionTaskMetricsResourceFetchType") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Unknown": NSURLSessionTaskMetricsResourceFetchTypeUnknown,
//        @"NetworkLoad": NSURLSessionTaskMetricsResourceFetchTypeNetworkLoad,
//        @"ServerPush": NSURLSessionTaskMetricsResourceFetchTypeServerPush,
//        @"LocalCache": NSURLSessionTaskMetricsResourceFetchTypeLocalCache
//      }
//    );
//  }
//  if (name == "NSURLSessionTaskMetricsResourceFetchTypeUnknown") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskMetricsResourceFetchTypeUnknown);
//  }
//  if (name == "NSURLSessionTaskMetricsResourceFetchTypeNetworkLoad") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskMetricsResourceFetchTypeNetworkLoad);
//  }
//  if (name == "NSURLSessionTaskMetricsResourceFetchTypeServerPush") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskMetricsResourceFetchTypeServerPush);
//  }
//  if (name == "NSURLSessionTaskMetricsResourceFetchTypeLocalCache") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskMetricsResourceFetchTypeLocalCache);
//  }
//  if (name == "NSURLSessionTaskMetricsResourceFetchTypeLocalCache") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskMetricsResourceFetchTypeLocalCache);
//  }
//  if (name == "NSURLSessionTaskMetricsResourceFetchTypeNetworkLoad") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskMetricsResourceFetchTypeNetworkLoad);
//  }
//  if (name == "NSURLSessionTaskMetricsResourceFetchTypeServerPush") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskMetricsResourceFetchTypeServerPush);
//  }
//  if (name == "NSURLSessionTaskMetricsResourceFetchTypeUnknown") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskMetricsResourceFetchTypeUnknown);
//  }
//  if (name == "NSURLSessionTaskPriorityDefault") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskPriorityDefault);
//  }
//  if (name == "NSURLSessionTaskPriorityHigh") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskPriorityHigh);
//  }
//  if (name == "NSURLSessionTaskPriorityLow") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskPriorityLow);
//  }
//  if (name == "NSURLSessionTaskState") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Running": NSURLSessionTaskStateRunning,
//        @"Suspended": NSURLSessionTaskStateSuspended,
//        @"Canceling": NSURLSessionTaskStateCanceling,
//        @"Completed": NSURLSessionTaskStateCompleted
//      }
//    );
//  }
//  if (name == "NSURLSessionTaskStateRunning") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskStateRunning);
//  }
//  if (name == "NSURLSessionTaskStateSuspended") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskStateSuspended);
//  }
//  if (name == "NSURLSessionTaskStateCanceling") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskStateCanceling);
//  }
//  if (name == "NSURLSessionTaskStateCompleted") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskStateCompleted);
//  }
//  if (name == "NSURLSessionTaskStateCanceling") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskStateCanceling);
//  }
//  if (name == "NSURLSessionTaskStateCompleted") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskStateCompleted);
//  }
//  if (name == "NSURLSessionTaskStateRunning") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskStateRunning);
//  }
//  if (name == "NSURLSessionTaskStateSuspended") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTaskStateSuspended);
//  }
//  // TODO: NSURLSessionTaskTransactionMetrics (Interface)
//  if (name == "NSURLSessionTransferSizeUnknown") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionTransferSizeUnknown);
//  }
//  // TODO: NSURLSessionUploadTask (Interface)
//  if (name == "NSURLSessionWebSocketCloseCode") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Invalid": NSURLSessionWebSocketCloseCodeInvalid,
//        @"NormalClosure": NSURLSessionWebSocketCloseCodeNormalClosure,
//        @"GoingAway": NSURLSessionWebSocketCloseCodeGoingAway,
//        @"ProtocolError": NSURLSessionWebSocketCloseCodeProtocolError,
//        @"UnsupportedData": NSURLSessionWebSocketCloseCodeUnsupportedData,
//        @"NoStatusReceived": NSURLSessionWebSocketCloseCodeNoStatusReceived,
//        @"AbnormalClosure": NSURLSessionWebSocketCloseCodeAbnormalClosure,
//        @"InvalidFramePayloadData": NSURLSessionWebSocketCloseCodeInvalidFramePayloadData,
//        @"PolicyViolation": NSURLSessionWebSocketCloseCodePolicyViolation,
//        @"MessageTooBig": NSURLSessionWebSocketCloseCodeMessageTooBig,
//        @"MandatoryExtensionMissing": NSURLSessionWebSocketCloseCodeMandatoryExtensionMissing,
//        @"InternalServerError": NSURLSessionWebSocketCloseCodeInternalServerError,
//        @"TLSHandshakeFailure": NSURLSessionWebSocketCloseCodeTLSHandshakeFailure
//      }
//    );
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeInvalid") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeInvalid);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeNormalClosure") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeNormalClosure);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeGoingAway") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeGoingAway);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeProtocolError") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeProtocolError);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeUnsupportedData") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeUnsupportedData);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeNoStatusReceived") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeNoStatusReceived);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeAbnormalClosure") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeAbnormalClosure);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeInvalidFramePayloadData") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeInvalidFramePayloadData);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodePolicyViolation") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodePolicyViolation);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeMessageTooBig") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeMessageTooBig);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeMandatoryExtensionMissing") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeMandatoryExtensionMissing);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeInternalServerError") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeInternalServerError);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeTLSHandshakeFailure") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeTLSHandshakeFailure);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeAbnormalClosure") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeAbnormalClosure);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeGoingAway") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeGoingAway);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeInternalServerError") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeInternalServerError);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeInvalid") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeInvalid);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeInvalidFramePayloadData") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeInvalidFramePayloadData);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeMandatoryExtensionMissing") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeMandatoryExtensionMissing);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeMessageTooBig") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeMessageTooBig);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeNoStatusReceived") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeNoStatusReceived);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeNormalClosure") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeNormalClosure);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodePolicyViolation") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodePolicyViolation);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeProtocolError") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeProtocolError);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeTLSHandshakeFailure") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeTLSHandshakeFailure);
//  }
//  if (name == "NSURLSessionWebSocketCloseCodeUnsupportedData") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketCloseCodeUnsupportedData);
//  }
//  // TODO: NSURLSessionWebSocketDelegate (Protocol)
//  // TODO: NSURLSessionWebSocketMessage (Interface)
//  if (name == "NSURLSessionWebSocketMessageType") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Data": NSURLSessionWebSocketMessageTypeData,
//        @"String": NSURLSessionWebSocketMessageTypeString
//      }
//    );
//  }
//  if (name == "NSURLSessionWebSocketMessageTypeData") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketMessageTypeData);
//  }
//  if (name == "NSURLSessionWebSocketMessageTypeString") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketMessageTypeString);
//  }
//  if (name == "NSURLSessionWebSocketMessageTypeData") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketMessageTypeData);
//  }
//  if (name == "NSURLSessionWebSocketMessageTypeString") {
//    return convertObjCObjectToJSIValue(runtime, NSURLSessionWebSocketMessageTypeString);
//  }
//  // TODO: NSURLSessionWebSocketTask (Interface)
//  if (name == "NSURLThumbnailDictionaryKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLThumbnailDictionaryKey);
//  }
//  if (name == "NSURLTotalFileAllocatedSizeKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLTotalFileAllocatedSizeKey);
//  }
//  if (name == "NSURLTotalFileSizeKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLTotalFileSizeKey);
//  }
//  if (name == "NSURLTypeIdentifierKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLTypeIdentifierKey);
//  }
//  if (name == "NSURLUbiquitousItemContainerDisplayNameKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousItemContainerDisplayNameKey);
//  }
//  if (name == "NSURLUbiquitousItemDownloadRequestedKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousItemDownloadRequestedKey);
//  }
//  if (name == "NSURLUbiquitousItemDownloadingErrorKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousItemDownloadingErrorKey);
//  }
//  if (name == "NSURLUbiquitousItemDownloadingStatusCurrent") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousItemDownloadingStatusCurrent);
//  }
//  if (name == "NSURLUbiquitousItemDownloadingStatusDownloaded") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousItemDownloadingStatusDownloaded);
//  }
//  if (name == "NSURLUbiquitousItemDownloadingStatusKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousItemDownloadingStatusKey);
//  }
//  if (name == "NSURLUbiquitousItemDownloadingStatusNotDownloaded") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousItemDownloadingStatusNotDownloaded);
//  }
//  if (name == "NSURLUbiquitousItemHasUnresolvedConflictsKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousItemHasUnresolvedConflictsKey);
//  }
//  if (name == "NSURLUbiquitousItemIsDownloadedKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousItemIsDownloadedKey);
//  }
//  if (name == "NSURLUbiquitousItemIsDownloadingKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousItemIsDownloadingKey);
//  }
//  if (name == "NSURLUbiquitousItemIsExcludedFromSyncKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousItemIsExcludedFromSyncKey);
//  }
//  if (name == "NSURLUbiquitousItemIsSharedKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousItemIsSharedKey);
//  }
//  if (name == "NSURLUbiquitousItemIsUploadedKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousItemIsUploadedKey);
//  }
//  if (name == "NSURLUbiquitousItemIsUploadingKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousItemIsUploadingKey);
//  }
//  if (name == "NSURLUbiquitousItemPercentDownloadedKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousItemPercentDownloadedKey);
//  }
//  if (name == "NSURLUbiquitousItemPercentUploadedKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousItemPercentUploadedKey);
//  }
//  if (name == "NSURLUbiquitousItemUploadingErrorKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousItemUploadingErrorKey);
//  }
//  if (name == "NSURLUbiquitousSharedItemCurrentUserPermissionsKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousSharedItemCurrentUserPermissionsKey);
//  }
//  if (name == "NSURLUbiquitousSharedItemCurrentUserRoleKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousSharedItemCurrentUserRoleKey);
//  }
//  if (name == "NSURLUbiquitousSharedItemMostRecentEditorNameComponentsKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousSharedItemMostRecentEditorNameComponentsKey);
//  }
//  if (name == "NSURLUbiquitousSharedItemOwnerNameComponentsKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousSharedItemOwnerNameComponentsKey);
//  }
//  if (name == "NSURLUbiquitousSharedItemPermissionsReadOnly") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousSharedItemPermissionsReadOnly);
//  }
//  if (name == "NSURLUbiquitousSharedItemPermissionsReadWrite") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousSharedItemPermissionsReadWrite);
//  }
//  if (name == "NSURLUbiquitousSharedItemRoleOwner") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousSharedItemRoleOwner);
//  }
//  if (name == "NSURLUbiquitousSharedItemRoleParticipant") {
//    return convertObjCObjectToJSIValue(runtime, NSURLUbiquitousSharedItemRoleParticipant);
//  }
//  if (name == "NSURLVolumeAvailableCapacityForImportantUsageKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeAvailableCapacityForImportantUsageKey);
//  }
//  if (name == "NSURLVolumeAvailableCapacityForOpportunisticUsageKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeAvailableCapacityForOpportunisticUsageKey);
//  }
//  if (name == "NSURLVolumeAvailableCapacityKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeAvailableCapacityKey);
//  }
//  if (name == "NSURLVolumeCreationDateKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeCreationDateKey);
//  }
//  if (name == "NSURLVolumeIdentifierKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeIdentifierKey);
//  }
//  if (name == "NSURLVolumeIsAutomountedKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeIsAutomountedKey);
//  }
//  if (name == "NSURLVolumeIsBrowsableKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeIsBrowsableKey);
//  }
//  if (name == "NSURLVolumeIsEjectableKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeIsEjectableKey);
//  }
//  if (name == "NSURLVolumeIsEncryptedKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeIsEncryptedKey);
//  }
//  if (name == "NSURLVolumeIsInternalKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeIsInternalKey);
//  }
//  if (name == "NSURLVolumeIsJournalingKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeIsJournalingKey);
//  }
//  if (name == "NSURLVolumeIsLocalKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeIsLocalKey);
//  }
//  if (name == "NSURLVolumeIsReadOnlyKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeIsReadOnlyKey);
//  }
//  if (name == "NSURLVolumeIsRemovableKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeIsRemovableKey);
//  }
//  if (name == "NSURLVolumeIsRootFileSystemKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeIsRootFileSystemKey);
//  }
//  if (name == "NSURLVolumeLocalizedFormatDescriptionKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeLocalizedFormatDescriptionKey);
//  }
//  if (name == "NSURLVolumeLocalizedNameKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeLocalizedNameKey);
//  }
//  if (name == "NSURLVolumeMaximumFileSizeKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeMaximumFileSizeKey);
//  }
//  if (name == "NSURLVolumeNameKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeNameKey);
//  }
//  if (name == "NSURLVolumeResourceCountKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeResourceCountKey);
//  }
//  if (name == "NSURLVolumeSupportsAccessPermissionsKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeSupportsAccessPermissionsKey);
//  }
//  if (name == "NSURLVolumeSupportsAdvisoryFileLockingKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeSupportsAdvisoryFileLockingKey);
//  }
//  if (name == "NSURLVolumeSupportsCasePreservedNamesKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeSupportsCasePreservedNamesKey);
//  }
//  if (name == "NSURLVolumeSupportsCaseSensitiveNamesKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeSupportsCaseSensitiveNamesKey);
//  }
//  if (name == "NSURLVolumeSupportsCompressionKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeSupportsCompressionKey);
//  }
//  if (name == "NSURLVolumeSupportsExclusiveRenamingKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeSupportsExclusiveRenamingKey);
//  }
//  if (name == "NSURLVolumeSupportsExtendedSecurityKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeSupportsExtendedSecurityKey);
//  }
//  if (name == "NSURLVolumeSupportsFileCloningKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeSupportsFileCloningKey);
//  }
//  if (name == "NSURLVolumeSupportsFileProtectionKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeSupportsFileProtectionKey);
//  }
//  if (name == "NSURLVolumeSupportsHardLinksKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeSupportsHardLinksKey);
//  }
//  if (name == "NSURLVolumeSupportsImmutableFilesKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeSupportsImmutableFilesKey);
//  }
//  if (name == "NSURLVolumeSupportsJournalingKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeSupportsJournalingKey);
//  }
//  if (name == "NSURLVolumeSupportsPersistentIDsKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeSupportsPersistentIDsKey);
//  }
//  if (name == "NSURLVolumeSupportsRenamingKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeSupportsRenamingKey);
//  }
//  if (name == "NSURLVolumeSupportsRootDirectoryDatesKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeSupportsRootDirectoryDatesKey);
//  }
//  if (name == "NSURLVolumeSupportsSparseFilesKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeSupportsSparseFilesKey);
//  }
//  if (name == "NSURLVolumeSupportsSwapRenamingKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeSupportsSwapRenamingKey);
//  }
//  if (name == "NSURLVolumeSupportsSymbolicLinksKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeSupportsSymbolicLinksKey);
//  }
//  if (name == "NSURLVolumeSupportsVolumeSizesKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeSupportsVolumeSizesKey);
//  }
//  if (name == "NSURLVolumeSupportsZeroRunsKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeSupportsZeroRunsKey);
//  }
//  if (name == "NSURLVolumeTotalCapacityKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeTotalCapacityKey);
//  }
//  if (name == "NSURLVolumeURLForRemountingKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeURLForRemountingKey);
//  }
//  if (name == "NSURLVolumeURLKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeURLKey);
//  }
//  if (name == "NSURLVolumeUUIDStringKey") {
//    return convertObjCObjectToJSIValue(runtime, NSURLVolumeUUIDStringKey);
//  }
//  if (name == "NSUTF16BigEndianStringEncoding") {
//    return convertObjCObjectToJSIValue(runtime, NSUTF16BigEndianStringEncoding);
//  }
//  if (name == "NSUTF16LittleEndianStringEncoding") {
//    return convertObjCObjectToJSIValue(runtime, NSUTF16LittleEndianStringEncoding);
//  }
//  if (name == "NSUTF16StringEncoding") {
//    return convertObjCObjectToJSIValue(runtime, NSUTF16StringEncoding);
//  }
//  if (name == "NSUTF32BigEndianStringEncoding") {
//    return convertObjCObjectToJSIValue(runtime, NSUTF32BigEndianStringEncoding);
//  }
//  if (name == "NSUTF32LittleEndianStringEncoding") {
//    return convertObjCObjectToJSIValue(runtime, NSUTF32LittleEndianStringEncoding);
//  }
//  if (name == "NSUTF32StringEncoding") {
//    return convertObjCObjectToJSIValue(runtime, NSUTF32StringEncoding);
//  }
//  if (name == "NSUTF8StringEncoding") {
//    return convertObjCObjectToJSIValue(runtime, NSUTF8StringEncoding);
//  }
//  // TODO: NSUUID (Interface)
//  if (name == "NSUbiquitousFileErrorMaximum") {
//    return convertObjCObjectToJSIValue(runtime, NSUbiquitousFileErrorMaximum);
//  }
//  if (name == "NSUbiquitousFileErrorMinimum") {
//    return convertObjCObjectToJSIValue(runtime, NSUbiquitousFileErrorMinimum);
//  }
//  if (name == "NSUbiquitousFileNotUploadedDueToQuotaError") {
//    return convertObjCObjectToJSIValue(runtime, NSUbiquitousFileNotUploadedDueToQuotaError);
//  }
//  if (name == "NSUbiquitousFileUbiquityServerNotAvailable") {
//    return convertObjCObjectToJSIValue(runtime, NSUbiquitousFileUbiquityServerNotAvailable);
//  }
//  if (name == "NSUbiquitousFileUnavailableError") {
//    return convertObjCObjectToJSIValue(runtime, NSUbiquitousFileUnavailableError);
//  }
//  // TODO: NSUbiquitousKeyValueStore (Interface)
//  if (name == "NSUbiquitousKeyValueStoreAccountChange") {
//    return convertObjCObjectToJSIValue(runtime, NSUbiquitousKeyValueStoreAccountChange);
//  }
//  if (name == "NSUbiquitousKeyValueStoreChangeReasonKey") {
//    return convertObjCObjectToJSIValue(runtime, NSUbiquitousKeyValueStoreChangeReasonKey);
//  }
//  if (name == "NSUbiquitousKeyValueStoreChangedKeysKey") {
//    return convertObjCObjectToJSIValue(runtime, NSUbiquitousKeyValueStoreChangedKeysKey);
//  }
//  if (name == "NSUbiquitousKeyValueStoreDidChangeExternallyNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSUbiquitousKeyValueStoreDidChangeExternallyNotification);
//  }
//  if (name == "NSUbiquitousKeyValueStoreInitialSyncChange") {
//    return convertObjCObjectToJSIValue(runtime, NSUbiquitousKeyValueStoreInitialSyncChange);
//  }
//  if (name == "NSUbiquitousKeyValueStoreQuotaViolationChange") {
//    return convertObjCObjectToJSIValue(runtime, NSUbiquitousKeyValueStoreQuotaViolationChange);
//  }
//  if (name == "NSUbiquitousKeyValueStoreServerChange") {
//    return convertObjCObjectToJSIValue(runtime, NSUbiquitousKeyValueStoreServerChange);
//  }
//  if (name == "NSUbiquitousUserDefaultsCompletedInitialSyncNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSUbiquitousUserDefaultsCompletedInitialSyncNotification);
//  }
//  if (name == "NSUbiquitousUserDefaultsDidChangeAccountsNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSUbiquitousUserDefaultsDidChangeAccountsNotification);
//  }
//  if (name == "NSUbiquitousUserDefaultsNoCloudAccountNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSUbiquitousUserDefaultsNoCloudAccountNotification);
//  }
//  if (name == "NSUbiquityIdentityDidChangeNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSUbiquityIdentityDidChangeNotification);
//  }
//  if (name == "NSUnarchiveFromDataTransformerName") {
//    return convertObjCObjectToJSIValue(runtime, NSUnarchiveFromDataTransformerName);
//  }
//  if (name == "NSUncachedRead") {
//    return convertObjCObjectToJSIValue(runtime, NSUncachedRead);
//  }
//  if (name == "NSUndefinedDateComponent") {
//    return convertObjCObjectToJSIValue(runtime, NSUndefinedDateComponent);
//  }
//  if (name == "NSUndefinedKeyException") {
//    return convertObjCObjectToJSIValue(runtime, NSUndefinedKeyException);
//  }
//  if (name == "NSUnderlyingErrorKey") {
//    return convertObjCObjectToJSIValue(runtime, NSUnderlyingErrorKey);
//  }
//  if (name == "NSUndoCloseGroupingRunLoopOrdering") {
//    return convertObjCObjectToJSIValue(runtime, NSUndoCloseGroupingRunLoopOrdering);
//  }
//  // TODO: NSUndoManager (Interface)
//  if (name == "NSUndoManagerCheckpointNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSUndoManagerCheckpointNotification);
//  }
//  if (name == "NSUndoManagerDidCloseUndoGroupNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSUndoManagerDidCloseUndoGroupNotification);
//  }
//  if (name == "NSUndoManagerDidOpenUndoGroupNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSUndoManagerDidOpenUndoGroupNotification);
//  }
//  if (name == "NSUndoManagerDidRedoChangeNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSUndoManagerDidRedoChangeNotification);
//  }
//  if (name == "NSUndoManagerDidUndoChangeNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSUndoManagerDidUndoChangeNotification);
//  }
//  if (name == "NSUndoManagerGroupIsDiscardableKey") {
//    return convertObjCObjectToJSIValue(runtime, NSUndoManagerGroupIsDiscardableKey);
//  }
//  if (name == "NSUndoManagerWillCloseUndoGroupNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSUndoManagerWillCloseUndoGroupNotification);
//  }
//  if (name == "NSUndoManagerWillRedoChangeNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSUndoManagerWillRedoChangeNotification);
//  }
//  if (name == "NSUndoManagerWillUndoChangeNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSUndoManagerWillUndoChangeNotification);
//  }
//  if (name == "NSUnicodeStringEncoding") {
//    return convertObjCObjectToJSIValue(runtime, NSUnicodeStringEncoding);
//  }
//  if (name == "NSUnionOfArraysKeyValueOperator") {
//    return convertObjCObjectToJSIValue(runtime, NSUnionOfArraysKeyValueOperator);
//  }
//  if (name == "NSUnionOfObjectsKeyValueOperator") {
//    return convertObjCObjectToJSIValue(runtime, NSUnionOfObjectsKeyValueOperator);
//  }
//  if (name == "NSUnionOfSetsKeyValueOperator") {
//    return convertObjCObjectToJSIValue(runtime, NSUnionOfSetsKeyValueOperator);
//  }
//  if (name == "NSUnionRange") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSUnionRange(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSUnionRange"), 2, func);
//  }
//  if (name == "NSUnionSetExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSUnionSetExpressionType);
//  }
//  // TODO: NSUnit (Interface)
//  // TODO: NSUnitAcceleration (Interface)
//  // TODO: NSUnitAngle (Interface)
//  // TODO: NSUnitArea (Interface)
//  // TODO: NSUnitConcentrationMass (Interface)
//  // TODO: NSUnitConverter (Interface)
//  // TODO: NSUnitConverterLinear (Interface)
//  // TODO: NSUnitDispersion (Interface)
//  // TODO: NSUnitDuration (Interface)
//  // TODO: NSUnitElectricCharge (Interface)
//  // TODO: NSUnitElectricCurrent (Interface)
//  // TODO: NSUnitElectricPotentialDifference (Interface)
//  // TODO: NSUnitElectricResistance (Interface)
//  // TODO: NSUnitEnergy (Interface)
//  // TODO: NSUnitFrequency (Interface)
//  // TODO: NSUnitFuelEfficiency (Interface)
//  // TODO: NSUnitIlluminance (Interface)
//  // TODO: NSUnitInformationStorage (Interface)
//  // TODO: NSUnitLength (Interface)
//  // TODO: NSUnitMass (Interface)
//  // TODO: NSUnitPower (Interface)
//  // TODO: NSUnitPressure (Interface)
//  // TODO: NSUnitSpeed (Interface)
//  // TODO: NSUnitTemperature (Interface)
//  // TODO: NSUnitVolume (Interface)
//  // TODO: NSUserActivity (Interface)
//  if (name == "NSUserActivityConnectionUnavailableError") {
//    return convertObjCObjectToJSIValue(runtime, NSUserActivityConnectionUnavailableError);
//  }
//  // TODO: NSUserActivityDelegate (Protocol)
//  if (name == "NSUserActivityErrorMaximum") {
//    return convertObjCObjectToJSIValue(runtime, NSUserActivityErrorMaximum);
//  }
//  if (name == "NSUserActivityErrorMinimum") {
//    return convertObjCObjectToJSIValue(runtime, NSUserActivityErrorMinimum);
//  }
//  if (name == "NSUserActivityHandoffFailedError") {
//    return convertObjCObjectToJSIValue(runtime, NSUserActivityHandoffFailedError);
//  }
//  if (name == "NSUserActivityHandoffUserInfoTooLargeError") {
//    return convertObjCObjectToJSIValue(runtime, NSUserActivityHandoffUserInfoTooLargeError);
//  }
//  if (name == "NSUserActivityRemoteApplicationTimedOutError") {
//    return convertObjCObjectToJSIValue(runtime, NSUserActivityRemoteApplicationTimedOutError);
//  }
//  if (name == "NSUserActivityTypeBrowsingWeb") {
//    return convertObjCObjectToJSIValue(runtime, NSUserActivityTypeBrowsingWeb);
//  }
//  if (name == "NSUserCancelledError") {
//    return convertObjCObjectToJSIValue(runtime, NSUserCancelledError);
//  }
//  // TODO: NSUserDefaults (Interface)
//  if (name == "NSUserDefaultsDidChangeNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSUserDefaultsDidChangeNotification);
//  }
//  if (name == "NSUserDefaultsSizeLimitExceededNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSUserDefaultsSizeLimitExceededNotification);
//  }
//  if (name == "NSUserDirectory") {
//    return convertObjCObjectToJSIValue(runtime, NSUserDirectory);
//  }
//  if (name == "NSUserDomainMask") {
//    return convertObjCObjectToJSIValue(runtime, NSUserDomainMask);
//  }
//  if (name == "NSUserName") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSUserName();
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSUserName"), 0, func);
//  }
//  if (name == "NSValidationErrorMaximum") {
//    return convertObjCObjectToJSIValue(runtime, NSValidationErrorMaximum);
//  }
//  if (name == "NSValidationErrorMinimum") {
//    return convertObjCObjectToJSIValue(runtime, NSValidationErrorMinimum);
//  }
//  // TODO: NSValue (Interface)
//  // TODO: NSValueTransformer (Interface)
//  if (name == "NSVariableExpressionType") {
//    return convertObjCObjectToJSIValue(runtime, NSVariableExpressionType);
//  }
//  if (name == "NSVolumeEnumerationOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"SkipHiddenVolumes": NSVolumeEnumerationSkipHiddenVolumes,
//        @"ProduceFileReferenceURLs": NSVolumeEnumerationProduceFileReferenceURLs
//      }
//    );
//  }
//  if (name == "NSVolumeEnumerationSkipHiddenVolumes") {
//    return convertObjCObjectToJSIValue(runtime, NSVolumeEnumerationSkipHiddenVolumes);
//  }
//  if (name == "NSVolumeEnumerationProduceFileReferenceURLs") {
//    return convertObjCObjectToJSIValue(runtime, NSVolumeEnumerationProduceFileReferenceURLs);
//  }
//  if (name == "NSVolumeEnumerationProduceFileReferenceURLs") {
//    return convertObjCObjectToJSIValue(runtime, NSVolumeEnumerationProduceFileReferenceURLs);
//  }
//  if (name == "NSVolumeEnumerationSkipHiddenVolumes") {
//    return convertObjCObjectToJSIValue(runtime, NSVolumeEnumerationSkipHiddenVolumes);
//  }
//  if (name == "NSWeekCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSWeekCalendarUnit);
//  }
//  if (name == "NSWeekOfMonthCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSWeekOfMonthCalendarUnit);
//  }
//  if (name == "NSWeekOfYearCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSWeekOfYearCalendarUnit);
//  }
//  if (name == "NSWeekdayCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSWeekdayCalendarUnit);
//  }
//  if (name == "NSWeekdayOrdinalCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSWeekdayOrdinalCalendarUnit);
//  }
//  if (name == "NSWidthInsensitiveSearch") {
//    return convertObjCObjectToJSIValue(runtime, NSWidthInsensitiveSearch);
//  }
//  if (name == "NSWillBecomeMultiThreadedNotification") {
//    return convertObjCObjectToJSIValue(runtime, NSWillBecomeMultiThreadedNotification);
//  }
//  if (name == "NSWindows95OperatingSystem") {
//    return convertObjCObjectToJSIValue(runtime, NSWindows95OperatingSystem);
//  }
//  if (name == "NSWindowsCP1250StringEncoding") {
//    return convertObjCObjectToJSIValue(runtime, NSWindowsCP1250StringEncoding);
//  }
//  if (name == "NSWindowsCP1251StringEncoding") {
//    return convertObjCObjectToJSIValue(runtime, NSWindowsCP1251StringEncoding);
//  }
//  if (name == "NSWindowsCP1252StringEncoding") {
//    return convertObjCObjectToJSIValue(runtime, NSWindowsCP1252StringEncoding);
//  }
//  if (name == "NSWindowsCP1253StringEncoding") {
//    return convertObjCObjectToJSIValue(runtime, NSWindowsCP1253StringEncoding);
//  }
//  if (name == "NSWindowsCP1254StringEncoding") {
//    return convertObjCObjectToJSIValue(runtime, NSWindowsCP1254StringEncoding);
//  }
//  if (name == "NSWindowsNTOperatingSystem") {
//    return convertObjCObjectToJSIValue(runtime, NSWindowsNTOperatingSystem);
//  }
//  if (name == "NSWrapCalendarComponents") {
//    return convertObjCObjectToJSIValue(runtime, NSWrapCalendarComponents);
//  }
//  // TODO: NSXMLParser (Interface)
//  if (name == "NSXMLParserAttributeHasNoValueError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserAttributeHasNoValueError);
//  }
//  if (name == "NSXMLParserAttributeListNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserAttributeListNotFinishedError);
//  }
//  if (name == "NSXMLParserAttributeListNotStartedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserAttributeListNotStartedError);
//  }
//  if (name == "NSXMLParserAttributeNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserAttributeNotFinishedError);
//  }
//  if (name == "NSXMLParserAttributeNotStartedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserAttributeNotStartedError);
//  }
//  if (name == "NSXMLParserAttributeRedefinedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserAttributeRedefinedError);
//  }
//  if (name == "NSXMLParserCDATANotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserCDATANotFinishedError);
//  }
//  if (name == "NSXMLParserCharacterRefAtEOFError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserCharacterRefAtEOFError);
//  }
//  if (name == "NSXMLParserCharacterRefInDTDError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserCharacterRefInDTDError);
//  }
//  if (name == "NSXMLParserCharacterRefInEpilogError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserCharacterRefInEpilogError);
//  }
//  if (name == "NSXMLParserCharacterRefInPrologError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserCharacterRefInPrologError);
//  }
//  if (name == "NSXMLParserCommentContainsDoubleHyphenError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserCommentContainsDoubleHyphenError);
//  }
//  if (name == "NSXMLParserCommentNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserCommentNotFinishedError);
//  }
//  if (name == "NSXMLParserConditionalSectionNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserConditionalSectionNotFinishedError);
//  }
//  if (name == "NSXMLParserConditionalSectionNotStartedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserConditionalSectionNotStartedError);
//  }
//  if (name == "NSXMLParserDOCTYPEDeclNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserDOCTYPEDeclNotFinishedError);
//  }
//  // TODO: NSXMLParserDelegate (Protocol)
//  if (name == "NSXMLParserDelegateAbortedParseError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserDelegateAbortedParseError);
//  }
//  if (name == "NSXMLParserDocumentStartError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserDocumentStartError);
//  }
//  if (name == "NSXMLParserElementContentDeclNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserElementContentDeclNotFinishedError);
//  }
//  if (name == "NSXMLParserElementContentDeclNotStartedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserElementContentDeclNotStartedError);
//  }
//  if (name == "NSXMLParserEmptyDocumentError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEmptyDocumentError);
//  }
//  if (name == "NSXMLParserEncodingNotSupportedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEncodingNotSupportedError);
//  }
//  if (name == "NSXMLParserEntityBoundaryError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityBoundaryError);
//  }
//  if (name == "NSXMLParserEntityIsExternalError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityIsExternalError);
//  }
//  if (name == "NSXMLParserEntityIsParameterError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityIsParameterError);
//  }
//  if (name == "NSXMLParserEntityNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityNotFinishedError);
//  }
//  if (name == "NSXMLParserEntityNotStartedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityNotStartedError);
//  }
//  if (name == "NSXMLParserEntityRefAtEOFError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityRefAtEOFError);
//  }
//  if (name == "NSXMLParserEntityRefInDTDError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityRefInDTDError);
//  }
//  if (name == "NSXMLParserEntityRefInEpilogError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityRefInEpilogError);
//  }
//  if (name == "NSXMLParserEntityRefInPrologError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityRefInPrologError);
//  }
//  if (name == "NSXMLParserEntityRefLoopError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityRefLoopError);
//  }
//  if (name == "NSXMLParserEntityReferenceMissingSemiError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityReferenceMissingSemiError);
//  }
//  if (name == "NSXMLParserEntityReferenceWithoutNameError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityReferenceWithoutNameError);
//  }
//  if (name == "NSXMLParserEntityValueRequiredError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityValueRequiredError);
//  }
//  if (name == "NSXMLParserEqualExpectedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEqualExpectedError);
//  }
//  if (name == "NSXMLParserError") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"InternalError": NSXMLParserInternalError,
//        @"OutOfMemoryError": NSXMLParserOutOfMemoryError,
//        @"DocumentStartError": NSXMLParserDocumentStartError,
//        @"EmptyDocumentError": NSXMLParserEmptyDocumentError,
//        @"PrematureDocumentEndError": NSXMLParserPrematureDocumentEndError,
//        @"InvalidHexCharacterRefError": NSXMLParserInvalidHexCharacterRefError,
//        @"InvalidDecimalCharacterRefError": NSXMLParserInvalidDecimalCharacterRefError,
//        @"InvalidCharacterRefError": NSXMLParserInvalidCharacterRefError,
//        @"InvalidCharacterError": NSXMLParserInvalidCharacterError,
//        @"CharacterRefAtEOFError": NSXMLParserCharacterRefAtEOFError,
//        @"CharacterRefInPrologError": NSXMLParserCharacterRefInPrologError,
//        @"CharacterRefInEpilogError": NSXMLParserCharacterRefInEpilogError,
//        @"CharacterRefInDTDError": NSXMLParserCharacterRefInDTDError,
//        @"EntityRefAtEOFError": NSXMLParserEntityRefAtEOFError,
//        @"EntityRefInPrologError": NSXMLParserEntityRefInPrologError,
//        @"EntityRefInEpilogError": NSXMLParserEntityRefInEpilogError,
//        @"EntityRefInDTDError": NSXMLParserEntityRefInDTDError,
//        @"ParsedEntityRefAtEOFError": NSXMLParserParsedEntityRefAtEOFError,
//        @"ParsedEntityRefInPrologError": NSXMLParserParsedEntityRefInPrologError,
//        @"ParsedEntityRefInEpilogError": NSXMLParserParsedEntityRefInEpilogError,
//        @"ParsedEntityRefInInternalSubsetError": NSXMLParserParsedEntityRefInInternalSubsetError,
//        @"EntityReferenceWithoutNameError": NSXMLParserEntityReferenceWithoutNameError,
//        @"EntityReferenceMissingSemiError": NSXMLParserEntityReferenceMissingSemiError,
//        @"ParsedEntityRefNoNameError": NSXMLParserParsedEntityRefNoNameError,
//        @"ParsedEntityRefMissingSemiError": NSXMLParserParsedEntityRefMissingSemiError,
//        @"UndeclaredEntityError": NSXMLParserUndeclaredEntityError,
//        @"UnparsedEntityError": NSXMLParserUnparsedEntityError,
//        @"EntityIsExternalError": NSXMLParserEntityIsExternalError,
//        @"EntityIsParameterError": NSXMLParserEntityIsParameterError,
//        @"UnknownEncodingError": NSXMLParserUnknownEncodingError,
//        @"EncodingNotSupportedError": NSXMLParserEncodingNotSupportedError,
//        @"StringNotStartedError": NSXMLParserStringNotStartedError,
//        @"StringNotClosedError": NSXMLParserStringNotClosedError,
//        @"NamespaceDeclarationError": NSXMLParserNamespaceDeclarationError,
//        @"EntityNotStartedError": NSXMLParserEntityNotStartedError,
//        @"EntityNotFinishedError": NSXMLParserEntityNotFinishedError,
//        @"LessThanSymbolInAttributeError": NSXMLParserLessThanSymbolInAttributeError,
//        @"AttributeNotStartedError": NSXMLParserAttributeNotStartedError,
//        @"AttributeNotFinishedError": NSXMLParserAttributeNotFinishedError,
//        @"AttributeHasNoValueError": NSXMLParserAttributeHasNoValueError,
//        @"AttributeRedefinedError": NSXMLParserAttributeRedefinedError,
//        @"LiteralNotStartedError": NSXMLParserLiteralNotStartedError,
//        @"LiteralNotFinishedError": NSXMLParserLiteralNotFinishedError,
//        @"CommentNotFinishedError": NSXMLParserCommentNotFinishedError,
//        @"ProcessingInstructionNotStartedError": NSXMLParserProcessingInstructionNotStartedError,
//        @"ProcessingInstructionNotFinishedError": NSXMLParserProcessingInstructionNotFinishedError,
//        @"NotationNotStartedError": NSXMLParserNotationNotStartedError,
//        @"NotationNotFinishedError": NSXMLParserNotationNotFinishedError,
//        @"AttributeListNotStartedError": NSXMLParserAttributeListNotStartedError,
//        @"AttributeListNotFinishedError": NSXMLParserAttributeListNotFinishedError,
//        @"MixedContentDeclNotStartedError": NSXMLParserMixedContentDeclNotStartedError,
//        @"MixedContentDeclNotFinishedError": NSXMLParserMixedContentDeclNotFinishedError,
//        @"ElementContentDeclNotStartedError": NSXMLParserElementContentDeclNotStartedError,
//        @"ElementContentDeclNotFinishedError": NSXMLParserElementContentDeclNotFinishedError,
//        @"XMLDeclNotStartedError": NSXMLParserXMLDeclNotStartedError,
//        @"XMLDeclNotFinishedError": NSXMLParserXMLDeclNotFinishedError,
//        @"ConditionalSectionNotStartedError": NSXMLParserConditionalSectionNotStartedError,
//        @"ConditionalSectionNotFinishedError": NSXMLParserConditionalSectionNotFinishedError,
//        @"ExternalSubsetNotFinishedError": NSXMLParserExternalSubsetNotFinishedError,
//        @"DOCTYPEDeclNotFinishedError": NSXMLParserDOCTYPEDeclNotFinishedError,
//        @"MisplacedCDATAEndStringError": NSXMLParserMisplacedCDATAEndStringError,
//        @"CDATANotFinishedError": NSXMLParserCDATANotFinishedError,
//        @"MisplacedXMLDeclarationError": NSXMLParserMisplacedXMLDeclarationError,
//        @"SpaceRequiredError": NSXMLParserSpaceRequiredError,
//        @"SeparatorRequiredError": NSXMLParserSeparatorRequiredError,
//        @"NMTOKENRequiredError": NSXMLParserNMTOKENRequiredError,
//        @"NAMERequiredError": NSXMLParserNAMERequiredError,
//        @"PCDATARequiredError": NSXMLParserPCDATARequiredError,
//        @"URIRequiredError": NSXMLParserURIRequiredError,
//        @"PublicIdentifierRequiredError": NSXMLParserPublicIdentifierRequiredError,
//        @"LTRequiredError": NSXMLParserLTRequiredError,
//        @"GTRequiredError": NSXMLParserGTRequiredError,
//        @"LTSlashRequiredError": NSXMLParserLTSlashRequiredError,
//        @"EqualExpectedError": NSXMLParserEqualExpectedError,
//        @"TagNameMismatchError": NSXMLParserTagNameMismatchError,
//        @"UnfinishedTagError": NSXMLParserUnfinishedTagError,
//        @"StandaloneValueError": NSXMLParserStandaloneValueError,
//        @"InvalidEncodingNameError": NSXMLParserInvalidEncodingNameError,
//        @"CommentContainsDoubleHyphenError": NSXMLParserCommentContainsDoubleHyphenError,
//        @"InvalidEncodingError": NSXMLParserInvalidEncodingError,
//        @"ExternalStandaloneEntityError": NSXMLParserExternalStandaloneEntityError,
//        @"InvalidConditionalSectionError": NSXMLParserInvalidConditionalSectionError,
//        @"EntityValueRequiredError": NSXMLParserEntityValueRequiredError,
//        @"NotWellBalancedError": NSXMLParserNotWellBalancedError,
//        @"ExtraContentError": NSXMLParserExtraContentError,
//        @"InvalidCharacterInEntityError": NSXMLParserInvalidCharacterInEntityError,
//        @"ParsedEntityRefInInternalError": NSXMLParserParsedEntityRefInInternalError,
//        @"EntityRefLoopError": NSXMLParserEntityRefLoopError,
//        @"EntityBoundaryError": NSXMLParserEntityBoundaryError,
//        @"InvalidURIError": NSXMLParserInvalidURIError,
//        @"URIFragmentError": NSXMLParserURIFragmentError,
//        @"NoDTDError": NSXMLParserNoDTDError,
//        @"DelegateAbortedParseError": NSXMLParserDelegateAbortedParseError
//      }
//    );
//  }
//  if (name == "NSXMLParserInternalError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserInternalError);
//  }
//  if (name == "NSXMLParserOutOfMemoryError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserOutOfMemoryError);
//  }
//  if (name == "NSXMLParserDocumentStartError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserDocumentStartError);
//  }
//  if (name == "NSXMLParserEmptyDocumentError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEmptyDocumentError);
//  }
//  if (name == "NSXMLParserPrematureDocumentEndError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserPrematureDocumentEndError);
//  }
//  if (name == "NSXMLParserInvalidHexCharacterRefError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserInvalidHexCharacterRefError);
//  }
//  if (name == "NSXMLParserInvalidDecimalCharacterRefError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserInvalidDecimalCharacterRefError);
//  }
//  if (name == "NSXMLParserInvalidCharacterRefError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserInvalidCharacterRefError);
//  }
//  if (name == "NSXMLParserInvalidCharacterError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserInvalidCharacterError);
//  }
//  if (name == "NSXMLParserCharacterRefAtEOFError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserCharacterRefAtEOFError);
//  }
//  if (name == "NSXMLParserCharacterRefInPrologError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserCharacterRefInPrologError);
//  }
//  if (name == "NSXMLParserCharacterRefInEpilogError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserCharacterRefInEpilogError);
//  }
//  if (name == "NSXMLParserCharacterRefInDTDError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserCharacterRefInDTDError);
//  }
//  if (name == "NSXMLParserEntityRefAtEOFError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityRefAtEOFError);
//  }
//  if (name == "NSXMLParserEntityRefInPrologError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityRefInPrologError);
//  }
//  if (name == "NSXMLParserEntityRefInEpilogError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityRefInEpilogError);
//  }
//  if (name == "NSXMLParserEntityRefInDTDError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityRefInDTDError);
//  }
//  if (name == "NSXMLParserParsedEntityRefAtEOFError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserParsedEntityRefAtEOFError);
//  }
//  if (name == "NSXMLParserParsedEntityRefInPrologError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserParsedEntityRefInPrologError);
//  }
//  if (name == "NSXMLParserParsedEntityRefInEpilogError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserParsedEntityRefInEpilogError);
//  }
//  if (name == "NSXMLParserParsedEntityRefInInternalSubsetError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserParsedEntityRefInInternalSubsetError);
//  }
//  if (name == "NSXMLParserEntityReferenceWithoutNameError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityReferenceWithoutNameError);
//  }
//  if (name == "NSXMLParserEntityReferenceMissingSemiError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityReferenceMissingSemiError);
//  }
//  if (name == "NSXMLParserParsedEntityRefNoNameError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserParsedEntityRefNoNameError);
//  }
//  if (name == "NSXMLParserParsedEntityRefMissingSemiError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserParsedEntityRefMissingSemiError);
//  }
//  if (name == "NSXMLParserUndeclaredEntityError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserUndeclaredEntityError);
//  }
//  if (name == "NSXMLParserUnparsedEntityError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserUnparsedEntityError);
//  }
//  if (name == "NSXMLParserEntityIsExternalError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityIsExternalError);
//  }
//  if (name == "NSXMLParserEntityIsParameterError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityIsParameterError);
//  }
//  if (name == "NSXMLParserUnknownEncodingError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserUnknownEncodingError);
//  }
//  if (name == "NSXMLParserEncodingNotSupportedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEncodingNotSupportedError);
//  }
//  if (name == "NSXMLParserStringNotStartedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserStringNotStartedError);
//  }
//  if (name == "NSXMLParserStringNotClosedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserStringNotClosedError);
//  }
//  if (name == "NSXMLParserNamespaceDeclarationError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserNamespaceDeclarationError);
//  }
//  if (name == "NSXMLParserEntityNotStartedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityNotStartedError);
//  }
//  if (name == "NSXMLParserEntityNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityNotFinishedError);
//  }
//  if (name == "NSXMLParserLessThanSymbolInAttributeError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserLessThanSymbolInAttributeError);
//  }
//  if (name == "NSXMLParserAttributeNotStartedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserAttributeNotStartedError);
//  }
//  if (name == "NSXMLParserAttributeNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserAttributeNotFinishedError);
//  }
//  if (name == "NSXMLParserAttributeHasNoValueError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserAttributeHasNoValueError);
//  }
//  if (name == "NSXMLParserAttributeRedefinedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserAttributeRedefinedError);
//  }
//  if (name == "NSXMLParserLiteralNotStartedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserLiteralNotStartedError);
//  }
//  if (name == "NSXMLParserLiteralNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserLiteralNotFinishedError);
//  }
//  if (name == "NSXMLParserCommentNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserCommentNotFinishedError);
//  }
//  if (name == "NSXMLParserProcessingInstructionNotStartedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserProcessingInstructionNotStartedError);
//  }
//  if (name == "NSXMLParserProcessingInstructionNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserProcessingInstructionNotFinishedError);
//  }
//  if (name == "NSXMLParserNotationNotStartedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserNotationNotStartedError);
//  }
//  if (name == "NSXMLParserNotationNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserNotationNotFinishedError);
//  }
//  if (name == "NSXMLParserAttributeListNotStartedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserAttributeListNotStartedError);
//  }
//  if (name == "NSXMLParserAttributeListNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserAttributeListNotFinishedError);
//  }
//  if (name == "NSXMLParserMixedContentDeclNotStartedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserMixedContentDeclNotStartedError);
//  }
//  if (name == "NSXMLParserMixedContentDeclNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserMixedContentDeclNotFinishedError);
//  }
//  if (name == "NSXMLParserElementContentDeclNotStartedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserElementContentDeclNotStartedError);
//  }
//  if (name == "NSXMLParserElementContentDeclNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserElementContentDeclNotFinishedError);
//  }
//  if (name == "NSXMLParserXMLDeclNotStartedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserXMLDeclNotStartedError);
//  }
//  if (name == "NSXMLParserXMLDeclNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserXMLDeclNotFinishedError);
//  }
//  if (name == "NSXMLParserConditionalSectionNotStartedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserConditionalSectionNotStartedError);
//  }
//  if (name == "NSXMLParserConditionalSectionNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserConditionalSectionNotFinishedError);
//  }
//  if (name == "NSXMLParserExternalSubsetNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserExternalSubsetNotFinishedError);
//  }
//  if (name == "NSXMLParserDOCTYPEDeclNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserDOCTYPEDeclNotFinishedError);
//  }
//  if (name == "NSXMLParserMisplacedCDATAEndStringError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserMisplacedCDATAEndStringError);
//  }
//  if (name == "NSXMLParserCDATANotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserCDATANotFinishedError);
//  }
//  if (name == "NSXMLParserMisplacedXMLDeclarationError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserMisplacedXMLDeclarationError);
//  }
//  if (name == "NSXMLParserSpaceRequiredError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserSpaceRequiredError);
//  }
//  if (name == "NSXMLParserSeparatorRequiredError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserSeparatorRequiredError);
//  }
//  if (name == "NSXMLParserNMTOKENRequiredError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserNMTOKENRequiredError);
//  }
//  if (name == "NSXMLParserNAMERequiredError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserNAMERequiredError);
//  }
//  if (name == "NSXMLParserPCDATARequiredError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserPCDATARequiredError);
//  }
//  if (name == "NSXMLParserURIRequiredError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserURIRequiredError);
//  }
//  if (name == "NSXMLParserPublicIdentifierRequiredError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserPublicIdentifierRequiredError);
//  }
//  if (name == "NSXMLParserLTRequiredError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserLTRequiredError);
//  }
//  if (name == "NSXMLParserGTRequiredError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserGTRequiredError);
//  }
//  if (name == "NSXMLParserLTSlashRequiredError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserLTSlashRequiredError);
//  }
//  if (name == "NSXMLParserEqualExpectedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEqualExpectedError);
//  }
//  if (name == "NSXMLParserTagNameMismatchError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserTagNameMismatchError);
//  }
//  if (name == "NSXMLParserUnfinishedTagError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserUnfinishedTagError);
//  }
//  if (name == "NSXMLParserStandaloneValueError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserStandaloneValueError);
//  }
//  if (name == "NSXMLParserInvalidEncodingNameError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserInvalidEncodingNameError);
//  }
//  if (name == "NSXMLParserCommentContainsDoubleHyphenError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserCommentContainsDoubleHyphenError);
//  }
//  if (name == "NSXMLParserInvalidEncodingError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserInvalidEncodingError);
//  }
//  if (name == "NSXMLParserExternalStandaloneEntityError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserExternalStandaloneEntityError);
//  }
//  if (name == "NSXMLParserInvalidConditionalSectionError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserInvalidConditionalSectionError);
//  }
//  if (name == "NSXMLParserEntityValueRequiredError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityValueRequiredError);
//  }
//  if (name == "NSXMLParserNotWellBalancedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserNotWellBalancedError);
//  }
//  if (name == "NSXMLParserExtraContentError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserExtraContentError);
//  }
//  if (name == "NSXMLParserInvalidCharacterInEntityError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserInvalidCharacterInEntityError);
//  }
//  if (name == "NSXMLParserParsedEntityRefInInternalError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserParsedEntityRefInInternalError);
//  }
//  if (name == "NSXMLParserEntityRefLoopError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityRefLoopError);
//  }
//  if (name == "NSXMLParserEntityBoundaryError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserEntityBoundaryError);
//  }
//  if (name == "NSXMLParserInvalidURIError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserInvalidURIError);
//  }
//  if (name == "NSXMLParserURIFragmentError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserURIFragmentError);
//  }
//  if (name == "NSXMLParserNoDTDError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserNoDTDError);
//  }
//  if (name == "NSXMLParserDelegateAbortedParseError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserDelegateAbortedParseError);
//  }
//  if (name == "NSXMLParserErrorDomain") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserErrorDomain);
//  }
//  if (name == "NSXMLParserExternalEntityResolvingPolicy") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"ResolveExternalEntitiesNever": NSXMLParserResolveExternalEntitiesNever,
//        @"ResolveExternalEntitiesNoNetwork": NSXMLParserResolveExternalEntitiesNoNetwork,
//        @"ResolveExternalEntitiesSameOriginOnly": NSXMLParserResolveExternalEntitiesSameOriginOnly,
//        @"ResolveExternalEntitiesAlways": NSXMLParserResolveExternalEntitiesAlways
//      }
//    );
//  }
//  if (name == "NSXMLParserResolveExternalEntitiesNever") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserResolveExternalEntitiesNever);
//  }
//  if (name == "NSXMLParserResolveExternalEntitiesNoNetwork") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserResolveExternalEntitiesNoNetwork);
//  }
//  if (name == "NSXMLParserResolveExternalEntitiesSameOriginOnly") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserResolveExternalEntitiesSameOriginOnly);
//  }
//  if (name == "NSXMLParserResolveExternalEntitiesAlways") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserResolveExternalEntitiesAlways);
//  }
//  if (name == "NSXMLParserExternalStandaloneEntityError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserExternalStandaloneEntityError);
//  }
//  if (name == "NSXMLParserExternalSubsetNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserExternalSubsetNotFinishedError);
//  }
//  if (name == "NSXMLParserExtraContentError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserExtraContentError);
//  }
//  if (name == "NSXMLParserGTRequiredError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserGTRequiredError);
//  }
//  if (name == "NSXMLParserInternalError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserInternalError);
//  }
//  if (name == "NSXMLParserInvalidCharacterError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserInvalidCharacterError);
//  }
//  if (name == "NSXMLParserInvalidCharacterInEntityError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserInvalidCharacterInEntityError);
//  }
//  if (name == "NSXMLParserInvalidCharacterRefError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserInvalidCharacterRefError);
//  }
//  if (name == "NSXMLParserInvalidConditionalSectionError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserInvalidConditionalSectionError);
//  }
//  if (name == "NSXMLParserInvalidDecimalCharacterRefError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserInvalidDecimalCharacterRefError);
//  }
//  if (name == "NSXMLParserInvalidEncodingError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserInvalidEncodingError);
//  }
//  if (name == "NSXMLParserInvalidEncodingNameError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserInvalidEncodingNameError);
//  }
//  if (name == "NSXMLParserInvalidHexCharacterRefError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserInvalidHexCharacterRefError);
//  }
//  if (name == "NSXMLParserInvalidURIError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserInvalidURIError);
//  }
//  if (name == "NSXMLParserLTRequiredError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserLTRequiredError);
//  }
//  if (name == "NSXMLParserLTSlashRequiredError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserLTSlashRequiredError);
//  }
//  if (name == "NSXMLParserLessThanSymbolInAttributeError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserLessThanSymbolInAttributeError);
//  }
//  if (name == "NSXMLParserLiteralNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserLiteralNotFinishedError);
//  }
//  if (name == "NSXMLParserLiteralNotStartedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserLiteralNotStartedError);
//  }
//  if (name == "NSXMLParserMisplacedCDATAEndStringError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserMisplacedCDATAEndStringError);
//  }
//  if (name == "NSXMLParserMisplacedXMLDeclarationError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserMisplacedXMLDeclarationError);
//  }
//  if (name == "NSXMLParserMixedContentDeclNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserMixedContentDeclNotFinishedError);
//  }
//  if (name == "NSXMLParserMixedContentDeclNotStartedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserMixedContentDeclNotStartedError);
//  }
//  if (name == "NSXMLParserNAMERequiredError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserNAMERequiredError);
//  }
//  if (name == "NSXMLParserNMTOKENRequiredError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserNMTOKENRequiredError);
//  }
//  if (name == "NSXMLParserNamespaceDeclarationError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserNamespaceDeclarationError);
//  }
//  if (name == "NSXMLParserNoDTDError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserNoDTDError);
//  }
//  if (name == "NSXMLParserNotWellBalancedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserNotWellBalancedError);
//  }
//  if (name == "NSXMLParserNotationNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserNotationNotFinishedError);
//  }
//  if (name == "NSXMLParserNotationNotStartedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserNotationNotStartedError);
//  }
//  if (name == "NSXMLParserOutOfMemoryError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserOutOfMemoryError);
//  }
//  if (name == "NSXMLParserPCDATARequiredError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserPCDATARequiredError);
//  }
//  if (name == "NSXMLParserParsedEntityRefAtEOFError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserParsedEntityRefAtEOFError);
//  }
//  if (name == "NSXMLParserParsedEntityRefInEpilogError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserParsedEntityRefInEpilogError);
//  }
//  if (name == "NSXMLParserParsedEntityRefInInternalError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserParsedEntityRefInInternalError);
//  }
//  if (name == "NSXMLParserParsedEntityRefInInternalSubsetError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserParsedEntityRefInInternalSubsetError);
//  }
//  if (name == "NSXMLParserParsedEntityRefInPrologError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserParsedEntityRefInPrologError);
//  }
//  if (name == "NSXMLParserParsedEntityRefMissingSemiError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserParsedEntityRefMissingSemiError);
//  }
//  if (name == "NSXMLParserParsedEntityRefNoNameError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserParsedEntityRefNoNameError);
//  }
//  if (name == "NSXMLParserPrematureDocumentEndError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserPrematureDocumentEndError);
//  }
//  if (name == "NSXMLParserProcessingInstructionNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserProcessingInstructionNotFinishedError);
//  }
//  if (name == "NSXMLParserProcessingInstructionNotStartedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserProcessingInstructionNotStartedError);
//  }
//  if (name == "NSXMLParserPublicIdentifierRequiredError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserPublicIdentifierRequiredError);
//  }
//  if (name == "NSXMLParserResolveExternalEntitiesAlways") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserResolveExternalEntitiesAlways);
//  }
//  if (name == "NSXMLParserResolveExternalEntitiesNever") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserResolveExternalEntitiesNever);
//  }
//  if (name == "NSXMLParserResolveExternalEntitiesNoNetwork") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserResolveExternalEntitiesNoNetwork);
//  }
//  if (name == "NSXMLParserResolveExternalEntitiesSameOriginOnly") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserResolveExternalEntitiesSameOriginOnly);
//  }
//  if (name == "NSXMLParserSeparatorRequiredError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserSeparatorRequiredError);
//  }
//  if (name == "NSXMLParserSpaceRequiredError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserSpaceRequiredError);
//  }
//  if (name == "NSXMLParserStandaloneValueError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserStandaloneValueError);
//  }
//  if (name == "NSXMLParserStringNotClosedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserStringNotClosedError);
//  }
//  if (name == "NSXMLParserStringNotStartedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserStringNotStartedError);
//  }
//  if (name == "NSXMLParserTagNameMismatchError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserTagNameMismatchError);
//  }
//  if (name == "NSXMLParserURIFragmentError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserURIFragmentError);
//  }
//  if (name == "NSXMLParserURIRequiredError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserURIRequiredError);
//  }
//  if (name == "NSXMLParserUndeclaredEntityError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserUndeclaredEntityError);
//  }
//  if (name == "NSXMLParserUnfinishedTagError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserUnfinishedTagError);
//  }
//  if (name == "NSXMLParserUnknownEncodingError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserUnknownEncodingError);
//  }
//  if (name == "NSXMLParserUnparsedEntityError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserUnparsedEntityError);
//  }
//  if (name == "NSXMLParserXMLDeclNotFinishedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserXMLDeclNotFinishedError);
//  }
//  if (name == "NSXMLParserXMLDeclNotStartedError") {
//    return convertObjCObjectToJSIValue(runtime, NSXMLParserXMLDeclNotStartedError);
//  }
//  // TODO: NSXPCCoder (Interface)
//  // TODO: NSXPCConnection (Interface)
//  if (name == "NSXPCConnectionErrorMaximum") {
//    return convertObjCObjectToJSIValue(runtime, NSXPCConnectionErrorMaximum);
//  }
//  if (name == "NSXPCConnectionErrorMinimum") {
//    return convertObjCObjectToJSIValue(runtime, NSXPCConnectionErrorMinimum);
//  }
//  if (name == "NSXPCConnectionInterrupted") {
//    return convertObjCObjectToJSIValue(runtime, NSXPCConnectionInterrupted);
//  }
//  if (name == "NSXPCConnectionInvalid") {
//    return convertObjCObjectToJSIValue(runtime, NSXPCConnectionInvalid);
//  }
//  if (name == "NSXPCConnectionOptions") {
//    return convertNSDictionaryToJSIObject(
//      runtime,
//      @{
//        @"Privileged": NSXPCConnectionPrivileged
//      }
//    );
//  }
//  if (name == "NSXPCConnectionPrivileged") {
//    return convertObjCObjectToJSIValue(runtime, NSXPCConnectionPrivileged);
//  }
//  if (name == "NSXPCConnectionPrivileged") {
//    return convertObjCObjectToJSIValue(runtime, NSXPCConnectionPrivileged);
//  }
//  if (name == "NSXPCConnectionReplyInvalid") {
//    return convertObjCObjectToJSIValue(runtime, NSXPCConnectionReplyInvalid);
//  }
//  // TODO: NSXPCInterface (Interface)
//  // TODO: NSXPCListener (Interface)
//  // TODO: NSXPCListenerDelegate (Protocol)
//  // TODO: NSXPCListenerEndpoint (Interface)
//  // TODO: NSXPCProxyCreating (Protocol)
//  if (name == "NSYearCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSYearCalendarUnit);
//  }
//  if (name == "NSYearForWeekOfYearCalendarUnit") {
//    return convertObjCObjectToJSIValue(runtime, NSYearForWeekOfYearCalendarUnit);
//  }
//  if (name == "NSZoneCalloc") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSZoneCalloc(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSZoneCalloc"), 3, func);
//  }
//  if (name == "NSZoneFree") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSZoneFree(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSZoneFree"), 2, func);
//  }
//  if (name == "NSZoneFromPointer") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSZoneFromPointer(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSZoneFromPointer"), 1, func);
//  }
//  if (name == "NSZoneMalloc") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSZoneMalloc(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSZoneMalloc"), 2, func);
//  }
//  if (name == "NSZoneName") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSZoneName(
//        convertJSIValueToObjCObject(arguments[0])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSZoneName"), 1, func);
//  }
//  if (name == "NSZoneRealloc") {
//    auto func = [this] (jsi::Runtime& runtime, const jsi::Value& thisValue, const jsi::Value* arguments, size_t count) -> jsi::Value {
//      id result = NSZoneRealloc(
//        convertJSIValueToObjCObject(arguments[0]),
//        convertJSIValueToObjCObject(arguments[1]),
//        convertJSIValueToObjCObject(arguments[2])
//      );
//      return convertObjCObjectToJSIValue(runtime, result);
//    };
//    return jsi::Function::createFromHostFunction(runtime, jsi::PropNameID::forUtf8(runtime, "NSZoneRealloc"), 3, func);
//  }
//  if (name == "NS_BigEndian") {
//    return convertObjCObjectToJSIValue(runtime, NS_BigEndian);
//  }
//  if (name == "NS_LittleEndian") {
//    return convertObjCObjectToJSIValue(runtime, NS_LittleEndian);
//  }
//  if (name == "NS_UnknownByteOrder") {
//    return convertObjCObjectToJSIValue(runtime, NS_UnknownByteOrder);
//  }
  // TODO: _expressionFlags (Struct)
  // TODO: _predicateFlags (Struct)

  // If no matching symbol was found
  return jsi::Value::undefined();
}

