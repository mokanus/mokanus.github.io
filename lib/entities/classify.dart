// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

import 'dart:convert';

import 'package:tingfm/global/global.dart';

class ClassifyRsp {
  ClassifyRsp({
    required this.status,
    required this.data,
    required this.msg,
    required this.error,
  });

  int status;
  List<ClassifyItem> data;
  String msg;
  String error;

  factory ClassifyRsp.fromJson(String str) =>
      ClassifyRsp.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClassifyRsp.fromMap(Map<String, dynamic> json) => ClassifyRsp(
        status: json["status"],
        data: List<ClassifyItem>.from(
            json["data"].map((x) => ClassifyItem.fromMap(x))),
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

class ClassifyItem {
  ClassifyItem({
    required this.id,
    required this.classify,
    required this.imgUrl,
  });

  int id;
  String classify;
  String imgUrl;

  factory ClassifyItem.fromJson(String str) =>
      ClassifyItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClassifyItem.fromMap(Map<String, dynamic> json) => ClassifyItem(
        id: json["id"],
        classify: json["classify"],
        imgUrl: json["img_url"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "classify": classify,
        "img_url": imgUrl,
      };

  String imageUrl() {
    return "${Global.ossPre}$imgUrl";
  }

  String cachedKey() {
    return imgUrl;
  }
}
