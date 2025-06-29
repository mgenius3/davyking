import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/utils/dimensions.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/states/mode.dart';
import 'package:davyking/core/widgets/bottom_navigation_widget.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:davyking/features/profile/data/model/templates_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileTemplatesWidget extends StatelessWidget {
  final ProfileTemplatesModel data;
  const ProfileTemplatesWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final LightningModeController lightningModeController =
        Get.find<LightningModeController>();
    final UserAuthDetailsController authDetailsController =
        Get.find<UserAuthDetailsController>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          color: lightningModeController.currentMode.value.mode == "light"
              ? const Color(0xFFDADADA)
              : const Color.fromARGB(255, 32, 31, 31),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    left: Dimensions.defaultLeftSpacing,
                    right: Dimensions.defaultRightSpacing,
                    top: Dimensions.defaultTopSpacing),
                child: TopHeaderWidget(data: TopHeaderModel(title: data.title)),
              ),
              Stack(
                clipBehavior: Clip.none, // Ensures no clipping of children
                children: [
                  Obx(
                    () =>
                        // SingleChildScrollView(
                        //       child:
                        Container(
                            width: Get.width,
                            height: Get.height - 300,
                            padding: const EdgeInsets.only(
                                left: Dimensions.defaultLeftSpacing,
                                right: Dimensions.defaultRightSpacing),
                            decoration: ShapeDecoration(
                              color: lightningModeController
                                          .currentMode.value.mode ==
                                      "light"
                                  ? LightThemeColors.background
                                  : DarkThemeColors.background,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                            ),
                            child: data.child),
                  )
                  // )
                  ,
                  if (data.showProfileDetails == true)
                    Positioned(
                      top:
                          -50, // Adjust this value to move the widget up or down
                      left: 0,
                      right: 0, // Ensures horizontal centering
                      child: Column(
                        children: [
                          Container(
                            width: 91.51,
                            height: 91.51,
                            decoration: ShapeDecoration(
                              image: const DecorationImage(
                                  image: AssetImage("assets/images/pfp.jpg"),
                                  fit: BoxFit.fill),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28.83)),
                            ),
                          ),
                          const SizedBox(height: 8), // Spacing between elements
                          Obx(() => Text(
                                authDetailsController.user.value?.name ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                        fontSize: 17.30,
                                        fontWeight: FontWeight.w600,
                                        height: 1.17),
                              )),
                          const SizedBox(height: 3), // Spacing between elements
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'ID: ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        fontSize: 12.49,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                TextSpan(
                                    text: authDetailsController.user.value?.id
                                            .toString() ??
                                        "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                            fontSize: 12.49,
                                            fontWeight: FontWeight.w300)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: const BottomNavigationWidget(currentIndex: 4)
    );
  }
}
