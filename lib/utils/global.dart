import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logger/logger.dart';
import 'package:tingfm/utils/purchase.dart';
import 'package:tingfm/utils/storage.dart';
import 'package:tingfm/utils/timer.dart';

/// 全局配置
class Global {
  static Future init() async {
    PurchaseUtil.checkOrInitUser();
    await PurchaseUtil.configureSDK();
    Timers.startTimers();
  }

  static void logEvent(name, params) async {
    await FirebaseAnalytics.instance.logEvent(
      name: name,
      parameters: params,
    );
  }

  static const String ossPre = 'https://www.chiyustudio.com/data/';
  static const String ossBannerPre = 'https://www.chiyustudio.com/banners/';

  static bool isLightTheme = true;
  static bool isTurnOnVibration = true;

  static Logger logger = Logger();

  static bool get isFirstQuest {
    return StorageUtil().getBool('isFirstOpen');
  }

  static set isFirstQuest(bool isFirst) {
    StorageUtil().setBool('isFirstOpen', true);
  }

  static bool isOfflineLogin = false;
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");
}
