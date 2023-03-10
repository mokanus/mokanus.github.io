import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tingfm/pages/album_info/album_info.dart';
import 'package:tingfm/providers/history.dart';
import 'package:tingfm/widgets/image.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});
  @override
  State<HistoryView> createState() => HistoryViewState();
}

class HistoryViewState extends State<HistoryView> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<HishoryProvider>(context, listen: false)
          .flushHistoryItems(),
    );

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HishoryProvider>(builder:
        (BuildContext context, HishoryProvider provider, Widget? child) {
      return provider.historyItems.isEmpty
          ? Center(
              child: Text(
              "空空如也，快去收听吧",
              style: TextStyle(fontSize: ScreenUtil().setSp(44)),
            ))
          : ListView.builder(
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              itemCount: provider.historyItems.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(UniqueKey().toString()),
                  direction: DismissDirection.horizontal,
                  onDismissed: (dir) {
                    provider.remove(index);
                  },
                  child: Container(
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
                          child: GestureDetector(
                            child: Card(
                              elevation: 0.2,
                              child: Row(
                                children: [
                                  Container(
                                    //设置边距
                                    margin: EdgeInsets.fromLTRB(
                                        ScreenUtil().setWidth(30),
                                        ScreenUtil().setHeight(30),
                                        ScreenUtil().setWidth(30),
                                        ScreenUtil().setHeight(30)),
                                    height: ScreenUtil().setHeight(270),
                                    width: ScreenUtil().setWidth(270),
                                    child: imageCached(
                                        provider.historyItems[index].imageUrl(),
                                        provider.historyItems[index]
                                            .cachedKey()),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 8),
                                          child: Text(
                                            "${provider.historyItems[index].album} · ${provider.historyItems[index].artist}",
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(44),
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          provider.getAlbumMetaInfo(index),
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(35),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () => {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: true,
                                  pageBuilder: (_, __, ___) => AlbumInfoPage(
                                    albumId: provider.historyItems[index].id,
                                    album: provider.historyItems[index].album,
                                  ),
                                ),
                              )
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
    });
  }
}
