import 'dart:convert';

// 用来保存专辑当前历史播放位置的数据结构
class AlbumMeta {
  AlbumMeta({
    required this.album,
    required this.title,
    required this.index,
    required this.hour,
    required this.minu,
    required this.second,
  });

  int index;
  String album;
  String title;
  int hour;
  int minu;
  int second;

  factory AlbumMeta.fromJson(Map<String, dynamic> json) => AlbumMeta(
        hour: json["hour"],
        minu: json["minu"],
        second: json["second"],
        index: json["index"],
        album: json["album"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "hour": hour,
        "minu": minu,
        "second": second,
        "index": index,
        "album": album,
        "title": title,
      };
}

AlbumMeta fromJson(String str) => AlbumMeta.fromJson(json.decode(str));

String toJson(AlbumMeta data) => json.encode(data.toJson());
