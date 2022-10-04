import 'package:vibration/vibration.dart';

class Vibrate {
  static void doVibrate(
      {int duration = 500,
      List<int> pattern = const [],
      int repeat = -1,
      List<int> intensities = const [],
      int amplitude = -1}) {
    Vibration.vibrate(
        duration: duration,
        pattern: pattern,
        repeat: repeat,
        intensities: intensities,
        amplitude: amplitude);
  }
}
