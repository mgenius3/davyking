import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:davyking/core/states/mode.dart';

class HomeHeaderWidget extends StatelessWidget {
  HomeHeaderWidget({super.key});

  final LightningModeController lightningModeController =
      Get.find<LightningModeController>();
  final UserAuthDetailsController authController =
      Get.find<UserAuthDetailsController>();

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else if (hour < 20) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 32.22,
              height: 33.37,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: DarkThemeColors.primaryColor),
              child: const Icon(Icons.person_2),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, ${authController.user.value?.name ?? "User"}',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.17),
                ),
                const SizedBox(height: 5),
                Text(
                  getGreeting(),
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
                )
              ],
            )
          ],
        ),
        Obx(
          () => Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(RoutesConstant.notification);
                },
                child: Container(
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
                child: const Icon(Icons.settings),
              )
            ],
          ),
        )
      ],
    );
  }
}
