// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tingfm/theme/theme_config.dart';
import 'package:tingfm/utils/constant.dart';
import 'package:tingfm/paywall/paywall.dart';
import 'package:tingfm/utils/global.dart';
import 'package:tingfm/utils/storage.dart';
import 'package:uuid/uuid.dart';

class PurchaseUtil {
  // 是否是会员
  static bool entitlementIsActive = false;

  static void checkOrInitUser() {
    if (appUserID == null || appUserID == "") {
      appUserID = const Uuid().v4();
    }
  }

  static Future<void> configureSDK() async {
    PurchaseUtil.checkOrInitUser();

    if (Global.isRelease) {
      await Purchases.setLogLevel(LogLevel.error);
    } else {
      await Purchases.setLogLevel(LogLevel.debug);
    }

    if (Platform.isIOS || Platform.isMacOS) {
      PurchasesConfiguration configuration = PurchasesConfiguration(appleApiKey)
        ..appUserID = appUserID
        ..observerMode = false;
      await Purchases.configure(configuration);
    } else if (Platform.isAndroid) {
      PurchasesConfiguration configuration =
          PurchasesConfiguration(googleApiKey)
            ..appUserID = appUserID
            ..observerMode = false;
      await Purchases.configure(configuration);
    }

    initPlatformState();
  }

  static Future<void> initPlatformState() async {
    PurchaseUtil.appUserID = await Purchases.appUserID;

    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      PurchaseUtil.appUserID = await Purchases.appUserID;

      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      EntitlementInfo? entitlement =
          customerInfo.entitlements.all[entitlementID];
      PurchaseUtil.entitlementIsActive = entitlement?.isActive ?? false;
    });
  }

  static String? get appUserID {
    var str = StorageUtil().getString('UserId');
    return str;
  }

  static set appUserID(String? value) {
    StorageUtil().setString('UserId', value!);
  }

  static bool get isVip {
    return Global.firstOpenTime
            .add(const Duration(minutes: 30))
            .isAfter(DateTime.now()) ||
        entitlementIsActive == true;
  }

  static showSubcription(BuildContext context) async {
    // 需要检查一下是不是已经订阅
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();

    if (customerInfo.entitlements.all[entitlementID] != null &&
        customerInfo.entitlements.all[entitlementID]?.isActive == true) {
    } else {
      Offerings? offerings;
      try {
        offerings = await Purchases.getOfferings();
      } on PlatformException catch (e) {}

      if (offerings == null || offerings.current == null) {
        // offerings are empty, show a message to your user
      } else {
        await showModalBottomSheet(
          useRootNavigator: true,
          isDismissible: true,
          isScrollControlled: true,
          backgroundColor: ThemeConfig.kColorBackground,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
              return Paywall(
                offering: offerings!.current!,
              );
            });
          },
        );
      }
    }
  }
}
