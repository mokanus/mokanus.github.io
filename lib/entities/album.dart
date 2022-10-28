// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class AlbumRsp {
  AlbumRsp({
    required this.status,
    required this.data,
    required this.msg,
    required this.error,
  });

  int status;
  List<AlbumItem> data;
  String msg;
  String error;

  factory AlbumRsp.fromJson(String str) => AlbumRsp.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AlbumRsp.fromMap(Map<String, dynamic> json) => AlbumRsp(
        status: json["status"],
        data:
            List<AlbumItem>.from(json["data"].map((x) => AlbumItem.fromMap(x))),
        msg: json["msg"],
        error: json["error"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "msg": msg,
        "error": error,
      };
}

class AlbumItem {
  AlbumItem({
    required this.id,
    required this.album,
    required this.artist,
    required this.classify,
    required this.artUri,
    required this.desc,
    required this.count,
    required this.listenTimes,
    required this.loveCount,
  });

  int id;
  String album;
  String artist;
  int classify;
  String artUri;
  String desc;
  int count;
  int listenTimes;
  int loveCount;

  factory AlbumItem.fromJson(String str) => AlbumItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AlbumItem.fromMap(Map<String, dynamic> json) => AlbumItem(
        id: json["ID"],
        album: json["album"],
        artist: json["artist"],
        classify: json["classify"],
        artUri: json["artUri"],
        desc: json["desc"],
        count: json["count"],
        listenTimes: json["listen_times"],
        loveCount: json["love_count"],
      );

  Map<String, dynamic> toMap() => {
        "ID": id,
        "album": album,
        "artist": artist,
        "classify": classify,
        "artUri": artUri,
        "desc": desc,
        "count": count,
        "listen_times": listenTimes,
        "love_count": loveCount,
      };
}
