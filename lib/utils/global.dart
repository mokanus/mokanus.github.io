import 'package:tingfm/utils/timer.dart';

/// 全局配置
class Global {
  static bool isFirstOpen = false;
  static bool isOfflineLogin = false;
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");

  static Future init() async {
    Timers.startTimers();
  }

  static const String ossPre =
      'https://tingfm-gz-1300862581.cos.ap-guangzhou.myqcloud.com/tingfm/';

  static bool isLightTheme = true;
  static bool isTurnOnVibration = true;
}
