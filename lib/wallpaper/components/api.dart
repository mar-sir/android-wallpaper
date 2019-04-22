import 'package:app/wallpaper/api.dart';

WallpaperCommentItemResult item = WallpaperCommentItemResult(
    id: 123.toString(),
    comment: "受命于天,既寿永昌",
    userName: "赢",
    userAvatar:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTXMghe9x1hmhhK-IPIAbr1m-S0_oFiTqv3uefYb2t_48UJWg1Xzg");
List<WallpaperCommentItemResult> wallpaperCommentItemResults =
    List.filled(20, item);
