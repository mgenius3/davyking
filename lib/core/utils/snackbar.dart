import 'package:davyking/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackbar(String title, String message, {bool isError = true}) {
  Get.snackbar(
    title,
    message,
    backgroundColor: isError ? Colors.red : DarkThemeColors.primaryColor,
    colorText: Colors.white,
  );
}
