// 专辑种类的model类

import 'package:flutter/material.dart';
import 'package:tingfm/entities/list_item_albums.dart';
import 'package:tingfm/utils/http.dart';

class RecommendAPI {
  static Future<Albums?> recommendAlbums({
    required BuildContext context,
    required String url,
    dynamic params,
  }) async {
    try {
      var response = await HttpUtil().post(
        url,
        parameters: params,
      );
      print("----->1");
      print(response);
      return Albums.fromRawJson(response.toString());
    } catch (e) {
      print("----->3");
      print(e);
      return null;
    }
  }
}
