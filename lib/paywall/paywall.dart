// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tingfm/pages/privacy/privacy.dart';
import 'package:tingfm/pages/privacy/user_privacy.dart';
import 'package:tingfm/theme/theme_config.dart';
import 'package:tingfm/utils/constant.dart';
import 'package:tingfm/utils/purchase.dart';
import 'package:tingfm/utils/router.dart';

class Paywall extends StatefulWidget {
  final Offering offering;

  const Paywall({Key? key, required this.offering}) : super(key: key);

  @override
  PaywallState createState() => PaywallState();
}

class PaywallState extends State<Paywall> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0)),
              color: Color.fromARGB(255, 234, 78, 94),
            ),
            height: 60,
            width: ScreenUtil().screenWidth,
            child: const Text(
              "听书铺子fm 会员订阅",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          const Divider(
            height: 1,
          ),
          Container(
            color: const Color.fromARGB(255, 246, 246, 246),
            alignment: Alignment.center,
            padding: const EdgeInsets.only(
                top: 30, bottom: 5, left: 16.0, right: 16.0),
            child: ListView.builder(
              itemCount: widget.offering.availablePackages.length,
              itemBuilder: (BuildContext context, int index) {
                var myProductList = widget.offering.availablePackages;
                return Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    title: Text(
                      myProductList[index].storeProduct.title,
                      style: ThemeConfig.kTitleTextStyle,
                    ),
                    subtitle: Text(
                      myProductList[index].storeProduct.description,
                      style: ThemeConfig.kDescriptionTextStyle
                          .copyWith(fontSize: ThemeConfig.kFontSizeSuperSmall),
                    ),
                    trailing: Text(
                        myProductList[index].storeProduct.priceString,
                        style: ThemeConfig.kTitleTextStyle),
                    onTap: () async {
                      setState(() {});
                      try {
                        showLoadingDialog();
                        CustomerInfo customerInfo =
                            await Purchases.purchasePackage(
                                myProductList[index]);
                        EntitlementInfo? entitlement =
                            customerInfo.entitlements.all[entitlementID];
                        PurchaseUtil.entitlementIsActive =
                            entitlement?.isActive ?? false;
                      } catch (e) {
                        print(e);
                      }
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
            ),
          ),
          const Divider(
            height: 1,
          ),
          Container(
            color: const Color.fromARGB(255, 246, 246, 246),
            alignment: Alignment.center,
            padding: const EdgeInsets.only(
                top: 5, bottom: 5, left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => {
                    AppRouter.pushPage(context, const UserPrivacyPage()),
                  },
                  child: Text(
                    "服务条款",
                    style: ThemeConfig.kMinDescriptionTextStyle,
                  ),
                ),
                Text(
                  "  |  ",
                  style: ThemeConfig.kMinDescriptionTextStyle,
                ),
                TextButton(
                  onPressed: () => {
                    AppRouter.pushPage(context, const PrivacyPage()),
                  },
                  child: Text(
                    "隐私政策",
                    style: ThemeConfig.kMinDescriptionTextStyle,
                  ),
                ),
                Text(
                  "  |  ",
                  style: ThemeConfig.kMinDescriptionTextStyle,
                ),
                TextButton(
                  onPressed: () => {restore()},
                  child: Text(
                    "恢复购买",
                    style: ThemeConfig.kMinDescriptionTextStyle,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 246, 246, 246),
            padding: const EdgeInsets.only(
                top: 0, bottom: 32, left: 16.0, right: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                "当您订阅app后，您的iTunes 账户将扣除您确认购买时的相应费用，您可通过前往iTunes账号设置里，取消订阅，必须在当前有效期结束前24小时禁用。否则将自动续费，我们将在当前有效期结束前24小时内向您的账号收取续订费用，订阅款项将自动从您的iTunes账户扣除。请注意：推介促销优惠期的任何未使用部分，将在您购买其他订阅时失效。",
                style: TextStyle(
                  color: ThemeConfig.kColorText,
                  fontWeight: FontWeight.normal,
                  fontSize: 8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// 显示加载中弹窗
  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // 防止用户点击弹窗外部关闭
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/jsons/lottie_a.json',
                fit: BoxFit.contain,
                width: 100,
                height: 100,
              ),
              const Text(
                "处理中...",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  restore() async {
    try {
      await Purchases.restorePurchases();
      PurchaseUtil.appUserID = await Purchases.appUserID;
    } on PlatformException catch (e) {
      // ignore: use_build_context_synchronously
      // await showDialog(
      //   context: context,
      //   builder: (BuildContext context) => ShowDialogToDismiss(
      //       title: "Error",
      //       content: e.message ?? "Unknown error",
      //       buttonText: 'OK'),
      // );
    }
  }
}
