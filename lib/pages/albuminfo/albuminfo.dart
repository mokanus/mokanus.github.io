// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:provider/provider.dart';
import 'package:tingfm/api/api_status.dart';
import 'package:tingfm/entities/album.dart';
import 'package:tingfm/entities/album_meta.dart';
import 'package:tingfm/pages/albuminfo/dialogcontinue.dart';
import 'package:tingfm/pages/player/player.dart';
import 'package:tingfm/providers/album_info.dart';
import 'package:tingfm/providers/favorite.dart';
import 'package:tingfm/providers/history.dart';
import 'package:tingfm/services/audio_service.dart';
import 'package:tingfm/theme/theme_config.dart';
import 'package:tingfm/utils/purchase.dart';
import 'package:tingfm/values/hive_box.dart';
import 'package:tingfm/values/hive_boxes/album_db.dart';
import 'package:tingfm/widgets/image.dart';
import 'package:tingfm/widgets/loading_widget.dart';
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
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<AlbumInfoProvider>(context, listen: false)
          .getAlbumInfo(context, widget.albumId),
    );

    WidgetsBinding.instance.addObserver(this);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(milliseconds: 500), () async {
        await showContinueDialog(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AlbumInfoProvider>(builder:
        (BuildContext context, AlbumInfoProvider provider, Widget? child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: const Text("专辑详情"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: provider.apiRequestStatus != APIRequestStatus.loaded
              ? const LoadingWidget()
              : Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        imageCached(
                          provider.item!.imageUrl(),
                          provider.item!.cachedKey(),
                          width: ScreenUtil().setWidth(320),
                          height: ScreenUtil().setWidth(320),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: ScreenUtil().setWidth(700),
                                child: Text(
                                  provider.item!.album,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: ScreenUtil().setSp(60),
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: "Avenir"),
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              Text(
                                "演播 : ${provider.item!.artist}",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(36),
                                    fontFamily: "Avenir"),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              Text(
                                "${provider.item!.listenTimes} 次收听 · ${provider.item!.loveCount} 次喜欢",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(36),
                                    fontFamily: "Avenir"),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: ScreenUtil().setHeight(134),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: ScreenUtil().setWidth(40),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.play_circle,
                                        color: Colors.redAccent,
                                        size: 30,
                                      ),
                                      onPressed: () => openPlayerPage(0),
                                    ),
                                    Text(
                                      "全部播放",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: ScreenUtil().setSp(44),
                                          fontFamily: "Avenir"),
                                    ),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(10),
                                    ),
                                    Text(" (共${provider.item!.count}章)",
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(32),
                                            fontFamily: "Avenir"))
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(bottom: 10),
                              shrinkWrap: true,
                              itemCount: Provider.of<AlbumInfoProvider>(context,
                                      listen: false)
                                  .item!
                                  .count,
                              itemBuilder: (context, index) {
                                return ListTileTheme(
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.only(
                                        left: 16.0, right: 10.0),
                                    leading: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        imageCached(
                                          Provider.of<AlbumInfoProvider>(
                                                  context,
                                                  listen: false)
                                              .item!
                                              .imageUrl(),
                                          Provider.of<AlbumInfoProvider>(
                                                  context,
                                                  listen: false)
                                              .item!
                                              .cachedKey(),
                                        ),
                                      ],
                                    ),
                                    title: Text(
                                      Provider.of<AlbumInfoProvider>(context,
                                              listen: false)
                                          .item!
                                          .mediaItems[index]
                                          .title
                                          .substring(
                                              0,
                                              Provider.of<AlbumInfoProvider>(
                                                          context,
                                                          listen: false)
                                                      .item!
                                                      .mediaItems[index]
                                                      .title
                                                      .length -
                                                  4),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Container(
                                          width: ScreenUtil().setWidth(80),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: const Border.fromBorderSide(
                                              BorderSide(
                                                  color: Colors.black45,
                                                  width: 0.3),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                          child: Text(
                                            "HD",
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(35),
                                                fontFamily: "Avenir"),
                                          ),
                                        ),
                                        SizedBox(
                                            width: ScreenUtil().setWidth(10)),
                                        Text(
                                          provider.item!.artist,
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(32),
                                              fontFamily: "Avenir"),
                                        ),
                                      ],
                                    ),
                                    onTap: () async {
                                      openPlayerPage(index);
                                    },
                                  ),
                                );
                              },
                            ),
                          )
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
      ShowSnackBar().showSnackBar(
        context,
        !deleted ? "${item.album} 已经加入喜欢列表啦" : "${item.album} 已经从喜欢列表移除啦",
      );
      await Provider.of<AlbumInfoProvider>(context, listen: false)
          .flushFavorateState();
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

  void openPlayerPage(int index) async {
    if (!PurchaseUtil.isVip) {
      PurchaseUtil.showSubcription(context);
      return;
    }
    addItemToHistory();
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => PlayerPage(
          fromMiniplayer: false,
          albumItem:
              Provider.of<AlbumInfoProvider>(context, listen: false).item,
          albumMeta: AlbumMeta(
              hour: 0, minu: 0, second: 0, index: index, album: "", title: ""),
        ),
      ),
    );
  }

  showContinueDialog(BuildContext context) async {
    var audioHandler = GetIt.I<AudioPlayerHandler>();
    if (audioHandler.playbackState.value.playing) {
      var meta = audioHandler.albumMeta;
      if (meta.album == widget.album) {
        return;
      }
    }

    var box = await Hive.openBox<AlbumItemDB>(HiveBoxes.hisotyDB);
    var historyItems = box.values.toList();
    var albumItemDB = AlbumItemDB(id: 0, album: "", artUri: "", artist: "");
    for (int i = 0; i < historyItems.length; i++) {
      if (historyItems[i].id == widget.albumId) {
        albumItemDB = historyItems[i];
        break;
      }
    }
    if (albumItemDB.id != 0) {
      var metaBox = await Hive.openBox(HiveBoxes.albumMetaDB);
      var metaData = metaBox.get('album_${albumItemDB.album}');
      if (metaData != null) {
        var mateDataInfo = AlbumMeta.fromJson(metaData.toString());
        await showModalBottomSheet(
          useRootNavigator: true,
          isDismissible: true,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
              return DialogContinue(
                  albumItem:
                      Provider.of<AlbumInfoProvider>(context, listen: false)
                          .item!,
                  albumMeta: mateDataInfo);
            });
          },
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
