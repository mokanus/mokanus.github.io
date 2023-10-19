import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:tingfm/utils/global.dart';
part 'album_db.g.dart';

@HiveType(typeId: 0)
class AlbumItemDB {
  AlbumItemDB({
    required this.id,
    required this.album,
    required this.artist,
    required this.artUri,
  });
  @HiveField(0)
  String album;
  @HiveField(1)
  String artUri;
  @HiveField(2)
  String artist;
  @HiveField(3)
  int id;

  factory AlbumItemDB.fromJson(String str) =>
      AlbumItemDB.fromMap(json.decode(str));

  factory AlbumItemDB.fromMap(Map<String, dynamic> json) => AlbumItemDB(
        id: json["id"],
        album: json["album"],
        artist: json["artist"],
        artUri: json["artUri"],
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "id": id,
        "album": album,
        "artist": artist,
        "artUri": artUri,
      };

  String imageUrl() {
    return "${Global.ossPre}/$artist/$album/$artUri";
  }

  String cachedKey() {
    return imageUrl();
  }
}
