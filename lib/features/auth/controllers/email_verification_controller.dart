import 'dart:async';
import 'dart:convert';
import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/errors/error_mapper.dart';
import 'package:davyking/core/errors/failure.dart';
import 'package:davyking/core/services/secure_storage_service.dart';
import 'package:davyking/core/utils/snackbar.dart';
import 'package:davyking/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailVerificationController extends GetxController {
  final AuthRepository authRepository = AuthRepository();

  // Form controllers
  final List<TextEditingController> codeControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  // Observable variables
  final isLoading = false.obs;
  final isResending = false.obs;
  final isCodeComplete = false.obs;
  final errorMessage = ''.obs;
  final countdown = 0.obs;
  final canResend = true.obs;

  // User email from arguments
  late String userEmail;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // Get email from route arguments
    final args = Get.arguments as Map<String, dynamic>?;
    userEmail = args?['email'] ?? '';

    if (userEmail.isEmpty) {
      showSnackbar("Error", "Email not provided");
      Get.back();
      return;
    }

    // Start countdown timer
    _startCountdown();

    // Listen to code changes
    _setupCodeListeners();
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var controller in codeControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }

  void _setupCodeListeners() {
    for (int i = 0; i < codeControllers.length; i++) {
      codeControllers[i].addListener(() {
        _onCodeChanged(i);
      });
    }
  }

  void _onCodeChanged(int index) {
    final text = codeControllers[index].text;

    if (text.isNotEmpty) {
      // Move to next field
      if (index < codeControllers.length - 1) {
        focusNodes[index + 1].requestFocus();
      } else {
        // Last field, unfocus
        focusNodes[index].unfocus();
      }
    }

    // Check if all fields are filled
    _checkCodeComplete();
  }

  void _checkCodeComplete() {
    final code = _getEnteredCode();
    isCodeComplete.value = code.length == 6;

    // Auto-verify when code is complete
    if (isCodeComplete.value) {
      verifyEmail();
    }
  }

  String _getEnteredCode() {
    return codeControllers.map((controller) => controller.text).join();
  }

  void _clearCode() {
    for (var controller in codeControllers) {
      controller.clear();
    }
    isCodeComplete.value = false;
    errorMessage.value = '';
    // Focus first field
    if (focusNodes.isNotEmpty) {
      focusNodes[0].requestFocus();
    }
  }

  void _startCountdown() {
    countdown.value = 120; // 2 minutes
    canResend.value = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  String get countdownText {
    final minutes = countdown.value ~/ 60;
    final seconds = countdown.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> verifyEmail() async {
    final code = _getEnteredCode();

    if (code.length != 6) {
      showSnackbar("Error", "Please enter the complete verification code");
      return;
    }

    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      await authRepository.verifyEmail(userEmail, code);

      // Success
      showSnackbar("Success", "Email verified successfully!", isError: false);

      // Navigate to next screen (login or home)
      Get.offAllNamed(RoutesConstant.signin);
    } catch (e) {
      Failure failure = ErrorMapper.map(e as Exception);
      errorMessage.value = failure.message;
      showSnackbar("Error", failure.message);

      // Clear the code on error
      _clearCode();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendVerificationCode() async {
    if (!canResend.value || isResending.value) return;

    isResending.value = true;
    errorMessage.value = '';

    try {
      await authRepository.resendEmailVerification(userEmail);

      showSnackbar("Success", "Verification code sent to your email",
          isError: false);

      // Restart countdown
      _startCountdown();

      // Clear current code
      _clearCode();
    } catch (e) {
      Failure failure = ErrorMapper.map(e as Exception);
      errorMessage.value = failure.message;
      showSnackbar("Error", failure.message);
    } finally {
      isResending.value = false;
    }
  }

  Future<void> checkVerificationStatus() async {
    try {
      final isVerified =
          await authRepository.checkEmailVerificationStatus(userEmail);

      if (isVerified) {
        showSnackbar("Info", "Email is already verified", isError: false);
        Get.offAllNamed(RoutesConstant.signin);
      }
    } catch (e) {
      // Ignore errors for status check
    }
  }

  void onBackPressed() {
    Get.dialog(
      AlertDialog(
        title: const Text('Leave Verification?'),
        content: const Text(
            'Your account won\'t be fully activated until email is verified. Are you sure you want to go back?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Go back to previous screen
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  void onCodeFieldTap(int index) {
    // Clear all fields after the tapped one
    for (int i = index; i < codeControllers.length; i++) {
      codeControllers[i].clear();
    }

    // Focus the tapped field
    focusNodes[index].requestFocus();
    _checkCodeComplete();
  }

  void onBackspacePressed(int index) {
    if (codeControllers[index].text.isEmpty && index > 0) {
      // Move to previous field and clear it
      focusNodes[index - 1].requestFocus();
      codeControllers[index - 1].clear();
    }
    _checkCodeComplete();
  }
}
