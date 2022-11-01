import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tingfm/entities/album.dart';
import 'package:tingfm/global/global.dart';
import 'package:tingfm/helper/dominant_color.dart';
import 'package:tingfm/pages/player/widgets/player_btns.dart';
import 'dart:ui' as ui;
import 'package:tingfm/pages/player/widgets/seek_bar.dart';
import 'package:tingfm/providers/album_info.dart';
import 'package:tingfm/services/audio_service.dart';
import 'package:tingfm/widgets/image.dart';

import 'widgets/player_contro.dart';
import 'widgets/playing_stream.dart';

// ignore: must_be_immutable
class PlayerPage extends StatefulWidget {
  final bool fromMiniplayer;
  AlbumItem? albumItem;

  PlayerPage({super.key, required this.fromMiniplayer, this.albumItem}) {}

  @override
  PlayerPageState createState() => PlayerPageState();
}

class PlayerPageState extends State<PlayerPage> with WidgetsBindingObserver {
  final AudioPlayerHandler audioHandler = GetIt.I<AudioPlayerHandler>();
  final PanelController panelController = PanelController();
  var isPanelOpened = false;
  final ValueNotifier<List<Color?>?> gradientColor =
      ValueNotifier<List<Color?>?>(
          [const Color(0xfff5f9ff), const Color(0xfff5f9ff)]);
  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));

    if (widget.fromMiniplayer) {
      widget.albumItem =
          Provider.of<AlbumInfoProvider>(context, listen: false).item;
    } else {
      audioHandler.stop();
      updateNplay();
    }

    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> updateNplay() async {
    if (!widget.fromMiniplayer) {
      var globalQueue = mockItems(widget.albumItem);
      await audioHandler.updateQueue(globalQueue);
      await audioHandler.skipToQueueItem(0);
      await audioHandler.play();
    }
  }

  List<MediaItem> mockItems(AlbumItem? album) {
    List<MediaItem> globalQueue = <MediaItem>[];

    if (album != null) {
      if (Global.isRelease) {
        for (var i = 0; i < album.mediaItems.length; i++) {
          globalQueue.add(album.mediaItem(i));
        }
      } else {
        globalQueue.add(album.mediaItem(0));
      }
    }

    return globalQueue;
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        direction: DismissDirection.down,
        background: const ColoredBox(color: Colors.transparent),
        key: const Key('PlayerPage'),
        onDismissed: (direction) {
          Navigator.pop(context);
        },
        child: buildBody());
  }

  Widget buildBody() {
    return StreamBuilder<MediaItem?>(
        stream: audioHandler.mediaItem,
        builder: (context, snapshot) {
          MediaItem? mediaItem = snapshot.data;
          if (mediaItem == null) {
            return const SizedBox();
          }
          getColors(
            imageProvider: CachedNetworkImageProvider(
              mediaItem.artUri.toString(),
            ),
          ).then((value) => updateBackgroundColors(value));

          return ValueListenableBuilder(
              valueListenable: gradientColor,
              child: SafeArea(
                child: LayoutBuilder(builder: (
                  BuildContext context,
                  BoxConstraints constraints,
                ) {
                  return Scaffold(
                    resizeToAvoidBottomInset: false,
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      centerTitle: true,
                      leading: IconButton(
                        icon: const Icon(Icons.expand_more_rounded),
                        tooltip: "返回",
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      title: Text(
                        widget.albumItem!.album,
                        style: const TextStyle(
                          fontFamily: "Avenir",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    body: Stack(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          imageCached(mediaItem.artUri.toString(),
                              '${mediaItem.album}·${mediaItem.artist}',
                              width: ScreenUtil().setWidth(628),
                              height: ScreenUtil().setHeight(628),
                              margin: const EdgeInsets.all(15)),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                ScreenUtil().setWidth(200),
                                ScreenUtil().setHeight(20),
                                ScreenUtil().setWidth(200),
                                ScreenUtil().setHeight(120)),
                            child: Text(
                              "${mediaItem.artist} - ${mediaItem.title}",
                              style: TextStyle(
                                  fontFamily: "Avenir",
                                  fontSize: ScreenUtil().setSp(45)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // 播放器控制控件
                          PlayerBtns(audioHandler: audioHandler),

                          // 进度条控件
                          buildSeekBar(mediaItem),

                          // 播放控件
                          PlayerContros(audioHandler),
                        ],
                      ),
                      buildSliderPanel(constraints)
                    ]),
                  );
                }),
              ),
              builder:
                  (BuildContext context, List<Color?>? value, Widget? child) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          value?[0] ?? const Color(0xfff5f9ff),
                          value?[1] ?? const Color(0xfff5f9ff),
                        ]),
                  ),
                  child: child,
                );
              });
        });
  }

  Widget buildSeekBar(MediaItem metadata) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(20),
          ScreenUtil().setHeight(64),
          ScreenUtil().setWidth(20),
          ScreenUtil().setHeight(10)),
      child: StreamBuilder<PositionData>(
          stream: _positionDataStream,
          builder: (context, snapshot) {
            final positionData = snapshot.data ??
                PositionData(
                  Duration.zero,
                  Duration.zero,
                  metadata.duration ?? Duration.zero,
                );

            return SeekBar(
              duration: positionData.bufferedPosition,
              position: positionData.position,
              bufferedPosition: positionData.bufferedPosition,
              onChangeEnd: (newPosition) {
                audioHandler.seek(newPosition);
              },
            );
          }),
    );
  }

  void sleepTimer(int time) {
    audioHandler.customAction('sleepTimer', {'time': time});
  }

  Widget buildSliderPanel(BoxConstraints constraints) {
    return Positioned(
      child: SlidingUpPanel(
        minHeight: ScreenUtil().setHeight(100),
        maxHeight: constraints.maxHeight * 0.75,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        backdropEnabled: true,
        boxShadow: const [],
        backdropOpacity: 0.01,
        color: Colors.black.withOpacity(0.02),
        controller: panelController,
        panelBuilder: (ScrollController scrollController) {
          return ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: 1.0,
                sigmaY: 1.0,
              ),
              child: ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    end: Alignment.topCenter,
                    begin: Alignment.center,
                    colors: [
                      Colors.transparent,
                      Colors.black,
                      Colors.black,
                      Colors.black,
                      Colors.transparent,
                    ],
                  ).createShader(
                    Rect.fromLTRB(
                      0,
                      0,
                      rect.width,
                      rect.height,
                    ),
                  );
                },
                blendMode: BlendMode.dstIn,
                child: NowPlayingStream(
                  head: true,
                  headHeight: 50,
                  audioHandler: audioHandler,
                  scrollController: scrollController,
                ),
              ),
            ),
          );
        },
        header: GestureDetector(
          onTap: () {
            if (panelController.isPanelOpen) {
              panelController.close();
            } else {
              if (panelController.panelPosition > 0.9) {
                panelController.close();
              } else {
                panelController.open();
              }
            }
          },
          onVerticalDragUpdate: (DragUpdateDetails details) {
            if (details.delta.dy > 0.0) {
              panelController.animatePanelToPosition(0.0);
            }
          },
          child: Container(
            height: 50,
            width: constraints.maxWidth,
            color: Colors.transparent,
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      isPanelOpened ? "收缩列表" : "弹出列表",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color.fromARGB(100, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Divider(),
                  ),
                ),
              ],
            ),
          ),
        ),
        onPanelOpened: () {
          setState(() {
            isPanelOpened = true;
          });
        },
        onPanelClosed: () {
          setState(() {
            isPanelOpened = false;
          });
        },
      ),
    );
  }

  void updateBackgroundColors(List<Color?> value) {
    gradientColor.value = value;
    return;
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        AudioService.position,
        _bufferedPositionStream,
        _durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  Stream<Duration> get _bufferedPositionStream => audioHandler.playbackState
      .map((state) => state.bufferedPosition)
      .distinct();

  Stream<Duration?> get _durationStream =>
      audioHandler.mediaItem.map((item) => item?.duration).distinct();
}

T? ambiguate<T>(T? value) => value;
