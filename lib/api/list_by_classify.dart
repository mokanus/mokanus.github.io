// 专辑种类的model类

import 'package:flutter/material.dart';
import 'package:tingfm/entities/list_by_classify.dart';
import 'package:tingfm/utils/http.dart';

class ListByClassifyAPI {
  static Future<ListByClassifyRsp?> getAlbumsByClassify({
    required BuildContext context,
    required String url,
    dynamic params,
  }) async {
    try {
      var response = await HttpUtil().post(
        url,
        parameters: params,
      );
      return ListByClassifyRsp.fromJson(response.toString());
    } catch (e) {
      return null;
    }
  }
}
