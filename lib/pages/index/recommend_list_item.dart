import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tingfm/entities/album.dart';
import 'package:tingfm/pages/album_info/album_info.dart';
import 'package:tingfm/widgets/image.dart';

class RecommendListItemWidget extends StatelessWidget {
  final List<AlbumItem> albums;
  const RecommendListItemWidget({super.key, required this.albums});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtil().screenWidth * 0.75,
      child: Column(
        children: [
          // 图片控件
          ItemWidget(album: albums[0]),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          ItemWidget(album: albums[1]),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          ItemWidget(album: albums[2]),
        ],
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  final AlbumItem album;
  const ItemWidget({super.key, required this.album});

  void openAlbumInfo(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => AlbumInfoPage(
          album: album.album,
          albumId: album.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openAlbumInfo(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //专辑名字
          Row(
            children: [
              imageCached(album.imageUrl(), album.cachedKey(),
                  width: ScreenUtil().setWidth(130),
                  height: ScreenUtil().setHeight(130)),
              SizedBox(
                width: ScreenUtil().setWidth(20),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(360),
                child: Text(
                  album.album,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(40),
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              SizedBox(
                  width: ScreenUtil().setWidth(180),
                  child: Text(
                    "- ${album.artist}",
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(32),
                        overflow: TextOverflow.clip),
                  )),
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.play_circle,
                color: Colors.red,
              ),
              SizedBox(
                width: ScreenUtil().setWidth(30),
              ),
            ],
          )
        ],
      ),
    );
  }
}
