# react-native-native-runtime

<p align="center">
    <a href="https://badge.fury.io/js/react-native-native-runtime"><img src="https://badge.fury.io/js/react-native-native-runtime.svg" alt="npm version" height="18"></a>
    <a href="https://discord.com/invite/QDMxYqXw">
        <img src="https://img.shields.io/discord/901103300735279144?label=chat&logo=discord"/>
    </a>
    <a href="https://opensource.org/licenses/mit-license.php">
        <img src="https://badges.frapsoft.com/os/mit/mit.png?v=103"/>
    </a>
    <!-- <a href="http://makeapullrequest.com">
        <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat"/>
    </a> -->
    <a href="https://twitter.com/intent/follow?screen_name=LinguaBrowse">
        <img src="https://img.shields.io/twitter/follow/LinguaBrowse.svg?style=social&logo=twitter"/>
    </a>
</p>

Access the native APIs directly from the React Native JS context!

For now, we support just Objective-C (for iOS/macOS/tvOS devices, but I'll refer to iOS for brevity). Adding support for Java (for Android devices) is on my wishlist for the future.

## Installation

Please get in contact if these instructions don't work for you!

```sh
# WARNING: only tested with react-native@^0.64.2.
# Will not work on lower versions; *may* work on newer versions.

# Install the npm package
npm install --save react-native-native-runtime

# Install the Cocoapod
cd ios && pod install && cd ..
```

## Usage

For now, as I haven't installed the package yet, just clone the repo and play around with [example/src/App.tsx](example/src/App.tsx).

### The Java runtime

🚧 I haven't yet started building this, and it's further away from my expertise (I'm more of an iOS developer). Get in contact if you'd like to get involved!

### The Obj-C runtime

All Obj-C APIs are exposed through a proxy object called `objc`, which is injected into the JS context's global scope early at run time (provided you have remembered to install the Cocoapod and rebuilt your iOS app since then). Technically it occurs when React Native finds the `setBridge` method in `ios/ObjcRuntime.mm` just like for any other iOS native module and then calls the `ObjcRuntimeJsi::install()` method within.

#### TypeScript typings?

⚠️ First, a warning: We only have very minimal hand-written TypeScript typings at the moment. Get used to `any` type until we make a more lasting solution, most likely based on the NativeScript metadata/typings generator. For now, copy [example/src/objc-types.d.ts](example/src/objc-types.d.ts) to get started.

#### The `objc` proxy object

As mentioned, this is available in the global scope on any Apple app.

Generally, you'll use the `objc` proxy object to look up some native data type. If a match is found for the native data type, we wrap it in a C++ HostObject class instance that is shared across to the JS context.

```typescript
// Class lookup:
// Returns a JS HostObject wrapping a native class.
// This works via the Obj-C runtime helper NSClassFromString,
// so it has O(1) complexity.
objc.NSString;

// Protocol lookup:
// Returns a JS HostObject wrapping a native Protocol (if a class
// with the same name wasn't found first).
// This works via the Obj-C runtime helper NSProtocolFromString,
// so it has O(1) complexity.
objc.NSSecureCoding;

// Constant/variable lookup:
// Looks up the `NSStringTransformLatinToHiragana` variable from
// the executable (if neither a class
// nor a protocol with the same name was found first).
// This works via dlsym, so I believe it has O(N) complexity, but
// probably isn't too slow anyway.
objc.NSStringTransformLatinToHiragana;

// Selector lookup:
// Returns a JS HostObject wrapping a native Selector.
// This works via the Obj-C runtime helper NSSelectorFromString, so
// it has O(1) complexity.
// I can't think of a good example for this, but it's possible.
objc.getSelector("NoGoodExample:soWhoKnows:");

// Will return an array of all Obj-C classes and all convenience
// methods, but that's all.
// Does not, for example, list out all constants/variables/protocols
// available. Those have to be looked up individually.
Object.keys(objc);

// Will return the string:
// [object HostObjectObjc]
objc.toString();

// Will cause an infinite loop and crash! Need some advice from JSI
// experts on this.
// It involves the following getters being called in sequence:
// $$typeof -> Symbol.toStringTag -> toJSON -> Symbol.toStringTag -> 
//   Symbol.toStringTag -> Symbol.toStringTag -> toString
console.log(objc);
```

#### Host Objects

Again, this is a C++ HostObject class instance that is shared across to the JS context. Don't ask me how the memory-management works! That's one for a JSI expert (and I'd love some code review on my approach).

The `objc` proxy object is one such HostObject. I've made some others:

* HostObjectClass (wraps a class)
* HostObjectClassInstance (wraps a class instance)
* HostObjectProtocol (wraps a protocol)
* HostObjectSelector (wraps a selector)

*TODO: I'll likely make these expand a common abstract class. For now, they all directly extend `facebook::jsi::HostObject`.*

These may expand in future, but the former two cover a huge API surface on their own. I'll focus on documenting those, as the latter two are largely empty skeletons.


##### HostObjectClass

You can obtain a HostObjectClass by looking up a class on the `objc` proxy object:

```typescript
const nSStringClass: objc.NSString = objc.NSString;
```

You can also call class methods (AKA static methods, in other languages) on it:

```typescript
const voice: objc.AVSpeechSynthesisVoice = 
  objc.AVSpeechSynthesisVoice['voiceWithLanguage:']('en-GB');
```

We'll cover what you can do with a class instance in the next section.

##### HostObjectClassInstance

Once you have a class instance, you can call instance methods. The method names mirror the Obj-C selector, hence you'll be seeing a lot of colons. The JS invocation takes as many arguments as the Obj-C selector suggests (each colon indicates one param).

```typescript
// Initialise an NSString
const hello: objc.NSString =
  objc.NSString.alloc()['initWithString:']('Hello');

// Return a new NSString by concatenating it 
const helloWorld: objc.NSString =
  hello['stringByAppendingString:'](', world!');
```

You will have noticed that we're passing JS primitive types in as parameters. All JS primitive types are marshalled into equivalent Obj-C types:

* string -> NSString
* number -> NSNumber
* boolean -> NSBoolean
* Array -> NSArray
* object -> NSDictionary
* undefined -> nil
* null -> nil

Conversely, you can also marshal the following types from Obj-C to JS:

* NSString -> string
* NSNumber -> number
* NSBoolean -> boolean
* NSArray -> Array (provided each of the constituent values are marshal-friendly)
* NSDictionary -> object (provided each of the constituent values are marshal-friendly)
* kCFNull -> null
* nil -> undefined

Do so using the `toJS()` method on a HostObjectClassInstance:

```typescript
// Marshal the NSString to a JS primitive string
console.log(helloWorld.toJS());
```

Beyond that, you can get the keys on the class instance:

```typescript
// Will return a list of all instance variables, properties, and
// native methods, and some added methods like toString().
// TODO: list out all the *inherited* instance variables,
// properties, and methods as well.
Object.keys(helloWorld);
```

You can also use getters:

```typescript
// Allocate a native class instance
const utterance: objc.AVSpeechUtterance =
  objc.AVSpeechUtterance.alloc()['initWithString:']('Hello, world!');

// Get the property
utterance.voice;
```

... and call setters:

```typescript
// Allocate a native class instance
const utterance: objc.AVSpeechUtterance =
  objc.AVSpeechUtterance.alloc()['initWithString:']('Hello, world!');

// Set properties on it
utterance.voice =
  objc.AVSpeechSynthesisVoice['voiceWithLanguage:']('ja-JP');
```

... but both getters and setters are currently *very* experimental and I need some help from an Obj-C expert to get them right.

## Is it complete?

The Java runtime isn't even started yet, for one thing.

The Obj-C runtime lets you do a lot of things already, but it is far from complete. There are some glaring things like lack of `console.log()` support and incomplete getter/setter support that are high priorities to solve, and peer review from JSI experts is also needed.

## Is it production-ready?

No, but you can help that by contributing!

Seriously, expect errors to be thrown if you don't know what you're doing (particularly as there are no TypeScript typings yet).

## Contributing

Get in touch on the `#objc-runtime` channel of the [React Native JSI Discord](https://discord.com/invite/QDMxYqXw), or [send me a message](https://twitter.com/LinguaBrowse) on Twitter!

I'll start putting some issues together to indicate tasks that need help.

## License

MIT
