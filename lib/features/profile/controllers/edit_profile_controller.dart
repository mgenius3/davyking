import 'dart:convert';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/errors/error_mapper.dart';
import 'package:davyking/core/services/secure_storage_service.dart';
import 'package:davyking/core/utils/snackbar.dart';
import 'package:davyking/core/models/user_auth_response_model.dart';
import 'package:davyking/features/profile/data/model/edit_profile_request_model.dart';
import 'package:davyking/features/profile/data/repositories/edit_profile_repository.dart';
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

  // Loading
  final isLoading = false.obs;

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

// Sign-in function
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
      // await _updateApiToken();

      showSnackbar("Success", "Edit profile successful!", isError: false);
      // Get.offNamed(RoutePaths.tab_nav);
    } catch (e) {
      final failure = ErrorMapper.map(e as Exception);
      showSnackbar("Error", failure.message);
    } finally {
      isLoading.value = false;
    }
  }

  // Store authentication details
  Future<void> _storeAuthDetails(User response) async {
    final storageService = SecureStorageService();
    await storageService.saveData(
        'user_details', jsonEncode(response.toJson()));
  }
}
