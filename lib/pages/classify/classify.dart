import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tingfm/pages/albums/albums.dart';
import 'package:tingfm/providers/classify.dart';
import 'package:tingfm/widgets/image.dart';

class ClassifyPage extends StatefulWidget {
  const ClassifyPage({super.key});

  @override
  State<ClassifyPage> createState() => ClassifyPageState();
}

class ClassifyPageState extends State<ClassifyPage>
    with AutomaticKeepAliveClientMixin {
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
      (_) => Provider.of<ClassifyProvider>(context, listen: false)
          .getClassifies(context),
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
        title: Text("专辑分类"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<ClassifyProvider>(builder:
            (BuildContext context, ClassifyProvider provider, Widget? child) {
          return EasyRefresh(
            controller: easyController,
            header: const DeliveryHeader(),
            footer: BezierFooter(backgroundColor: Theme.of(context).cardColor),
            onRefresh: () async {
              await provider.getClassifies(context);
              easyController.finishRefresh();
              easyController.resetFooter();
            },
            //底部加载
            onLoad: () async {
              await provider.getClassifies(context);
              easyController.finishLoad(IndicatorResult.success);
            },
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              itemCount: provider.classifies.length,
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
                                      provider.classifies[index].imageUrl(),
                                      provider.classifies[index].cachedKey(),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                      child: Text(
                                        provider.classifies[index].classify,
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(40),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          onTap: () => {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (_, __, ___) => AlbumsPage(
                                  classify: provider.classifies[index].classify,
                                  classifyId: provider.classifies[index].id,
                                ),
                              ),
                            )
                          },
                        ),
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
  void dispose() {
    _scrollController.dispose();
    easyController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => false;
}
