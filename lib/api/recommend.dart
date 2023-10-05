// 专辑种类的model类

import 'package:flutter/material.dart';
import 'package:tingfm/entities/recommend.dart';
import 'package:tingfm/utils/http.dart';

class RecommendAPI {
  static Future<RecommendAlbumsRsp?> recommendAlbums({
    required BuildContext context,
    required String url,
    dynamic params,
  }) async {
    try {
      var response = await HttpUtil().post(
        url,
        parameters: params,
      );
      print(response);
      return RecommendAlbumsRsp.fromJson(response.toString());
    } catch (e) {
      return null;
    }
  }
}
