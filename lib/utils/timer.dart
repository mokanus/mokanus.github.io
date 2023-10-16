import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tingfm/services/audio_service.dart';
import 'package:tingfm/utils/global.dart';
import 'package:tingfm/values/hive_box.dart';
import 'dart:io' show Platform;

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
      (Timer t) => storagePlayedData(),
    );

    if (Platform.isIOS) {
      Timer.periodic(
        const Duration(seconds: 1),
        (Timer t) => unlockNext(),
      );
    }

    // Timer.periodic(const Duration(seconds: 5), (Timer t) {
    //   if (Global.isVip) {
    //     if (DateTime.now()
    //         .isAfter(Global.becameVipTime.add(const Duration(minutes: 30)))) {
    //       Global.isVip = false;
    //       var audioHandler = GetIt.I<AudioPlayerHandler>();
    //       audioHandler.queue.value.clear();
    //       audioHandler.stop();
    //     }
    //   }
    // });
  }

  ///保存当前的播放进度
  static void storagePlayedData() async {
    var audioHandler = GetIt.I<AudioPlayerHandler>();
    if (audioHandler.playbackState.value.playing) {
      var box = await Hive.openBox(HiveBoxes.albumMetaDB);
      var meta = audioHandler.albumMeta;
      await box.put('album_${meta.album}', meta.toJson());
    }
  }

  static Map<String, bool> readyUnlocked = <String, bool>{};

  static void clearReadyClockedCache() {
    readyUnlocked.clear();
  }

  static void unlockNext() async {
    try {
      var audioHandler = GetIt.I<AudioPlayerHandler>();
      if (audioHandler.playbackState.value.playing) {
        var index = audioHandler.albumMeta.index + 1;

        var key = '${audioHandler.albumMeta.album}$index';
        var unlocked = readyUnlocked[key];
        if (unlocked != null) {
          return;
        }

        var mediaItem = await audioHandler.getMediaItem(index.toString());
        if (mediaItem != null) {
          var url = mediaItem.extras!['url'].toString();
          if (url.endsWith('-end')) {
            mediaItem.extras!['url'] =
                url.substring(0, url.toString().length - 4);
          }
          await audioHandler.updateMediaItem(mediaItem);
          readyUnlocked[key] = true;
        }
      }
    } on Exception {
      Global.logger.e('RewardedAd failed to load');
    }
  }
}
