import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tingfm/config/config.dart';
import 'package:tingfm/pages/player/common.dart';

class PlayerPage extends StatefulWidget {
  final bool fromMiniplayer;

  const PlayerPage({
    super.key,
    required this.fromMiniplayer,
  });

  @override
  PlayerPageState createState() => PlayerPageState();
}

class PlayerPageState extends State<PlayerPage> with WidgetsBindingObserver {
  final AudioPlayerHandler audioHandler = GetIt.I<AudioPlayerHandler>();
  List<MediaItem> globalQueue = [];

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
    await audioHandler.skipToQueueItem(4);
    audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
    await audioHandler.play();
  }

  Future<List<MediaItem>> MockItems() async {
    List<MediaItem> globalQueue = <MediaItem>[];

    for (var i = 1; i < 2; i++) {
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
          title: "隋唐演义$num集",
          album: "隋唐演义",
          artist: "田连元",
          duration: const Duration(minutes: 23, seconds: 20),
          artUri: Uri.parse(
              "https://www.chiyustudio.com:81/tingfm/隋唐演义·田连元|田连元/隋唐演义·田连元.png"),
          extras: {
            'url':
                'https://www.chiyustudio.com:81/tingfm/隋唐演义·田连元|田连元/隋唐演义$num集.aac',
          }));
    }
    return globalQueue;
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    super.dispose();
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
                  body: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  ScreenUtil().setWidth(200),
                                  ScreenUtil().setHeight(30),
                                  ScreenUtil().setWidth(200),
                                  ScreenUtil().setHeight(30)),
                              decoration: ShapeDecoration(
                                image: DecorationImage(
                                  //设置背景图片
                                  image: NetworkImage(
                                    metadata.artUri.toString(),
                                  ),
                                ),
                                //设置圆角
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(10)),
                              ),
                              height: ScreenUtil().setHeight(800),
                              width: ScreenUtil().setWidth(800),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  ScreenUtil().setWidth(200),
                                  ScreenUtil().setHeight(10),
                                  ScreenUtil().setWidth(200),
                                  ScreenUtil().setHeight(30)),
                              child: Text(metadata.album.toString(),
                                  style: Theme.of(context).textTheme.headline5),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  ScreenUtil().setWidth(200),
                                  ScreenUtil().setHeight(5),
                                  ScreenUtil().setWidth(200),
                                  ScreenUtil().setHeight(60)),
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
                              ScreenUtil().setHeight(20)),
                          child: Row(
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
                                    Icon(Icons.repeat, color: Colors.orange),
                                    Icon(Icons.repeat_one,
                                        color: Colors.orange),
                                  ];
                                  const cycleModes = [
                                    AudioServiceRepeatMode.none,
                                    AudioServiceRepeatMode.all,
                                    AudioServiceRepeatMode.one,
                                  ];
                                  final index = cycleModes.indexOf(repeatMode);
                                  return IconButton(
                                    icon: icons[index],
                                    onPressed: () async {
                                      await audioHandler.setRepeatMode(
                                        cycleModes[
                                            (cycleModes.indexOf(repeatMode) +
                                                    1) %
                                                cycleModes.length],
                                      );
                                    },
                                  );
                                },
                              ),
                              const Expanded(
                                child: SizedBox(),
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
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(20),
                              ScreenUtil().setHeight(5),
                              ScreenUtil().setWidth(20),
                              ScreenUtil().setHeight(20)),
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
                          child: ControlButtons(audioHandler),
                        ),
                      ],
                    ),
                  ));
            }));
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayerHandler audioHandler;

  const ControlButtons(this.audioHandler, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.volume_up_rounded),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "调整音量",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: audioHandler.volume.value,
              stream: audioHandler.volume,
              onChanged: audioHandler.setVolume,
            );
          },
        ),
        StreamBuilder<QueueState?>(
            stream: audioHandler.queueState,
            builder: (context, snapshot) {
              final queueState = snapshot.data;
              return IconButton(
                icon: const Icon(Icons.skip_previous_rounded),
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
                icon: const Icon(Icons.play_circle_fill_rounded),
                iconSize: 64.0,
                onPressed: audioHandler.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause_circle_rounded),
                iconSize: 64.0,
                onPressed: audioHandler.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 64.0,
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
                icon: const Icon(Icons.skip_next_rounded),
                onPressed: queueState?.hasNext ?? true
                    ? audioHandler.skipToNext
                    : null,
              );
            }),
        StreamBuilder<double>(
          stream: audioHandler.speed,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                value: audioHandler.speed.value,
                stream: audioHandler.speed,
                onChanged: audioHandler.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}

abstract class AudioPlayerHandler implements AudioHandler {
  Stream<QueueState> get queueState;
  Future<void> moveQueueItem(int currentIndex, int newIndex);
  ValueStream<double> get volume;
  Future<void> setVolume(double volume);
  ValueStream<double> get speed;
}

class QueueState {
  static const QueueState empty =
      QueueState([], 0, [], AudioServiceRepeatMode.none);

  final List<MediaItem> queue;
  final int? queueIndex;
  final List<int>? shuffleIndices;
  final AudioServiceRepeatMode repeatMode;

  const QueueState(
    this.queue,
    this.queueIndex,
    this.shuffleIndices,
    this.repeatMode,
  );

  bool get hasPrevious =>
      repeatMode != AudioServiceRepeatMode.none || (queueIndex ?? 0) > 0;
  bool get hasNext =>
      repeatMode != AudioServiceRepeatMode.none ||
      (queueIndex ?? 0) + 1 < queue.length;

  List<int> get indices =>
      shuffleIndices ?? List.generate(queue.length, (i) => i);
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  // TODO: Replace these two by ValueStream.
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
