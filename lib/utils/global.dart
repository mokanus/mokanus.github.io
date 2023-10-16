import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:tingfm/utils/timer.dart';
import 'package:tingfm/values/hive_box.dart';

/// 全局配置
class Global {
  static bool isFirstOpen = false;
  static bool isOfflineLogin = false;
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");

  static User? user = null;

  static Future init() async {
    Timers.startTimers();
  }

  static void setVip() {
    isVip = true;
    becameVipTime = DateTime.now();
  }

  static const String ossPre =
      'https://tingfm-gz-1300862581.cos.ap-guangzhou.myqcloud.com/data/';

  static const String ossBannerPre =
      'https://tingfm-gz-1300862581.cos.ap-guangzhou.myqcloud.com/banners/';

  static bool isLightTheme = true;
  static bool isTurnOnVibration = true;
  static bool isVip = false;
  static DateTime becameVipTime = DateTime.now();

  static Logger logger = Logger();
}
