// 专辑种类的model类

import 'package:flutter/material.dart';
import 'package:tingfm/entities/search.dart';
import 'package:tingfm/utils/http.dart';

class SearchAPI {
  static Future<SearchRsp?> searchAlbums({
    required BuildContext context,
    required String url,
    dynamic params,
  }) async {
    try {
      var response = await HttpUtil().post(
        url,
        parameters: params,
      );
      return SearchRsp.fromJson(response.toString());
    } catch (e) {
      return null;
    }
  }
}
