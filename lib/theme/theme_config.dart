import 'package:flutter/material.dart';

class ThemeConfig {
  static Color lightPrimary = Colors.white;
  static Color darkPrimary = Color(0xFF222429);
  // static Color lightAccent = Color(0xff2ca8e2);
  static Color lightAccent = Colors.red;

  static Color darkAccent = Colors.red;
  // static Color darkAccent = Color(0xff2ca8e2);
  static Color lightBG = Colors.white;
  static Color darkBG = Color(0xFF222429);
  static Color darkCard = Color(0xff303238);

  static Color lightTitleCategory = Colors.black54;
  static Color darkTitleCategory = Colors.white54;

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBG,
    cardColor: lightPrimary,
    toggleableActiveColor: lightAccent,
    appBarTheme: AppBarTheme(
      elevation: 0.0,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    scaffoldBackgroundColor: darkBG,
    cardColor: darkCard,
    appBarTheme: AppBarTheme(
      elevation: 0.0,
    ),
  );
}
