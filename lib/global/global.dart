import 'package:flutter/material.dart';
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

  /// init
  static Future init() async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();

    ///开启定时器的任务
    Timers.startTimers();
  }

  static const String ossPre =
      'https://tingfm-gz-1300862581.cos.ap-guangzhou.myqcloud.com/tingfm/';

  static String curAlbum = "";

  ///当前的主题颜色
  static bool isLightTheme = true;

  static bool isTurnOnVibration = true;
}
