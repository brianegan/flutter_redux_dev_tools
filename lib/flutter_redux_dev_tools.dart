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
///     final store = new DevToolsStore(
///       addReducer,
///       initialState: 0,
///     );
///
///     // Finally, create your app:
///     runApp(new MaterialApp(
///       home: new Scaffold(
///         body: new ReduxDevTools(store),
///       ),
///     ));
class ReduxDevTools<AppState> extends StatefulWidget {
  static final saveKey = new UniqueKey();
  static final resetKey = new UniqueKey();
  static final recomputeKey = new UniqueKey();

  final DevToolsStore<AppState> store;

  ReduxDevTools(this.store);

  @override
  State<StatefulWidget> createState() {
    return new _ReduxDevToolsState<AppState>();
  }
}

class _ReduxDevToolsState<AppState> extends State<ReduxDevTools<AppState>> {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<ReduxDevToolsViewModel>(
      stream: widget.store.onChange.map((_) {
        return new ReduxDevToolsViewModel(
          widget.store,
          _ContainerState.of(context),
          context,
        );
      }),
      builder: (context, snapshot) {
        final model = snapshot.hasData
            ? snapshot.data
            : new ReduxDevToolsViewModel(
                widget.store,
                _ContainerState.of(context),
                context,
              );

        return new ListView(
          children: <Widget>[
            new Center(
              child: new Text(
                "Redux Time Travel",
                style: new TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            new Container(
              padding: new EdgeInsets.only(
                top: 20.0,
                bottom: 12.0,
              ),
              child: new Slider(
                value: model.sliderPosition,
                onChanged: model.onSliderChanged,
                min: 0.0,
                max: model.sliderMax,
              ),
            ),
            new Container(
              child: new Row(
                children: [
                  new Expanded(
                    child: new IconButton(
                      icon: new Icon(Icons.save),
                      key: ReduxDevTools.saveKey,
                      onPressed: model.onSavePressed,
                      tooltip: 'Save',
                    ),
                  ),
                  new Expanded(
                    child: new IconButton(
                      icon: new Icon(Icons.restore),
                      key: ReduxDevTools.resetKey,
                      onPressed: model.onResetPressed,
                      tooltip: 'Reset',
                    ),
                  ),
                  new Expanded(
                    child: new IconButton(
                      icon: new Icon(
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
            new Container(
              margin: new EdgeInsets.symmetric(vertical: 16.0),
              child: new InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    child: new AlertDialog(
                      content: new Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: new ListView(
                          children: [
                            new Text(
                              model.latestState,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: new Column(
                  children: <Widget>[
                    new Container(
                      alignment: FractionalOffset.topLeft,
                      padding: new EdgeInsets.only(
                        left: 12.0,
                        top: 8.0,
                        bottom: 0.0,
                        right: 0.0,
                      ),
                      child: new Text(
                        "Current State",
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    new Container(
                      alignment: FractionalOffset.topLeft,
                      padding: new EdgeInsets.all(12.0),
                      child: new Text(
                        model.latestState,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            new InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  child: new AlertDialog(
                    content: new Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: new ListView(
                        children: [
                          new Text(
                            model.latestAction,
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: new Column(
                children: <Widget>[
                  new Container(
                    alignment: FractionalOffset.topLeft,
                    padding: new EdgeInsets.only(
                      left: 12.0,
                      top: 8.0,
                      bottom: 0.0,
                      right: 0.0,
                    ),
                    child: new Text(
                      "Current Action",
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ),
                  new Container(
                    alignment: FractionalOffset.topLeft,
                    padding: new EdgeInsets.all(12.0),
                    child: new Text(
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
  final Color recomputeColor;
  final String recomputeButtonString;

  ReduxDevToolsViewModel._({
    this.recomputeColor,
    this.latestAction,
    this.latestState,
    this.onSavePressed,
    this.onResetPressed,
    this.onRecomputePressed,
    this.onSliderChanged,
    this.sliderMax,
    this.sliderPosition,
    this.recomputeButtonString,
  });

  factory ReduxDevToolsViewModel(
    DevToolsStore<dynamic> store,
    _ContainerState containerState,
    BuildContext context,
  ) {
    return new ReduxDevToolsViewModel._(
      latestAction: store.devToolsState.latestAction.toString(),
      latestState: store.state.toString(),
      onSavePressed: () => store.dispatch(new DevToolsAction.save()),
      onResetPressed: () => store.dispatch(new DevToolsAction.reset()),
      recomputeColor:
          containerState != null && containerState.recomputeOnHotReload
              ? Theme.of(context).accentColor
              : Theme.of(context).textTheme.button.color,
      onRecomputePressed: () {
        if (containerState != null) {
          containerState.toggleRecomputeOnHotReload();
        } else {
          store.dispatch(new DevToolsAction.recompute());
        }
      },
      recomputeButtonString: containerState == null
          ? 'Recompute'
          : 'Toggle "Recompute on Hot Reload"',
      onSliderChanged: (val) =>
          store.dispatch(new DevToolsAction.jumpToState(val.floor())),
      sliderMax: (store.devToolsState.computedStates.length - 1).toDouble(),
      sliderPosition: store.devToolsState.currentPosition.toDouble(),
    );
  }
}

/// Hot Reload. For your State! Change your Reducers? The state will be
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
    Key key,
    @required this.store,
    @required this.child,
    this.recomputeOnHotReload = true,
  })
      : super(key: key);

  @override
  _ReduxDevToolsRecomputeState createState() {
    return new _ReduxDevToolsRecomputeState();
  }
}

class _ReduxDevToolsRecomputeState extends State<ReduxDevToolsContainer> {
  bool _recomputeOnHotReload;

  @override
  Widget build(BuildContext context) {
    return new _ContainerState(
      child: widget.child,
      recomputeOnHotReload: _recomputeOnHotReload,
      toggleRecomputeOnHotReload: _toggleRecomputeOnHotReload,
    );
  }

  _toggleRecomputeOnHotReload() {
    setState(() {
      _recomputeOnHotReload = !_recomputeOnHotReload;
    });
  }

  @override
  void reassemble() {
    if (_recomputeOnHotReload) {
      widget.store.dispatch(new DevToolsAction.recompute());
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
    Key key,
    @required Widget child,
    @required this.recomputeOnHotReload,
    @required this.toggleRecomputeOnHotReload,
  })
      : super(key: key, child: child);

  static _ContainerState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(_ContainerState);
  }

  @override
  bool updateShouldNotify(_ContainerState oldWidget) {
    return recomputeOnHotReload != oldWidget.recomputeOnHotReload;
  }
}
