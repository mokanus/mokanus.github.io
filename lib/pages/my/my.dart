import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("听书铺子"),
        elevation: 0.2,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(47),
            ScreenUtil().setWidth(47),
            ScreenUtil().setWidth(47),
            ScreenUtil().setWidth(47)),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            personDataWidgt(),
            listenDataWidgt()
          ],
        ),
      ),
    );
  }

  Widget personDataWidgt() {
    return SizedBox(
      height: ScreenUtil().setHeight(490),
      width: 1000,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Card(
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
                          ScreenUtil().setHeight(0),
                          ScreenUtil().setWidth(47),
                          ScreenUtil().setHeight(0)),
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
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(34)),
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
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(34)),
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
          const Positioned(
            top: -30,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 32,
                backgroundImage: AssetImage("assets/images/milk.png"),
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
}
