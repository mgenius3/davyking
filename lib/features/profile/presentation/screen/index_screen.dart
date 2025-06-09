import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/states/mode.dart';
import 'package:davyking/features/profile/data/model/profile_list_model.dart';
import 'package:davyking/features/profile/data/model/templates_model.dart';
import 'package:davyking/features/profile/presentation/widget/profile_list_widget.dart';
import 'package:davyking/features/profile/presentation/widget/templates_widget.dart';
import 'package:davyking/features/profile/controllers/edit_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileIndexScreen extends StatelessWidget {
  const ProfileIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LightningModeController lightningModeController =
        Get.find<LightningModeController>();
    final EditProfileController profileController =
        Get.put(EditProfileController());

    return ProfileTemplatesWidget(
        data: ProfileTemplatesModel(
      title: "My Profile",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       'Dark Mode',
          //       style: Theme.of(context)
          //           .textTheme
          //           .displayMedium
          //           ?.copyWith(fontSize: 13, fontWeight: FontWeight.w500),
          //     ),
          //     modeSwitch()
          //   ],
          // ),
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
          const SizedBox(height: 20),

          // Delete Account Option
          // GestureDetector(
          //   onTap: () {
          //     _showDeleteAccountDialog(context, profileController);
          //   },
          //   child: profileListWidget(
          //       data: ProfileListModel(
          //           profileListName: 'Delete Account',
          //           color: Colors.red,
          //           icon: Icons.delete_forever,
          //           routes: "")),
          // ),
          // const SizedBox(height: 20),
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

  void _showDeleteAccountDialog(
      BuildContext context, EditProfileController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.warning_rounded,
                color: Colors.red[700],
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Delete Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Are you sure you want to delete your account? This action cannot be undone.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 14,
                        color: Colors.red[700],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'This will permanently:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.red[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Delete all your personal data\n'
                    '• Remove your transaction history\n'
                    '• Cancel any pending transactions\n'
                    '• Log you out of all devices',
                    style: TextStyle(
                        fontSize: 11, color: Color(0xFF666666), height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 14,
                    color: Colors.amber[700],
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Consider logging out instead if you just want to switch accounts.',
                      style: TextStyle(fontSize: 11, color: Color(0xFF666666)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Obx(() => controller.isDeletingAccount.value
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.red,
                    ),
                  ),
                )
              : ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                    _showConfirmDeleteDialog(context, controller);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.delete_forever,
                        size: 16,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Delete Account',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                )),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showConfirmDeleteDialog(
      BuildContext context, EditProfileController controller) {
    final TextEditingController confirmationController =
        TextEditingController();

    Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Final Confirmation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.red,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Type "DELETE" to confirm account deletion:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmationController,
                decoration: InputDecoration(
                  hintText: 'Type DELETE here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.red[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                confirmationController.dispose();
                Get.back(); // Close dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Obx(() => controller.isDeletingAccount.value
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.red),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () {
                      if (confirmationController.text.trim() == 'DELETE') {
                        confirmationController.dispose();
                        // Get.back(); // Close dialog
                        controller.deleteAccount();
                      } else {
                        Get.snackbar(
                            'Error', 'Please type "DELETE" exactly to confirm',
                            backgroundColor: Colors.red[100],
                            colorText: Colors.red[800],
                            snackPosition: SnackPosition.TOP);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Confirm Delete',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  )),
          ],
        ),
        barrierDismissible: false);
  }
}
