import 'dart:convert';

import 'package:davyking/api/api_client.dart';
import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/errors/error_mapper.dart';
import 'package:davyking/core/errors/failure.dart';
import 'package:davyking/core/services/secure_storage_service.dart';
import 'package:davyking/core/utils/snackbar.dart';
import 'package:davyking/features/auth/data/models/sign_in_request_model.dart';
import 'package:davyking/core/models/user_auth_response_model.dart';
import 'package:davyking/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var obscurePassword = true.obs;
  // Loading and error states
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final AuthRepository authRepository = AuthRepository();

  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Validate input fields
  bool validateInputs() {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      showSnackbar("Error", "Please complete all fields");
      return false;
    }
    return true;
  }

  // Sign-up submit function
  Future<void> signIn() async {
    if (!validateInputs()) return;
    isLoading.value = true;
    // Create request model
    final request = SignInRequest(
        password: passwordController.text.trim(),
        email: emailController.text.trim());
    try {
      // Call sign-in API
      UserAuthResponse response = await authRepository.signIn(request);
      Get.find<UserAuthDetailsController>().saveUser(response);
      await _storeAuthDetails(response);
      await _updateApiToken();
      // showSnackbar("Success", "Sign-in successful!", isError: false);
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
        'user_details', jsonEncode(response.toJson()));
  }

  // Update API client with new token
  Future<void> _updateApiToken() async {
    final dioClient = DioClient();
    await dioClient.updateToken();
  }
}
