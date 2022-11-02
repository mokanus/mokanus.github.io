// 播放暂停 - 上下一曲
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tingfm/services/audio_service.dart';

class PlayerContros extends StatelessWidget {
  final AudioPlayerHandler audioHandler;

  const PlayerContros(this.audioHandler, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<QueueState?>(
              stream: audioHandler.queueState,
              builder: (context, snapshot) {
                final queueState = snapshot.data;
                return IconButton(
                  splashRadius: 1,
                  icon: const Icon(
                    Icons.skip_previous_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: queueState?.hasPrevious ?? true
                      ? audioHandler.skipToPrevious
                      : null,
                );
              }),
          StreamBuilder<PlaybackState>(
            stream: audioHandler.playbackState,
            builder: (context, snapshot) {
              final playbackState = snapshot.data;
              final processingState = playbackState?.processingState;
              final playing = playbackState?.playing ?? true;
              if (processingState == AudioProcessingState.loading ||
                  processingState == AudioProcessingState.buffering &&
                      playing == false) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  width: 64.0,
                  height: 64.0,
                  child: const CircularProgressIndicator(
                    color: Color.fromARGB(255, 234, 78, 94),
                    strokeWidth: 4.0,
                  ),
                );
              } else if (playing != true) {
                return IconButton(
                  splashRadius: 1,
                  icon: const Icon(
                    Icons.play_circle_fill_rounded,
                    color: Colors.white,
                  ),
                  iconSize: 90.0,
                  onPressed: audioHandler.play,
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  splashRadius: 1,
                  icon: const Icon(
                    Icons.pause_circle_rounded,
                    color: Colors.white,
                  ),
                  iconSize: 90.0,
                  onPressed: audioHandler.pause,
                );
              } else {
                return IconButton(
                  splashRadius: 1,
                  icon: const Icon(
                    Icons.replay,
                    color: Colors.white,
                  ),
                  iconSize: 90.0,
                  onPressed: () => audioHandler.pause,
                );
              }
            },
          ),
          StreamBuilder<QueueState?>(
              stream: audioHandler.queueState,
              builder: (context, snapshot) {
                final queueState = snapshot.data;
                return IconButton(
                  splashRadius: 1,
                  icon: const Icon(
                    Icons.skip_next_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: queueState?.hasNext ?? true
                      ? audioHandler.skipToNext
                      : null,
                );
              }),
        ],
      ),
    );
  }
}
