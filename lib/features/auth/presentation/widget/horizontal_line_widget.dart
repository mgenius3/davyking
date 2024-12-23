import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget horizontalLine() {
  return Container(
    width: Get.context!.width * .35,
    decoration: ShapeDecoration(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          strokeAlign: BorderSide.strokeAlignCenter,
          color: Colors.black.withOpacity(0.5),
        ),
      ),
    ),
  );
}
