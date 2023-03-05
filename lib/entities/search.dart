// To parse this JSON data, do
//
//     final searchRsp = searchRspFromMap(jsonString);

import 'dart:convert';

import 'package:tingfm/entities/album.dart';

class SearchRsp {
  SearchRsp({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  Data data;

  factory SearchRsp.fromJson(String str) => SearchRsp.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchRsp.fromMap(Map<String, dynamic> json) => SearchRsp(
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
