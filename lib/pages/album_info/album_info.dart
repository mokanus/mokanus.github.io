import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tingfm/pages/player/player.dart';
import 'package:tingfm/providers/album_info.dart';
import 'package:tingfm/providers/favorate.dart';
import 'package:tingfm/providers/history.dart';
import 'package:tingfm/widgets/image.dart';
import 'package:tingfm/widgets/mini_player.dart';
import 'package:tingfm/widgets/snackbar.dart';

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
    return Consumer<AlbumInfoProvider>(builder:
        (BuildContext context, AlbumInfoProvider provider, Widget? child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: provider.item == null
              ? const SizedBox()
              : Container(
                  padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: Column(
                    children: [
                      Expanded(
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
                                    fontSize: ScreenUtil().setSp(60),
                                    fontFamily: "Avenir"),
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
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(44),
                                    fontFamily: "Avenir"),
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
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(36),
                                    fontFamily: "Avenir"),
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
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(30),
                                          fontFamily: "Avenir"),
                                    ),
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: ScreenUtil().setHeight(134),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.menu),
                                      Text(" ${provider.item!.count}集",
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(40),
                                              fontFamily: "Avenir"))
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  child: Container(
                                    height: ScreenUtil().setHeight(134),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.favorite_sharp,
                                          color:
                                              Color.fromARGB(255, 234, 78, 94),
                                        ),
                                        Text("加入喜欢",
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(40),
                                                fontFamily: "Avenir"))
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    addItemToFavorate();
                                  },
                                ),
                                GestureDetector(
                                  child: Container(
                                    height: ScreenUtil().setHeight(140),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.play_arrow_rounded),
                                        provider.isPlayed()
                                            ? Text("继续播放",
                                                style: TextStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(40),
                                                    fontFamily: "Avenir"))
                                            : Text("开始播放",
                                                style: TextStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(40),
                                                    fontFamily: "Avenir"))
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    addItemToHistory();
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
                              ],
                            ),
                            provider.isPlayed()
                                ? Container(
                                    alignment: Alignment.centerLeft,
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          provider.getAlbumMetaInfo(),
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(32),
                                              fontFamily: "Avenir"),
                                        ),
                                        Text(
                                          provider.getDuration(),
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(32),
                                              fontFamily: "Avenir"),
                                        ),
                                      ],
                                    ))
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      const MiniPlayer(),
                    ],
                  ),
                ),
        ),
      );
    });
  }

  addItemToHistory() {
    var item = Provider.of<AlbumInfoProvider>(context, listen: false).item;
    if (item != null) {
      Provider.of<HishoryProvider>(context, listen: false)
          .addItemFromAlbum(item);
    }
  }

  addItemToFavorate() {
    var item = Provider.of<AlbumInfoProvider>(context, listen: false).item;
    if (item != null) {
      Provider.of<FavorateProvider>(context, listen: false)
          .addItemFromAlbum(item);
      ShowSnackBar().showSnackBar(
        context,
        "${item.album} 已经加入喜欢列表啦",
      );
    }
  }
}
