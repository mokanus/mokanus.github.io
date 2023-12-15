import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:tingfm/pages/privacy/privacy.dart';
import 'package:tingfm/pages/privacy/user_privacy.dart';
import 'package:tingfm/pages/setting/setting.dart';
import 'package:tingfm/utils/global.dart';
import 'package:tingfm/utils/purchase.dart';
import 'package:tingfm/utils/router.dart';

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
      {
        'icon': Ionicons.golf_sharp,
        'title': '评分鼓励',
        'function': () => {
              showDialog(
                context: context,
                barrierDismissible:
                    true, // set to false if you want to force a rating
                builder: (context) => _dialog,
              )
            },
      },
    ];
  }

  final _dialog = RatingDialog(
    initialRating: 3.0,
    // your app's name?
    title: const Text(
      '听书铺子fm',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),
    // encourage your user to leave a high rating?
    message: const Text(
      '听友们留下你的评分',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15),
    ),
    starColor: const Color.fromARGB(255, 234, 78, 94),
    // your app's logo?
    image: ClipRRect(
      borderRadius: BorderRadius.circular(10.0), // 设置圆角半径
      child: Image.asset(
        "assets/images/icon.png",
        width: 100,
        height: 100,
        fit: BoxFit.fitHeight, // 图片填充方式，可根据需要调整
      ),
    ),
    starSize: 32,
    submitButtonText: '提交',
    commentHint: '我想说两句..',
    onCancelled: () => {},
    onSubmitted: (response) {
      if (response.rating < 3.0) {
      } else {
        StoreRedirect.redirect(
            androidAppId: 'com.mokanu.ant.ting',
            iOSAppId: 'com.mokanu.ant.tingfm');
      }
    },
  );

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
                  return PurchaseUtil.isVip
                      ? const SizedBox()
                      : subscriptionWidgt();
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

  Widget personDataWidgt(String name, String avator) {
    return SizedBox(
      height: ScreenUtil().setHeight(300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
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
              onPressed: () => {
                    AppRouter.pushPage(context, const SettingPage()),
                  },
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
            "会员可以听全部专辑",
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
                PurchaseUtil.showSubcription(context);
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

  Widget vipDataWidgt() {
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
            "听书铺子的尊贵会员",
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
                PurchaseUtil.showSubcription(context);
              },
              child: const Center(
                child: Text(
                  "查看信息",
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
