import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:tingfm/utils/timer.dart';

/// 全局配置
class Global {
  /// 是否第一次打开
  static bool isFirstOpen = false;

  /// 是否离线登录
  static bool isOfflineLogin = false;

  /// 应用状态,

  /// 是否 release
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");

  ///全局的播放对象
  static late AudioPlayer player;

  /// init
  static Future init() async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();

    JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );

    // 播放实例的初始化
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    player = AudioPlayer();

    ///开启定时器的任务
    Timers.startTimers();
  }

  static const String OSS_AUDIO_FILE_PRE = 'app-data/ting-fm/audios/';

  ///
  static const String OSS_AUDIO_ALBUMN_LIST_ADREE = 'app-data/ting-fm/configs/';

  ///专辑列表名类
  static const String OSS_AUDIO_CATEGORY_LIST_ADREE =
      'app-data/ting-fm/configs/专辑类型.json';

  static const String FILE_NAME_MARGE = '/';

  // ignore: non_constant_identifier_names
  static const String JSON_NAME_FILE_TILE = '.json';

  ///当前的主题颜色
  static bool isLightTheme = true;

  static bool isTurnOnVibration = true;

  static bool isVip = true;

  ///免费收听的个数
  static int freeItemNum = 5;

  ///插屏广告播放间隔
  static int insertAdsPlayGap = 90;
}
