library flutter_redux_dev_tools;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

/// A Widget you can use to show a Time Travel UI. Simply put it in a part of
/// your UI that makes sense (Such as a Dev Tools Drawer), pass it a
/// DevToolsStore and you'll be good to go!
///
/// Note: This Widget does not work with a normal Redux Store. It is meant to
/// work with the redux_dev_tools package, which provides a DevToolsStore. The
/// DevToolsStore is a drop-in replacement for your Store during Development!
///
/// ### Example
///
/// This example paints only a broad outline of how to use the ReduxDevTools.
/// For a complete example, see the `example` folder.
///
///     int addReducer(int state, action) => state + 1;
///
///     // Create a DevToolsStore instead of a normal Store during Development
///     final store = DevToolsStore(
///       addReducer,
///       initialState: 0,
///     );
///
///     // Finally, create your app:
///     runApp(MaterialApp(
///       home: Scaffold(
///         body: ReduxDevTools(store),
///       ),
///     ));
class ReduxDevTools<AppState> extends StatefulWidget {
  static final saveKey = UniqueKey();
  static final resetKey = UniqueKey();
  static final recomputeKey = UniqueKey();

  final DevToolsStore<AppState> store;

  ReduxDevTools(this.store);

  @override
  State<StatefulWidget> createState() {
    return _ReduxDevToolsState<AppState>();
  }
}

class _ReduxDevToolsState<AppState> extends State<ReduxDevTools<AppState>> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ReduxDevToolsViewModel>(
      stream: widget.store.onChange.map((_) {
        return ReduxDevToolsViewModel(
          widget.store,
          _ContainerState.of(context),
          context,
        );
      }),
      builder: (context, snapshot) {
        final model = snapshot.hasData
            ? snapshot.data!
            : ReduxDevToolsViewModel(
                widget.store,
                _ContainerState.of(context),
                context,
              );

        return ListView(
          children: <Widget>[
            Center(
              child: Text(
                'Redux Time Travel',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 20.0,
                bottom: 12.0,
              ),
              child: Slider(
                value: model.sliderPosition,
                onChanged: model.onSliderChanged,
                min: 0.0,
                max: model.sliderMax,
              ),
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.save),
                      key: ReduxDevTools.saveKey,
                      onPressed: model.onSavePressed,
                      tooltip: 'Save',
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.restore),
                      key: ReduxDevTools.resetKey,
                      onPressed: model.onResetPressed,
                      tooltip: 'Reset',
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(
                        Icons.functions,
                        color: model.recomputeColor,
                      ),
                      key: ReduxDevTools.recomputeKey,
                      onPressed: model.onRecomputePressed,
                      tooltip: model.recomputeButtonString,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16.0),
              child: InkWell(
                onTap: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: ListView(
                            children: [
                              Text(
                                model.latestState,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: FractionalOffset.topLeft,
                      padding: EdgeInsets.only(
                        left: 12.0,
                        top: 8.0,
                        bottom: 0.0,
                        right: 0.0,
                      ),
                      child: Text(
                        'Current State',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      alignment: FractionalOffset.topLeft,
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        model.latestState,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: ListView(
                          children: [
                            Text(
                              model.latestAction,
                              textAlign: TextAlign.left,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: FractionalOffset.topLeft,
                    padding: EdgeInsets.only(
                      left: 12.0,
                      top: 8.0,
                      bottom: 0.0,
                      right: 0.0,
                    ),
                    child: Text(
                      'Current Action',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ),
                  Container(
                    alignment: FractionalOffset.topLeft,
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      model.latestAction,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class ReduxDevToolsViewModel {
  final String latestAction;
  final String latestState;
  final VoidCallback onSavePressed;
  final VoidCallback onResetPressed;
  final VoidCallback onRecomputePressed;
  final ValueChanged<double> onSliderChanged;
  final double sliderMax;
  final double sliderPosition;
  final Color? recomputeColor;
  final String recomputeButtonString;

  ReduxDevToolsViewModel._({
    required this.recomputeColor,
    required this.latestAction,
    required this.latestState,
    required this.onSavePressed,
    required this.onResetPressed,
    required this.onRecomputePressed,
    required this.onSliderChanged,
    required this.sliderMax,
    required this.sliderPosition,
    required this.recomputeButtonString,
  });

  factory ReduxDevToolsViewModel(
    DevToolsStore<dynamic> store,
    _ContainerState? containerState,
    BuildContext context,
  ) {
    return ReduxDevToolsViewModel._(
      latestAction: store.devToolsState.latestAction.toString(),
      latestState: store.state.toString(),
      onSavePressed: () => store.dispatch(DevToolsAction.save()),
      onResetPressed: () => store.dispatch(DevToolsAction.reset()),
      recomputeColor:
          containerState != null && containerState.recomputeOnHotReload
              ? Theme.of(context).accentColor
              : Theme.of(context).textTheme.button?.color,
      onRecomputePressed: () {
        if (containerState != null) {
          containerState.toggleRecomputeOnHotReload();
        } else {
          store.dispatch(DevToolsAction.recompute());
        }
      },
      recomputeButtonString: containerState == null
          ? 'Recompute'
          : 'Toggle "Recompute on Hot Reload"',
      onSliderChanged: (val) =>
          store.dispatch(DevToolsAction.jumpToState(val.floor())),
      sliderMax: (store.devToolsState.computedStates.length - 1).toDouble(),
      sliderPosition: store.devToolsState.currentPosition.toDouble(),
    );
  }
}

/// Hot Reload for your State! Change your Reducers? The state will be
/// recomputed and your UI will update, pronto.
///
/// To make this work, it's best to wrap your whole app with this Widget. That
/// way it will always remain mounted and can listen to Hot Reload changes for
/// any Route.
///
/// Since you won't want to wrap your Production app with any Dev Tools, it's
/// best to only use this in Dev mode. See the `example` directory of this
/// repo for a demonstration of how to do this.
class ReduxDevToolsContainer<S> extends StatefulWidget {
  final Store<S> store;
  final Widget child;
  final bool recomputeOnHotReload;

  ReduxDevToolsContainer({
    Key? key,
    required this.store,
    required this.child,
    this.recomputeOnHotReload = true,
  }) : super(key: key);

  @override
  _ReduxDevToolsRecomputeState createState() {
    return _ReduxDevToolsRecomputeState();
  }
}

class _ReduxDevToolsRecomputeState extends State<ReduxDevToolsContainer> {
  bool _recomputeOnHotReload = false;

  @override
  Widget build(BuildContext context) {
    return _ContainerState(
      recomputeOnHotReload: _recomputeOnHotReload,
      toggleRecomputeOnHotReload: _toggleRecomputeOnHotReload,
      child: widget.child,
    );
  }

  void _toggleRecomputeOnHotReload() {
    setState(() {
      _recomputeOnHotReload = !_recomputeOnHotReload;
    });
  }

  @override
  void reassemble() {
    if (_recomputeOnHotReload) {
      widget.store.dispatch(DevToolsAction.recompute());
    }

    super.reassemble();
  }

  @override
  void initState() {
    super.initState();

    _recomputeOnHotReload = widget.recomputeOnHotReload;
  }
}

class _ContainerState extends InheritedWidget {
  final bool recomputeOnHotReload;
  final Function() toggleRecomputeOnHotReload;

  _ContainerState({
    Key? key,
    required Widget child,
    required this.recomputeOnHotReload,
    required this.toggleRecomputeOnHotReload,
  }) : super(key: key, child: child);

  static _ContainerState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ContainerState>();
  }

  @override
  bool updateShouldNotify(_ContainerState oldWidget) {
    return recomputeOnHotReload != oldWidget.recomputeOnHotReload;
  }
}
