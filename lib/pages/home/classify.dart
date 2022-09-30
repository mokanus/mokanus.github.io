import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClassifyPage extends StatefulWidget {
  const ClassifyPage({super.key});

  @override
  State<ClassifyPage> createState() => _ClassifyPageState();
}

class _ClassifyPageState extends State<ClassifyPage> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      itemCount: 10,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(55),
              ScreenUtil().setHeight(8),
              ScreenUtil().setWidth(55),
              ScreenUtil().setHeight(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Card(
                  elevation: 0.2,
                  child: Row(
                    children: [
                      Container(
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            //设置背景图片
                            image: AssetImage(
                              "assets/images/milk.png",
                            ),
                          ),
                          //设置圆角
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadiusDirectional.circular(5)),
                        ),
                        //设置边距
                        margin: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(20),
                            ScreenUtil().setHeight(20),
                            ScreenUtil().setWidth(30),
                            ScreenUtil().setHeight(20)),
                        height: ScreenUtil().setHeight(160),
                        width: ScreenUtil().setWidth(160),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Text(
                              "相声评书",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(40),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            "共300个专辑",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Card(
                  elevation: 0.2,
                  child: Row(
                    children: [
                      Container(
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            //设置背景图片
                            image: AssetImage(
                              "assets/images/milk.png",
                            ),
                          ),
                          //设置圆角
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadiusDirectional.circular(5)),
                        ),
                        //设置边距
                        margin: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(20),
                            ScreenUtil().setHeight(20),
                            ScreenUtil().setWidth(30),
                            ScreenUtil().setHeight(20)),
                        height: ScreenUtil().setHeight(160),
                        width: ScreenUtil().setWidth(160),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Text(
                              "相声评书",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(40),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            "共300个专辑",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
