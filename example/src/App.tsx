import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
// import { multiply } from 'react-native-objc-runtime';

declare const objc: any;

export default function App() {
  React.useEffect(() => {
    // multiply(3, 7).then(setResult);
    console.log(`objc.toString():`, objc.toString());
    objc.NSString.alloc();
    // console.log(`objc.NSString:`, objc.NSString);
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
