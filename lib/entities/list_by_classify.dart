// To parse this JSON data, do
//
//     final listByClassifyRsp = listByClassifyRspFromMap(jsonString);

import 'dart:convert';

import 'package:tingfm/entities/album.dart';

class ListByClassifyRsp {
  ListByClassifyRsp({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  Data data;

  factory ListByClassifyRsp.fromJson(String str) =>
      ListByClassifyRsp.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ListByClassifyRsp.fromMap(Map<String, dynamic> json) =>
      ListByClassifyRsp(
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
    required this.albums,
  });

  List<AlbumItem> albums;

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        albums: List<AlbumItem>.from(
            json["albums"].map((x) => AlbumItem.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "albums": List<dynamic>.from(albums.map((x) => x.toMap())),
      };
}
