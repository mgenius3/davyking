import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/states/mode.dart';
import 'package:davyking/features/profile/data/model/profile_list_model.dart';
import 'package:davyking/features/profile/data/model/templates_model.dart';
import 'package:davyking/features/profile/presentation/widget/mode_switch_widget.dart';
import 'package:davyking/features/profile/presentation/widget/profile_list_widget.dart';
import 'package:davyking/features/profile/presentation/widget/templates_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileIndexScreen extends StatelessWidget {
  const ProfileIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LightningModeController lightningModeController =
        Get.find<LightningModeController>();

    return ProfileTemplatesWidget(
        data: ProfileTemplatesModel(
      title: "My Profile",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dark Mode',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              modeSwitch()
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
              onTap: () {
                Get.toNamed(RoutesConstant.editprofile);
              },
              child: profileListWidget(
                data: ProfileListModel(
                    color: lightningModeController.currentMode.value.mode ==
                            "light"
                        ? LightThemeColors.primaryColor
                        : DarkThemeColors.primaryColor,
                    profileListName: 'Edit Profile',
                    icon: Icons.person,
                    routes: RoutesConstant.editprofile),
              )),
          // const SizedBox(height: 20),
          // profileListWidget(
          //     data: ProfileListModel(
          //         color:
          //             lightningModeController.currentMode.value.mode == "light"
          //                 ? LightThemeColors.primaryColor
          //                 : DarkThemeColors.primaryColor,
          //         profileListName: 'Wallet',
          //         icon: Icons.wallet,
          //         routes: '')),
          const SizedBox(height: 20),

          GestureDetector(
              onTap: () {
                Get.toNamed(RoutesConstant.profileSecurity);
              },
              child: profileListWidget(
                  data: ProfileListModel(
                      color: lightningModeController.currentMode.value.mode ==
                              "light"
                          ? LightThemeColors.primaryColor
                          : DarkThemeColors.primaryColor,
                      profileListName: 'Security',
                      icon: Icons.security,
                      routes: RoutesConstant.profileSecurity))),
          const SizedBox(height: 20),

          GestureDetector(
              onTap: () {
                Get.toNamed(RoutesConstant.helpAndFaq);
              },
              child: profileListWidget(
                  data: ProfileListModel(
                      color: lightningModeController.currentMode.value.mode ==
                              "light"
                          ? LightThemeColors.primaryColor
                          : DarkThemeColors.primaryColor,
                      profileListName: 'Help & FAQ',
                      icon: Icons.support_agent,
                      routes: RoutesConstant.helpAndFaq))),
          const SizedBox(height: 20),

          GestureDetector(
              onTap: () {
                Get.toNamed(RoutesConstant.withdrawalBank);
              },
              child: profileListWidget(
                  data: ProfileListModel(
                      color: lightningModeController.currentMode.value.mode ==
                              "light"
                          ? LightThemeColors.primaryColor
                          : DarkThemeColors.primaryColor,
                      profileListName: 'Withdrawal Bank',
                      icon: Icons.account_balance,
                      routes: RoutesConstant.withdrawalBank))),
          const SizedBox(height: 70),
          GestureDetector(
            onTap: () async {
              await Get.find<UserAuthDetailsController>().logout();
              Get.offAllNamed(RoutesConstant.signin);
            },
            child: profileListWidget(
                data: ProfileListModel(
                    profileListName: 'Logout',
                    color: Colors.red,
                    icon: Icons.logout,
                    routes: RoutesConstant.signin)),
          ),
          SizedBox(height: Get.height * 0.1),
        ],
      ),
    ));
  }
}
