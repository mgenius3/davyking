import 'package:davyking/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/model/profile_list_model.dart';
import 'package:get/get.dart';
import 'package:davyking/core/states/mode.dart';

Widget profileListWidget({required ProfileListModel data}) {
  final LightningModeController lightningModeController =
      Get.find<LightningModeController>();

  return Row(
    children: [
      Container(
        width: 33.49,
        height: 30.96,
        padding: const EdgeInsets.symmetric(vertical: 1.90),
        decoration: ShapeDecoration(
          color: data.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.86),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Icon(data.icon)],
        ),
      ),
      const SizedBox(width: 12),
      Text(data.profileListName,
          style: TextStyle(
              color: lightningModeController.currentMode.value.mode == "light"
                  ? LightThemeColors.shade
                  : DarkThemeColors.shade,
              fontSize: 13,
              fontWeight: FontWeight.w500))
    ],
  );
}
