import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});

  final List items = [
    {
      'icon': Icons.cleaning_services,
      'title': '账号清理',
      'function': () async => {await FirebaseAuth.instance.signOut()},
    },
    {
      'icon': Icons.login_outlined,
      'title': '退出登陆',
      'function': () async => {await FirebaseAuth.instance.signOut()},
    },
  ];

  @override
  Widget build(Object context) {
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
}
