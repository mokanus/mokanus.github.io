import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tingfm/purchase/constant.dart';
import 'package:tingfm/purchase/store_config.dart';
import 'package:tingfm/utils/timer.dart';

/// 全局配置
class Global {
  static bool isFirstOpen = false;
  static bool isOfflineLogin = false;
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");

  static Future init() async {
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

  static Future<void> _configureSDK() async {
    // Enable debug logs before calling `configure`.
    await Purchases.setLogLevel(LogLevel.debug);

    /*
    - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids

    - observerMode is false, so Purchases will automatically handle finishing transactions. Read more about Observer Mode here: https://docs.revenuecat.com/docs/observer-mode
    */
    PurchasesConfiguration configuration;
    if (StoreConfig.isForAmazonAppstore()) {
      configuration = AmazonConfiguration(StoreConfig.instance.apiKey)
        ..appUserID = null
        ..observerMode = false;
    } else {
      configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
        ..appUserID = null
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
  static String appUserID = '';

  static bool get logined => FirebaseAuth.instance.currentUser != null;

  static const String ossPre = 'https://www.chiyustudio.com/data/';
  static const String ossBannerPre = 'https://www.chiyustudio.com/banners/';

  static bool isLightTheme = true;
  static bool isTurnOnVibration = true;

  static Logger logger = Logger();
}
