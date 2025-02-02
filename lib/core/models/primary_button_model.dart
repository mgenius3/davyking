import 'package:flutter/material.dart';

class CustomPrimaryButtonModel {
  final String? text;
  final double width;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final bool shadow;
  final Widget? child;

  const CustomPrimaryButtonModel({
    this.text,
    this.width = 0.0,
    this.color,
    this.borderColor,
    this.textColor,
    this.shadow = false,
    this.child,
  });
}
