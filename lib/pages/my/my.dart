import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tingfm/pages/privacy/privacy.dart';
import 'package:tingfm/pages/privacy/user_privacy.dart';
import 'package:tingfm/pages/setting/setting.dart';
import 'package:tingfm/purchase/components/native_dialog.dart';
import 'package:tingfm/purchase/constant.dart';
import 'package:tingfm/purchase/model/styles.dart';
import 'package:tingfm/purchase/views/paywall.dart';
import 'package:tingfm/utils/router.dart';
import 'package:tingfm/widgets/image.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  late List items;

  @override
  void initState() {
    super.initState();
    items = [
      {
        'icon': null,
        'title': '应用信息',
      },
      {
        'icon': null,
        'title': '订阅控件',
      },
      {
        'icon': Ionicons.shield_checkmark_outline,
        'title': '隐私政策',
        'function': () => AppRouter.pushPage(context, const PrivacyPage()),
      },
      {
        'icon': Ionicons.person,
        'title': '用户协议',
        'function': () => AppRouter.pushPage(context, const UserPrivacyPage()),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(47),
                ScreenUtil().setHeight(10),
                ScreenUtil().setWidth(47),
                ScreenUtil().setHeight(20)),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                if (items[index]['title'] == '应用信息') {
                  return personDataWidgt("听书铺子fm", "");
                }
                if (items[index]['title'] == '订阅控件') {
                  return subscriptionWidgt();
                }
                return ListTile(
                  onTap: items[index]['function'],
                  leading: Icon(
                    items[index]['icon'],
                    color: const Color.fromARGB(255, 234, 78, 94),
                  ),
                  title: Text(
                    items[index]['title'],
                  ),
                  trailing: const Icon(Icons.arrow_right_sharp),
                );
              },
            )));
  }

  void perfomMagic() async {
    // 需要检查一下是不是已经订阅
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();

    if (customerInfo.entitlements.all[entitlementID] != null &&
        customerInfo.entitlements.all[entitlementID]?.isActive == true) {
    } else {
      Offerings? offerings;
      try {
        offerings = await Purchases.getOfferings();
      } on PlatformException catch (e) {
        // ignore: use_build_context_synchronously
        await showDialog(
            context: context,
            builder: (BuildContext context) => ShowDialogToDismiss(
                title: "Error",
                content: e.message ?? "Unknown error",
                buttonText: 'OK'));
      }

      if (offerings == null || offerings.current == null) {
        // offerings are empty, show a message to your user
      } else {
        // current offering is available, show paywall
        // ignore: use_build_context_synchronously
        await showModalBottomSheet(
          useRootNavigator: true,
          isDismissible: true,
          isScrollControlled: true,
          backgroundColor: kColorBackground,
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

  Widget personDataWidgt(String name, String avator) {
    return SizedBox(
      height: ScreenUtil().setHeight(300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          avator != ""
              ? imageCached(
                  avator,
                  avator,
                  width: ScreenUtil().setWidth(200.0),
                  height: ScreenUtil().setHeight(200.0),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(16.0), // 设置圆角半径
                  child: Image.asset(
                    "assets/images/icon.png",
                    width: ScreenUtil().setWidth(200.0),
                    height: ScreenUtil().setHeight(200.0),
                    fit: BoxFit.cover, // 图片填充方式，可根据需要调整
                  ),
                ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(64),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
              onPressed: () => {AppRouter.pushPage(context, SettingPage())},
              icon: const Icon(Icons.settings))
        ],
      ),
    );
  }

  Widget subscriptionWidgt() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(10), 5, ScreenUtil().setWidth(10), 10),
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 250, 203, 148),
          borderRadius: BorderRadius.circular(5.0)),
      height: ScreenUtil().setHeight(220),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "订阅解锁全部专辑",
            style: TextStyle(
              color: Color.fromARGB(255, 58, 39, 17),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Container(
            height: 40.0,
            width: 100.0,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 85, 58, 29), // 跑道的颜色
              borderRadius: BorderRadius.circular(30.0), // 圆角半径，使其成为圆形
            ),
            child: InkWell(
              onTap: () {
                perfomMagic();
              },
              child: const Center(
                child: Text(
                  "立即订阅",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
