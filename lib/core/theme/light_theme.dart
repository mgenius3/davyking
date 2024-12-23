import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData lightTheme() {
  return ThemeData(
    scaffoldBackgroundColor: LightThemeColors.background,
    brightness: Brightness.light,
    textTheme: TextTheme(
      displayLarge: TextStyle(color: LightThemeColors.textColor, fontSize: 18),
      displayMedium: TextStyle(color: LightThemeColors.textColor, fontSize: 14),
      displaySmall: TextStyle(color: LightThemeColors.textColor, fontSize: 12),
    ),
    fontFamily: 'Poppins',
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: LightThemeColors.primaryColor,
        selectionHandleColor: LightThemeColors.primaryColor,
        selectionColor: LightThemeColors.primaryColor),
    inputDecorationTheme: InputDecorationTheme(
      // Set the default text style for inputs
      hintStyle:
          TextStyle(color: LightThemeColors.textColor), // Hint text color
      labelStyle:
          TextStyle(color: LightThemeColors.textColor), // Label text color
    ),
  );
}
