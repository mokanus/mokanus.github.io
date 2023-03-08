import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tingfm/pages/feedback/feedback.dart';
import 'package:tingfm/pages/privacy/privacy.dart';
import 'package:tingfm/utils/admob.dart';
import 'package:tingfm/utils/global.dart';
import 'package:tingfm/utils/router.dart';
import 'package:tingfm/utils/storage.dart';
import 'package:vibration/vibration.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  late List items;
  late AdmobAdManager admob;
  @override
  void initState() {
    admob = AdmobAdManager();
    admob.loadAd(RewardAdType.my);
    super.initState();
    items = [
      {
        'icon': null,
        'title': '应用信息',
      },
      {
        'icon': Ionicons.link_outline,
        'title': '看个广告鼓励一下',
        'function': () => watchAd(),
      },
      {
        'icon': Icons.lightbulb,
        'title': '没有我想听?',
        'function': () => AppRouter.pushPage(context, const FeedbackPage()),
      },
      // {
      //   'icon': Icons.vibration,
      //   'title': '开启震动',
      //   // 'function': () => _pushPage(Downloads()),
      // },
      {
        'icon': Ionicons.file_tray,
        'title': '隐私政策声明',
        'function': () => AppRouter.pushPage(context, const PrivacyPage()),
      }
      // {
      //   'icon': Ionicons.mail,
      //   'title': '联系我们',
      //   'function': () => showAbout(),
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
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                if (items[index]['title'] == '应用信息') {
                  return personDataWidgt();
                }

                if (items[index]['title'] == '统计数据') {
                  return listenDataWidgt();
                }

                if (items[index]['title'] == '开启震动') {
                  return _buildVibrationSwitch(items[index]);
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
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            )));
  }

  Widget _buildVibrationSwitch(Map item) {
    return SwitchListTile(
      secondary: Icon(
        item['icon'],
        color: Colors.red,
      ),
      activeColor: const Color.fromARGB(255, 234, 78, 94),
      title: Text(
        item['title'],
      ),
      value: Global.isTurnOnVibration ? true : false,
      onChanged: (v) async {
        if (v) {
          Global.isTurnOnVibration = true;
          Vibration.vibrate();
        } else {
          Global.isTurnOnVibration = false;
        }
        setState(() {
          StorageUtil().setBool("turnOnVibration", Global.isTurnOnVibration);
        });
      },
    );
  }

  Widget personDataWidgt() {
    return SizedBox(
      height: ScreenUtil().setHeight(300),
      width: 1000,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Card(
            elevation: 0.5,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      ScreenUtil().setWidth(47),
                      ScreenUtil().setWidth(47),
                      ScreenUtil().setWidth(47),
                      ScreenUtil().setHeight(20)),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      ScreenUtil().setWidth(47),
                      ScreenUtil().setHeight(80),
                      ScreenUtil().setWidth(47),
                      ScreenUtil().setWidth(40),
                    ),
                    child: Center(
                      child: Text(
                        "听书铺子",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(54),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: -30,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white38,
              child: CircleAvatar(
                radius: 32,
                backgroundImage: AssetImage("assets/images/icon.png"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget listenDataWidgt() {
    return SizedBox(
      height: ScreenUtil().setHeight(490),
      width: 1000,
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(47),
                  ScreenUtil().setWidth(47),
                  ScreenUtil().setWidth(47),
                  ScreenUtil().setWidth(40)),
              child: Row(
                children: [
                  Icon(
                    Icons.timeline_outlined,
                    color: const Color.fromARGB(255, 234, 78, 94),
                    size: ScreenUtil().setWidth(73),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(50),
                  ),
                  Text(
                    "收听数据",
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(47),
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      ScreenUtil().setWidth(47),
                      ScreenUtil().setWidth(0),
                      ScreenUtil().setWidth(47),
                      ScreenUtil().setWidth(0)),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "总收听时长",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(40),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(50),
                            ),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "22",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(60),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(10),
                                  ),
                                  Text(
                                    "小时",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(32),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]),
                            SizedBox(
                              height: ScreenUtil().setHeight(44),
                            ),
                            Text(
                              "本周收听100小时",
                              style:
                                  TextStyle(fontSize: ScreenUtil().setSp(34)),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "总收听专辑",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(40),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(50),
                            ),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "40",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(60),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(10),
                                  ),
                                  Text(
                                    "个",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(32),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]),
                            SizedBox(
                              height: ScreenUtil().setHeight(44),
                            ),
                            Text(
                              "本周收听10个专辑",
                              style:
                                  TextStyle(fontSize: ScreenUtil().setSp(34)),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  watchAd() {
    admob.showAd(RewardAdType.my);
  }

  @override
  void dispose() {
    admob.dispose();
    super.dispose();
  }

  showAbout() {
    showDialog(
      context: context,
      builder: (_) {
        return const AlertDialog(
          title: Text(
            '听书铺子',
          ),
          content: Text(
            '一个简洁好用的听书APP',
          ),
          actions: <Widget>[
            // FlatButton(
            //   textColor: Theme.of(context).accentColor,
            //   onPressed: () => Navigator.pop(context),
            //   child: const Text(
            //     'Close',
            //   ),
            // ),
          ],
        );
      },
    );
  }
}
