import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tingfm/pages/player/player.dart';
import 'package:tingfm/providers/recommend_provider.dart';
import 'package:tingfm/widgets/body_builder.dart';

class RecommendView extends StatefulWidget {
  const RecommendView({super.key});

  @override
  State<RecommendView> createState() => _RecommendViewState();
}

class _RecommendViewState extends State<RecommendView>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<RecommendProvider>(context, listen: false)
          .getRecommendData(context, 0, 10),
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecommendProvider>(builder: (BuildContext context,
        RecommendProvider recommendProvider, Widget? child) {
      return BodyBuilder(
        apiRequestStatus: recommendProvider.apiRequestStatus,
        reload: () => recommendProvider.getRecommendData(context, 0, 10),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          itemCount: 10,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(55),
                  ScreenUtil().setHeight(5),
                  ScreenUtil().setWidth(55),
                  ScreenUtil().setHeight(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 0.2,
                      child: GestureDetector(
                        child: Column(
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
                                        BorderRadiusDirectional.circular(10)),
                              ),
                              //设置边距
                              margin: const EdgeInsets.only(top: 16),
                              height: ScreenUtil().setHeight(371),
                              width: ScreenUtil().setWidth(371),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  ScreenUtil().setWidth(60),
                                  ScreenUtil().setHeight(50),
                                  ScreenUtil().setWidth(55),
                                  ScreenUtil().setHeight(10)),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "隋唐演义",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 51, 51, 51),
                                  fontSize: ScreenUtil().setSp(43),
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.fromLTRB(
                                  ScreenUtil().setWidth(60),
                                  ScreenUtil().setHeight(10),
                                  ScreenUtil().setWidth(55),
                                  ScreenUtil().setHeight(70)),
                              child: Text(
                                "田连元 · 100万人收听",
                                style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 136, 136, 136),
                                  fontSize: ScreenUtil().setSp(33),
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (_, __, ___) => const PlayerPage(
                                fromMiniplayer: false,
                                album: "隋唐演义",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 0.2,
                      child: Column(
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
                                      BorderRadiusDirectional.circular(10)),
                            ),
                            //设置边距
                            margin: const EdgeInsets.only(top: 16),
                            height: ScreenUtil().setHeight(371),
                            width: ScreenUtil().setWidth(371),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                ScreenUtil().setWidth(60),
                                ScreenUtil().setHeight(50),
                                ScreenUtil().setWidth(55),
                                ScreenUtil().setHeight(10)),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "隋唐演义",
                              style: TextStyle(
                                color: const Color.fromRGBO(51, 51, 51, 1),
                                fontSize: ScreenUtil().setSp(43),
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.fromLTRB(
                                ScreenUtil().setWidth(60),
                                ScreenUtil().setHeight(10),
                                ScreenUtil().setWidth(55),
                                ScreenUtil().setHeight(70)),
                            child: Text(
                              "田连元 · 100万人收听",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 136, 136, 136),
                                fontSize: ScreenUtil().setSp(33),
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
