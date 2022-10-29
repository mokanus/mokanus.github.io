import 'dart:convert';
import 'package:tingfm/entities/album.dart';

class AlbumInfoRsp {
  AlbumInfoRsp({
    required this.status,
    required this.data,
    required this.msg,
    required this.error,
  });

  int status;
  AlbumItem data;
  String msg;
  String error;

  factory AlbumInfoRsp.fromJson(String str) =>
      AlbumInfoRsp.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AlbumInfoRsp.fromMap(Map<String, dynamic> json) => AlbumInfoRsp(
        status: json["status"],
        data: AlbumItem.fromMap(json["data"]),
        msg: json["msg"],
        error: json["error"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "data": data.toMap(),
        "msg": msg,
        "error": error,
      };
}
