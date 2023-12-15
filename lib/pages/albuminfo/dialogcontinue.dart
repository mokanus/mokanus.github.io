// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:provider/provider.dart';
import 'package:tingfm/entities/album.dart';

import 'package:tingfm/entities/album_meta.dart';
import 'package:tingfm/pages/player/player.dart';
import 'package:tingfm/providers/album_info.dart';
import 'package:tingfm/widgets/image.dart';

class DialogContinue extends StatefulWidget {
  late AlbumItem albumItem;
  late AlbumMeta albumMeta;

  DialogContinue({
    Key? key,
    required this.albumItem,
    required this.albumMeta,
  }) : super(key: key);

  @override
  State<DialogContinue> createState() => DialogContinueState();
}

class DialogContinueState extends State<DialogContinue> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
            color: Color.fromARGB(255, 234, 78, 94),
          ),
          height: 60,
          width: ScreenUtil().screenWidth,
          child: const Text(
            "播放历史",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
          child: Container(
            margin: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(55),
                ScreenUtil().setHeight(8),
                ScreenUtil().setWidth(55),
                ScreenUtil().setHeight(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 0.2,
                    surfaceTintColor: Colors.transparent,
                    child: Row(
                      children: [
                        Container(
                          //设置边距
                          margin: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(30),
                              ScreenUtil().setHeight(30),
                              ScreenUtil().setWidth(30),
                              ScreenUtil().setHeight(30)),
                          height: ScreenUtil().setHeight(270),
                          width: ScreenUtil().setWidth(270),
                          child: imageCached(
                            widget.albumItem.imageUrl(),
                            widget.albumItem.cachedKey(),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                child: Text(
                                  "${widget.albumItem.album} · ${widget.albumItem.artist}",
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(44),
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                "播放到 : ${widget.albumMeta.title}",
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(35),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 50),
          child: IconsButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (_, __, ___) => PlayerPage(
                    fromMiniplayer: false,
                    albumItem:
                        Provider.of<AlbumInfoProvider>(context, listen: false)
                            .item,
                    albumMeta: widget.albumMeta,
                  ),
                ),
              );
            },
            text: '继续',
            iconData: Icons.arrow_right_rounded,
            color: const Color.fromARGB(255, 234, 78, 94),
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
