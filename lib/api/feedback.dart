import 'package:flutter/material.dart';
import 'package:tingfm/utils/http.dart';

class FeedbackAPI {
  static Future<void> feedback({
    required BuildContext context,
    required String url,
    dynamic params,
  }) async {
    try {
      await HttpUtil().post(
        url,
        parameters: params,
      );
    } catch (e) {
      return;
    }
  }
}
