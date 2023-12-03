import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tingfm/api/api_status.dart';
import 'package:tingfm/components/search_bar.dart';
import 'package:tingfm/pages/album_info/album_info.dart';
import 'package:tingfm/pages/index/menu.dart';
import 'package:tingfm/pages/index/recommend.dart';
import 'package:tingfm/pages/index/recommend_list.dart';
import 'package:tingfm/providers/index.dart';
import 'package:tingfm/widgets/image.dart';
import 'package:tingfm/widgets/loading_widget.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) =>
          Provider.of<IndexProvider>(context, listen: false).flushData(context),
    );
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<IndexProvider>(
        builder: (BuildContext context, IndexProvider provider, Widget? child) {
      return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          foregroundColor: Colors.black,
          title: const TingSearchBar(),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        body: provider.apiRequestStatus != APIRequestStatus.loaded
            ? const LoadingWidget()
            : ListView(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(50)),
                children: [
                  Column(
                    children: [
                      // swiper组件
                      SizedBox(
                        height: ScreenUtil().setHeight(500),
                        child: Swiper(
                          autoplay: true,
                          itemBuilder: (BuildContext context, int index) {
                            return imageCached(
                              provider.albumBanners[index].imageURL(),
                              provider.albumBanners[index].cacheKey(),
                              height: ScreenUtil().setHeight(480),
                              width: ScreenUtil().screenWidth,
                            );
                          },
                          itemCount: provider.albumBanners.length,
                          onTap: (index) => {
                            Navigator.of(context).push(PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (_, __, ___) => AlbumInfoPage(
                                album: provider.albumBanners[index].album,
                                albumId: provider.albumBanners[index].albumId,
                              ),
                            ))
                          },
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(64),
                      ),
                      // 菜单控件
                      const MenuWidget(),
                      SizedBox(
                        height: ScreenUtil().setHeight(64),
                      ),
                      // 推荐列表控件
                      RecommendListWidget(
                          title: "猜你喜欢", albums: provider.suggestAlbums),
                      buildRecomendWidgets(provider),
                    ],
                  ),
                ],
              ),
      );
    });
  }

  Widget buildRecomendWidgets(IndexProvider provider) {
    List<Widget> items = [];

    for (var classify in provider.classifies) {
      items.add(RecommendWidget(
        classify: classify,
        albums: provider.albums[classify.id]!,
      ));
    }

    Widget content = Column(
      children: items,
    );
    return content;
  }

  @override
  bool get wantKeepAlive => true;
}
