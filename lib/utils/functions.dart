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
      return '${(num / 1000).toStringAsFixed(2)}千';
    } else if (num >= 10000) {
      return '${(num / 10000).toStringAsFixed(2)}万';
    } else if (num >= 100000) {
      return '${(num / 100000).toStringAsFixed(2)}十万';
    } else if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(2)}百万';
    } else if (num >= 10000000) {
      return '${(num / 10000000).toStringAsFixed(2)}千万';
    }
    return num.toString();
  }

  static String formatSeconds(int seconds) {
    int minutes = (seconds / 60).floor();
    int remainingSeconds = seconds % 60;

    String minutesStr = minutes < 10 ? '0$minutes' : '$minutes';
    String secondsStr =
        remainingSeconds < 10 ? '0$remainingSeconds' : '$remainingSeconds';

    return '$minutesStr:$secondsStr';
  }
}
