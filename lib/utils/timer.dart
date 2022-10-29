///本类是自定义的定时器工具类
///
///
class Timers {
  ///启动定时器任务
  static void startTimers() {
    startStoragePlayerDataTimer();
  }

  ///保存当前的播放进度
  static void storagePlayedData() async {
    // var audio =
    //     Global.player.sequenceState!.currentSource?.tag as AudioMetadata;

    // await StorageUtil().setJSON(
    //     'STORAGE_ALBUMN_PLAYED_${audio.album}',
    //     AudioPlayedSavedMeta(
    //             playedDurationHour: Global.player.position.inHours,
    //             playedDurationMinu: Global.player.position.inMinutes,
    //             playedDurationSecond: Global.player.position.inSeconds,
    //             playedIndex: Global.player.currentIndex as int,
    //             playedItemName: audio.title)
    //         .toJson());
  }

  ///开启自动存储的Timer
  static void startStoragePlayerDataTimer() {
    // Timer.periodic(
    //     const Duration(seconds: 5),
    //     (Timer t) => {
    //           if (Global.player.playing == true)
    //             {
    //               storagePlayedData(),
    //             },
    //         });
  }
}
