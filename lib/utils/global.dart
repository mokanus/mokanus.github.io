import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logger/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tingfm/purchase/constant.dart';
import 'package:tingfm/purchase/store_config.dart';
import 'package:tingfm/utils/timer.dart';
import 'package:uuid/uuid.dart';
import 'storage.dart';

/// 全局配置
class Global {
  static bool isFirstOpen = false;
  static bool isOfflineLogin = false;
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");

  static Future init() async {
    checkOrInitUser();

    if (Platform.isIOS || Platform.isMacOS) {
      StoreConfig(
        store: Store.appStore,
        apiKey: appleApiKey,
      );
    } else if (Platform.isAndroid) {
      StoreConfig(
        store: Store.playStore,
        apiKey: googleApiKey,
      );
    }
    await _configureSDK();
    Timers.startTimers();
  }

  static checkOrInitUser() {
    if (appUserID == null || appUserID == "") {
      appUserID = const Uuid().v4();
    }
  }

  static Future<void> _configureSDK() async {
    // Enable debug logs before calling `configure`.
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration configuration;
    if (StoreConfig.isForAmazonAppstore()) {
      configuration = AmazonConfiguration(StoreConfig.instance.apiKey)
        ..appUserID = appUserID
        ..observerMode = false;
    } else {
      configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
        ..appUserID = appUserID
        ..observerMode = false;
    }
    await Purchases.configure(configuration);
  }

  static void logEvent(name, params) async {
    await FirebaseAnalytics.instance.logEvent(
      name: name,
      parameters: params,
    );
  }

  static bool entitlementIsActive = false;

  static stomerInfo() async {
    var isSubscribed = await Purchases.getCustomerInfo();
    print("---> customerInfo :${isSubscribed}");
    print("---> latestExpirationDate :${isSubscribed.latestExpirationDate}");
  }

  static String? get appUserID {
    var str = StorageUtil().getString('UserId');
    return str;
  }

  static set appUserID(String? value) {
    StorageUtil().setString('UserId', value!);
  }

  static const String ossPre = 'https://www.chiyustudio.com/data/';
  static const String ossBannerPre = 'https://www.chiyustudio.com/banners/';

  static bool isLightTheme = true;
  static bool isTurnOnVibration = true;

  static Logger logger = Logger();
}
