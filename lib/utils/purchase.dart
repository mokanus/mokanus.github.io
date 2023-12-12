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
  static bool entitlementIsActive = false;

  static Future<List<String>> activeSubs() async {
    var customerInfo = await Purchases.getCustomerInfo();
    return customerInfo.activeSubscriptions;
  }

  static Future<String?> latestExpirationDate() async {
    var customerInfo = await Purchases.getCustomerInfo();
    return customerInfo.latestExpirationDate;
  }

  static Future<void> configureSDK() async {
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

  static void checkOrInitUser() {
    if (appUserID == null || appUserID == "") {
      appUserID = const Uuid().v4();
    }
  }

  static String? get appUserID {
    var str = StorageUtil().getString('UserId');
    return str;
  }

  static set appUserID(String? value) {
    StorageUtil().setString('UserId', value!);
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








// CustomerInfo(
//   entitlements: 
//     EntitlementInfos(
//       all: {
//         月度会员: EntitlementInfo(identifier: 月度会员, isActive: true, willRenew: true, latestPurchaseDate: 2023-12-11T05:36:35Z, originalPurchaseDate: 2023-12-07T13:58:59Z, productIdentifier: tingfm_vip_month, isSandbox: true, ownershipType: OwnershipType.purchased, store: Store.appStore, periodType: PeriodType.normal, expirationDate: 2023-12-11T05:41:35Z, unsubscribeDetectedAt: null, billingIssueDetectedAt: null, verification: VerificationResult.notRequested),
//         年度会员: EntitlementInfo(identifier: 年度会员, isActive: false, willRenew: true, latestPurchaseDate: 2023-12-07T15:03:52Z, originalPurchaseDate: 2023-12-07T13:58:59Z, productIdentifier: tingfm_vip_year, isSandbox: true, ownershipType: OwnershipType.purchased, store: Store.appStore, periodType: PeriodType.normal, expirationDate: 2023-12-07T15:03:52Z, unsubscribeDetectedAt: null, billingIssueDetectedAt: null, verification: VerificationResult.notRequested), 
//         季度会员: EntitlementInfo(identifier: 季度会员, isActive: false, willRenew: true, latestPurchaseDate: 2023-12-09T05:54:01Z, originalPurchaseDate: 2023-12-07T13:58:59Z, productIdentifier: tingfm_vip_quarter, isSandbox: true, ownershipType: OwnershipType.purchased, store: Store.appStore, periodType: PeriodType.normal, expirationDate: 2023-12-09T06:09:01Z, unsubscribeDetectedAt: null, billingIssueDetectedAt: null, verification: VerificationResult.notRequested)},
//          active: {
//           月度会员: EntitlementInfo(
//             identifier: 月度会员, isActive: true, willRenew: true, latestPurchaseDate: 2023-12-11T05:36:35Z, originalPurchaseDate: 2023-12-07T13:58:59Z, productIdentifier: tingfm_vip_month, isSandbox: true, ownershipType: OwnershipType.purchased, store: Store.appStore, periodType: PeriodType.normal, expirationDate: 2023-12-11T05:41:35Z, unsubscribeDetectedAt: null, billingIssueDetectedAt: null, verification: VerificationResult.notRequested)},
//           verification: VerificationResult.notRequested
//     ), 
//     allPurchaseDates: {
//             tingfm_vip_month: 2023-12-11T05:36:35Z, 
//             tingfm_vip_quarter: 2023-12-09T05:54:01Z, 
//             tingfm_vip_year: 2023-12-07T15:03:52Z
//    },
//    activeSubscriptions: [tingfm_vip_month],
//    allPurchasedProductIdentifiers: [tingfm_vip_year, tingfm_vip_month, tingfm_vip_quarter],
//    nonSubscriptionTransactions: [], 
//    firstSeen: 2023-12-10T14:51:59Z, 
//    originalAppUserId: 29ef33d2-7857-4c32-a8a7-bd9cb4623530,
//    allExpirationDates: {
//                     tingfm_vip_quarter: 2023-12-09T06:09:01Z,
//                     tingfm_vip_month: 2023-12-11T05:41:35Z,
//                     tingfm_vip_year: 2023-12-07T15:03:52Z
//    }, 
//    requestDate: 2023-12-11T05:36:53Z, 
//    latestExpirationDate: 2023-12-11T05:41:35Z,
//    originalPurchaseDate: 2013-08-01T07:00:00Z, 
//    originalApplicationVersion: 1.0,
//    managementURL: https://apps.apple.com/account/subscriptions
   
//    )
