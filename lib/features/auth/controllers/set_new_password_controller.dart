import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:davyking/features/auth/data/repositories/auth_repository.dart';

final isLoading = false.obs;

class SetNewPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var obscurePassword = true.obs;
  final isLoading = false.obs;

  final AuthRepository authRepository = AuthRepository();

  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }


  Future<void> setNewPassword(String email) async {
    isLoading.value = true;
    try {
      if (passwordController.text == confirmPasswordController.text &&
          passwordController.text.length >= 6) {
        await authRepository.setNewPassword(email, passwordController.text);
        Get.toNamed(RoutesConstant.signin);
      } else {
        showSnackbar("Error", "your password must be minimum of 6 characters");
      }
    } catch (err) {
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
