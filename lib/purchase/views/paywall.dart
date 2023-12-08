import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tingfm/pages/privacy/privacy.dart';
import 'package:tingfm/pages/privacy/user_privacy.dart';
import 'package:tingfm/purchase/components/native_dialog.dart';
import 'package:tingfm/purchase/constant.dart';
import 'package:tingfm/purchase/model/styles.dart';
import 'package:tingfm/utils/global.dart';
import 'package:tingfm/utils/router.dart';

class Paywall extends StatefulWidget {
  final Offering offering;

  const Paywall({Key? key, required this.offering}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PaywallState createState() => _PaywallState();
}

class _PaywallState extends State<Paywall> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Wrap(
          children: <Widget>[
            Container(
              height: 70.0,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: kColorBar,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(5.0))),
              child:
                  const Center(child: Text('听书铺子fm', style: kTitleTextStyle)),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  '听书铺子fm',
                  style: kDescriptionTextStyle,
                ),
              ),
            ),
            ListView.builder(
              itemCount: widget.offering.availablePackages.length,
              itemBuilder: (BuildContext context, int index) {
                var myProductList = widget.offering.availablePackages;
                return Card(
                  color: Colors.black,
                  child: ListTile(
                    title: Text(
                      myProductList[index].storeProduct.title,
                      style: kTitleTextStyle,
                    ),
                    subtitle: Text(
                      myProductList[index].storeProduct.description,
                      style: kDescriptionTextStyle.copyWith(
                          fontSize: kFontSizeSuperSmall),
                    ),
                    trailing: Text(
                        myProductList[index].storeProduct.priceString,
                        style: kTitleTextStyle),
                    onTap: () async {
                      setState(() {});
                      try {
                        CustomerInfo customerInfo =
                            await Purchases.purchasePackage(
                                myProductList[index]);
                        EntitlementInfo? entitlement =
                            customerInfo.entitlements.all[entitlementID];
                        Global.entitlementIsActive =
                            entitlement?.isActive ?? false;
                      } catch (e) {
                        print(e);
                      }
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    },
                  ),
                );
              },
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 5, bottom: 5, left: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => {
                      AppRouter.pushPage(context, const UserPrivacyPage()),
                    },
                    child: const Text(
                      "服务条款",
                      style: kMinDescriptionTextStyle,
                    ),
                  ),
                  const Text(
                    "  |  ",
                    style: kMinDescriptionTextStyle,
                  ),
                  TextButton(
                    onPressed: () => {
                      AppRouter.pushPage(context, const PrivacyPage()),
                    },
                    child: const Text(
                      "隐私政策",
                      style: kMinDescriptionTextStyle,
                    ),
                  ),
                  const Text(
                    "  |  ",
                    style: kMinDescriptionTextStyle,
                  ),
                  TextButton(
                    onPressed: () => {restore()},
                    child: const Text(
                      "恢复购买",
                      style: kMinDescriptionTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 16.0, right: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  "当您订阅app后，您的iTunes 账户将扣除您确认购买时的相应费用，您可通过前往iTunes账号设置里，取消订阅，必须在当前有效期结束前24小时禁用。否则将自动续费，我们将在当前有效期结束前24小时内向您的账号收取续订费用，订阅款项将自动从您的iTunes账户扣除。请注意：推介促销优惠期的任何未使用部分，将在您购买其他订阅时失效。",
                  style: TextStyle(
                    color: kColorText,
                    fontWeight: FontWeight.normal,
                    fontSize: 8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  restore() async {
    /*
      How to login and identify your users with the Purchases SDK.

      Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
    */
    try {
      await Purchases.restorePurchases();
      Global.appUserID = await Purchases.appUserID;
    } on PlatformException catch (e) {
      // ignore: use_build_context_synchronously
      await showDialog(
          context: context,
          builder: (BuildContext context) => ShowDialogToDismiss(
              title: "Error",
              content: e.message ?? "Unknown error",
              buttonText: 'OK'));
    }
  }
}
