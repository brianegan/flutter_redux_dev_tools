import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

enum Actions { Increment, Decrement }

int counterReducer(int state, action) {
  if (action == Actions.Increment) {
    return state + 1;
  } else if (action == Actions.Decrement) {
    return state - 1;
  }

  return state;
}

void main() {
  runApp(new FlutterReduxApp());
}

class FlutterReduxApp extends StatelessWidget {
  // Create your store as a final variable in a base Widget. This works better
  // with Hot Reload than creating it directly in the `build` function.
  final store = new DevToolsStore<int>(counterReducer, initialState: 0);

  @override
  Widget build(BuildContext context) {
    final title = 'Flutter Redux Demo';

    return new MaterialApp(
      theme: new ThemeData.dark(),
      title: title,
      home: new StoreProvider(
        store: store,
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text(title),
          ),
          body: new Container(
            child: new ListView(
              children: [
                new StoreConnector<int, ViewModel>(
                  distinct: true,
                  converter: (store) => new ViewModel.fromStore(store),
                  builder: (context, viewModel) {
                    return new Center(
                      child: new Container(
                        padding: new EdgeInsets.only(
                          top: 32.0,
                          bottom: 20.0,
                        ),
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              padding: new EdgeInsets.only(bottom: 28.0),
                              child: new Text(
                                'Current count',
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            new Text(
                              viewModel.count,
                              style: Theme.of(context).textTheme.display1,
                            ),
                            new Container(
                              margin: new EdgeInsets.only(
                                top: 16.0,
                                bottom: 40.0,
                              ),
                              padding: new EdgeInsets.only(bottom: 40.0),
                              decoration: new BoxDecoration(
                                border: new Border(
                                  bottom: new BorderSide(
                                    color: Colors.grey[800],
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: new MaterialButton(
                                      onPressed: viewModel.onIncrementPressed,
                                      child: new Text("Increment"),
                                    ),
                                  ),
                                  new Expanded(
                                    child: new MaterialButton(
                                      onPressed: viewModel.onDecrementPressed,
                                      child: new Text("Decrement"),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                new StoreBuilder(
                  rebuildOnChange: false,
                  builder: (context, store) {
                    return new ReduxDevTools(store);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ViewModel {
  final String count;
  final VoidCallback onIncrementPressed;
  final VoidCallback onDecrementPressed;

  ViewModel(
    this.count,
    this.onIncrementPressed,
    this.onDecrementPressed,
  );

  factory ViewModel.fromStore(Store<int> store) {
    return new ViewModel(
      store.state.toString(),
      () => store.dispatch(Actions.Increment),
      () => store.dispatch(Actions.Decrement),
    );
  }
}
