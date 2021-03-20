// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

void main() {
  int addReducer(int state, dynamic action) => state + 1;

  testWidgets('Should display the current state of the app',
      (WidgetTester tester) async {
    final store = DevToolsStore(
      addReducer,
      initialState: 0,
    );
    final widget = MaterialApp(
      home: Scaffold(
        body: ReduxDevTools(store),
      ),
    );

    await tester.pumpWidget(widget);

    expect(
      find.text('1'),
      findsOneWidget,
    );
  });

  testWidgets('Should display the current action', (WidgetTester tester) async {
    final store = DevToolsStore(
      addReducer,
      initialState: 0,
    );
    final widget = MaterialApp(
      home: Scaffold(
        body: ReduxDevTools(store),
      ),
    );
    final action = 'Hi';

    store.dispatch(action);
    await tester.pumpWidget(widget);

    expect(
      find.text(action),
      findsOneWidget,
    );
  });

  testWidgets(
      'Should display the slider at the latest state when an action is dispatched',
      (WidgetTester tester) async {
    final store = DevToolsStore(
      addReducer,
      initialState: 0,
    );
    final widget = MaterialApp(
      home: Scaffold(
        body: ReduxDevTools(store),
      ),
    );

    store.dispatch('Heyo');
    await tester.pumpWidget(widget);
    final slider = tester.firstWidget<Slider>(find.byType(Slider));

    expect(slider.value, 1.0);
  });

  testWidgets('Should move the slider to the original state and upate the UI',
      (WidgetTester tester) async {
    final store = DevToolsStore(
      addReducer,
      initialState: 0,
    );
    final widget = MaterialApp(
      home: Scaffold(
        body: ReduxDevTools(store),
      ),
    );
    final action = 'Yo yo';

    // Dispatch an extra action
    store.dispatch(action);

    await tester.pumpWidget(widget);

    // Find the Slider, and ensure it's on the latest state
    var sliderFinder = find.byType(Slider);
    var slider = tester.firstWidget<Slider>(sliderFinder);
    expect(slider.value, 1.0);
    expect(
      find.text('2'),
      findsOneWidget,
    );
    expect(
      find.text(action),
      findsOneWidget,
    );

    // Tap the slider at the left-most position, this should move the app state
    // back in time.
    await tester.tap(sliderFinder, pointer: 0);
    await tester.pump();

    slider = tester.firstWidget(sliderFinder);

    // Find Ensure the Slider has been set back to 0, and the Widget displays
    // the initial state and action.
    expect(slider.value, 0.0);
    expect(
      find.text(store.devToolsState.computedStates[0].toString()),
      findsOneWidget,
    );
    expect(
      find.text(store.devToolsState.stagedActions[0].toString()),
      findsOneWidget,
    );
  });

  testWidgets('Reset sets the store back to the last saved or initial state',
      (WidgetTester tester) async {
    final store = DevToolsStore(
      addReducer,
      initialState: 0,
    );
    final widget = MaterialApp(
      home: Scaffold(
        body: ReduxDevTools(store),
      ),
    );
    final action = 'Yep.';

    // Dispatch an extra action
    store.dispatch(action);

    await tester.pumpWidget(widget);

    // Find the Slider, and ensure it's on the latest state
    var sliderFinder = find.byType(Slider);
    var slider = tester.firstWidget<Slider>(sliderFinder);
    expect(slider.value, 1.0);
    expect(
      find.text('2'),
      findsOneWidget,
    );
    expect(
      find.text(action),
      findsOneWidget,
    );

    // Reset the Store by tapping a button
    await tester.tap(find.byKey(ReduxDevTools.resetKey));
    await tester.pump();

    // Ensure the UI is reset back to the initial state of the Store
    slider = tester.firstWidget(sliderFinder);
    expect(slider.value, 0.0);
    expect(
      find.text('1'),
      findsOneWidget,
    );
    expect(
      find.text(store.devToolsState.stagedActions[0].toString()),
      findsOneWidget,
    );
  });

  testWidgets(
      'Save collapses all actions into only the current state and action',
      (WidgetTester tester) async {
    final store = DevToolsStore(
      addReducer,
      initialState: 0,
    );
    final widget = MaterialApp(
      home: Scaffold(
        body: ReduxDevTools(store),
      ),
    );
    final action = 'Hey hey hey hey';

    // Dispatch an extra action
    store.dispatch(action);

    await tester.pumpWidget(widget);

    // Find the Slider, and ensure it's on the latest state
    var sliderFinder = find.byType(Slider);
    var slider = tester.firstWidget<Slider>(sliderFinder);
    expect(slider.value, 1.0);
    expect(
      find.text('2'),
      findsOneWidget,
    );
    expect(
      find.text(action),
      findsOneWidget,
    );

    // Reset the Store by tapping a button
    await tester.tap(find.byKey(ReduxDevTools.saveKey));
    await tester.pump();

    // Ensure the Slider is set back to the initial value, that the state was
    // the most recent, and that there is only 1 action int total.
    slider = tester.firstWidget(sliderFinder);
    expect(slider.value, 0.0);
    expect(
      find.text('2'),
      findsOneWidget,
    );
    expect(
      find.text(store.devToolsState.stagedActions[0].toString()),
      findsOneWidget,
    );
  });
}
