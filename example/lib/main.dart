import 'package:example/app.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import 'package:example/store.dart';

// The production version of your app. Relies on a real store, and does not
// pull in any dev dependencies!
//
// In addition, it will not create a Dev Drawer.
void main() {
  runApp(new App(
    store: new Store(
      counterReducer,
      initialState: 0,
    ),
  ));
}
