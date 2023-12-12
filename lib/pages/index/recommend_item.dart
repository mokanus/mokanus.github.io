import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tingfm/entities/album.dart';
import 'package:tingfm/pages/albuminfo/albuminfo.dart';
import 'package:tingfm/widgets/image.dart';

class RecommendItemWidget extends StatelessWidget {
  final AlbumItem album;
  const RecommendItemWidget({super.key, required this.album});

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
    return Column(
      children: [
        // 图片控件
        Stack(
          children: [
            GestureDetector(
              onTap: () => openAlbumInfo(context),
              child: Container(
                width: ScreenUtil().setWidth(320),
                height: ScreenUtil().setHeight(320),
                padding: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setSp(10), 0),
                child: imageCached(
                  album.imageUrl(),
                  album.cachedKey(),
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                width: ScreenUtil().setWidth(320),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.play_arrow_outlined,
                      color: Colors.white,
                    ),
                    Text(
                      album.listenTime(),
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(32),
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(20),
                    ),
                  ],
                )),
          ],
        ),
        SizedBox(
          height: ScreenUtil().setHeight(5),
        ),
        //专辑名字
        Text(
          album.album,
          style: TextStyle(fontSize: ScreenUtil().setSp(40)),
        )
      ],
    );
  }
}
