/* eslint-disable */

// Modified from the typings distributed by @nativescript/ios/types (equally possible to generate in any NativeScript iOS project):
//   objc!ObjectiveC.d.ts
//   objc!Foundation.d.ts
// This is a stand-in until we have an automatic solution for generating types. It is *far* from comprehensive!
// The main differences from the NativeScript iOS types are that:
// - I've namespaced everything under `objc`.
// - Selectors take their unaltered Obj-C runtime names (i.e. they'll have colons when accepting args).
// @see https://github.com/NativeScript/NativeScript/tree/master/packages/types-ios

import globalObjc = objc;

/**
 * Very provisional.
 */
interface HostObject {
    toString(): string;
    [key: string]: unknown;
}
interface HostObjectClass<T extends NSObject> extends HostObject {
    clazz: typeof T;
}
interface HostObjectClassInstance<T extends NSObject> extends HostObject {
    instance: T;
}
interface HostObjectClassSelector extends HostObject {
    sel: any; // I'll think about this later...
}
interface HostObjectClassProtocol extends HostObject {
    protocol: any; // I'll think about this later...
}

/**
 * From NativeScript; haven't yet decided how to handle params with these types.
 * Defining the interface simply saves me some text-editing.
 */
declare module interop {
    type Pointer = unknown;
    type Reference<T> = unknown;
}

declare module objc {
    /**
     * Turns any serialisable hostObjectClassInstance back into a JS type.
     * I'm only writing NSString into the typings for now.
     */
    function marshal(hostObjectClassInstance: NSString): string;

    export class NSObject implements NSObjectProtocol {

        static alloc(): NSObject;

        toJS(): any|undefined;
    
        // static automaticallyNotifiesObserversForKey(key: string): boolean;
    
        // static cancelPreviousPerformRequestsWithTarget(aTarget: any): void;
    
        // static cancelPreviousPerformRequestsWithTargetSelectorObject(aTarget: any, aSelector: string, anArgument: any): void;
    
        // static class(): typeof NSObject;
    
        // static classFallbacksForKeyedArchiver(): NSArray<string>;
    
        // static classForKeyedUnarchiver(): typeof NSObject;
    
        // static conformsToProtocol(protocol: any /* Protocol */): boolean;
    
        // static copyWithZone(zone: interop.Pointer | interop.Reference<any>): any;
    
        // static debugDescription(): string;
    
        // static description(): string;
    
        // static hash(): number;
    
        // static initialize(): void;
    
        // static instanceMethodForSelector(aSelector: string): interop.FunctionReference<() => void>;
    
        // static instanceMethodSignatureForSelector(aSelector: string): NSMethodSignature;
    
        // static instancesRespondToSelector(aSelector: string): boolean;
    
        // static isSubclassOfClass(aClass: typeof NSObject): boolean;
    
        // static keyPathsForValuesAffectingValueForKey(key: string): NSSet<string>;
    
        // static load(): void;
    
        // static mutableCopyWithZone(zone: interop.Pointer | interop.Reference<any>): any;
    
        static new(): NSObject;
    
        // static resolveClassMethod(sel: string): boolean;
    
        // static resolveInstanceMethod(sel: string): boolean;
    
        // static setVersion(aVersion: number): void;
    
        // static superclass(): typeof NSObject;
    
        // static version(): number;
    
        // accessibilityActivationPoint: CGPoint;
    
        // accessibilityAttributedHint: NSAttributedString;
    
        // accessibilityAttributedLabel: NSAttributedString;
    
        // accessibilityAttributedUserInputLabels: NSArray<NSAttributedString>;
    
        // accessibilityAttributedValue: NSAttributedString;
    
        // accessibilityContainerType: UIAccessibilityContainerType;
    
        // accessibilityCustomActions: NSArray<UIAccessibilityCustomAction>;
    
        // accessibilityCustomRotors: NSArray<UIAccessibilityCustomRotor>;
    
        // accessibilityDragSourceDescriptors: NSArray<UIAccessibilityLocationDescriptor>;
    
        // accessibilityDropPointDescriptors: NSArray<UIAccessibilityLocationDescriptor>;
    
        // accessibilityElements: NSArray<any>;
    
        // accessibilityElementsHidden: boolean;
    
        // accessibilityFrame: CGRect;
    
        // accessibilityHint: string;
    
        // accessibilityLabel: string;
    
        // accessibilityLanguage: string;
    
        // accessibilityNavigationStyle: UIAccessibilityNavigationStyle;
    
        // accessibilityPath: UIBezierPath;
    
        // accessibilityRespondsToUserInteraction: boolean;
    
        // accessibilityTextualContext: string;
    
        // accessibilityTraits: number;
    
        // accessibilityUserInputLabels: NSArray<string>;
    
        // accessibilityValue: string;
    
        // accessibilityViewIsModal: boolean;
    
        // readonly autoContentAccessingProxy: any;
    
        // readonly classForCoder: typeof NSObject;
    
        // readonly classForKeyedArchiver: typeof NSObject;
    
        // isAccessibilityElement: boolean;
    
        // observationInfo: interop.Pointer | interop.Reference<any>;
    
        // shouldGroupAccessibilityChildren: boolean;
    
        // static readonly accessInstanceVariablesDirectly: boolean;
    
        // readonly debugDescription: string; // inherited from NSObjectProtocol
    
        // readonly description: string; // inherited from NSObjectProtocol
    
        // readonly hash: number; // inherited from NSObjectProtocol
    
        // readonly isProxy: boolean; // inherited from NSObjectProtocol
    
        // readonly superclass: typeof NSObject; // inherited from NSObjectProtocol
    
        // readonly  // inherited from NSObjectProtocol
    
        // constructor();
    
        // accessibilityActivate(): boolean;
    
        // accessibilityAssistiveTechnologyFocusedIdentifiers(): NSSet<string>;
    
        // accessibilityDecrement(): void;
    
        // accessibilityElementAtIndex(index: number): any;
    
        // accessibilityElementCount(): number;
    
        // accessibilityElementDidBecomeFocused(): void;
    
        // accessibilityElementDidLoseFocus(): void;
    
        // accessibilityElementIsFocused(): boolean;
    
        // accessibilityIncrement(): void;
    
        // accessibilityPerformEscape(): boolean;
    
        // accessibilityPerformMagicTap(): boolean;
    
        // accessibilityScroll(direction: UIAccessibilityScrollDirection): boolean;
    
        // addObserverForKeyPathOptionsContext(observer: NSObject, keyPath: string, options: NSKeyValueObservingOptions, context: interop.Pointer | interop.Reference<any>): void;
    
        // attemptRecoveryFromErrorOptionIndex(error: NSError, recoveryOptionIndex: number): boolean;
    
        // attemptRecoveryFromErrorOptionIndexDelegateDidRecoverSelectorContextInfo(error: NSError, recoveryOptionIndex: number, delegate: any, didRecoverSelector: string, contextInfo: interop.Pointer | interop.Reference<any>): void;
    
        // awakeAfterUsingCoder(coder: NSCoder): any;
    
        // awakeFromNib(): void;
    
        // class(): typeof NSObject;
    
        // conformsToProtocol(aProtocol: any /* Protocol */): boolean;
    
        // copy(): any;
    
        // dealloc(): void;
    
        // dictionaryWithValuesForKeys(keys: NSArray<string> | string[]): NSDictionary<string, any>;
    
        // didChangeValueForKey(key: string): void;
    
        // didChangeValueForKeyWithSetMutationUsingObjects(key: string, mutationKind: NSKeyValueSetMutationKind, objects: NSSet<any>): void;
    
        // didChangeValuesAtIndexesForKey(changeKind: NSKeyValueChange, indexes: NSIndexSet, key: string): void;
    
        // doesNotRecognizeSelector(aSelector: string): void;
    
        // fileManagerShouldProceedAfterError(fm: NSFileManager, errorInfo: NSDictionary<any, any>): boolean;
    
        // fileManagerWillProcessPath(fm: NSFileManager, path: string): void;
    
        // finalize(): void;
    
        // forwardInvocation(anInvocation: NSInvocation): void;
    
        // forwardingTargetForSelector(aSelector: string): any;
    
        // indexOfAccessibilityElement(element: any): number;
    
        init(): this;
    
        // isEqual(object: any): boolean;
    
        // isKindOfClass(aClass: typeof NSObject): boolean;
    
        // isMemberOfClass(aClass: typeof NSObject): boolean;
    
        // methodForSelector(aSelector: string): interop.FunctionReference<() => void>;
    
        // methodSignatureForSelector(aSelector: string): NSMethodSignature;
    
        // mutableArrayValueForKey(key: string): NSMutableArray<any>;
    
        // mutableArrayValueForKeyPath(keyPath: string): NSMutableArray<any>;
    
        // mutableCopy(): any;
    
        // mutableOrderedSetValueForKey(key: string): NSMutableOrderedSet<any>;
    
        // mutableOrderedSetValueForKeyPath(keyPath: string): NSMutableOrderedSet<any>;
    
        // mutableSetValueForKey(key: string): NSMutableSet<any>;
    
        // mutableSetValueForKeyPath(keyPath: string): NSMutableSet<any>;
    
        // observeValueForKeyPathOfObjectChangeContext(keyPath: string, object: any, change: NSDictionary<string, any>, context: interop.Pointer | interop.Reference<any>): void;
    
        // performSelector(aSelector: string): any;
    
        // performSelectorInBackgroundWithObject(aSelector: string, arg: any): void;
    
        // performSelectorOnMainThreadWithObjectWaitUntilDone(aSelector: string, arg: any, wait: boolean): void;
    
        // performSelectorOnMainThreadWithObjectWaitUntilDoneModes(aSelector: string, arg: any, wait: boolean, array: NSArray<string> | string[]): void;
    
        // performSelectorOnThreadWithObjectWaitUntilDone(aSelector: string, thr: NSThread, arg: any, wait: boolean): void;
    
        // performSelectorOnThreadWithObjectWaitUntilDoneModes(aSelector: string, thr: NSThread, arg: any, wait: boolean, array: NSArray<string> | string[]): void;
    
        // performSelectorWithObject(aSelector: string, object: any): any;
    
        // performSelectorWithObjectAfterDelay(aSelector: string, anArgument: any, delay: number): void;
    
        // performSelectorWithObjectAfterDelayInModes(aSelector: string, anArgument: any, delay: number, modes: NSArray<string> | string[]): void;
    
        // performSelectorWithObjectWithObject(aSelector: string, object1: any, object2: any): any;
    
        // prepareForInterfaceBuilder(): void;
    
        // provideImageDataBytesPerRowOriginSizeUserInfo(data: interop.Pointer | interop.Reference<any>, rowbytes: number, x: number, y: number, width: number, height: number, info: any): void;
    
        // removeObserverForKeyPath(observer: NSObject, keyPath: string): void;
    
        // removeObserverForKeyPathContext(observer: NSObject, keyPath: string, context: interop.Pointer | interop.Reference<any>): void;
    
        // replacementObjectForCoder(coder: NSCoder): any;
    
        // replacementObjectForKeyedArchiver(archiver: NSKeyedArchiver): any;
    
        // respondsToSelector(aSelector: string): boolean;
    
        // retainCount(): number;
    
        // self(): this;
    
        // setNilValueForKey(key: string): void;
    
        // setValueForKey(value: any, key: string): void;
    
        // setValueForKeyPath(value: any, keyPath: string): void;
    
        // setValueForUndefinedKey(value: any, key: string): void;
    
        // setValuesForKeysWithDictionary(keyedValues: NSDictionary<string, any>): void;
    
        // validateValueForKeyError(ioValue: interop.Pointer | interop.Reference<any>, inKey: string): boolean;
    
        // validateValueForKeyPathError(ioValue: interop.Pointer | interop.Reference<any>, inKeyPath: string): boolean;
    
        // valueForKey(key: string): any;
    
        // valueForKeyPath(keyPath: string): any;
    
        // valueForUndefinedKey(key: string): any;
    
        // willChangeValueForKey(key: string): void;
    
        // willChangeValueForKeyWithSetMutationUsingObjects(key: string, mutationKind: NSKeyValueSetMutationKind, objects: NSSet<any>): void;
    
        // willChangeValuesAtIndexesForKey(changeKind: NSKeyValueChange, indexes: NSIndexSet, key: string): void;
    }
    
    interface NSObjectProtocol {
    
        debugDescription?: string;
    
        description: string;
    
        hash: number;
    
        isProxy: boolean;
    
        superclass: typeof NSObject;
    
        
    
        // class(): typeof NSObject;
    
        // conformsToProtocol(aProtocol: any /* Protocol */): boolean;
    
        // isEqual(object: any): boolean;
    
        // isKindOfClass(aClass: typeof NSObject): boolean;
    
        // isMemberOfClass(aClass: typeof NSObject): boolean;
    
        // performSelector(aSelector: string): any;
    
        // performSelectorWithObject(aSelector: string, object: any): any;
    
        // performSelectorWithObjectWithObject(aSelector: string, object1: any, object2: any): any;
    
        // respondsToSelector(aSelector: string): boolean;
    
        // retainCount(): number;
    
        // self(): NSObjectProtocol;
    }
    declare var NSObjectProtocol: {
    
        prototype: NSObjectProtocol;
    };

    /**
     * Very much a work in progress.
     * TODO: Anything that returns string more than likely should actually return NSString.
     * TODO: Rewrite method names to include colons as appropriate.
     * TODO: Deal with those interop types somehow...
     */
    export class NSString extends NSObject /* implements CKRecordValue, CNKeyDescriptor, NSCopying, NSItemProviderReading, NSItemProviderWriting, NSMutableCopying, NSSecureCoding */ {

        static alloc(): NSString; // inherited from NSObject

        // static itemProviderVisibilityForRepresentationWithTypeIdentifier(typeIdentifier: string): NSItemProviderRepresentationVisibility;

        // static localizedNameOfStringEncoding(encoding: number): string;

        // static localizedUserNotificationStringForKeyArguments(key: string, _arguments: NSArray<any> | any[]): string;

        static new(): NSString; // inherited from NSObject

        // static objectWithItemProviderDataTypeIdentifierError(data: NSData, typeIdentifier: string): NSString;

        // static pathWithComponents(components: NSArray<string> | string[]): string;

        // static string(): NSString;

        // static stringEncodingForDataEncodingOptionsConvertedStringUsedLossyConversion(data: NSData, opts: NSDictionary<string, any>, string: interop.Pointer | interop.Reference<string>, usedLossyConversion: interop.Pointer | interop.Reference<boolean>): number;

        // static stringWithCString(bytes: string | interop.Pointer | interop.Reference<any>): any;

        // static stringWithCStringEncoding(cString: string | interop.Pointer | interop.Reference<any>, enc: number): NSString;

        // static stringWithCStringLength(bytes: string | interop.Pointer | interop.Reference<any>, length: number): any;

        // static stringWithCharactersLength(characters: interop.Pointer | interop.Reference<string>, length: number): NSString;

        // static stringWithContentsOfFile(path: string): any;

        // static stringWithContentsOfFileEncodingCompletion(path: string, enc: number, callback: (p1: string, p2: NSError) => void): void;

        // static stringWithContentsOfFileEncodingError(path: string, enc: number): NSString;

        // static stringWithContentsOfFileUsedEncodingError(path: string, enc: interop.Pointer | interop.Reference<number>): NSString;

        // static stringWithContentsOfURL(url: NSURL): any;

        // static stringWithContentsOfURLEncodingError(url: NSURL, enc: number): NSString;

        // static stringWithContentsOfURLUsedEncodingError(url: NSURL, enc: interop.Pointer | interop.Reference<number>): NSString;

        // static stringWithString(string: string): NSString;

        // static stringWithUTF8String(nullTerminatedCString: string | interop.Pointer | interop.Reference<any>): NSString;

        // readonly UTF8String: string;

        // readonly absolutePath: boolean;

        // readonly boolValue: boolean;

        // readonly capitalizedString: string;

        // readonly decomposedStringWithCanonicalMapping: string;

        // readonly decomposedStringWithCompatibilityMapping: string;

        // readonly doubleValue: number;

        // readonly fastestEncoding: number;

        // readonly fileSystemRepresentation: string;

        // readonly floatValue: number;

        // readonly intValue: number;

        // readonly integerValue: number;

        // readonly lastPathComponent: string;

        // readonly length: number;

        // readonly localizedCapitalizedString: string;

        // readonly localizedLowercaseString: string;

        // readonly localizedUppercaseString: string;

        // readonly longLongValue: number;

        // readonly lowercaseString: string;

        // readonly pathComponents: NSArray<string>;

        // readonly pathExtension: string;

        // readonly precomposedStringWithCanonicalMapping: string;

        // readonly precomposedStringWithCompatibilityMapping: string;

        // readonly smallestEncoding: number;

        // readonly stringByAbbreviatingWithTildeInPath: string;

        // readonly stringByDeletingLastPathComponent: string;

        // readonly stringByDeletingPathExtension: string;

        // readonly stringByExpandingTildeInPath: string;

        // readonly stringByRemovingPercentEncoding: string;

        // readonly stringByResolvingSymlinksInPath: string;

        // readonly stringByStandardizingPath: string;

        // readonly uppercaseString: string;

        // static readonly availableStringEncodings: interop.Pointer | interop.Reference<number>;

        // static readonly defaultCStringEncoding: number;

        // readonly debugDescription: string; // inherited from NSObjectProtocol

        // readonly description: string; // inherited from NSObjectProtocol

        // readonly hash: number; // inherited from NSObjectProtocol

        // readonly isProxy: boolean; // inherited from NSObjectProtocol

        // readonly superclass: typeof NSObject; // inherited from NSObjectProtocol

        // readonly writableTypeIdentifiersForItemProvider: NSArray<string>; // inherited from NSItemProviderWriting

        // readonly  // inherited from NSObjectProtocol

        // static readonly readableTypeIdentifiersForItemProvider: NSArray<string>; // inherited from NSItemProviderReading

        // static readonly supportsSecureCoding: boolean; // inherited from NSSecureCoding

        // static readonly writableTypeIdentifiersForItemProvider: NSArray<string>; // inherited from NSItemProviderWriting

        // constructor(o: { bytes: interop.Pointer | interop.Reference<any>; length: number; encoding: number; });

        // constructor(o: { bytesNoCopy: interop.Pointer | interop.Reference<any>; length: number; encoding: number; deallocator: (p1: interop.Pointer | interop.Reference<any>, p2: number) => void; });

        // constructor(o: { bytesNoCopy: interop.Pointer | interop.Reference<any>; length: number; encoding: number; freeWhenDone: boolean; });

        // constructor(o: { CString: string | interop.Pointer | interop.Reference<any>; });

        // constructor(o: { CString: string | interop.Pointer | interop.Reference<any>; encoding: number; });

        // constructor(o: { CString: string | interop.Pointer | interop.Reference<any>; length: number; });

        // constructor(o: { CStringNoCopy: string | interop.Pointer | interop.Reference<any>; length: number; freeWhenDone: boolean; });

        // constructor(o: { characters: interop.Pointer | interop.Reference<string>; length: number; });

        // constructor(o: { charactersNoCopy: interop.Pointer | interop.Reference<string>; length: number; deallocator: (p1: interop.Pointer | interop.Reference<string>, p2: number) => void; });

        // constructor(o: { charactersNoCopy: interop.Pointer | interop.Reference<string>; length: number; freeWhenDone: boolean; });

        // constructor(o: { coder: NSCoder; }); // inherited from NSCoding

        // constructor(o: { contentsOfFile: string; });

        // constructor(o: { contentsOfFile: string; encoding: number; });

        // constructor(o: { contentsOfFile: string; usedEncoding: interop.Pointer | interop.Reference<number>; });

        // constructor(o: { contentsOfURL: NSURL; });

        // constructor(o: { contentsOfURL: NSURL; encoding: number; });

        // constructor(o: { contentsOfURL: NSURL; usedEncoding: interop.Pointer | interop.Reference<number>; });

        // constructor(o: { data: NSData; encoding: number; });

        // constructor(o: { string: string; });

        // constructor(o: { UTF8String: string | interop.Pointer | interop.Reference<any>; });

        // boundingRectWithSizeOptionsAttributesContext(size: CGSize, options: NSStringDrawingOptions, attributes: NSDictionary<string, any>, context: NSStringDrawingContext): CGRect;

        // cString(): string;

        // cStringLength(): number;

        // cStringUsingEncoding(encoding: number): string;

        // canBeConvertedToEncoding(encoding: number): boolean;

        // capitalizedStringWithLocale(locale: NSLocale): string;

        // caseInsensitiveCompare(string: string): NSComparisonResult;

        // characterAtIndex(index: number): string;

        // class(): typeof NSObject;

        // commonPrefixWithStringOptions(str: string, mask: NSStringCompareOptions): string;

        // compare(string: string): NSComparisonResult;

        // compareOptions(string: string, mask: NSStringCompareOptions): NSComparisonResult;

        // compareOptionsRange(string: string, mask: NSStringCompareOptions, rangeOfReceiverToCompare: NSRange): NSComparisonResult;

        // compareOptionsRangeLocale(string: string, mask: NSStringCompareOptions, rangeOfReceiverToCompare: NSRange, locale: any): NSComparisonResult;

        // completePathIntoStringCaseSensitiveMatchesIntoArrayFilterTypes(outputName: interop.Pointer | interop.Reference<string>, flag: boolean, outputArray: interop.Pointer | interop.Reference<NSArray<string>>, filterTypes: NSArray<string> | string[]): number;

        // componentsSeparatedByCharactersInSet(separator: NSCharacterSet): NSArray<string>;

        // componentsSeparatedByString(separator: string): NSArray<string>;

        // conformsToProtocol(aProtocol: any /* Protocol */): boolean;

        // containsString(str: string): boolean;

        // copyWithZone(zone: interop.Pointer | interop.Reference<any>): any;

        // dataUsingEncoding(encoding: number): NSData;

        // dataUsingEncodingAllowLossyConversion(encoding: number, lossy: boolean): NSData;

        // drawAtPointForWidthWithFontFontSizeLineBreakModeBaselineAdjustment(point: CGPoint, width: number, font: UIFont, fontSize: number, lineBreakMode: NSLineBreakMode, baselineAdjustment: UIBaselineAdjustment): CGSize;

        // drawAtPointForWidthWithFontLineBreakMode(point: CGPoint, width: number, font: UIFont, lineBreakMode: NSLineBreakMode): CGSize;

        // drawAtPointForWidthWithFontMinFontSizeActualFontSizeLineBreakModeBaselineAdjustment(point: CGPoint, width: number, font: UIFont, minFontSize: number, actualFontSize: interop.Pointer | interop.Reference<number>, lineBreakMode: NSLineBreakMode, baselineAdjustment: UIBaselineAdjustment): CGSize;

        // drawAtPointWithAttributes(point: CGPoint, attrs: NSDictionary<string, any>): void;

        // drawAtPointWithFont(point: CGPoint, font: UIFont): CGSize;

        // drawInRectWithAttributes(rect: CGRect, attrs: NSDictionary<string, any>): void;

        // drawInRectWithFont(rect: CGRect, font: UIFont): CGSize;

        // drawInRectWithFontLineBreakMode(rect: CGRect, font: UIFont, lineBreakMode: NSLineBreakMode): CGSize;

        // drawInRectWithFontLineBreakModeAlignment(rect: CGRect, font: UIFont, lineBreakMode: NSLineBreakMode, alignment: NSTextAlignment): CGSize;

        // drawWithRectOptionsAttributesContext(rect: CGRect, options: NSStringDrawingOptions, attributes: NSDictionary<string, any>, context: NSStringDrawingContext): void;

        // encodeWithCoder(coder: NSCoder): void;

        // enumerateLinesUsingBlock(block: (p1: string, p2: interop.Pointer | interop.Reference<boolean>) => void): void;

        // enumerateLinguisticTagsInRangeSchemeOptionsOrthographyUsingBlock(range: NSRange, scheme: string, options: NSLinguisticTaggerOptions, orthography: NSOrthography, block: (p1: string, p2: NSRange, p3: NSRange, p4: interop.Pointer | interop.Reference<boolean>) => void): void;

        // enumerateSubstringsInRangeOptionsUsingBlock(range: NSRange, opts: NSStringEnumerationOptions, block: (p1: string, p2: NSRange, p3: NSRange, p4: interop.Pointer | interop.Reference<boolean>) => void): void;

        // getBytesMaxLengthUsedLengthEncodingOptionsRangeRemainingRange(buffer: interop.Pointer | interop.Reference<any>, maxBufferCount: number, usedBufferCount: interop.Pointer | interop.Reference<number>, encoding: number, options: NSStringEncodingConversionOptions, range: NSRange, leftover: interop.Pointer | interop.Reference<NSRange>): boolean;

        // getCString(bytes: string | interop.Pointer | interop.Reference<any>): void;

        // getCStringMaxLength(bytes: string | interop.Pointer | interop.Reference<any>, maxLength: number): void;

        // getCStringMaxLengthEncoding(buffer: string | interop.Pointer | interop.Reference<any>, maxBufferCount: number, encoding: number): boolean;

        // getCStringMaxLengthRangeRemainingRange(bytes: string | interop.Pointer | interop.Reference<any>, maxLength: number, aRange: NSRange, leftoverRange: interop.Pointer | interop.Reference<NSRange>): void;

        // getCharacters(buffer: interop.Pointer | interop.Reference<string>): void;

        // getCharactersRange(buffer: interop.Pointer | interop.Reference<string>, range: NSRange): void;

        // getFileSystemRepresentationMaxLength(cname: string | interop.Pointer | interop.Reference<any>, max: number): boolean;

        // getLineStartEndContentsEndForRange(startPtr: interop.Pointer | interop.Reference<number>, lineEndPtr: interop.Pointer | interop.Reference<number>, contentsEndPtr: interop.Pointer | interop.Reference<number>, range: NSRange): void;

        // getParagraphStartEndContentsEndForRange(startPtr: interop.Pointer | interop.Reference<number>, parEndPtr: interop.Pointer | interop.Reference<number>, contentsEndPtr: interop.Pointer | interop.Reference<number>, range: NSRange): void;

        // hasPrefix(str: string): boolean;

        // hasSuffix(str: string): boolean;

        ['initWithBytes:length:encoding:'](bytes: interop.Pointer | interop.Reference<any>, len: number, encoding: number): this;

        // initWithBytesNoCopyLengthEncodingDeallocator(bytes: interop.Pointer | interop.Reference<any>, len: number, encoding: number, deallocator: (p1: interop.Pointer | interop.Reference<any>, p2: number) => void): this;

        ['initWithBytesNoCopy:length:encoding:freeWhenDone:'](bytes: interop.Pointer | interop.Reference<any>, len: number, encoding: number, freeBuffer: boolean): this;

        // initWithCString(bytes: string | interop.Pointer | interop.Reference<any>): this;

        ['initWithCString:encoding:'](nullTerminatedCString: string | interop.Pointer | interop.Reference<any>, encoding: number): this;

        // initWithCStringLength(bytes: string | interop.Pointer | interop.Reference<any>, length: number): this;

        // initWithCStringNoCopyLengthFreeWhenDone(bytes: string | interop.Pointer | interop.Reference<any>, length: number, freeBuffer: boolean): this;

        ['initWithCharacters:length:'](characters: interop.Pointer | interop.Reference<string>, length: number): this;

        // initWithCharactersNoCopyLengthDeallocator(chars: interop.Pointer | interop.Reference<string>, len: number, deallocator: (p1: interop.Pointer | interop.Reference<string>, p2: number) => void): this;

        ['initWithCharactersNoCopy:length:freeWhenDone:'](characters: interop.Pointer | interop.Reference<string>, length: number, freeBuffer: boolean): this;

        // initWithCoder(coder: NSCoder): this;

        // initWithContentsOfFile(path: string): this;

        // initWithContentsOfFileEncodingError(path: string, enc: number): this;

        // initWithContentsOfFileUsedEncodingError(path: string, enc: interop.Pointer | interop.Reference<number>): this;

        // initWithContentsOfURL(url: NSURL): this;

        // initWithContentsOfURLEncodingError(url: NSURL, enc: number): this;

        // initWithContentsOfURLUsedEncodingError(url: NSURL, enc: interop.Pointer | interop.Reference<number>): this;

        ['initWithFormat:'](data: NSData, encoding: number): this;

        ['initWithString:'](aString: string): this;

        ['initWithUTF8String:'](nullTerminatedCString: string | interop.Pointer | interop.Reference<any>): this;

        // isEqual(object: any): boolean;

        // isEqualToString(aString: string): boolean;

        // isKindOfClass(aClass: typeof NSObject): boolean;

        // isMemberOfClass(aClass: typeof NSObject): boolean;

        // itemProviderVisibilityForRepresentationWithTypeIdentifier(typeIdentifier: string): NSItemProviderRepresentationVisibility;

        // lengthOfBytesUsingEncoding(enc: number): number;

        // lineRangeForRange(range: NSRange): NSRange;

        // linguisticTagsInRangeSchemeOptionsOrthographyTokenRanges(range: NSRange, scheme: string, options: NSLinguisticTaggerOptions, orthography: NSOrthography, tokenRanges: interop.Pointer | interop.Reference<NSArray<NSValue>>): NSArray<string>;

        // loadDataWithTypeIdentifierForItemProviderCompletionHandler(typeIdentifier: string, completionHandler: (p1: NSData, p2: NSError) => void): NSProgress;

        // localizedCaseInsensitiveCompare(string: string): NSComparisonResult;

        // localizedCaseInsensitiveContainsString(str: string): boolean;

        // localizedCompare(string: string): NSComparisonResult;

        // localizedStandardCompare(string: string): NSComparisonResult;

        // localizedStandardContainsString(str: string): boolean;

        // localizedStandardRangeOfString(str: string): NSRange;

        // lossyCString(): NSString;

        // lowercaseStringWithLocale(locale: NSLocale): NSString;

        // maximumLengthOfBytesUsingEncoding(enc: number): number;

        // mdf_calculatedLanguageDirection(): NSLocaleLanguageDirection;

        // mdf_stringWithBidiEmbedding(languageDirection: NSLocaleLanguageDirection): NSString;

        // mdf_stringWithBidiMarkersStripped(): NSString;

        // mdf_stringWithStereoResetContext(direction: NSLocaleLanguageDirection, contextDirection: NSLocaleLanguageDirection): NSString;

        // mutableCopyWithZone(zone: interop.Pointer | interop.Reference<any>): any;

        // paragraphRangeForRange(range: NSRange): NSRange;

        // performSelector(aSelector: string): any;

        // performSelectorWithObject(aSelector: string, object: any): any;

        // performSelectorWithObjectWithObject(aSelector: string, object1: any, object2: any): any;

        // propertyList(): any;

        // propertyListFromStringsFileFormat(): NSDictionary<any, any>;

        // rangeOfCharacterFromSet(searchSet: NSCharacterSet): NSRange;

        // rangeOfCharacterFromSetOptions(searchSet: NSCharacterSet, mask: NSStringCompareOptions): NSRange;

        // rangeOfCharacterFromSetOptionsRange(searchSet: NSCharacterSet, mask: NSStringCompareOptions, rangeOfReceiverToSearch: NSRange): NSRange;

        // rangeOfComposedCharacterSequenceAtIndex(index: number): NSRange;

        // rangeOfComposedCharacterSequencesForRange(range: NSRange): NSRange;

        // rangeOfString(searchString: string): NSRange;

        // rangeOfStringOptions(searchString: string, mask: NSStringCompareOptions): NSRange;

        // rangeOfStringOptionsRange(searchString: string, mask: NSStringCompareOptions, rangeOfReceiverToSearch: NSRange): NSRange;

        // rangeOfStringOptionsRangeLocale(searchString: string, mask: NSStringCompareOptions, rangeOfReceiverToSearch: NSRange, locale: NSLocale): NSRange;

        // respondsToSelector(aSelector: string): boolean;

        // retainCount(): number;

        // self(): this;

        // sizeWithAttributes(attrs: NSDictionary<string, any>): CGSize;

        // sizeWithFont(font: UIFont): CGSize;

        // sizeWithFontConstrainedToSize(font: UIFont, size: CGSize): CGSize;

        // sizeWithFontConstrainedToSizeLineBreakMode(font: UIFont, size: CGSize, lineBreakMode: NSLineBreakMode): CGSize;

        // sizeWithFontForWidthLineBreakMode(font: UIFont, width: number, lineBreakMode: NSLineBreakMode): CGSize;

        // sizeWithFontMinFontSizeActualFontSizeForWidthLineBreakMode(font: UIFont, minFontSize: number, actualFontSize: interop.Pointer | interop.Reference<number>, width: number, lineBreakMode: NSLineBreakMode): CGSize;

        // sr_sensorForDeletionRecordsFromSensor(): NSString;

        // stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters: NSCharacterSet): NSString;

        // stringByAddingPercentEscapesUsingEncoding(enc: number): NSString;

        // stringByAppendingPathComponent(str: string): NSString;

        // stringByAppendingPathComponentConformingToType(partialName: string, contentType: UTType): NSString;

        // stringByAppendingPathExtension(str: string): NSString;

        // stringByAppendingPathExtensionForType(contentType: UTType): NSString;

        ['stringByAppendingString:'](aString: string): NSString;

        ['stringByApplyingTransform:reverse:'](transform: string, reverse: boolean): NSString;

        // stringByFoldingWithOptionsLocale(options: NSStringCompareOptions, locale: NSLocale): NSString;

        // stringByPaddingToLengthWithStringStartingAtIndex(newLength: number, padString: string, padIndex: number): NSString;

        // stringByReplacingCharactersInRangeWithString(range: NSRange, replacement: string): NSString;

        // stringByReplacingOccurrencesOfStringWithString(target: string, replacement: string): NSString;

        // stringByReplacingOccurrencesOfStringWithStringOptionsRange(target: string, replacement: string, options: NSStringCompareOptions, searchRange: NSRange): NSString;

        // stringByReplacingPercentEscapesUsingEncoding(enc: number): NSString;

        // stringByTrimmingCharactersInSet(set: NSCharacterSet): NSString;

        // stringsByAppendingPaths(paths: NSArray<string> | string[]): NSArray<string>;

        // substringFromIndex(from: number): NSString;

        // substringToIndex(to: number): NSString;

        // substringWithRange(range: NSRange): NSString;

        // uppercaseStringWithLocale(locale: NSLocale): NSString;

        // variantFittingPresentationWidth(width: number): NSString;

        // writeToFileAtomically(path: string, useAuxiliaryFile: boolean): boolean;

        // writeToFileAtomicallyEncodingCompletion(path: string, atomically: boolean, enc: number, callback: (p1: NSError) => void): void;

        // writeToFileAtomicallyEncodingError(path: string, useAuxiliaryFile: boolean, enc: number): boolean;

        // writeToURLAtomically(url: NSURL, atomically: boolean): boolean;

        // writeToURLAtomicallyEncodingError(url: NSURL, useAuxiliaryFile: boolean, enc: number): boolean;
    }

    declare class AVSpeechUtterance extends NSObject /* implements NSCopying, NSSecureCoding */ {

        static alloc(): AVSpeechUtterance; // inherited from NSObject
    
        static new(): AVSpeechUtterance; // inherited from NSObject
    
        // static speechUtteranceWithAttributedString(string: NSAttributedString): AVSpeechUtterance;
    
        // static speechUtteranceWithString(string: string): AVSpeechUtterance;
    
        // readonly attributedSpeechString: NSAttributedString;
    
        // pitchMultiplier: number;
    
        // postUtteranceDelay: number;
    
        // preUtteranceDelay: number;
    
        // prefersAssistiveTechnologySettings: boolean;
    
        // rate: number;
    
        // readonly speechString: string;
    
        voice: AVSpeechSynthesisVoice;
    
        // volume: number;
    
        // static readonly supportsSecureCoding: boolean; // inherited from NSSecureCoding
    
        // constructor(o: { attributedString: NSAttributedString; });
    
        // constructor(o: { coder: NSCoder; }); // inherited from NSCoding
    
        // constructor(o: { string: string; });
    
        // copyWithZone(zone: interop.Pointer | interop.Reference<any>): any;
    
        // encodeWithCoder(coder: NSCoder): void;
    
        // initWithAttributedString(string: NSAttributedString): this;
    
        // initWithCoder(coder: NSCoder): this;
    
        ['initWithString:'](string: string): this;
    }

    declare class AVSpeechSynthesisVoice extends NSObject /* implements NSSecureCoding */ {

        static alloc(): AVSpeechSynthesisVoice; // inherited from NSObject
    
        // static currentLanguageCode(): string;
    
        // static new(): AVSpeechSynthesisVoice; // inherited from NSObject
    
        // static speechVoices(): NSArray<AVSpeechSynthesisVoice>;
    
        // static voiceWithIdentifier(identifier: string): AVSpeechSynthesisVoice;
    
        static ['voiceWithLanguage:'](languageCode: string): AVSpeechSynthesisVoice;
    
        // readonly audioFileSettings: NSDictionary<string, any>;
    
        // readonly gender: AVSpeechSynthesisVoiceGender;
    
        // readonly identifier: string;
    
        // readonly language: string;
    
        // readonly name: string;
    
        // readonly quality: AVSpeechSynthesisVoiceQuality;
    
        // static readonly supportsSecureCoding: boolean; // inherited from NSSecureCoding
    
        // constructor(o: { coder: NSCoder; }); // inherited from NSCoding
    
        // encodeWithCoder(coder: NSCoder): void;
    
        // initWithCoder(coder: NSCoder): this;
    }

    declare class AVSpeechSynthesizer extends NSObject {

        static alloc(): AVSpeechSynthesizer; // inherited from NSObject
    
        static new(): AVSpeechSynthesizer; // inherited from NSObject
    
        // delegate: AVSpeechSynthesizerDelegate;
    
        // mixToTelephonyUplink: boolean;
    
        // outputChannels: NSArray<AVAudioSessionChannelDescription>;
    
        // readonly paused: boolean;
    
        // readonly speaking: boolean;
    
        // usesApplicationAudioSession: boolean;
    
        // continueSpeaking(): boolean;
    
        // pauseSpeakingAtBoundary(boundary: AVSpeechBoundary): boolean;
    
        ['speakUtterance:'](utterance: AVSpeechUtterance): void;
    
        // stopSpeakingAtBoundary(boundary: AVSpeechBoundary): boolean;
    
        // writeUtteranceToBufferCallback(utterance: AVSpeechUtterance, bufferCallback: (p1: AVAudioBuffer) => void): void;
    }
}