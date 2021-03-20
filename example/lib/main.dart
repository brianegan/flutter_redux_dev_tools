import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import 'app.dart';
import 'store.dart';

// The production version of your app. Relies on a real store, and does not
// pull in any dev dependencies!
//
// In addition, it will not create a Dev Drawer.
void main() {
  runApp(App(
    store: Store(
      counterReducer,
      initialState: 0,
    ),
  ));
}
