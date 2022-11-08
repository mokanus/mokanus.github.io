import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tingfm/pages/player/widgets/seek_bar.dart';
import 'package:tingfm/providers/album_info.dart';
import 'package:tingfm/providers/favorite.dart';
import 'package:tingfm/services/audio_service.dart';
import 'package:tingfm/widgets/snackbar.dart';

class PlayerBtns extends StatelessWidget {
  final AudioPlayerHandler audioHandler;

  const PlayerBtns({Key? key, required this.audioHandler}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(20),
          ScreenUtil().setHeight(5),
          ScreenUtil().setWidth(20),
          ScreenUtil().setHeight(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StreamBuilder<AudioServiceRepeatMode>(
            stream: audioHandler.playbackState
                .map((state) => state.repeatMode)
                .distinct(),
            builder: (context, snapshot) {
              final repeatMode = snapshot.data ?? AudioServiceRepeatMode.none;
              const icons = [
                Icon(Icons.repeat, color: Colors.black),
                Icon(Icons.repeat, color: Colors.orange),
                Icon(Icons.repeat_one, color: Colors.orange),
              ];
              const cycleModes = [
                AudioServiceRepeatMode.none,
                AudioServiceRepeatMode.all,
                AudioServiceRepeatMode.one,
              ];
              final index = cycleModes.indexOf(repeatMode);
              return IconButton(
                icon: icons[index],
                onPressed: () async {
                  await audioHandler.setRepeatMode(
                    cycleModes[(cycleModes.indexOf(repeatMode) + 1) %
                        cycleModes.length],
                  );
                },
              );
            },
          ),
          // StreamBuilder<bool>(
          //   stream: audioHandler.playbackState
          //       .map(
          //         (state) => state.shuffleMode == AudioServiceShuffleMode.all,
          //       )
          //       .distinct(),
          //   builder: (context, snapshot) {
          //     final shuffleModeEnabled = snapshot.data ?? false;
          //     return IconButton(
          //       icon: shuffleModeEnabled
          //           ? const Icon(Icons.shuffle, color: Colors.orange)
          //           : const Icon(Icons.shuffle, color: Colors.white),
          //       onPressed: () async {
          //         final enable = !shuffleModeEnabled;
          //         await audioHandler.setShuffleMode(
          //           enable
          //               ? AudioServiceShuffleMode.all
          //               : AudioServiceShuffleMode.none,
          //         );
          //       },
          //     );
          //   },
          // ),

          StreamBuilder<double>(
            stream: audioHandler.speed,
            builder: (context, snapshot) => IconButton(
              icon: Stack(clipBehavior: Clip.none, children: [
                Positioned(
                  top: -8.0,
                  right: -8.0,
                  child: Text(
                    "${snapshot.data?.toStringAsFixed(1)}x",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 8,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Positioned(
                  child: Icon(
                    Icons.speed_rounded,
                    color: Colors.black,
                  ),
                ),
              ]),
              onPressed: () {
                showSliderDialog(
                  context: context,
                  title: "播放速度",
                  divisions: 15,
                  min: 0.5,
                  max: 2.0,
                  value: audioHandler.speed.value,
                  stream: audioHandler.speed,
                  onChanged: audioHandler.setSpeed,
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.red.shade400,
            ),
            onPressed: () {
              addItemToFavorate(context);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.timer,
              color: Colors.black,
            ),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "定时关闭",
                divisions: 10,
                min: 0.0,
                max: 1.0,
                value: audioHandler.volume.value,
                stream: audioHandler.volume,
                onChanged: audioHandler.setVolume,
              );
            },
          ),
        ],
      ),
    );
  }

  addItemToFavorate(BuildContext ctx) {
    var item = Provider.of<AlbumInfoProvider>(ctx, listen: false).item;
    if (item != null) {
      Provider.of<FavoriteProvider>(ctx, listen: false).addItemFromAlbum(item);
      ShowSnackBar().showSnackBar(
        ctx,
        "${item.album} 已经加入喜欢列表啦",
      );
    }
  }
}
