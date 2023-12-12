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

// UI Colors
  static Color kColorBar = Colors.black;
  static Color kColorText = Colors.black;
  static Color kColorAccent = const Color.fromRGBO(10, 115, 217, 1.0);
  static Color kColorError = Colors.red;
  static Color kColorSuccess = Colors.green;
  static Color kColorNavIcon = const Color.fromRGBO(131, 136, 139, 1.0);
  static Color kColorBackground = const Color.fromRGBO(30, 28, 33, 1.0);
  static Color kLightBackground = const Color.fromARGB(255, 246, 246, 246);

// Weather Colors
  static Color kWeatherReallyCold = const Color.fromRGBO(3, 75, 132, 1);
  static Color kWeatherCold = const Color.fromRGBO(0, 39, 96, 1);
  static Color kWeatherCloudy = const Color.fromRGBO(51, 0, 58, 1);
  static Color kWeatherSunny = const Color.fromRGBO(212, 70, 62, 1);
  static Color kWeatherHot = const Color.fromRGBO(181, 0, 58, 1);
  static Color kWeatherReallyHot = const Color.fromRGBO(204, 0, 58, 1);

// Text Styles
  static double kFontSizeSuperSmall = 10.0;
  static double kFontSizeSmall = 14.0;
  static double kFontSizeNormal = 16.0;
  static double kFontSizeMedium = 18.0;
  static double kFontSizeHead = 20.0;
  static double kFontSizeLarge = 96.0;

  static TextStyle kDescriptionTextStyle = TextStyle(
    color: kColorText,
    fontWeight: FontWeight.normal,
    fontSize: kFontSizeNormal,
  );

  static TextStyle kMinDescriptionTextStyle = TextStyle(
    color: kColorText,
    fontWeight: FontWeight.normal,
    fontSize: kFontSizeSmall,
  );

  static TextStyle kHeadTextStyle = TextStyle(
    color: kColorText,
    fontWeight: FontWeight.bold,
    fontSize: kFontSizeHead,
  );

  static TextStyle kTitleTextStyle = TextStyle(
    color: kColorText,
    fontWeight: FontWeight.bold,
    fontSize: kFontSizeMedium,
  );

// Inputs
  static double kButtonRadius = 10.0;

  static InputDecoration userInputDecoration = InputDecoration(
    fillColor: Colors.black,
    filled: true,
    hintText: 'Enter App User ID',
    hintStyle: TextStyle(color: kColorText),
    contentPadding:
        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(kButtonRadius)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black, width: 0),
      borderRadius: BorderRadius.all(Radius.circular(kButtonRadius)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(kButtonRadius)),
    ),
  );
}
