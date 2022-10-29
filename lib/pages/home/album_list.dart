import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tingfm/pages/player/player.dart';

// 列表页面-可用来展示分类后的专辑列表信息
// 比如说相声、小说、评书等等

class AlbumListPage extends StatefulWidget {
  final String title;

  const AlbumListPage({super.key, required this.title});

  @override
  State<AlbumListPage> createState() => _AlbumListPageState();
}

class _AlbumListPageState extends State<AlbumListPage> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: false,
          elevation: 0,
        ),
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          itemCount: 10,
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
                        margin: const EdgeInsets.all(10),
                        height: ScreenUtil().setHeight(270),
                        width: ScreenUtil().setWidth(270),
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
                                color: const Color.fromARGB(255, 136, 136, 136),
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
                        pageBuilder: (_, __, ___) => const PlayerPage(
                          fromMiniplayer: false,
                          album: "隋唐演义",
                          albumId: 1,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ));
  }
}
