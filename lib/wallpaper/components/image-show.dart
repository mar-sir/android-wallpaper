
import 'package:app/wallpaper/api.dart';
import 'package:app/wallpaper/components/barrage-review.dart';
import 'package:app/wallpaper/redux.dart';
import 'package:app/wallpaper/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_downloader/image_downloader.dart';

class ImageShow extends StatefulWidget {
  final int index;

  const ImageShow(this.index);

  @override
  _ImageShowState createState() => _ImageShowState();
}

class _ImageShowState extends State<ImageShow> {
  int index;
  IconData downloadIcon = Icons.cloud_download;
  Offset moveOffset;
  Offset startOffset;
  int maxIndex = 0;
  double halfScreenWidth = 200.0;

  @override
  void initState() {
    super.initState();
    index = widget.index;
    moveOffset = Offset(0, 0);
  }

  download(BuildContext context, String url) async {
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(url);
      if (imageId == null) {
        return;
      }
      // Below is a method of obtaining saved image information.
      // var fileName = await ImageDownloader.findName(imageId);
      // var path = await ImageDownloader.findPath(imageId);
      // var size = await ImageDownloader.findByteSize(imageId);
      // var mimeType = await ImageDownloader.findMimeType(imageId);
      setState(() {
        downloadIcon = Icons.cloud_done;
      });
    } catch (error) {
      print(error);
    }
  }

  void _onPanStart(DragStartDetails details) {
    startOffset = details.globalPosition;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      moveOffset = Offset(details.globalPosition.dx - startOffset.dx, 0);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (moveOffset.dx < -halfScreenWidth && index < maxIndex - 1) {
      index++;
    }
    if (moveOffset.dx > halfScreenWidth && index > 0) {
      index--;
    }
    if (maxIndex - index < 5) {
      Service.getWallpaper(Service.cid);
    }
    setState(() {
      moveOffset = Offset(0, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    halfScreenWidth = MediaQuery.of(context).size.width / 2;
    return StoreConnector<AppState, List<WallpaperItemResult>>(
      converter: (store) => store.state.wallpaperState.wallpaperResult.items,
      builder: (context, items) => _buildBody(items),
    );
  }

  Widget _buildBody(List<WallpaperItemResult> items) {
    maxIndex = items.length;
    print(maxIndex);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButton: FloatingActionButton(
        child: Icon(downloadIcon, color: Colors.pink),
        onPressed: () {
          download(context, items[index].preview);
        },
      ),
      body: GestureDetector(
        key: Key(items[index].id),
        onTap: () => Navigator.pop(context),
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(items[index + 1].thumb))),
              child: Image.network(
                items[index + 1].preview,
                fit: BoxFit.cover,
              ),
            ),
            Transform.translate(
              offset: moveOffset,
              child: SizedBox.expand(
                child: Hero(
                  tag: items[index].id,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(items[index].thumb))),
                    child: Image.network(
                      items[index].preview,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            BarrageReview(items[index].id)
          ],
        ),
      ),
    );
  }
}
