import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:provider/provider.dart';
import 'package:tingfm/api/api_status.dart';
import 'package:tingfm/pages/player/player.dart';
import 'package:tingfm/providers/album_info.dart';
import 'package:tingfm/providers/favorite.dart';
import 'package:tingfm/providers/history.dart';
import 'package:tingfm/utils/admob.dart';
import 'package:tingfm/utils/global.dart';
import 'package:tingfm/widgets/image.dart';
import 'package:tingfm/widgets/mini_player.dart';
import 'package:tingfm/widgets/snackbar.dart';

import '../../widgets/loading_widget.dart';

class AlbumInfoPage extends StatefulWidget {
  final String album;
  final int albumId;

  const AlbumInfoPage({super.key, required this.album, required this.albumId});

  @override
  State<AlbumInfoPage> createState() => _AlbumInfoPageState();
}

class _AlbumInfoPageState extends State<AlbumInfoPage>
    with WidgetsBindingObserver {
  late AdmobAdManager admob;

  @override
  void initState() {
    admob = AdmobAdManager(rewardCallback);
    admob.loadAd(RewardAdType.info);

    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<AlbumInfoProvider>(context, listen: false)
          .getAlbumInfo(context, widget.albumId),
    );

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AlbumInfoProvider>(builder:
        (BuildContext context, AlbumInfoProvider provider, Widget? child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text("专辑信息"),
        ),
        body: SafeArea(
          child: provider.apiRequestStatus != APIRequestStatus.loaded
              ? const LoadingWidget()
              : Column(
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: showAuidoListDialog,
                                child: SizedBox(
                                  height: ScreenUtil().setHeight(134),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.menu),
                                      Text(" ${provider.item!.count}章",
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(42),
                                              fontFamily: "Avenir"))
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                child: SizedBox(
                                  height: ScreenUtil().setHeight(134),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.favorite_sharp,
                                        color: provider.readyFavorate
                                            ? const Color.fromARGB(
                                                255, 234, 78, 94)
                                            : Colors.grey,
                                      ),
                                      Text("喜欢",
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(42),
                                              fontFamily: "Avenir"))
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    addItemToFavorate();
                                  });
                                },
                              ),
                              GestureDetector(
                                child: SizedBox(
                                  height: ScreenUtil().setHeight(140),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.play_arrow_rounded),
                                      provider.isPlayed()
                                          ? Text("继续",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(42),
                                                  fontFamily: "Avenir"))
                                          : Text("播放",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(42),
                                                  fontFamily: "Avenir"))
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  showAdDialog();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const MiniPlayer(),
                  ],
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

  Future<void> addItemToFavorate() async {
    var item = Provider.of<AlbumInfoProvider>(context, listen: false).item;
    if (item != null) {
      var deleted = await Provider.of<FavoriteProvider>(context, listen: false)
          .addItemFromAlbum(item);
      // ignore: use_build_context_synchronously
      ShowSnackBar().showSnackBar(
        context,
        !deleted ? "${item.album} 已经加入喜欢列表啦" : "${item.album} 已经从喜欢列表移除啦",
      );
      // ignore: use_build_context_synchronously
      await Provider.of<AlbumInfoProvider>(context, listen: false)
          .flushFavorateState();
    }
  }

  void showAdDialog() {
    if (Global.isVip) {
      openPlayerPage();
    } else {
      admob.loadAd(RewardAdType.info);
      Dialogs.materialDialog(
          color: Colors.white,
          msg: '看次广告获取30分钟的收听时间',
          title: '畅听所有专辑',
          lottieBuilder: Lottie.asset(
            'assets/jsons/lottie_a.json',
            fit: BoxFit.contain,
          ),
          customView: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0)),
              color: Color.fromARGB(255, 234, 78, 94),
            ),
            height: 60,
          ),
          customViewPosition: CustomViewPosition.BEFORE_ANIMATION,
          context: context,
          actions: [
            IconsButton(
              onPressed: () {
                if (admob.adLoaded) {
                  Navigator.pop(context);
                  admob.showAd(RewardAdType.info);
                } else {
                  Navigator.pop(context);
                  openPlayerPage();
                }
              },
              text: '确定',
              iconData: Icons.arrow_right_rounded,
              color: const Color.fromARGB(255, 234, 78, 94),
              textStyle: const TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ]);
    }
  }

  void showCongradulationsDialog() {
    Dialogs.materialDialog(
        color: Colors.white,
        msg: '恭喜你获得30分钟畅听奖励时长,点击播放畅听吧',
        title: '30分钟奖励',
        lottieBuilder: Lottie.asset(
          'assets/jsons/lottie_a.json',
          fit: BoxFit.contain,
        ),
        customView: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
            color: Color.fromARGB(255, 234, 78, 94),
          ),
          height: 60,
        ),
        customViewPosition: CustomViewPosition.BEFORE_ANIMATION,
        context: context,
        actions: [
          IconsButton(
            onPressed: () {
              Navigator.pop(context);
            },
            text: '收到',
            iconData: Icons.arrow_right_rounded,
            color: const Color.fromARGB(255, 234, 78, 94),
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  void showAuidoListDialog() {
    Dialogs.bottomMaterialDialog(
      color: Colors.white,
      customView: Padding(
        padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
        child: SizedBox(
          height: 350,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 10),
            shrinkWrap: true,
            itemCount: Provider.of<AlbumInfoProvider>(context, listen: false)
                .item!
                .count,
            itemBuilder: (context, index) {
              return ListTileTheme(
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.only(left: 16.0, right: 10.0),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox.square(
                        dimension: 50,
                        child: imageCached(
                          Provider.of<AlbumInfoProvider>(context, listen: false)
                              .item!
                              .imageUrl(),
                          Provider.of<AlbumInfoProvider>(context, listen: false)
                              .item!
                              .cachedKey(),
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    Provider.of<AlbumInfoProvider>(context, listen: false)
                        .item!
                        .mediaItems[index]
                        .title
                        .substring(
                            0,
                            Provider.of<AlbumInfoProvider>(context,
                                        listen: false)
                                    .item!
                                    .mediaItems[index]
                                    .title
                                    .length -
                                4),
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    showAdDialog();
                  },
                ),
              );
            },
          ),
        ),
      ),
      customViewPosition: CustomViewPosition.BEFORE_ANIMATION,
      context: context,
    );
  }

  void rewardCallback() {
    Global.setVip();
    showCongradulationsDialog();
    // 刷新窗口
  }

  void openPlayerPage() {
    addItemToHistory();
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => PlayerPage(
          fromMiniplayer: false,
          albumItem:
              Provider.of<AlbumInfoProvider>(context, listen: false).item,
        ),
      ),
    );
  }

  @override
  void dispose() {
    admob.dispose();
    super.dispose();
  }
}
