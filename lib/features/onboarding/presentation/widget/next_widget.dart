import 'package:davyking/core/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget nextButton(Function nextPage) {
  return GestureDetector(
    onTap: () {
      nextPage();
    },
    child: Container(
        width: 48.81,
        height: 48.81,
        decoration: ShapeDecoration(
          color: LightThemeColors.buttonColor,
          shape: const OvalBorder(),
        ),
        child: Container(
          width: 29.29,
          height: 29.29,
          child: const Icon(CupertinoIcons.forward),
        )),
  );
}
