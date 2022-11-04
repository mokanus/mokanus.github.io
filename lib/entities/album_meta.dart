// To parse this JSON data, do
//
//     final albumMeta = albumMetaFromMap(jsonString);

import 'dart:convert';

class AlbumMeta {
  AlbumMeta({
    required this.hour,
    required this.minu,
    required this.second,
    required this.index,
    required this.album,
    required this.title,
  });

  int hour;
  int minu;
  int second;
  int index;
  String album;
  String title;

  factory AlbumMeta.fromJson(String str) => AlbumMeta.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AlbumMeta.fromMap(Map<String, dynamic> json) => AlbumMeta(
        hour: json["hour"],
        minu: json["minu"],
        second: json["second"],
        index: json["index"],
        album: json["album"],
        title: json["title"],
      );

  Map<String, dynamic> toMap() => {
        "hour": hour,
        "minu": minu,
        "second": second,
        "index": index,
        "album": album,
        "title": title,
      };
}
