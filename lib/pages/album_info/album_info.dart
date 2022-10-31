import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tingfm/pages/player/player.dart';
import 'package:tingfm/providers/album_info.dart';
import 'package:tingfm/widgets/body_builder.dart';
import 'package:tingfm/widgets/image.dart';

class AlbumInfoPage extends StatefulWidget {
  final String album;
  final int albumId;

  const AlbumInfoPage({super.key, required this.album, required this.albumId});

  @override
  State<AlbumInfoPage> createState() => _AlbumInfoPageState();
}

class _AlbumInfoPageState extends State<AlbumInfoPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<AlbumInfoProvider>(context, listen: false)
          .getAlbumInfo(context, widget.albumId),
    );

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Consumer<AlbumInfoProvider>(builder:
            (BuildContext context, AlbumInfoProvider provider, Widget? child) {
          return BodyBuilder(
            apiRequestStatus: provider.apiRequestStatus,
            reload: () => provider.getAlbumInfo(context, widget.albumId),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(200),
                        ScreenUtil().setHeight(70),
                        ScreenUtil().setWidth(200),
                        ScreenUtil().setHeight(0)),
                    child: imageCached(
                      provider.item!.imageUrl(),
                      provider.item!.cachedKey(),
                      width: ScreenUtil().setWidth(574),
                      height: ScreenUtil().setWidth(574),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(200),
                        ScreenUtil().setHeight(60),
                        ScreenUtil().setWidth(200),
                        ScreenUtil().setHeight(0)),
                    child: Text(
                      provider.item!.album,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(60)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(200),
                        ScreenUtil().setHeight(40),
                        ScreenUtil().setWidth(200),
                        ScreenUtil().setHeight(0)),
                    child: Text(
                      "艺术家 : ${provider.item!.artist}",
                      style: TextStyle(fontSize: ScreenUtil().setSp(44)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(200),
                        ScreenUtil().setHeight(44),
                        ScreenUtil().setWidth(200),
                        ScreenUtil().setHeight(10)),
                    child: Text(
                      "${provider.item!.listenTimes} 次收听 · ${provider.item!.loveCount} 次喜欢",
                      style: TextStyle(fontSize: ScreenUtil().setSp(36)),
                    ),
                  ),
                  provider.item!.desc == ""
                      ? const SizedBox()
                      : Padding(
                          padding: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(200),
                              ScreenUtil().setHeight(70),
                              ScreenUtil().setWidth(200),
                              ScreenUtil().setHeight(0)),
                          child: Text(
                            "简要概述:${provider.item!.desc}",
                            style: TextStyle(fontSize: ScreenUtil().setSp(40)),
                          ),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        child: Container(
                          height: ScreenUtil().setHeight(140),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.play_arrow),
                              Text(" 开始收听",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: ScreenUtil().setSp(40)))
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (_, __, ___) => PlayerPage(
                                fromMiniplayer: false,
                                albumItem: provider.item,
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        height: ScreenUtil().setHeight(134),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.list, size: 40),
                            Text("  ${provider.item!.count} 集",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(40)))
                          ],
                        ),
                      ),
                      Container(
                        height: ScreenUtil().setHeight(134),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.favorite_sharp),
                            Text("  收藏",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(40),
                                    fontFamily: "Avenir"))
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
