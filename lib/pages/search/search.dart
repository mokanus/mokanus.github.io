import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:tingfm/entities/album.dart';
import 'package:tingfm/pages/player/player.dart';
import 'package:tingfm/providers/search.dart';
import 'package:tingfm/utils/router.dart';
import 'package:tingfm/utils/vibration.dart';
import 'package:tingfm/widgets/image.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
            PlayerPage(
              fromMiniplayer: false,
              album: album.album,
              albumId: album.id,
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
                        album.artUri,
                        album.album,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      album.album,
                      style: const TextStyle(
                        fontFamily: "Avenir",
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      album.artist,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          color: Colors.orange),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: const <Widget>[
                        Icon(Icons.multitrack_audio,
                            size: 16, color: Colors.red),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "200 集",
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              color: Colors.red,
                              fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.headset_rounded,
                          size: 16,
                          color: Colors.orange,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "200",
                          style: (TextStyle(color: Colors.orange)),
                        ),
                      ],
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
