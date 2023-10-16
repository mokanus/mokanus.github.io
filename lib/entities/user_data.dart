import 'dart:convert';

class UserData {
  String name;
  String userId;
  String avatar;
  bool isVip;

  UserData({
    required this.name,
    required this.userId,
    required this.avatar,
    required this.isVip,
  });

  factory UserData.fromJson(String str) => UserData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
        name: json["name"],
        userId: json["userId"],
        avatar: json["avatar"],
        isVip: json["isVip"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "userId": userId,
        "avatar": avatar,
        "isVip": isVip,
      };
}
