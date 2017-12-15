import 'package:example/app.dart';
import 'package:flutter/material.dart';
import 'package:example/store.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

// The Dev version of your app. It will build a DevToolsStore instead of a
// normal Store. In addition, it will provide a DevDrawer for the app, which
// will contain the ReduxDevTools themselves.
void main() {
  final store = new DevToolsStore(
    counterReducer,
    initialState: 0,
  );

  // A ReduxDevToolsApp will recompute the state of your app on Hot Reload.
  // This means if you change the way a reducer works, it will replay all the
  // actions through the reducer to recompute the new state!
  runApp(new ReduxDevToolsContainer(
    store: store,
    child: new App(
      store: store,
      // Since we want a Dev Drawer that includes the Redux Dev Tools, we'll
      // provide a function that returns one! In production, notice we don't
      // provide one.
      devDrawerBuilder: (context) {
        return new Drawer(
          child: new Padding(
            padding: new EdgeInsets.only(top: 24.0),
            child: new ReduxDevTools(store),
          ),
        );
      },
    ),
  ));
}
