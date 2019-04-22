
import 'dart:math';

import 'package:app/wallpaper/api.dart';
import 'package:app/wallpaper/service.dart';
import 'package:flutter/material.dart';

class BarrageReview extends StatefulWidget {
  final String id;
  BarrageReview(this.id);
  @override
  _BarrageReviewState createState() => _BarrageReviewState();
}

class _BarrageReviewState extends State<BarrageReview>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  WallpaperCommentItemResult item;
  List<WallpaperCommentItemResult> barrageCommentList = [];
  List<BarrageWidget> barrageWidgetList = [];
  int index = 0;
  int skep = 0;
  bool isReverse = false;
  void initData() async {
    WallpaperCommentResult result =
        await Service.getWallpaperComments(widget.id);
    barrageCommentList = result.items;
    skep = ((Service.screenSize.height - 50) / 50).floor();
    initBarrageListWidget();
  }

  randomInitAxisX() {
    return Random().nextDouble() * Service.screenSize.width +
        Service.screenSize.width;
  }

  initBarrageListWidget() {
    int min =
        skep < barrageCommentList.length ? skep : barrageCommentList.length;
    barrageWidgetList = new List(min);
    for (var i = 0; i < min; i++) {
      Offset initOffset = Offset(randomInitAxisX(), (i * 50.0 + 50.0));
      barrageWidgetList[i] = BarrageWidget(
        item: barrageCommentList[i],
        initOffset: initOffset,
        offset: initOffset,
      );
    }
    index = min;
  }

// w-2w =>  -2w
  generateChangeBarrageListWidget() {
    for (var i = 0; i < barrageWidgetList.length; i++) {
      if (index >= barrageCommentList.length) {
        return;
      }
      barrageWidgetList[i].initOffset =
          Offset(randomInitAxisX(), (i * 50.0 + 50.0));
      barrageWidgetList[i].offset = barrageWidgetList[i].initOffset;
      barrageWidgetList[i].item = barrageCommentList[index];
      index++;
    }
    setState(() {    });
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 9000));
    double width = Service.screenSize.width;
    animation = Tween(begin: 0.0, end: width * 3).animate(controller)
      ..addListener(() {
        setState(() {
          barrageWidgetList.forEach((e) {
            if (isReverse) {
              e.offset = e.initOffset - Offset(width * 3 - animation.value, 0);
            } else {
              e.offset = e.initOffset - Offset(animation.value, 0);
            }
          });
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          isReverse = true;
          generateChangeBarrageListWidget();
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          isReverse = false;
          generateChangeBarrageListWidget();
          controller.forward();
        }
        print(status);
      });
    controller.forward();
    initData();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: barrageWidgetList
          .map((b) => Transform.translate(
                offset: b.offset,
                child: b,
              ))
          .toList(),
    );
  }
}

class BarrageWidget extends StatelessWidget {
  Offset offset;
  Offset initOffset;
  WallpaperCommentItemResult item;
  BarrageWidget(
      {@required this.initOffset, @required this.offset, @required this.item});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.grey.withOpacity(0.6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(
            radius: 45,
            child: Image.network(item.userAvatar),
          ),
          Text(item.comment)
        ],
      ),
    );
  }
}
