import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:tingfm/pages/player/player.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  AudioPlayerHandler audioHandler = GetIt.I<AudioPlayerHandler>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
        stream: audioHandler.playbackState,
        builder: (context, snapshot) {
          final playbackState = snapshot.data;
          final processingState = playbackState?.processingState;
          if (processingState == AudioProcessingState.idle) {
            return const SizedBox();
          }
          return StreamBuilder<MediaItem?>(
              stream: audioHandler.mediaItem,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.active) {
                  return const SizedBox();
                }
                final mediaItem = snapshot.data;
                if (mediaItem == null) return const SizedBox();
                return Card(
                  elevation: 0.5,
                  margin: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(5.0),
                    vertical: ScreenUtil().setHeight(2.0),
                  ),
                  child: SizedBox(
                    height: 76.0,
                    child: ListTile(
                      dense: false,
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (_, __, ___) => const PlayerPage(
                              fromMiniplayer: true,
                            ),
                          ),
                        );
                      },
                      title: Text(
                        mediaItem.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        mediaItem.artist.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: Hero(
                        tag: 'currentArtwork',
                        child: Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: SizedBox.square(
                            dimension: 50.0,
                            child: Image(
                              fit: BoxFit.cover,
                              image: NetworkImage(mediaItem.artUri.toString()),
                            ),
                          ),
                        ),
                      ),
                      trailing: _buildMiniPlay(),
                    ),
                  ),
                );
              });
        });
  }

  Widget _buildMiniPlay() {
    return SizedBox(
      height: ScreenUtil().setHeight(200.0),
      width: ScreenUtil().setWidth(200.0),
      child: StreamBuilder<PlaybackState>(
        stream: audioHandler.playbackState,
        builder: (context, snapshot) {
          final playbackState = snapshot.data;
          final processingState = playbackState?.processingState;
          final playing = playbackState?.playing ?? true;
          return Center(
              child: (processingState == AudioProcessingState.loading ||
                      processingState == AudioProcessingState.buffering)
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).iconTheme.color!,
                        ),
                      ),
                    )
                  : Center(
                      child: playing
                          ? IconButton(
                              tooltip: "暂停",
                              onPressed: audioHandler.pause,
                              icon: const Icon(
                                Icons.pause_circle,
                              ),
                              color: Theme.of(context).iconTheme.color,
                              splashRadius: 1,
                              iconSize: 40,
                            )
                          : IconButton(
                              tooltip: "播放",
                              onPressed: audioHandler.play,
                              icon: const Icon(
                                Icons.play_circle_fill,
                              ),
                              color: Theme.of(context).iconTheme.color,
                              splashRadius: 1,
                              iconSize: 40,
                            ),
                    ));
        },
      ),
    );
  }
}
