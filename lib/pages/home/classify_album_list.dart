import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tingfm/pages/album_info/album_info.dart';
import 'package:tingfm/pages/player/player.dart';
import 'package:tingfm/providers/list_by_classify.dart';
import 'package:tingfm/widgets/body_builder.dart';
import 'package:tingfm/widgets/image.dart';

// 列表页面-可用来展示分类后的专辑列表信息
// 比如说相声、小说、评书等等

class AlbumListPage extends StatefulWidget {
  final String classify;
  final int classifyId;

  const AlbumListPage(
      {super.key, required this.classify, required this.classifyId});

  @override
  State<AlbumListPage> createState() => _AlbumListPageState();
}

class _AlbumListPageState extends State<AlbumListPage>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<ListByClassifyProvider>(context, listen: false)
          .getAlbumsByClassify(context, widget.classifyId, 0, 10),
    );
    WidgetsBinding.instance.addObserver(this);
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
            ListByClassifyProvider listByClassifyProvider, Widget? child) {
          return BodyBuilder(
            apiRequestStatus: listByClassifyProvider.apiRequestStatus,
            reload: () => listByClassifyProvider.getAlbumsByClassify(
                context, widget.classifyId, 0, 10),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              itemCount: listByClassifyProvider.albumList.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.fromLTRB(
                      ScreenUtil().setWidth(50),
                      ScreenUtil().setHeight(5),
                      ScreenUtil().setWidth(50),
                      ScreenUtil().setHeight(5)),
                  child: Card(
                    elevation: 0.2,
                    child: GestureDetector(
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
                                listByClassifyProvider.albumList[index]
                                    .imageUrl(),
                                listByClassifyProvider.albumList[index]
                                    .cachedKey(),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(
                                    ScreenUtil().setWidth(60),
                                    ScreenUtil().setHeight(50),
                                    ScreenUtil().setWidth(55),
                                    ScreenUtil().setHeight(10)),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  listByClassifyProvider.albumList[index].album,
                                  style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 51, 51, 51),
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
                                  listByClassifyProvider.albumList[index]
                                      .listenTime(),
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 136, 136, 136),
                                    fontSize: ScreenUtil().setSp(33),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (_, __, ___) => AlbumInfoPage(
                              albumId:
                                  listByClassifyProvider.albumList[index].id,
                              album:
                                  listByClassifyProvider.albumList[index].album,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        }));
  }
}
