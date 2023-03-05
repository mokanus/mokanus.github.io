// To parse this JSON data, do
//
//     final classifyRsp = classifyRspFromMap(jsonString);

import 'dart:convert';

import 'package:tingfm/utils/global.dart';

class ClassifyRsp {
  ClassifyRsp({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  Data data;

  factory ClassifyRsp.fromJson(String str) =>
      ClassifyRsp.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClassifyRsp.fromMap(Map<String, dynamic> json) => ClassifyRsp(
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
    required this.classifies,
  });

  List<Classify> classifies;

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        classifies: List<Classify>.from(
            json["classifies"].map((x) => Classify.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "classifies": List<dynamic>.from(classifies.map((x) => x.toMap())),
      };
}

class Classify {
  Classify({
    required this.id,
    required this.classify,
    required this.imgUrl,
  });

  int id;
  String classify;
  String imgUrl;

  factory Classify.fromJson(String str) => Classify.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Classify.fromMap(Map<String, dynamic> json) => Classify(
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
