import 'package:davyking/features/common/controllers/primary_button_controller.dart';
import 'package:flutter/material.dart';

class CustomPrimaryButton extends StatelessWidget {
  final CustomPrimaryButtonController controller;

  const CustomPrimaryButton({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = controller.model;

    return Container(
      width: model.width != 0.0 ? model.width : double.infinity,
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: controller.getButtonDecoration(),
      child: MaterialButton(
        onPressed: controller.onPressed,
        child: model.child ??
            Text(model.text ?? '',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: model.textColor ?? Colors.white)),
      ),
    );
  }
}
