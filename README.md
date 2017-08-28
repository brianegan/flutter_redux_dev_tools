# flutter_redux_dev_tools

[![build status](https://gitlab.com/brianegan/flutter_redux_dev_tools/badges/master/build.svg)](https://gitlab.com/brianegan/flutter_redux_dev_tools/commits/master)

A Widget you can use to show a Time Travel UI. Simply put it in a part of your UI that makes sense (Such as a Dev Tools Drawer), pass it a `DevToolsStore` and you'll be good to go!

Note: This Widget does not work with a normal Redux `Store`. It is meant to work with the [redux_dev_tools package](https://pub.dartlang.org/packages/redux_dev_tools), which provides a `DevToolsStore`. The `DevToolsStore` is a drop-in replacement for your Store during Development!

### Demo

A simple Flutter app that allows you to Increment and Decrement a counter.

![A screenshot of the Dev Tools in Action](https://gitlab.com/brianegan/flutter_redux_dev_tools/raw/master/devtools.gif)

### Example

This example paints only a broad outline of how to use the ReduxDevTools. For a complete example, see the `example` folder.

```dart
int addReducer(int state, action) => state + 1;

// Create a DevToolsStore instead of a normal Store during Development
final store = new DevToolsStore(
  addReducer,
  initialState: 0,
);

// Finally, create your app with a Redux Dev Tools
main() { 
  runApp(new MaterialApp(
    home: new Scaffold(
      body: new ReduxDevTools(store),
    ),
  ));
}
```

## Credits

All of this is inspired by the original [Redux Devtools](https://github.com/gaearon/redux-devtools).

