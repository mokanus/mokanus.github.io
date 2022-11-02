import 'dart:convert';

import 'package:hive/hive.dart';
part 'album_db.g.dart';

@HiveType(typeId: 0)
class AlbumItemDB {
  AlbumItemDB({
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
  @HiveField(0)
  String album;
  @HiveField(1)
  String artUri;
  @HiveField(2)
  String artist;
  @HiveField(3)
  int classify;
  @HiveField(4)
  int count;
  @HiveField(5)
  String desc;
  @HiveField(6)
  int id;
  @HiveField(7)
  int listenTimes;
  @HiveField(8)
  int loveCount;
  @HiveField(9)
  List<Media> mediaItems;

  factory AlbumItemDB.fromJson(String str) =>
      AlbumItemDB.fromMap(json.decode(str));

  factory AlbumItemDB.fromMap(Map<String, dynamic> json) => AlbumItemDB(
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
}

@HiveType(typeId: 0)
class Media {
  Media({
    required this.duration,
    required this.title,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        duration: json["duration"],
        title: json["title"],
      );

  @HiveField(0)
  int duration;
  @HiveField(2)
  String title;

  Map<String, dynamic> toJson() => {
        "duration": duration,
        "title": title,
      };
}
