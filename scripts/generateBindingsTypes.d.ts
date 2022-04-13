export interface ObjcMetadata {
  Module: MetadataModule;
  Items: MetadataItem[];
}

export interface MetadataModule {
  FullName: string;
  IsPartOfFramework: boolean;
  IsSystemModule: boolean;
  Libraries: MetadataModuleLibrary[];
}

export interface MetadataModuleLibrary {
  Library: string;
  IsFramework: boolean;
}

export interface MetadataItem<T extends MetadataItemType = MetadataItemType> {
  Name: string;
  JsName: string;
  Filename: string;
  Module: MetadataItemModule;
  IntroducedIn?: number;
  Flags: string[];
  Type: T;
}

export interface MetadataItemEnumConstant extends MetadataItem<'EnumConstant'> {
  Value: string;
}

export interface MetadataItemEnum extends MetadataItem<'Enum'> {
  /**
   * @example [{ NSActivityIdleDisplaySleepDisabled: '1099511627776' }]
   */
  FullNameFields: Record<string, string>[];
  /**
   * @example [{ IdleDisplaySleepDisabled: '1099511627776' }]
   */
  SwiftNameFields: Record<string, string>[];
}

export interface MetadataProtocol extends MetadataItem<'Protocol'> {
  /** I don't have any use for this yet, so won't work out the typings. */
  InstanceMethods: unknown;
  /** I don't have any use for this yet, so won't work out the typings. */
  StaticMethods: unknown[];
  /** I don't have any use for this yet, so won't work out the typings. */
  InstanceProperties: unknown[];
  /** I don't have any use for this yet, so won't work out the typings. */
  StaticProperties: unknown[];
  Protocols: string[];
}

/**
 * This one's a bit complicated. A Var can hold anything.
 * @example NSHTTPCookieVersion holds an interface
 * @example NSHashTableCopyIn holds an Enum
 * @example NSIntMapValueCallBacks holds a Struct
 * @example NSStringTransformToLatin holds an Interface by the name of NSString.
 */
export interface MetadataItemVar extends MetadataItem<'Var'> {
  Signature:
    | {
        Type: MetadataItemType;
        Name: string;
        [string: any];
      }
    // I'll type each simple common case.
    | {
        Type: 'Interface';
        Name: 'NSString';
        WithProtocols: [];
      };
  [string: any];
}

export interface MetadataItemMethod extends MetadataItem<'Method'> {
  /** I don't have any use for this yet, so won't work out the typings. */
  Signature: unknown;
}

export interface MetadataItemFunction extends MetadataItem<'Function'> {
  /**
   * I don't have any use for this yet, so won't work out the typings.
   */
  Signature: unknown;
}

/**
 * @example NSDecimal
 * @example NSFastEnumerationState
 * @example NSHashEnumerator
 * @example NSHashTableCallBacks
 * @example NSMapEnumerator
 * @example NSMapTableKeyCallBacks
 * @example NSMapTableValueCallBacks
 * @example NSOperatingSystemVersion
 * @example NSRange
 * @example NSSwappedDouble
 * @example NSSwappedFloat
 * @example _expressionFlags
 * @example _predicateFlags
 */
export interface MetadataItemStruct extends MetadataItem<'Struct'> {
  Fields: MetadataItemStructField[];
}

export interface MetadataItemStructField {
  Name: string;
  Signature:
    | {
        Type: string;
      }
    | {
        Type: string;
        // Any possible type, really
        [string: any];
      }
    | {
        Type: string;
        ArrayType: {
          Type: string;
        };
        Size: number;
      }
    | {
        Type: string;
        PointerType: {
          Type: string;
          WithProtocols?: string[];
        };
      };
}

export type MetadataItemType =
  | 'EnumConstant'
  | 'Enum'
  | 'Protocol'
  | 'Var'
  | 'Method'
  | 'Struct'
  | 'Interface'
  | 'BridgedInterface' // See CoreFoundation
  | 'Function';
export interface MetadataItemModule {
  FullName: string;
  IsPartOfFramework: boolean;
  IsSystemModule: boolean;
  Libraries: [];
}
