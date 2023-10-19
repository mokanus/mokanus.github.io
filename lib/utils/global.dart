import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:tingfm/utils/timer.dart';

/// 全局配置
class Global {
  static bool isFirstOpen = false;
  static bool isOfflineLogin = false;
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");

  static Future init() async {
    Timers.startTimers();
  }

  static void logEvent(name, params) async {
    await FirebaseAnalytics.instance.logEvent(
      name: name,
      parameters: params,
    );
  }

  static bool get logined => FirebaseAuth.instance.currentUser != null;

  static const String ossPre = 'https://www.chiyustudio.com/data/';
  static const String ossBannerPre = 'https://www.chiyustudio.com/banners/';

  static bool isLightTheme = true;
  static bool isTurnOnVibration = true;

  static Logger logger = Logger();
}
