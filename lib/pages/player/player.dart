import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:ui' as ui;
import 'package:tingfm/pages/player/common.dart';
import 'package:tingfm/services/audio_service.dart';

class PlayerPage extends StatefulWidget {
  final bool fromMiniplayer;
  final String album;

  const PlayerPage({
    super.key,
    required this.fromMiniplayer,
    required this.album,
  });

  @override
  PlayerPageState createState() => PlayerPageState();
}

class PlayerPageState extends State<PlayerPage> with WidgetsBindingObserver {
  final AudioPlayerHandler audioHandler = GetIt.I<AudioPlayerHandler>();
  final PanelController panelController = PanelController();
  List<MediaItem> globalQueue = [];
  var isPanelOpened = false;
  @override
  void initState() {
    super.initState();
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));

    if (!widget.fromMiniplayer) {
      if (!Platform.isAndroid) {
        // Don't know why but it fixes the playback issue with iOS Side
        audioHandler.stop();
      }
      updateNplay();
    }
  }

  Future<void> updateNplay() async {
    var globalQueue = await MockItems();
    await audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    await audioHandler.updateQueue(globalQueue);
    await audioHandler.skipToQueueItem(0);
    audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
    await audioHandler.play();
  }

  Future<List<MediaItem>> MockItems() async {
    List<MediaItem> globalQueue = <MediaItem>[];

    for (var i = 1; i <= 3; i++) {
      var num = "";
      if (i < 10) {
        num = "00$i";
      } else if (i <= 99) {
        num = "0$i";
      } else {
        num = i.toString();
      }

      globalQueue.add(MediaItem(
          id: i.toString(),
          title: "水浒传$num集",
          album: "水浒传",
          artist: "田连元",
          duration: const Duration(seconds: 1800),
          artUri: Uri.parse(
              "https://tingfm-gz-1300862581.cos.ap-guangzhou.myqcloud.com/水浒传·田连元|田连元/水浒传·田连元.png"),
          extras: {
            'url':
                'https://tingfm-gz-1300862581.cos.ap-guangzhou.myqcloud.com/水浒传·田连元|田连元/水浒传$num集.aac',
          }));
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
        child: StreamBuilder<MediaItem?>(
            stream: audioHandler.mediaItem,
            builder: (context, snapshot) {
              final MediaItem? metadata = snapshot.data;
              if (metadata == null) {
                return const SizedBox();
              }
              return Scaffold(
                  resizeToAvoidBottomInset: false,
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
                  ),
                  body: LayoutBuilder(builder: (
                    BuildContext context,
                    BoxConstraints constraints,
                  ) {
                    return SafeArea(
                      child: Stack(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: SizedBox.square(
                                    dimension: constraints.maxWidth * 0.7,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      errorWidget:
                                          (BuildContext context, _, __) =>
                                              const Image(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          'assets/images/cover.jpg',
                                        ),
                                      ),
                                      placeholder: (BuildContext context, _) =>
                                          const Image(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          'assets/images/cover.jpg',
                                        ),
                                      ),
                                      imageUrl: metadata.artUri.toString(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      ScreenUtil().setWidth(200),
                                      ScreenUtil().setHeight(10),
                                      ScreenUtil().setWidth(200),
                                      ScreenUtil().setHeight(20)),
                                  child: Text(metadata.album.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      ScreenUtil().setWidth(200),
                                      ScreenUtil().setHeight(5),
                                      ScreenUtil().setWidth(200),
                                      ScreenUtil().setHeight(10)),
                                  child: Text(metadata.title),
                                ),
                              ],
                            ),

                            // 控件
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  ScreenUtil().setWidth(20),
                                  ScreenUtil().setHeight(5),
                                  ScreenUtil().setWidth(20),
                                  ScreenUtil().setHeight(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  StreamBuilder<AudioServiceRepeatMode>(
                                    stream: audioHandler.playbackState
                                        .map((state) => state.repeatMode)
                                        .distinct(),
                                    builder: (context, snapshot) {
                                      final repeatMode = snapshot.data ??
                                          AudioServiceRepeatMode.none;
                                      const icons = [
                                        Icon(Icons.repeat, color: Colors.grey),
                                        Icon(Icons.repeat,
                                            color: Colors.orange),
                                        Icon(Icons.repeat_one,
                                            color: Colors.orange),
                                      ];
                                      const cycleModes = [
                                        AudioServiceRepeatMode.none,
                                        AudioServiceRepeatMode.all,
                                        AudioServiceRepeatMode.one,
                                      ];
                                      final index =
                                          cycleModes.indexOf(repeatMode);
                                      return IconButton(
                                        icon: icons[index],
                                        onPressed: () async {
                                          await audioHandler.setRepeatMode(
                                            cycleModes[(cycleModes
                                                        .indexOf(repeatMode) +
                                                    1) %
                                                cycleModes.length],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  StreamBuilder<bool>(
                                    stream: audioHandler.playbackState
                                        .map(
                                          (state) =>
                                              state.shuffleMode ==
                                              AudioServiceShuffleMode.all,
                                        )
                                        .distinct(),
                                    builder: (context, snapshot) {
                                      final shuffleModeEnabled =
                                          snapshot.data ?? false;
                                      return IconButton(
                                        icon: shuffleModeEnabled
                                            ? const Icon(Icons.shuffle,
                                                color: Colors.orange)
                                            : const Icon(Icons.shuffle,
                                                color: Colors.grey),
                                        onPressed: () async {
                                          final enable = !shuffleModeEnabled;
                                          await audioHandler.setShuffleMode(
                                            enable
                                                ? AudioServiceShuffleMode.all
                                                : AudioServiceShuffleMode.none,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  StreamBuilder<double>(
                                    stream: audioHandler.speed,
                                    builder: (context, snapshot) => IconButton(
                                      icon: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Positioned(
                                              top: -8.0,
                                              right: -8.0,
                                              child: Text(
                                                "${snapshot.data?.toStringAsFixed(1)}x",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 8,
                                                ),
                                              ),
                                            ),
                                            const Positioned(
                                              child: Icon(Icons.speed_rounded),
                                            ),
                                          ]),
                                      onPressed: () {
                                        showSliderDialog(
                                          context: context,
                                          title: "播放速度",
                                          divisions: 3,
                                          min: 0.5,
                                          max: 2.0,
                                          value: audioHandler.speed.value,
                                          stream: audioHandler.speed,
                                          onChanged: audioHandler.setSpeed,
                                        );
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.timer),
                                    onPressed: () {
                                      showSliderDialog(
                                        context: context,
                                        title: "定时关闭",
                                        divisions: 10,
                                        min: 0.0,
                                        max: 1.0,
                                        value: audioHandler.volume.value,
                                        stream: audioHandler.volume,
                                        onChanged: audioHandler.setVolume,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  ScreenUtil().setWidth(20),
                                  ScreenUtil().setHeight(5),
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
                                      bufferedPosition:
                                          positionData.bufferedPosition,
                                      onChangeEnd: (newPosition) {
                                        audioHandler.seek(newPosition);
                                      },
                                    );
                                  }),
                            ),
                            Expanded(
                              child: PlayerContros(audioHandler),
                            ),

                            // Up Next with blur background
                          ],
                        ),
                        Positioned(
                          child: SlidingUpPanel(
                            minHeight: ScreenUtil().setHeight(100),
                            maxHeight: constraints.maxHeight * 0.75,
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            backdropEnabled: true,
                            boxShadow: const [],
                            backdropOpacity: 0.01,
                            color: const Color.fromARGB(255, 245, 245, 245),
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
                                          Colors.black,
                                          Colors.black,
                                          Colors.black,
                                          Color.fromARGB(255, 255, 255, 255),
                                          Color.fromARGB(255, 255, 255, 255),
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
                              onVerticalDragUpdate:
                                  (DragUpdateDetails details) {
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
                                          color: const Color.fromARGB(
                                              180, 0, 0, 0),
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                        )
                      ]),
                    );
                  }));
            }));
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

// 播放暂停 - 上下一曲
class PlayerContros extends StatelessWidget {
  final AudioPlayerHandler audioHandler;

  const PlayerContros(this.audioHandler, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<QueueState?>(
            stream: audioHandler.queueState,
            builder: (context, snapshot) {
              final queueState = snapshot.data;
              return IconButton(
                splashRadius: 1,
                icon: const Icon(
                  Icons.skip_previous_rounded,
                  size: 32,
                ),
                onPressed: queueState?.hasPrevious ?? true
                    ? audioHandler.skipToPrevious
                    : null,
              );
            }),
        StreamBuilder<PlaybackState>(
          stream: audioHandler.playbackState,
          builder: (context, snapshot) {
            final playbackState = snapshot.data;
            final processingState = playbackState?.processingState;
            final playing = playbackState?.playing ?? true;
            if (processingState == AudioProcessingState.loading ||
                processingState == AudioProcessingState.buffering &&
                    playing == false) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(
                  color: Color.fromARGB(255, 234, 78, 94),
                  strokeWidth: 4.0,
                ),
              );
            } else if (playing != true) {
              return IconButton(
                splashRadius: 1,
                icon: const Icon(Icons.play_circle_fill_rounded),
                iconSize: 90.0,
                onPressed: audioHandler.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                splashRadius: 1,
                icon: const Icon(Icons.pause_circle_rounded),
                iconSize: 90.0,
                onPressed: audioHandler.pause,
              );
            } else {
              return IconButton(
                splashRadius: 1,
                icon: const Icon(Icons.replay),
                iconSize: 90.0,
                onPressed: () => audioHandler.pause,
              );
            }
          },
        ),
        StreamBuilder<QueueState?>(
            stream: audioHandler.queueState,
            builder: (context, snapshot) {
              final queueState = snapshot.data;
              return IconButton(
                splashRadius: 1,
                icon: const Icon(
                  Icons.skip_next_rounded,
                  size: 32,
                ),
                onPressed: queueState?.hasNext ?? true
                    ? audioHandler.skipToNext
                    : null,
              );
            }),
      ],
    );
  }
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => SizedBox(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: const TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

T? ambiguate<T>(T? value) => value;

class NowPlayingStream extends StatelessWidget {
  final AudioPlayerHandler audioHandler;
  final ScrollController? scrollController;
  final bool head;
  final double headHeight;

  const NowPlayingStream({
    super.key,
    required this.audioHandler,
    this.scrollController,
    this.head = false,
    this.headHeight = 50,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QueueState>(
      stream: audioHandler.queueState,
      builder: (context, snapshot) {
        final queueState = snapshot.data ?? QueueState.empty;
        final queue = queueState.queue;

        return ReorderableListView.builder(
          header: SizedBox(
            height: head ? headHeight : 0,
          ),
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex--;
            }
            audioHandler.moveQueueItem(oldIndex, newIndex);
          },
          scrollController: scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 10),
          shrinkWrap: true,
          itemCount: queue.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: ValueKey(queue[index].id),
              direction: index == queueState.queueIndex
                  ? DismissDirection.none
                  : DismissDirection.horizontal,
              onDismissed: (dir) {
                audioHandler.removeQueueItemAt(index);
              },
              child: ListTileTheme(
                selectedColor: Theme.of(context).colorScheme.secondary,
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.only(left: 16.0, right: 10.0),
                  selected: index == queueState.queueIndex,
                  trailing: index == queueState.queueIndex
                      ? IconButton(
                          icon: const Icon(
                            Icons.bar_chart_rounded,
                          ),
                          tooltip: "播放中",
                          onPressed: () {},
                        )
                      : const SizedBox(),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Card(
                        elevation: 0.1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: (queue[index].artUri == null)
                            ? const SizedBox.square(
                                dimension: 50,
                                child: Image(
                                  image: AssetImage('assets/images/cover.jpg'),
                                ),
                              )
                            : SizedBox.square(
                                dimension: 50,
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  errorWidget: (BuildContext context, _, __) =>
                                      const Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      'assets/images/cover.jpg',
                                    ),
                                  ),
                                  placeholder: (BuildContext context, _) =>
                                      const Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      'assets/images/cover.jpg',
                                    ),
                                  ),
                                  imageUrl: queue[index].artUri.toString(),
                                ),
                              ),
                      ),
                    ],
                  ),
                  title: Text(
                    queue[index].title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: index == queueState.queueIndex
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    queue[index].artist!,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    audioHandler.skipToQueueItem(index);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
