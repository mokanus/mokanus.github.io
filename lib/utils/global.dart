import 'package:logger/logger.dart';
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
    ///
    if (isRelease) {
      //   await FlUMeng().init(
      //       preInit: true,
      //       androidAppKey: '63eb01e8ba6a5259c40200e3',
      //       iosAppKey: '63eadba9ba6a5259c401db43',
      //       channel: 'Google Play');

      //   /// 注册友盟 统计 性能检测
      //   await FlUMeng().init(
      //       androidAppKey: '63eb01e8ba6a5259c40200e3',
      //       iosAppKey: '63eadba9ba6a5259c401db43',
      //       channel: 'Google Play');
      // }
    }
  }

  static Future<void> initAds() async {
    // MobileAds.instance.initialize();
  }

  static void setVip() {
    isVip = true;
    becameVipTime = DateTime.now();
  }

  static const String ossPre =
      'https://tingfm-gz-1300862581.cos.ap-guangzhou.myqcloud.com/data/';

  static bool isLightTheme = true;
  static bool isTurnOnVibration = true;
  static bool isVip = false;
  static DateTime becameVipTime = DateTime.now();

  static Logger logger = Logger();
}
