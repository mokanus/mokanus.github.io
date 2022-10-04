// To parse this JSON data, do
//
//     final coordinate = coordinateFromJson(jsonString);

import 'dart:convert';

class Coordinate {
  Coordinate({
    required this.classifyItems,
  });

  List<ClassifyItem> classifyItems;

  factory Coordinate.fromRawJson(String str) =>
      Coordinate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Coordinate.fromJson(Map<String, dynamic> json) => Coordinate(
        classifyItems: List<ClassifyItem>.from(
            json["classify_items"].map((x) => ClassifyItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "classify_items":
            List<dynamic>.from(classifyItems.map((x) => x.toJson())),
      };
}

class ClassifyItem {
  ClassifyItem({
    required this.albumsNum,
    required this.name,
    required this.url,
  });

  String albumsNum;
  String name;
  String url;

  factory ClassifyItem.fromRawJson(String str) =>
      ClassifyItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClassifyItem.fromJson(Map<String, dynamic> json) => ClassifyItem(
        albumsNum: json["albums_num"],
        name: json["name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "albums_num": albumsNum,
        "name": name,
        "url": url,
      };
}
