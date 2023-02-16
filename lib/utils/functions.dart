import 'package:flutter/material.dart';

class Functions {
  static isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static bool checkConnectionError(e) {
    if (e.toString().contains('SocketException') ||
        e.toString().contains('HandshakeException')) {
      return true;
    } else {
      return false;
    }
  }

  static String numToUnit(int num) {
    if (num >= 1000) {
      return '${num / 1000}千';
    } else if (num >= 10000) {
      return '${num / 10000}万';
    } else if (num >= 100000) {
      return '${num / 100000}十万';
    } else if (num >= 1000000) {
      return '${num / 1000000}百万';
    } else if (num >= 10000000) {
      return '${num / 10000000}千万';
    }
    return num.toString();
  }
}
