import 'package:app/wallpaper/components/category.dart';
import 'package:app/wallpaper/redux.dart';
import 'package:app/wallpaper/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class HomePage extends StatelessWidget {
  final Store<AppState> store =
      Store<AppState>(appReducer, initialState: AppState.init());

  HomePage() {
    Service.setStore(store);
  }
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: CategoryWidget(),
        ),
      ),
    );
  }
}
