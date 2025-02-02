import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/features/home/data/model/header_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:davyking/core/states/mode.dart';

Widget homeHeaderWidget(HomeHeaderModel data) {
  final LightningModeController lightningModeController =
      Get.find<LightningModeController>();

  return Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32.22,
                height: 33.37,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                      image: NetworkImage(data.profileUrl ??
                          "https://via.placeholder.com/32x33"),
                      fit: BoxFit.fill),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11.51)),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  Text(
                    'Hi ${data.firstName}',
                    style: Theme.of(Get.context!)
                        .textTheme
                        .displayMedium
                        ?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.17),
                  ),
                  Text(
                    'Good Morning',
                    style: Theme.of(Get.context!)
                        .textTheme
                        .displayMedium
                        ?.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
                  )
                ],
              )
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(RoutesConstant.notification);
                },
                child: Container(
                  // width: 25,
                  // height: 24,
                  padding: const EdgeInsets.all(2),
                  decoration: ShapeDecoration(
                    color: lightningModeController.currentMode.value.mode ==
                            "light"
                        ? const Color(0xFFDFF7E2)
                        : DarkThemeColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Icon(Icons.notification_important),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                  padding: const EdgeInsets.all(2),
                  decoration: ShapeDecoration(
                    color: lightningModeController.currentMode.value.mode ==
                            "light"
                        ? const Color(0xFFDFF7E2)
                        : DarkThemeColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Icon(Icons.settings))
            ],
          )
        ],
      ));
}
