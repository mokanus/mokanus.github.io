import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logger/logger.dart';
import 'package:tingfm/utils/storage.dart';
import 'package:tingfm/utils/timer.dart';

/// 全局配置
class Global {
  static Future init() async {
    Timers.startTimers();
  }

  static void logEvents(name, params) async {
    await FirebaseAnalytics.instance.logEvent(
      name: name,
      parameters: params,
    );
  }

  static void logEvent(name, data) async {
    var params = <String, dynamic>{};
    params[name] = data;
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

  static bool get firstQuestSuccessed {
    return StorageUtil().getBool('firstQuestSuccessed');
  }

  static set firstQuestSuccessed(bool finished) {
    StorageUtil().setBool('firstQuestSuccessed', true);
  }

  // 获取首次打开时间
  static DateTime get firstOpenTime {
    var jsonString = StorageUtil().getString('firstOpenTime');
    if (jsonString != null && jsonString != "") {
      DateTime dateTime = DateTime.parse(jsonString);
      return dateTime;
    } else {
      var now = DateTime.now();
      StorageUtil().setString('firstOpenTime', now.toIso8601String());
      return now;
    }
  }

  static bool isOfflineLogin = false;
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");
}
