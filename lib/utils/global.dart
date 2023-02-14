import 'package:tingfm/utils/timer.dart';

/// 全局配置
class Global {
  static bool isFirstOpen = false;
  static bool isOfflineLogin = false;
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");

  static Future init() async {
    Timers.startTimers();
    await initUmeng();
  }

  static Future<void> initUmeng() async {
    /// 务必先预初始化 随后调用自己的 用户授权协议 之后再进行正常初始化
    // await FlUMeng().init(
    //     preInit: true,
    //     androidAppKey: '63eb01e8ba6a5259c40200e3',
    //     iosAppKey: '63eadba9ba6a5259c401db43',
    //     channel: 'Umeng');
  }

  static const String ossPre = 'http://www.chiyustudio.com/tingfm/';

  static bool isLightTheme = true;
  static bool isTurnOnVibration = true;
}
