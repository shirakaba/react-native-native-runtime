/// <reference path="objc-types.d.ts" />
import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';

export default function App() {
  React.useEffect(() => {
    const hello: objc.NSString =
      objc.NSString.alloc()['initWithString:']('Hello');
    const helloWorld: objc.NSString =
      hello['stringByAppendingString:'](', world!');
    console.log('Concatenate two NSStrings:', helloWorld.toJS());

    console.log(
      `Marshal UTF-8 text back and forth, given "白樺":`,
      objc.NSString.alloc()['initWithString:']('白樺').toJS()
    );

    console.log(
      `Get unicode name for each character, given "🐝":`,
      objc.NSString.alloc()
        ['initWithString:']('🐝')
        ['stringByApplyingTransform:reverse:']('Name-Any', false)
        .toJS()
    );

    // Fun with Foundation String Transforms!
    // @see https://nshipster.com/ios9/
    // @see https://nshipster.com/cfstringtransform/
    // @see https://sites.google.com/site/icuprojectuserguide/transforms/general#TOC-ICU-Transliterators
    // @see https://twitter.com/LinguaBrowse/status/1390225265612181505?s=20
    console.log(
      'Convert Chinese script from Trad. -> Simp., given "漢字簡化爭論":',
      objc.NSString.alloc()
        ['initWithString:']('漢字簡化爭論')
        ['stringByApplyingTransform:reverse:']('Simplified-Traditional', false)
        .toJS()
    );

    console.log(
      'Look up the global variable "NSStringTransformLatinToHiragana" in order to transliterate Japanese Hiragana to Latin, given "しらかば":',
      objc.NSString.alloc()
        ['initWithString:']('しらかば')
        ['stringByApplyingTransform:reverse:'](
          (objc as any).NSStringTransformLatinToHiragana,
          false
        )
        .toJS()
    );

    console.log(
      'Do the same, this time using the equivalent Core Foundation symbol, "kCFStringTransformToLatin":',
      objc.NSString.alloc()
        ['initWithString:']('しらかば')
        ['stringByApplyingTransform:reverse:'](
          (objc as any).kCFStringTransformToLatin,
          false
        )
        .toJS()
    );

    console.log(
      'Transliterate Korean Hangul to Latin, given "안녕하세요":',
      objc.NSString.alloc()
        ['initWithString:']('안녕하세요')
        ['stringByApplyingTransform:reverse:']('Latin-Hangul', false)
        .toJS()
    );

    /* Uncomment this if you're happy to hear a voice speak! */
    // const utterance =
    //   objc.AVSpeechUtterance.alloc()['initWithString:']('Hello, world!');
    // utterance.voice =
    //   objc.AVSpeechSynthesisVoice['voiceWithLanguage:']('en-GB');
    // objc.AVSpeechSynthesizer.alloc().init()['speakUtterance:'](utterance);
  }, []);

  return (
    <View style={styles.container}>
      <Text>Placeholder text</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
