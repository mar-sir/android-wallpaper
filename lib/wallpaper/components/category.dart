import 'dart:ui';

import 'package:app/wallpaper/api.dart';
import 'package:app/wallpaper/components/wallpaper.dart';
import 'package:app/wallpaper/redux.dart';
import 'package:app/wallpaper/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CategoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Service.setSize(MediaQuery.of(context).size);
    return StoreConnector<AppState, CategoryResult>(
      converter: (store) {
        return store.state.categoryState.categoryResult;
      },
      builder: (BuildContext context, CategoryResult vm) => Scaffold(
            body:
                vm.items.length > 0 ? _buildGridBody(vm) : _buildEmptyWidget(),
          ),
    );
  }

  Widget _buildGridBody(CategoryResult vm) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: vm.items.length,
      itemBuilder: (BuildContext context, int index) =>
          _buildCategoryItem(context, vm.items[index]),
    );
  }

  Widget _buildEmptyWidget() {
    Service.getCategory();
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(),
          ),
          Text("加载中"),
          Icon(
            Icons.hourglass_empty,
            color: Colors.pink,
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, CategoryResultItem item) {
    return GestureDetector(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Image.network(item.cover),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Center(
            child: Text(item.name,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,letterSpacing: 20),),
          )
        ],
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute<Null>(
                builder: (context) => WallpaperListWidget(
                      id: item.id,
                      title: item.name,
                    )));
      },
    );
  }
}
