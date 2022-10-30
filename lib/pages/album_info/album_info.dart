import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tingfm/pages/player/player.dart';
import 'package:tingfm/providers/album_info.dart';
import 'package:tingfm/widgets/body_builder.dart';
import 'package:tingfm/widgets/image.dart';

class AlbumInfoPage extends StatefulWidget {
  final String album;
  final int albumId;

  const AlbumInfoPage({super.key, required this.album, required this.albumId});

  @override
  State<AlbumInfoPage> createState() => _AlbumInfoPageState();
}

class _AlbumInfoPageState extends State<AlbumInfoPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<AlbumInfoProvider>(context, listen: false)
          .getAlbumInfo(context, widget.albumId),
    );

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Consumer<AlbumInfoProvider>(builder:
            (BuildContext context, AlbumInfoProvider provider, Widget? child) {
          return BodyBuilder(
            apiRequestStatus: provider.apiRequestStatus,
            reload: () => provider.getAlbumInfo(context, widget.albumId),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: imageCached(
                      provider.item!.imageUrl(),
                      provider.item!.cachedKey(),
                      width: 270,
                      height: 270,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(200),
                        ScreenUtil().setHeight(5),
                        ScreenUtil().setWidth(200),
                        ScreenUtil().setHeight(10)),
                    child: Text(provider.item!.album),
                  ),
                  GestureDetector(
                    child: Container(
                      width: 120,
                      height: 60,
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: const Text("开始播放"),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (_, __, ___) => PlayerPage(
                            fromMiniplayer: false,
                            albumItem: provider.item,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        }));
  }
}
