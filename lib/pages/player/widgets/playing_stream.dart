import 'package:flutter/material.dart';
import 'package:tingfm/services/audio_service.dart';
import 'package:tingfm/widgets/image.dart';

class NowPlayingStream extends StatelessWidget {
  final AudioPlayerHandler audioHandler;
  final ScrollController? scrollController;
  final bool head;
  final double headHeight;

  const NowPlayingStream({
    super.key,
    required this.audioHandler,
    this.scrollController,
    this.head = false,
    this.headHeight = 50,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QueueState>(
      stream: audioHandler.queueState,
      builder: (context, snapshot) {
        final queueState = snapshot.data ?? QueueState.empty;
        final queue = queueState.queue;

        return ReorderableListView.builder(
          header: SizedBox(
            height: head ? headHeight : 0,
          ),
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex--;
            }
            audioHandler.moveQueueItem(oldIndex, newIndex);
          },
          scrollController: scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 10),
          shrinkWrap: true,
          itemCount: queue.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: ValueKey(queue[index].id),
              direction: index == queueState.queueIndex
                  ? DismissDirection.none
                  : DismissDirection.horizontal,
              onDismissed: (dir) {
                audioHandler.removeQueueItemAt(index);
              },
              child: ListTileTheme(
                selectedColor: const Color.fromARGB(255, 234, 78, 94),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.only(left: 16.0, right: 10.0),
                  selected: index == queueState.queueIndex,
                  trailing: index == queueState.queueIndex
                      ? IconButton(
                          icon: const Icon(
                            Icons.bar_chart_rounded,
                          ),
                          tooltip: "播放中",
                          onPressed: () {},
                        )
                      : const SizedBox(),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      (queue[index].artUri == null)
                          ? const SizedBox.square(
                              dimension: 50,
                              child: Image(
                                image: AssetImage('assets/images/cover.jpg'),
                              ),
                            )
                          : SizedBox.square(
                              dimension: 50,
                              child: imageCached(
                                queue[index].artUri.toString(),
                                '${queue[index].album}·${queue[index].artUri}',
                              ),
                            ),
                    ],
                  ),
                  title: Text(
                    queue[index].title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: index == queueState.queueIndex
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    audioHandler.skipToQueueItem(index);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
