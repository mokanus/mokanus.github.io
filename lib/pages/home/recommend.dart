import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tingfm/pages/player/player.dart';
import 'package:tingfm/providers/recommend.dart';
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
          itemCount: recommendProvider.recommendAlbumnList.length ~/ 2,
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
                            Card(
                              margin: const EdgeInsets.only(top: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: SizedBox.square(
                                dimension: ScreenUtil().setWidth(371),
                                child: CachedNetworkImage(
                                    height: ScreenUtil().setHeight(371),
                                    width: ScreenUtil().setWidth(371),
                                    imageUrl:
                                        "https://tingfm-gz-1300862581.cos.ap-guangzhou.myqcloud.com/水浒传·田连元|田连元/水浒传·田连元.png"),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  ScreenUtil().setWidth(60),
                                  ScreenUtil().setHeight(50),
                                  ScreenUtil().setWidth(55),
                                  ScreenUtil().setHeight(10)),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                recommendProvider
                                    .recommendAlbumnList[index * 2].album,
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
                                "${recommendProvider.recommendAlbumnList[index * 2].artist}·${recommendProvider.recommendAlbumnList[index * 2].listenTimes}人收听",
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
                      child: GestureDetector(
                        child: Column(
                          children: [
                            Card(
                              margin: const EdgeInsets.only(top: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: SizedBox.square(
                                dimension: ScreenUtil().setWidth(371),
                                child: CachedNetworkImage(
                                    height: ScreenUtil().setHeight(371),
                                    width: ScreenUtil().setWidth(371),
                                    imageUrl:
                                        "https://tingfm-gz-1300862581.cos.ap-guangzhou.myqcloud.com/水浒传·田连元|田连元/水浒传·田连元.png"),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  ScreenUtil().setWidth(60),
                                  ScreenUtil().setHeight(50),
                                  ScreenUtil().setWidth(55),
                                  ScreenUtil().setHeight(10)),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                recommendProvider
                                    .recommendAlbumnList[index * 2 + 1].album,
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
                                "${recommendProvider.recommendAlbumnList[index * 2 + 1].artist}·${recommendProvider.recommendAlbumnList[index * 2 + 1].listenTimes}人收听",
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
