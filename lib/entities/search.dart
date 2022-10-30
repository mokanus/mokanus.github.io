import 'dart:convert';
import 'package:tingfm/entities/album.dart';

class SearchRsp {
  SearchRsp({
    required this.status,
    required this.data,
    required this.msg,
    required this.error,
  });

  int status;
  List<AlbumItem> data;
  String msg;
  String error;

  factory SearchRsp.fromJson(String str) => SearchRsp.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchRsp.fromMap(Map<String, dynamic> json) => SearchRsp(
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
