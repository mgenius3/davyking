import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData darkTheme() {
  return ThemeData(
    scaffoldBackgroundColor: DarkThemeColors.background,
    brightness: Brightness.dark,
    textTheme: TextTheme(
      displayLarge: TextStyle(color: DarkThemeColors.textColor, fontSize: 17),
      displayMedium: TextStyle(color: DarkThemeColors.textColor, fontSize: 14),
      displaySmall: TextStyle(color: DarkThemeColors.textColor, fontSize: 12),
    ),
    fontFamily: 'Poppins',
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: DarkThemeColors.primaryColor,
        selectionHandleColor: DarkThemeColors.primaryColor,
        selectionColor: DarkThemeColors.primaryColor),
    inputDecorationTheme: InputDecorationTheme(
      // Set the default text style for inputs
      hintStyle: TextStyle(color: DarkThemeColors.textColor), // Hint text color
      labelStyle:
          TextStyle(color: DarkThemeColors.textColor), // Label text color
    ),
  );
}
