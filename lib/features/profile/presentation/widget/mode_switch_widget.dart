import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/features/profile/controllers/mode_switch_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget modeSwitch() {
  final ModeSwitchController controller = Get.put(ModeSwitchController());

  return Obx(() => GestureDetector(
        onTap: controller.toggleSwitch,
        child: Container(
          width: 60,
          height: 30,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: controller.isOn.value
                ? LightThemeColors.primaryColor
                : Colors.grey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: controller.isOn.value
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle)),
          ),
        ),
      ));
}
