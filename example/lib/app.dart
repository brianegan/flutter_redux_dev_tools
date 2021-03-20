import 'package:flutter/material.dart' hide Actions;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import './store.dart';

class App extends StatelessWidget {
  final Store<int> store;
  final WidgetBuilder? devDrawerBuilder;

  App({
    Key? key,
    required this.store,
    this.devDrawerBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = 'Flutter Redux Demo';

    return MaterialApp(
      theme: ThemeData.dark(),
      title: title,
      home: StoreProvider(
        store: store,
        child: Scaffold(
          endDrawer: devDrawerBuilder?.call(context),
          appBar: AppBar(
            title: Text(title),
          ),
          body: Container(
            child: ListView(
              children: [
                StoreConnector<int, ViewModel>(
                  distinct: true,
                  converter: (store) => ViewModel.fromStore(store),
                  builder: (context, viewModel) {
                    return Center(
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 32.0,
                          bottom: 20.0,
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(bottom: 28.0),
                              child: Text(
                                'Current count',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              viewModel.count,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 16.0,
                                bottom: 40.0,
                              ),
                              padding: EdgeInsets.only(bottom: 40.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade800,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: MaterialButton(
                                      onPressed: viewModel.onIncrementPressed,
                                      child: Text("Increment"),
                                    ),
                                  ),
                                  Expanded(
                                    child: MaterialButton(
                                      onPressed: viewModel.onDecrementPressed,
                                      child: Text("Decrement"),
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
    return ViewModel(
      store.state.toString(),
      () => store.dispatch(Actions.Increment),
      () => store.dispatch(Actions.Decrement),
    );
  }
}
