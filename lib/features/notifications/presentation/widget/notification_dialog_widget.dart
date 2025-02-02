import 'package:davyking/core/constants/images.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/states/mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

Widget notifationDialogWidget(BuildContext context) {
  final LightningModeController lightningModeController =
      Get.find<LightningModeController>();

  return Obx(() => Center(
          child: Container(
        decoration: BoxDecoration(
            color: lightningModeController.currentMode.value.mode == "light"
                ? LightThemeColors.background
                : DarkThemeColors.background,
            borderRadius: BorderRadius.circular(20)),
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(SvgConstant.notifictionBell),
            Text('Read all notifications',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.38,
                    letterSpacing: -0.41)),
            const SizedBox(height: 20),
            Text('Do you want to mark all notifications\nas read?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.57,
                    letterSpacing: -0.41)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('Cancel',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              color: LightThemeColors.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 1.57,
                              letterSpacing: -0.41)),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                        color: DarkThemeColors.primaryColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: TextButton(
                      onPressed: () {},
                      child: Text('Agree',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 1.57,
                                  letterSpacing: -0.41)),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      )));
}
