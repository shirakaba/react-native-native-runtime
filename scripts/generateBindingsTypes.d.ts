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
  Signature: Signature[];
}

export interface MetadataItemFunction extends MetadataItem<'Function'> {
  Signature: Signature[];
}

export interface MetadataItemVar extends MetadataItem<'Var'> {
  /** Usually an NSString, Double, or Enum. */
  Signature: Signature;
}

export type Signature =
  | {
      Type: 'Interface';
      /** @example 'NSArray' */
      Name: string;
      WithProtocols: string[];
    }
  | {
      Type: 'Id';
      /** @example ['NSDecimalNumberBehaviors'] */
      WithProtocols: string[];
    }
  | {
      Type: 'Pointer';
      PointerType: {
        /**
         * @example 'Void'
         * @example 'Struct'
         * @example 'Ulong'
         * */
        Type: string;
        /** @example 'Foundation.NSDecimal' */
        Module?: string;
        /** @example 'NSDecimal' */
        Name?: string;
      };
    }
  | {
      Type: 'Bool';
    }
  | {
      Type: 'CString';
    }
  | {
      Type: 'BridgedInterface';
      /** @example 'id' */
      Name: string;
      /** @example 'id' */
      BridgedTo: string;
    }
  | {
      Type: 'Struct';
      /**
       * @example 'Foundation.NSHashTable'
       * @example 'Foundation.NSMapTable'
       * */
      Module: string;
      /**
       * @example 'NSHashTableCallBacks'
       * @example 'NSMapTableKeyCallBacks'
       * */
      Name: string;
    }
  | {
      Type: 'Selector';
    }
  | {
      Type: 'Ulong';
    }
  | {
      Type: 'Double';
    }
  | {
      Type: 'Long';
    }
  | {
      Type: 'InstanceType';
    }
  | {
      Type: 'Enum';
      /** @example 'NSCalculationError' */
      Name: string;
    }
  | {
      Type: 'TypeArgument';
      /** @example 'ObjectType' */
      Name: string;
      UnderlyingType: Signature;
    }
  | {
      /** @example 'IncompleteArray' */
      Type: string;
      ArrayType: Signature;
      Size: number;
    }
  | {
      Type: 'FunctionPointer';
      Signature: Signature[];
    }
  | {
      Type: 'Class';
    };

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
  | 'Interface' // See: declare class NSMapTable<KeyType, ObjectType> extends NSObject implements NSCopying, NSFastEnumeration, NSSecureCoding {
  | 'BridgedInterface' // See CoreFoundation
  | 'Function';
export interface MetadataItemModule {
  FullName: string;
  IsPartOfFramework: boolean;
  IsSystemModule: boolean;
  Libraries: [];
}
