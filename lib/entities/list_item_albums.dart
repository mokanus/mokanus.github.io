// To parse this JSON data, do
//
//     final albums = albumsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class Albums {
  Albums({
    required this.data,
    required this.error,
    required this.msg,
    required this.status,
  });

  List<Datum> data;
  String error;
  String msg;
  double status;

  factory Albums.fromRawJson(String str) {
    print("----->2");
    print(str);
    return Albums.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  factory Albums.fromJson(Map<String, dynamic> json) {
    return Albums(
      data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      error: json["error"],
      msg: json["msg"],
      status: json["status"].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "error": error,
        "msg": msg,
        "status": status,
      };
}

class Datum {
  Datum({
    required this.album,
    required this.artist,
    required this.artUri,
    required this.count,
    required this.id,
    required this.title,
  });

  String album;
  String artist;
  String artUri;
  String count;
  String id;
  String title;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        album: json["album"],
        artist: json["artist"],
        artUri: json["artUri"],
        count: json["count"],
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "album": album,
        "artist": artist,
        "artUri": artUri,
        "count": count,
        "id": id,
        "title": title,
      };
}
