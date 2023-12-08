import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/services.dart';
import 'package:tingfm/purchase/components/native_dialog.dart';
import 'package:tingfm/purchase/components/top_bar.dart';
import 'package:tingfm/purchase/model/styles.dart';
import 'package:tingfm/utils/global.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  _logIn(String newAppUserID) async {
    setState(() {
      _isLoading = true;
    });

    /*
      How to login and identify your users with the Purchases SDK.

      Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
    */

    try {
      await Purchases.logIn(newAppUserID);
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

    setState(() {
      _isLoading = false;
    });
  }

  _logOut() async {
    setState(() {
      _isLoading = true;
    });

    /*
      How to login and identify your users with the Purchases SDK.

      Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
    */

    try {
      await Purchases.logOut();
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

    setState(() {
      _isLoading = false;
    });
  }

  _restore() async {
    setState(() {
      _isLoading = true;
    });

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

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TopBar(
        text: "User",
        style: kTitleTextStyle,
        uniqueHeroTag: 'user',
        child: Scaffold(
          backgroundColor: kColorBackground,
          body: ModalProgressHUD(
            inAsyncCall: _isLoading,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 32.0, right: 8.0, left: 8.0, bottom: 8.0),
                      child: Text(
                        'Current User Identifier',
                        textAlign: TextAlign.center,
                        style: kTitleTextStyle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Global.appUserID,
                      textAlign: TextAlign.center,
                      style: kDescriptionTextStyle,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                        top: 24.0, bottom: 8.0, left: 8.0, right: 8.0),
                    child: Text(
                      'Subscription Status',
                      textAlign: TextAlign.center,
                      style: kTitleTextStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Global.entitlementIsActive == true
                          ? 'Active'
                          : 'Not Active',
                      textAlign: TextAlign.center,
                      style: kDescriptionTextStyle.copyWith(
                          color: (Global.entitlementIsActive == true)
                              ? kColorSuccess
                              : kColorError),
                    ),
                  ),
                  Visibility(
                    visible: Global.appUserID.contains("RCAnonymousID:"),
                    child: const Padding(
                      padding: EdgeInsets.only(
                          top: 24.0, bottom: 8.0, left: 8.0, right: 8.0),
                      child: Text(
                        'Login',
                        textAlign: TextAlign.center,
                        style: kTitleTextStyle,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: Global.appUserID.contains("RCAnonymousID:"),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.text,
                          style: kDescriptionTextStyle,
                          onSubmitted: (value) {
                            if (value != '') _logIn(value);
                          },
                          decoration: userInputDecoration),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Column(
                      children: [
                        Visibility(
                          visible: !Global.appUserID.contains("RCAnonymousID:"),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              onPressed: () {
                                _logOut();
                              },
                              child: Text(
                                "Logout",
                                style: kDescriptionTextStyle.copyWith(
                                    fontSize: kFontSizeMedium,
                                    fontWeight: FontWeight.bold,
                                    color: kColorError),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () {
                              _restore();
                            },
                            child: Text(
                              "Restore Purchases",
                              style: kDescriptionTextStyle.copyWith(
                                  fontSize: kFontSizeMedium,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
