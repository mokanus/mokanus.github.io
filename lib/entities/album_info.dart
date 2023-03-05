// To parse this JSON data, do
//
//     final albumInfoRsp = albumInfoRspFromMap(jsonString);

import 'dart:convert';

import 'package:tingfm/entities/album.dart';

class AlbumInfoRsp {
  AlbumInfoRsp({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  Data data;

  factory AlbumInfoRsp.fromJson(String str) =>
      AlbumInfoRsp.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AlbumInfoRsp.fromMap(Map<String, dynamic> json) => AlbumInfoRsp(
        code: json["code"],
        message: json["message"],
        data: Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "message": message,
        "data": data.toMap(),
      };
}

class Data {
  Data({
    required this.album,
  });

  AlbumItem album;

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        album: AlbumItem.fromMap(json["album"]),
      );

  Map<String, dynamic> toMap() => {
        "album": album.toMap(),
      };
}
