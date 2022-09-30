import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  Widget build(BuildContext context) {
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
          onTap: () {},
          title: const Text(
            "隋唐演义",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: const Text(
            "田连元",
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
              child: const SizedBox.square(
                dimension: 50.0,
                child: Image(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/images/milk.png',
                  ),
                ),
              ),
            ),
          ),
          // trailing: ControlButtons(
          //   audioHandler,
          //   miniplayer: true,
          //   buttons: mediaItem.artUri.toString().startsWith('file:')
          //       ? ['Like', 'Play/Pause', 'Next']
          //       : preferredMiniButtons,
          // ),
        ),
      ),
    );
  }
}
