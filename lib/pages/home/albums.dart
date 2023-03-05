import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tingfm/pages/album_info/album_info.dart';
import 'package:tingfm/providers/list_by_classify.dart';
import 'package:tingfm/widgets/image.dart';

// 列表页面-可用来展示分类后的专辑列表信息
// 比如说相声、小说、评书等等

class AlbumsPage extends StatefulWidget {
  final String classify;
  final int classifyId;

  const AlbumsPage(
      {super.key, required this.classify, required this.classifyId});

  @override
  State<AlbumsPage> createState() => AlbumsPageState();
}

class AlbumsPageState extends State<AlbumsPage> {
  final ScrollController _scrollController = ScrollController();
  final EasyRefreshController easyController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  int currentIndex = 10;
  int freshOffset = 10;
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<ListByClassifyProvider>(context, listen: false)
          .refreshAlbumsByClassify(context, widget.classifyId, 0, freshOffset),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.classify),
          centerTitle: false,
          elevation: 0,
        ),
        body: Consumer<ListByClassifyProvider>(builder: (BuildContext context,
            ListByClassifyProvider provider, Widget? child) {
          return EasyRefresh(
            controller: easyController,
            header: const DeliveryHeader(),
            footer: BezierFooter(
                backgroundColor: Theme.of(context).cardColor,
                triggerOffset: 50),
            onRefresh: () async {
              await provider.refreshAlbumsByClassify(
                  context, widget.classifyId, 0, freshOffset);
              easyController.finishRefresh();
              easyController.resetFooter();
              currentIndex = 10;
            },
            //底部加载
            onLoad: () async {
              await provider.getAlbumsByClassify(
                  context, widget.classifyId, currentIndex, freshOffset);
              currentIndex += freshOffset;
              easyController.finishLoad(IndicatorResult.success);
            },
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              itemCount: provider.albumList.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.fromLTRB(
                      ScreenUtil().setWidth(50),
                      ScreenUtil().setHeight(5),
                      ScreenUtil().setWidth(50),
                      ScreenUtil().setHeight(5)),
                  child: GestureDetector(
                    child: Card(
                      elevation: 0.2,
                      child: Row(
                        children: [
                          Card(
                            margin: EdgeInsets.fromLTRB(
                                ScreenUtil().setWidth(30),
                                ScreenUtil().setHeight(30),
                                ScreenUtil().setWidth(60),
                                ScreenUtil().setHeight(30)),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: SizedBox.square(
                              dimension: ScreenUtil().setWidth(270),
                              child: imageCached(
                                provider.albumList[index].imageUrl(),
                                provider.albumList[index].cachedKey(),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  provider.albumList[index].album,
                                  style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 51, 51, 51),
                                    fontSize: ScreenUtil().setSp(43),
                                  ),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.fromLTRB(
                                      ScreenUtil().setWidth(10),
                                      ScreenUtil().setHeight(10),
                                      ScreenUtil().setWidth(55),
                                      ScreenUtil().setHeight(70)),
                                  child: Text(
                                    provider.albumList[index].listenTime(),
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 136, 136, 136),
                                      fontSize: ScreenUtil().setSp(33),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (_, __, ___) => AlbumInfoPage(
                            albumId: provider.albumList[index].id,
                            album: provider.albumList[index].album,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        }));
  }
}
