import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tingfm/services/audio_service.dart';
import 'package:tingfm/values/hive_box.dart';

///本类是自定义的定时器工具类
///
///
class Timers {
  ///启动定时器任务
  static void startTimers() {
    startStoragePlayerDataTimer();
  }

  ///开启自动存储的Timer
  static void startStoragePlayerDataTimer() {
    Timer.periodic(
        const Duration(seconds: 5),
        (Timer t) => {
              storagePlayedData(),
            });

    Timer.periodic(
        const Duration(seconds: 2),
        (Timer t) => {
              unlockNext(),
            });
  }

  ///保存当前的播放进度
  static void storagePlayedData() async {
    var audioHandler = GetIt.I<AudioPlayerHandler>();
    if (audioHandler.playbackState.value.playing) {
      var box = await Hive.openBox(HiveBoxes.albumMetaDB);
      var meta = audioHandler.albumMeta;
      box.put('album_${meta.album}', meta.toJson());
    }
  }

  static void unlockNext() async {
    var audioHandler = GetIt.I<AudioPlayerHandler>();
    if (audioHandler.playbackState.value.playing) {
      var index = audioHandler.albumMeta.index + 1;
      var mediaItem = await audioHandler.getMediaItem(index.toString());
      if (mediaItem != null) {
        var url = mediaItem.extras!['url'].toString();
        if (url.endsWith('-end')) {
          mediaItem.extras!['url'] =
              url.substring(0, url.toString().length - 4);
        }
        await audioHandler.updateMediaItem(mediaItem);
      }
    }
  }
}
