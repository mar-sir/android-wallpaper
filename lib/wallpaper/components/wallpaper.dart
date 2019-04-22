import 'dart:math';

import 'package:app/wallpaper/api.dart';
import 'package:app/wallpaper/components/image-show.dart';
import 'package:app/wallpaper/redux.dart';
import 'package:app/wallpaper/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

class WallpaperListWidget extends StatefulWidget {
  final String id;
  final String title;

  const WallpaperListWidget({Key key, this.id, this.title}) : super(key: key);

  @override
  _WallpaperListWidgetState createState() => _WallpaperListWidgetState();
}

class _WallpaperListWidgetState extends State<WallpaperListWidget> {
  String id;
  String title;
  ScrollController scrollController = ScrollController();
  TextEditingController randomTextController = TextEditingController();
  List<DropdownMenuItem> dropDownItems = [
    DropdownMenuItem(
      value: "new",
      child: Text("时间顺序"),
    ),
    DropdownMenuItem(
      value: "hot",
      child: Text("热门顺序"),
    )
  ];
  var selectItemValue;
  _WallpaperListWidgetState() {}
  void initState() {
    super.initState();
    selectItemValue = dropDownItems[0].value;

    id = widget.id;
    title = widget.title;
    Service.getWallpaper(id);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Service.getWallpaper();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    randomTextController.dispose();
  }

  randomWallpaperTap(context) {
    String text = randomTextController.text;
    if (text == null || text.isEmpty) {
      Service.randomWallperPage(Random().nextInt(1000));
    } else {
      Service.randomWallperPage(int.parse(text));
    }
    Navigator.pop(context);
  }

  randomPageTap(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text('跳转'),
            content: TextField(
              decoration: InputDecoration(
                hintText: '随机一个',
              ),
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              controller: randomTextController,
              onSubmitted: (s) => randomWallpaperTap(context),
            ),
            actions: <Widget>[
              RaisedButton(
                child: Text("跳转"),
                onPressed: () => randomWallpaperTap(context),
              )
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, WallpaperResult>(
      converter: (store) => store.state.wallpaperState.wallpaperResult,
      builder: (BuildContext context, WallpaperResult vm) => Scaffold(
            appBar: AppBar(
              title: Text(title),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.cake),
                  onPressed: () => randomPageTap(context),
                ),
                DropdownButton(
                  items: dropDownItems,
                  value: selectItemValue,
                  hint: Text("what"),
                  onChanged: (e) {
                    print(e);
                    setState(() {
                      selectItemValue = e;
                    });
                    Service.getWallpaper(id, e);
                    // Service.get
                  },
                )
              ],
            ),
            body: _buildGridBody(context, vm),
          ),
    );
  }

  Widget _buildGridBody(BuildContext context, WallpaperResult vm) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.66),
      itemCount: vm.items.length,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
            child: Hero(
              tag: vm.items[index].id,
              child: Image.network(
                vm.items[index].thumb,
                fit: BoxFit.fitWidth,
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<Null>(
                      builder: (BuildContext context) => ImageShow(index)));
            },
          ),
      controller: scrollController,
    );
  }
}
