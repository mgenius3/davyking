import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/features/common/data/models/primary_button_model.dart';
import 'package:flutter/material.dart';

class CustomPrimaryButtonController {
  final CustomPrimaryButtonModel model;
  final VoidCallback onPressed;

  CustomPrimaryButtonController({
    required this.model,
    required this.onPressed,
  });

  BoxDecoration getButtonDecoration() {
    return BoxDecoration(
      boxShadow: model.shadow
          ? [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25), // shadow color
                spreadRadius: 5, // spread radius
                blurRadius: 45, // blur radius
                offset: const Offset(0, -15), // changes position of shadow
              ),
            ]
          : null,
      border:
          Border.all(color: model.borderColor ?? LightThemeColors.primaryColor),
      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
      color: model.color ?? LightThemeColors.primaryColor,
    );
  }
}
