import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:tingfm/entities/album.dart';
import 'package:tingfm/pages/album_info/album_info.dart';
import 'package:tingfm/providers/search.dart';
import 'package:tingfm/utils/router.dart';
import 'package:tingfm/utils/vibration.dart';
import 'package:tingfm/widgets/image.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Scaffold(
      body: Stack(
        children: [
          buildFloatingSearchBar(),
        ],
      ),
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: '搜索 隋唐演义',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 500),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      openWidth: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      elevation: 1.0,
      onQueryChanged: (query) {
        query = query.trim();
        if (query.isNotEmpty) {
          Provider.of<SearchProvider>(context, listen: false)
              .searchData(context, query);
        }
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        const FloatingSearchBarAction(
          showIfOpened: false,
          child: Icon(
            Icons.multitrack_audio,
            color: Colors.red,
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return Consumer<SearchProvider>(
          builder: (BuildContext context, SearchProvider searchProvider,
              Widget? child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                color: Theme.of(context).cardColor,
                elevation: 2.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: searchProvider.searchedAlbumnList.map((album) {
                    return albumnItemWidget(album);
                  }).toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget albumnItemWidget(AlbumItem album) {
    return GestureDetector(
      onTap: () => {
        // 灰度处理的上下文
        Vibrate.doVibrate(
          pattern: [0, 90, 10, 70],
        ),
        //定义点击函数
        AppRouter.pushPage(
            context,
            AlbumInfoPage(
              albumId: album.id,
              album: album.album,
            )),
      },
      child: Card(
        child: Container(
          height: 100,
          color: Theme.of(context).cardColor,
          //内边距
//        padding: EdgeInsets.only(left: 1, right: 1),
          child: Row(
            //对齐方式
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //弹性布局
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: imageCached(
                        album.imageUrl(),
                        album.cachedKey(),
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(40),
                          ScreenUtil().setHeight(50),
                          ScreenUtil().setWidth(55),
                          ScreenUtil().setHeight(10)),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        album.album,
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
                          ScreenUtil().setWidth(40),
                          ScreenUtil().setHeight(10),
                          ScreenUtil().setWidth(55),
                          ScreenUtil().setHeight(70)),
                      child: Text(
                        album.listenTime(),
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
            ],
          ),
        ),
      ),
    );
  }
}
