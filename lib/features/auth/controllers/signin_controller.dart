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
import 'package:davyking/core/theme/colors.dart';
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
    // emailController.dispose();
    // passwordController.dispose();
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

  // Sign-in submit function
  Future<void> signIn() async {
    if (!validateInputs()) return;
    isLoading.value = true;
    errorMessage.value = '';
    
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
      
      // Success - navigate to home
      Get.offAllNamed(RoutesConstant.home);
      
    } catch (e) {
      // Handle error
      Failure failure = ErrorMapper.map(e as Exception);
      errorMessage.value = failure.message;
      
      // Check if error is related to email verification
      if (_isEmailVerificationError(failure.message)) {
        _handleEmailVerificationError();
      } else {
        // Show regular error message
        showSnackbar("Error", failure.message);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Check if the error message indicates email verification is needed
  bool _isEmailVerificationError(String errorMessage) {
    final lowerCaseMessage = errorMessage.toLowerCase();
    return lowerCaseMessage.contains("please verify your email address") ||
           lowerCaseMessage.contains("email not verified") ||
           lowerCaseMessage.contains("verify your email") ||
           lowerCaseMessage.contains("email verification required");
  }

  // Handle email verification error with dialog and navigation
  void _handleEmailVerificationError() {
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
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.mark_email_unread_rounded,
                color: Colors.orange[700],
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Email Verification Required',
              style: TextStyle(
                fontSize: 16,
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
              'Your account exists but your email address needs to be verified before you can sign in.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 14,
                        color: Colors.blue[700],
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Email Address:',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    emailController.text.trim(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue[800],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
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
                    Icons.info_outline,
                    size: 14,
                    color: Colors.amber[700],
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'We\'ll send a verification code to complete the process.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF666666),
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
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close dialog
              _navigateToEmailVerification();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: LightThemeColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.mark_email_read_rounded,
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  'Verify Email',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Navigate to email verification and send verification code
  Future<void> _navigateToEmailVerification() async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Sending verification code...',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Send email verification
      await authRepository.sendEmailVerification(emailController.text.trim());
      
      // Close loading dialog
      Get.back();
      
      // Show success message
      showSnackbar(
        "Verification Sent", 
        "Please check your email for the verification code", 
        isError: false
      );
      
      // Navigate to email verification screen
      Get.toNamed(
        RoutesConstant.emailVerification,
        arguments: {
          'email': emailController.text.trim(),
          'fromSignin': true,
        }
      );
      
    } catch (e) {
      // Close loading dialog
      Get.back();
      
      // Handle error in sending verification email
      Failure failure = ErrorMapper.map(e as Exception);
      showSnackbar("Error", "Failed to send verification code: ${failure.message}");
      
      // Still navigate to verification screen in case user has a code
      Get.toNamed(
        RoutesConstant.emailVerification,
        arguments: {
          'email': emailController.text.trim(),
          'fromSignin': true,
        }
      );
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