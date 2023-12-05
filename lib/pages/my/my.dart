import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tingfm/pages/privacy/privacy.dart';
import 'package:tingfm/pages/privacy/user_privacy.dart';
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
      // {
      //   'icon': null,
      //   'title': '订阅控件',
      // },
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
      // {
      //   'icon': Icons.login_outlined,
      //   'title': '退出登陆',
      //   'function': () async => {await FirebaseAuth.instance.signOut()},
      // },
      // {
      //   'icon': Ionicons.albums,
      //   'title': '订阅',
      //   'function': () => {},
      // }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(47),
                ScreenUtil().setHeight(20),
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

  Widget personDataWidgt(String name, String avator) {
    return SizedBox(
      height: ScreenUtil().setHeight(400),
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
                  // Text(
                  //   "UID: ajsdkhkj_jkashkdhhiowej_j",
                  //   style: TextStyle(
                  //     fontSize: ScreenUtil().setSp(32),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          const Icon(Icons.settings)
        ],
      ),
    );
  }

  Widget subscriptionWidgt() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(10), 5, ScreenUtil().setWidth(10), 10),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 250, 203, 148),
          borderRadius: BorderRadius.circular(5.0)),
      height: ScreenUtil().setHeight(200),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
