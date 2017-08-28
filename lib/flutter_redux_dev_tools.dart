library flutter_redux_dev_tools;

import 'package:flutter/material.dart';
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
///        body: new ReduxDevTools(store),
///      ),
///    ));
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
      stream: widget.store.onChange.map(
        (_) => new ReduxDevToolsViewModel.fromStore(widget.store),
      ),
      builder: (context, snapshot) {
        final model = snapshot.hasData
            ? snapshot.data
            : new ReduxDevToolsViewModel.fromStore(widget.store);

        return new Column(
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
                    child: new FlatButton(
                      key: ReduxDevTools.saveKey,
                      onPressed: model.onSavePressed,
                      child: new Text("Save"),
                    ),
                  ),
                  new Expanded(
                    child: new FlatButton(
                      key: ReduxDevTools.resetKey,
                      onPressed: model.onResetPressed,
                      child: new Text("Reset"),
                    ),
                  ),
                  new Expanded(
                    child: new FlatButton(
                      key: ReduxDevTools.recomputeKey,
                      onPressed: model.onRecomputePressed,
                      child: new Text("Recompute"),
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              margin: new EdgeInsets.only(top: 8.0),
              padding: new EdgeInsets.only(top: 8.0),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          child: new AlertDialog(
                            content: new ListView(
                              children: [
                                new Text(
                                  model.latestState,
                                )
                              ],
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
                              "Current State:",
                              style: new TextStyle(
                                fontStyle: FontStyle.italic,
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
                  new Expanded(
                    child: new InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          child: new AlertDialog(
                            content: new ListView(
                              children: [
                                new Text(
                                  model.latestAction,
                                  textAlign: TextAlign.left,
                                ),
                              ],
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
                              "Current Action:",
                              style: new TextStyle(
                                fontStyle: FontStyle.italic,
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

  ReduxDevToolsViewModel({
    this.latestAction,
    this.latestState,
    this.onSavePressed,
    this.onResetPressed,
    this.onRecomputePressed,
    this.onSliderChanged,
    this.sliderMax,
    this.sliderPosition,
  });

  factory ReduxDevToolsViewModel.fromStore(DevToolsStore<dynamic> store) {
    return new ReduxDevToolsViewModel(
      latestAction: store.devToolsState.latestAction.toString(),
      latestState: store.state.toString(),
      onSavePressed: () => store.dispatch(new DevToolsAction.save()),
      onResetPressed: () => store.dispatch(new DevToolsAction.reset()),
      onRecomputePressed: () => store.dispatch(new DevToolsAction.recompute()),
      onSliderChanged: (val) =>
          store.dispatch(new DevToolsAction.jumpToState(val.floor())),
      sliderMax: (store.devToolsState.computedStates.length - 1).toDouble(),
      sliderPosition: store.devToolsState.currentPosition.toDouble(),
    );
  }
}
