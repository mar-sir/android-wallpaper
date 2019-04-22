import 'package:dio/dio.dart';

class CategoryResultItem {
  final String id;
  final String name;
  final String cover;

  CategoryResultItem({this.id, this.name, this.cover});

  factory CategoryResultItem.fromJson(Map<String, Object> obj) {
    return CategoryResultItem(
      id: obj["id"] as String,
      name: obj["name"] as String,
      cover: obj["cover"] as String,
    );
  }
}

class WallpaperItemResult {
  final String id;
  final String preview;
  final String thumb;

  WallpaperItemResult({
    this.id,
    this.preview,
    this.thumb,
  });

  factory WallpaperItemResult.fromJson(Map<String, Object> json) {
    return WallpaperItemResult(
        id: json["id"] as String,
        preview: json["preview"] as String,
        thumb: json["thumb"] as String);
  }
}

class WallpaperCommentItemResult {
  final String id;
  final String userName;
  final String userAvatar;
  final String comment;

  WallpaperCommentItemResult(
      {this.id, this.userName, this.userAvatar, this.comment});

  factory WallpaperCommentItemResult.fromJson(Map<String, Object> json) {
    return WallpaperCommentItemResult(
      id: json["id"] as String,
      comment: json["content"] as String,
      userAvatar: ((json["user"] as Map<String, Object>)["avatar"] as String),
      userName: ((json["user"] as Map<String, Object>)["name"] as String),
    );
  }
}

class CategoryResult {
  final List<CategoryResultItem> items;

  CategoryResult(this.items);

  factory CategoryResult.fromJson(dynamic json) {
    final items = (json as List)
        .cast<Map<String, Object>>()
        .map((Map<String, Object> item) => CategoryResultItem.fromJson(item))
        .toList();

    return CategoryResult(items);
  }
}

class WallpaperResult {
  List<WallpaperItemResult> items;

  WallpaperResult(this.items);
  factory WallpaperResult.fromJson(dynamic json) {
    final items = (json as List)
        .cast<Map<String, Object>>()
        .map((Map<String, Object> item) => WallpaperItemResult.fromJson(item))
        .toList();
    return WallpaperResult(items);
  }
}

class WallpaperCommentResult {
  final List<WallpaperCommentItemResult> items;
  WallpaperCommentResult(this.items);
  factory WallpaperCommentResult.fromJson(dynamic json) {
    final items = (json as List)
        .cast<Map<String, Object>>()
        .map((Map<String, Object> item) =>
            WallpaperCommentItemResult.fromJson(item))
        .toList();
    return WallpaperCommentResult(items);
  }
}

class WallpaperApi {
  final String baseUrl;
  final Dio dio = Dio();

  WallpaperApi({this.baseUrl = "http://service.picasso.adesk.com"}) {
    dio.options.baseUrl = baseUrl;
  }

  Future<WallpaperResult> getWallpapers(
      String id, String sort, int start) async {
    final response = await dio.get(
        "/v1/vertical/category/$id/vertical?limit=20&adult=false&first=1&order=$sort&skip=$start");
    if (response.data != null) {
      return WallpaperResult.fromJson(response.data["res"]["vertical"]);
    }
    return WallpaperResult([]);
  }

  Future<CategoryResult> getCategories() async {
    final response = await dio.get('/v1/vertical/category');
    if (response.data != null) {
      return CategoryResult.fromJson(response.data["res"]["category"]);
    }
    return CategoryResult(<CategoryResultItem>[]);
  }

  Future<WallpaperCommentResult> getComments(String id) async {
    final response = await dio.get("/v2/vertical/vertical/$id/comment");
    if (response.data != null) {
      return WallpaperCommentResult.fromJson(response.data["res"]["comment"]);
    }
    return WallpaperCommentResult.fromJson([]);
  }
}
