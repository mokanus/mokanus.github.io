import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tingfm/entities/album.dart';
import 'package:tingfm/pages/player/player.dart';
import 'package:tingfm/widgets/image.dart';

class RecommendItem extends StatefulWidget {
  final AlbumItem albumItem;
  const RecommendItem({super.key, required this.albumItem});

  @override
  State<RecommendItem> createState() => _RecommendItemState();
}

class _RecommendItemState extends State<RecommendItem> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Card(
        elevation: 0.2,
        child: GestureDetector(
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.only(top: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: SizedBox.square(
                  dimension: ScreenUtil().setWidth(371),
                  child: imageCached(
                    widget.albumItem.imageUrl(),
                    widget.albumItem.cachedKey(),
                    width: ScreenUtil().setWidth(371),
                    height: ScreenUtil().setHeight(371),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(60),
                    ScreenUtil().setHeight(50),
                    ScreenUtil().setWidth(55),
                    ScreenUtil().setHeight(10)),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.albumItem.album,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 51, 51, 51),
                    fontSize: ScreenUtil().setSp(43),
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(60),
                    ScreenUtil().setHeight(10),
                    ScreenUtil().setWidth(55),
                    ScreenUtil().setHeight(70)),
                child: Text(
                  widget.albumItem.listenTime(),
                  style: TextStyle(
                    color: const Color.fromARGB(255, 136, 136, 136),
                    fontSize: ScreenUtil().setSp(33),
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (_, __, ___) => PlayerPage(
                  fromMiniplayer: false,
                  album: widget.albumItem.album,
                  albumId: widget.albumItem.id,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
