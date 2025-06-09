import 'dart:convert';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/errors/error_mapper.dart';
import 'package:davyking/core/services/secure_storage_service.dart';
import 'package:davyking/core/utils/snackbar.dart';
import 'package:davyking/core/models/user_auth_response_model.dart';
import 'package:davyking/features/profile/data/model/edit_profile_request_model.dart';
import 'package:davyking/features/profile/data/repositories/edit_profile_repository.dart';
import 'package:davyking/core/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final UserAuthDetailsController authDetailsController =
      Get.find<UserAuthDetailsController>();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  var obscurePassword = true.obs;

  final EditProfileRepository editrepo = EditProfileRepository();

  // Loading states
  final isLoading = false.obs;
  final isDeletingAccount = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize controllers with user data
    nameController.text = authDetailsController.user.value?.name ?? "";
    emailController.text = authDetailsController.user.value?.email ?? "";
    phoneController.text = authDetailsController.user.value?.phone ?? "";
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  /// Edit profile function
  Future<void> editProfile() async {
    isLoading.value = true;

    final request = EditProfileRequest(
        id: authDetailsController.user.value?.id.toString() ?? "",
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim());

    try {
      User response = await editrepo.editProfile(request);
      Get.find<UserAuthDetailsController>().updateUser(response);
      await _storeAuthDetails(response);

      showSnackbar("Success", "Edit profile successful!", isError: false);
    } catch (e) {
      final failure = ErrorMapper.map(e as Exception);
      showSnackbar("Error", failure.message);
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete account function
  Future<void> deleteAccount() async {
    final userId = authDetailsController.user.value?.id.toString();

    if (userId == null || userId.isEmpty) {
      showSnackbar("Error", "Unable to delete account: User ID not found");
      return;
    }

    isDeletingAccount.value = true;

    // try {
    //   // Check if account can be deleted
    //   // await _checkAccountDeletionStatus(userId);

    //   // Proceed with deletion
    //   final success = await editrepo.deleteAccount(userId);

    //   if (success) {
    //     // Clear all user data and logout
    //     await _clearUserData();

    //     showSnackbar(
    //         "Account Deleted", "Your account has been permanently deleted",
    //         isError: false);

    //     // Navigate to sign-in screen
    //     Get.offAllNamed(RoutesConstant.signin);
    //   } else {
    //     showSnackbar("Error", "Failed to delete account. Please try again.");
    //   }
    // } catch (e) {
    //   final failure = ErrorMapper.map(e as Exception);
    //   showSnackbar("Error", failure.message);
    // } finally {
    //   isDeletingAccount.value = false;
    // }
  }

  /// Check if account can be deleted (optional pre-check)
  // Future<void> _checkAccountDeletionStatus(String userId) async {
  //   try {
  //     final status = await editrepo.getAccountDeletionStatus(userId);

  //     // Handle any pre-deletion requirements
  //     if (status['canDelete'] == false) {
  //       final reason = status['reason'] ?? 'Account cannot be deleted at this time';
  //       throw Exception(reason);
  //     }

  //     // Check for pending transactions
  //     if (status['pendingTransactions'] == true) {
  //       throw Exception('Cannot delete account: You have pending transactions. Please wait for them to complete.');
  //     }

  //     // Check for outstanding balance
  //     if (status['hasBalance'] == true) {
  //       throw Exception('Cannot delete account: Please withdraw your remaining balance first.');
  //     }

  //   } catch (e) {
  //     // If status check fails, continue with deletion attempt
  //     // The actual deletion API will handle validation
  //     print('Account deletion status check failed: $e');
  //   }
  // }

  /// Clear all user data from device
  Future<void> _clearUserData() async {
    try {
      final storageService = SecureStorageService();

      // Clear stored authentication data
      await storageService.deleteData('auth_token');
      await storageService.deleteData('user_details');
      await storageService.deleteData('user_has');

      // Clear any other stored user preferences/data
      await storageService.deleteData('user_preferences');
      await storageService.deleteData('last_login');

      // Clear user from auth controller
      // authDetailsController.clearUser();
    } catch (e) {
      print('Error clearing user data: $e');
      // Continue with logout even if clearing fails
    }
  }

  /// Show account deletion confirmation dialog
  void showDeleteAccountDialog() {
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
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete your account? This action cannot be undone.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'This will permanently delete:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• All your personal information\n'
              '• Transaction history\n'
              '• Account balance\n'
              '• All stored preferences',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF666666),
                height: 1.5,
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
          Obx(() => isDeletingAccount.value
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
                    deleteAccount();
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

  // Store authentication details
  Future<void> _storeAuthDetails(User response) async {
    final storageService = SecureStorageService();
    await storageService.saveData(
        'user_details', jsonEncode(response.toJson()));
  }
}
