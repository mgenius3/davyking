import 'dart:convert';

import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/errors/error_mapper.dart';
import 'package:davyking/core/errors/failure.dart';
import 'package:davyking/core/services/secure_storage_service.dart';
import 'package:davyking/core/utils/snackbar.dart';
import 'package:davyking/features/auth/data/models/sign_up_request_model.dart';
import 'package:davyking/core/models/user_auth_response_model.dart';
import 'package:davyking/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:davyking/api/api_client.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  var obscurePassword = true.obs;
  var checkedbox = false.obs;

  // Loading and error states
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  // Auth repository
  final AuthRepository authRepository = AuthRepository();

  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void checkBoxChanged(bool? checkedboxchanges) {
    checkedbox.value = checkedboxchanges ?? false;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    passwordConfirmationController.dispose();
    super.onClose();
  }

  // Validate input fields
  bool validateInputs() {
    if (nameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordConfirmationController.text.isEmpty) {
      showSnackbar("Error", "Please complete all fields");
      return false;
    }

    if (phoneController.text.trim().length != 11) {
      showSnackbar("Error", "Invalid phone number");
      return false;
    }
    if (passwordController.text.trim().length < 8) {
      showSnackbar("Error", "Password must not be less than 8 characters");
      return false;
    }

    return true;
  }

  // Sign-up submit function
  Future<void> signUp() async {
    if (!validateInputs()) return;
    isLoading.value = true;
    // Create request model
    final request = SignUpRequest(
        name: nameController.text.trim(),
        password: passwordController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password_confirmation: passwordConfirmationController.text.trim());
    try {
      // Call sign-up API
      UserAuthResponse response = await authRepository.signUp(request);
      Get.find<UserAuthDetailsController>().saveUser(response);

      await _storeAuthDetails(response);
      await _updateApiToken();
      // Handle success
      // showSnackbar("Success", "Sign-up successful!", isError: false);
      Get.toNamed(RoutesConstant.home);
    } catch (e) {
      // Handle error
      Failure failure = ErrorMapper.map(e as Exception);
      errorMessage.value = failure.message;
      showSnackbar("Error", failure.message);
    } finally {
      isLoading.value = false;
    }
  }

  // Store authentication details
  Future<void> _storeAuthDetails(UserAuthResponse response) async {
    final storageService = SecureStorageService();
    await storageService.saveData('auth_token', response.token);
    await storageService.saveData(
        'user_details', jsonEncode(response.user.toJson()));
    await storageService.saveData("user_has", "sign_in");
  }

  // Update API client with new token
  Future<void> _updateApiToken() async {
    final dioClient = DioClient();
    await dioClient.updateToken();
  }
}
