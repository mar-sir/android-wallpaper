import 'package:app/wallpaper/api.dart';
import 'package:app/wallpaper/redux.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class Service {
  static Store store;
  static WallpaperApi api = WallpaperApi();

  // 获取某个类型的图片时， 类型id， 获取第几张图片，图片的排序方式
  static String cid;
  static int start;
  static String sort = "new"; //备选 hot

  static bool isRequest = false;

  static Size screenSize;
  Service() {
    cid = null;
    start = 0;
  }
  static setSize(Size size) {
    screenSize = size;
  }

  static setStore(Store s) {
    store = s;
  }

  static getCategory() {
    api.getCategories().then((val) {
      store.dispatch(CategoryResultAction(val));
    });
  }

  static getWallpaper(
      [String id = "-1", String psort = "sort", int pstart = -1]) {
    if (id != cid && id != "-1") {
      cid = id;
      start = 0;
      sort = "new";
      store.dispatch(WallpaperClearAction());
    }
    if (pstart != -1) start = pstart;
    if (psort != "sort" && psort != sort) {
      store.dispatch(WallpaperClearAction());
      start = 0;
      sort = psort;
    }
    if (isRequest) return;
    isRequest = true;
    api.getWallpapers(cid, sort, start).then((val) {
      start += val.items.length;
      isRequest = false;
      store.dispatch(WallpaperResultAction(val));
    });
  }

  static randomWallperPage(int page) {
    start = page;
    getWallpaper(cid);
  }

  static getWallpaperComments(String id) async {
    return api.getComments(id);
    // .then((value) => store.dispatch(WallpaperCommentResultAction(value)));
  }
}
