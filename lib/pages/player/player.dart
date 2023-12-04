import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tingfm/entities/album.dart';
import 'package:tingfm/pages/player/extras.dart';
import 'package:tingfm/pages/player/seekbar.dart';
import 'package:tingfm/providers/album_info.dart';
import 'package:tingfm/services/audio_service.dart';
import 'package:tingfm/utils/global.dart';
import 'package:tingfm/utils/timer.dart';
import 'package:tingfm/widgets/image.dart';

import 'contros.dart';
import 'panel.dart';

// ignore: must_be_immutable
class PlayerPage extends StatefulWidget {
  final bool fromMiniplayer;
  AlbumItem? albumItem;
  int? skipIndex;

  PlayerPage(
      {super.key,
      required this.fromMiniplayer,
      this.albumItem,
      this.skipIndex});

  @override
  PlayerPageState createState() => PlayerPageState();
}

class PlayerPageState extends State<PlayerPage> with WidgetsBindingObserver {
  final AudioPlayerHandler audioHandler = GetIt.I<AudioPlayerHandler>();
  final PanelController panelController = PanelController();
  var isPanelOpened = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));

    if (widget.fromMiniplayer) {
      widget.albumItem =
          Provider.of<AlbumInfoProvider>(context, listen: false).item;

      if (audioHandler.mediaItem.hasValue) {
        audioHandler.play();
      }
    } else {
      setState(() {
        audioHandler.stop();
        updateNplay(widget.skipIndex);
      });
    }
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> updateNplay(int? skipToIndex) async {
    if (!widget.fromMiniplayer) {
      var globalQueue = fillAudioItems(widget.albumItem);
      await audioHandler.updateQueue(globalQueue);
      await audioHandler.skipToQueueItem(skipToIndex!);
      await audioHandler.play();
    }
  }

  List<MediaItem> fillAudioItems(AlbumItem? album) {
    List<MediaItem> globalQueue = <MediaItem>[];
    if (album != null) {
      for (var i = 0; i < album.mediaItems.length; i++) {
        globalQueue.add(album.mediaItem(i));
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
          return SafeArea(
            child: LayoutBuilder(builder: (
              BuildContext context,
              BoxConstraints constraints,
            ) {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  elevation: 0,
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(Icons.expand_more_rounded),
                    tooltip: "返回",
                    color: Colors.grey,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    widget.albumItem!.album,
                    style: const TextStyle(
                      fontFamily: "Avenir",
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  actions: [
                    GestureDetector(
                        child: Icon(
                          Ionicons.link_outline,
                          color: const Color.fromARGB(255, 234, 78, 94),
                          size: ScreenUtil().setSp(84),
                        ),
                        onTap: () {}),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                body: Stack(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(200),
                            ScreenUtil().setHeight(50),
                            ScreenUtil().setWidth(200),
                            ScreenUtil().setHeight(50)),
                        child: imageCached(
                          mediaItem.artUri.toString(),
                          '${mediaItem.album}·${mediaItem.artist}',
                          width: ScreenUtil().setWidth(574),
                          height: ScreenUtil().setWidth(574),
                        ),
                      ),
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
                            fontSize: ScreenUtil().setSp(45),
                            color: Colors.black.withOpacity(0.7),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // 播放器控制控件
                      ExtraBtns(audioHandler: audioHandler),

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
          );
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
              duration: positionData.duration,
              position: positionData.position,
              bufferedPosition: positionData.bufferedPosition,
              onChangeEnd: (newPosition) {
                audioHandler.seek(newPosition);
              },
            );
          }),
    );
  }

  void rewardCallback() {
    Global.logger.d("奖励回调");
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
        backdropColor: const Color.fromARGB(255, 245, 245, 245),
        controller: panelController,
        panelBuilder: (ScrollController scrollController) {
          return ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            child: NowPlayingStream(
              head: true,
              headHeight: 50,
              audioHandler: audioHandler,
              scrollController: scrollController,
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
            color: const Color.fromARGB(255, 245, 245, 245),
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
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      isPanelOpened ? "收缩列表" : "弹出列表",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.6),
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
