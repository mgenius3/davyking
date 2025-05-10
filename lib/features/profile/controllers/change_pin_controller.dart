import 'package:davyking/core/controllers/transaction_auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePinController extends GetxController {
  final TransactionAuthController _authController =
      Get.find<TransactionAuthController>();

  // Reactive state
  final RxString oldPin = ''.obs;
  final RxString newPin = ''.obs;
  final RxString confirmPin = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Clear inputs and state
  void clear() {
    oldPin.value = '';
    newPin.value = '';
    confirmPin.value = '';
    errorMessage.value = '';
    isLoading.value = false;
  }

  // Change PIN logic
  Future<bool> changePin(BuildContext context) async {
    isLoading.value = true;
    errorMessage.value = '';

    // Validate inputs
    if (oldPin.value.length != 4 ||
        newPin.value.length != 4 ||
        confirmPin.value.length != 4) {
      errorMessage.value = 'Please enter a 4-digit PIN for all fields';
      isLoading.value = false;
      return false;
    }

    if (newPin.value != confirmPin.value) {
      errorMessage.value = 'New PIN and confirmation do not match';
      isLoading.value = false;
      return false;
    }

    // Validate old PIN
    bool isOldPinValid = await _authController.authenticate(
      context,
      'PIN verification for changing PIN',
    );

    if (!isOldPinValid) {
      errorMessage.value = 'Incorrect old PIN';
      isLoading.value = false;
      return false;
    }

    // Update PIN
    try {
      await _authController.setupAuth(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN changed successfully'),
          backgroundColor: Color(0xFF00C853),
        ),
      );
      clear(); // Clear inputs after success
      isLoading.value = false;
      return true;
    } catch (e) {
      errorMessage.value = 'Error changing PIN: $e';
      isLoading.value = false;
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Reset PIN (for "Forgot PIN" link)
  Future<void> resetPin(BuildContext context) async {
    await _authController.resetPin(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PIN reset successful'),
        backgroundColor: Color(0xFF00C853),
      ),
    );
  }
}
