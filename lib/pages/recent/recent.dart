import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tingfm/providers/recent.dart';
import 'package:tingfm/widgets/recommend_item.dart';

class RecentPage extends StatefulWidget {
  const RecentPage({super.key});

  @override
  State<RecentPage> createState() => RecentPageState();
}

class RecentPageState extends State<RecentPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final EasyRefreshController easyController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  int currentIndex = 20;
  int freshOffset = 20;

  @override
  void initState() {
    super.initState();

// 只会在build完成之后被调用一次
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<RecentProvider>(context, listen: false)
          .refreshRecentAlbumsData(context, 0, freshOffset),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("最近更新"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<RecentProvider>(builder:
            (BuildContext context, RecentProvider provider, Widget? child) {
          return EasyRefresh(
            controller: easyController,
            header: const DeliveryHeader(),
            footer: BezierFooter(
                backgroundColor: Theme.of(context).cardColor,
                triggerOffset: 50),
            onRefresh: () async {
              await provider.refreshRecentAlbumsData(context, 0, freshOffset);
              easyController.finishRefresh();
              easyController.resetFooter();
              currentIndex = 20;
            },
            //底部加载
            onLoad: () async {
              await provider.getRecentlyData(
                  context, currentIndex, freshOffset);
              currentIndex += freshOffset;
              easyController.finishLoad(IndicatorResult.success);
            },
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              itemCount: provider.recentAlbumnList.length ~/ 2,
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
                      RecommendItem(
                        albumItem: provider.recentAlbumnList[index * 2],
                      ),
                      RecommendItem(
                        albumItem: provider.recentAlbumnList[index * 2 + 1],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;

  @override
  void dispose() {
    _scrollController.dispose();
    easyController.dispose();
    super.dispose();
  }
}
