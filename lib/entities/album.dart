// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:tingfm/utils/global.dart';
import 'package:tingfm/values/hive_boxes/album_db.dart';

class AlbumItem {
  AlbumItem({
    required this.id,
    required this.album,
    required this.artist,
    required this.classify,
    required this.mediaItems,
    required this.artUri,
    required this.desc,
    required this.count,
    required this.listenTimes,
    required this.loveCount,
  });

  factory AlbumItem.withAlbum() {
    return AlbumItem(
        id: 1,
        classify: 1,
        album: "",
        artUri: '',
        artist: '',
        count: 1,
        desc: '',
        listenTimes: 1,
        loveCount: 1,
        mediaItems: []);
  }

  factory AlbumItem.fromJson(String str) => AlbumItem.fromMap(json.decode(str));

  factory AlbumItem.fromMap(Map<String, dynamic> json) => AlbumItem(
        id: json["ID"],
        album: json["album"],
        artist: json["artist"],
        classify: json["classify"],
        mediaItems:
            List<Media>.from(json["media_items"].map((x) => Media.fromJson(x))),
        artUri: json["artUri"],
        desc: json["desc"],
        count: json["count"],
        listenTimes: json["listen_times"],
        loveCount: json["love_count"],
      );

  String album;
  String artUri;
  String artist;
  int classify;
  int count;
  String desc;
  int id;
  int listenTimes;
  int loveCount;
  List<Media> mediaItems;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "ID": id,
        "album": album,
        "artist": artist,
        "classify": classify,
        "media_items": mediaItems,
        "artUri": artUri,
        "desc": desc,
        "count": count,
        "listen_times": listenTimes,
        "love_count": loveCount,
      };

  String imageUrl() {
    return "${Global.ossPre}$artist/$album/${artUri}";
  }

  String listenTime() {
    return "${artist} · ${listenTimes}次收听";
  }

  MediaItem mediaItem(index) {
    return MediaItem(
        id: index.toString(),
        title: mediaItems[index]
            .title
            .substring(0, mediaItems[index].title.length - 4),
        album: album,
        artist: artist,
        duration: Duration(seconds: mediaItems[index].duration),
        artUri: Uri.parse(imageUrl()),
        extras: {
          'url': index == 0
              ? '${Global.ossPre}$artist/$album/${mediaItems[index].title}'
              : '${Global.ossPre}$artist/$album/${mediaItems[index].title}-end',
        });
  }

  String cachedKey() {
    return imageUrl();
  }

  AlbumItemDB convertToAlbumItemDB() {
    return AlbumItemDB.fromJson(toJson());
  }
}

class Media {
  Media({
    required this.duration,
    required this.title,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        duration: json["duration"],
        title: json["title"],
      );

  int duration;
  String title;

  Map<String, dynamic> toJson() => {
        "duration": duration,
        "title": title,
      };
}
