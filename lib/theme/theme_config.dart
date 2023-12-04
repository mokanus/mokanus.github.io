import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeConfig {
  static Color lightPrimary = Colors.white;
  static Color darkPrimary = const Color(0xFF222429);
  // static Color lightAccent = Color(0xff2ca8e2);
  static Color lightAccent = Colors.red;

  static Color darkAccent = Colors.red;
  // static Color darkAccent = Color(0xff2ca8e2);
  static Color lightBG = Colors.white;
  static Color darkBG = const Color(0xFF222429);
  static Color darkCard = const Color(0xff303238);

  static Color lightTitleCategory = Colors.black54;
  static Color darkTitleCategory = Colors.white54;

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(255, 246, 246, 246),
    shadowColor: const Color.fromARGB(255, 245, 245, 245),
    cardTheme: const CardTheme(
      color: Color.fromARGB(255, 254, 254, 254),
      surfaceTintColor: Colors.transparent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 246, 246, 246),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      foregroundColor: Colors.black,
      surfaceTintColor: Colors.transparent,
    ),
    sliderTheme: const SliderThemeData(
      thumbColor: Color.fromARGB(255, 234, 78, 94),
      activeTrackColor: Color.fromARGB(120, 234, 78, 94),
      overlayColor: Color.fromARGB(120, 234, 78, 94),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimary,
    scaffoldBackgroundColor: darkBG,
    cardTheme: CardTheme(surfaceTintColor: Colors.transparent, color: darkCard),
    hintColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
      elevation: 0.0,
      surfaceTintColor: Colors.transparent,
    ),
  );
}
