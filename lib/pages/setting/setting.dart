import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tingfm/pages/privacy/privacy.dart';
import 'package:tingfm/pages/privacy/user_privacy.dart';
import 'package:tingfm/utils/purchase.dart';
import 'package:tingfm/utils/router.dart';
import 'package:tingfm/widgets/snackbar.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  late List items;

  @override
  void initState() {
    super.initState();
    items = [
      {
        'icon': Icons.supervised_user_circle_outlined,
        'title': 'UID',
        'function': () async {
          ShowSnackBar().showSnackBar(
            context,
            "UID是:${PurchaseUtil.appUserID}",
          );
        },
      },
      {
        'icon': Icons.cleaning_services,
        'title': '账号清理',
        'function': () async => {await FirebaseAuth.instance.signOut()},
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: const Text("设置"),
          centerTitle: true,
        ),
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

  showUID() {}

  cleanUID() {}
}
