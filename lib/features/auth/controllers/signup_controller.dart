import 'dart:convert';

import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/errors/error_mapper.dart';
import 'package:davyking/core/errors/failure.dart';
import 'package:davyking/core/services/secure_storage_service.dart';
import 'package:davyking/core/theme/colors.dart';
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
    phoneController.dispose();
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

    if (passwordController.text.trim() !=
        passwordConfirmationController.text.trim()) {
      showSnackbar("Error", "Passwords do not match");
      return false;
    }

    if (!checkedbox.value) {
      showSnackbar("Error", "Please accept the terms and conditions");
      return false;
    }

    return true;
  }

  // Sign-up submit function
  Future<void> signUp() async {
    if (!validateInputs()) return;

    isLoading.value = true;
    errorMessage.value = '';

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

      // Save user details
      Get.find<UserAuthDetailsController>().saveUser(response);
      await _storeAuthDetails(response);
      await _updateApiToken();

      // Send email verification
      await _sendEmailVerification();
    } catch (e) {
      // Handle error
      Failure failure = ErrorMapper.map(e as Exception);
      errorMessage.value = failure.message;
      showSnackbar("Error", failure.message);
    } finally {
      isLoading.value = false;
    }
  }

  // Send email verification after successful signup
  Future<void> _sendEmailVerification() async {
    try {
      await authRepository.sendEmailVerification(emailController.text.trim());

      showSnackbar("Success",
          "Account created! Please check your email for verification code",
          isError: false);

      // Navigate to email verification screen
      Get.offNamed(RoutesConstant.emailVerification, arguments: {
        'email': emailController.text.trim(),
        'fromSignup': true,
      });
    } catch (e) {
      // If email verification fails, still show success but navigate to home
      showSnackbar("Success", "Account created successfully!", isError: false);

      // Show dialog asking if user wants to verify email later
      _showEmailVerificationDialog();
    }
  }

  // Show dialog for email verification option
  void _showEmailVerificationDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.email_outlined,
              color: LightThemeColors.primaryColor,
            ),
            const SizedBox(width: 8),
            const Text(
              'Email Verification',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your account has been created successfully!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Would you like to verify your email address now? This will help secure your account and enable all features.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.blue[700],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'You can verify your email later from the app settings.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue[700],
                      ),
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
              Get.offAllNamed(RoutesConstant.home); // Go to home
            },
            child: Text(
              'Skip for Now',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.offNamed(RoutesConstant.emailVerification, arguments: {
                'email': emailController.text.trim(),
                'fromSignup': true
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: LightThemeColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Verify Now',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
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
