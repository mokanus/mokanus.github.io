// 专辑种类的model类

import 'package:flutter/material.dart';
import 'package:tingfm/entities/classify.dart';
import 'package:tingfm/utils/http.dart';

class ClassifyAPI {
  static Future<ClassifyRsp?> getClassifies({
    required BuildContext context,
    required String url,
    dynamic params,
  }) async {
    try {
      var response = await HttpUtil().post(
        url,
        parameters: params,
      );
      return ClassifyRsp.fromJson(response.toString());
    } catch (e) {
      return null;
    }
  }
}
