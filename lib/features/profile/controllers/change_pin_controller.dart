import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePinController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final currentPin = TextEditingController();
  final newPin = TextEditingController();
  final confirmPin = TextEditingController();
  var obscureCurrentPin = true.obs;
  var obscureNewPin = true.obs;
  var obscureConfirmNewPin = true.obs;

  // Toggle CurrentPin visibility
  void toggleCurrentPinVisibility() {
    obscureCurrentPin.value = !obscureCurrentPin.value;
  }

  // Toggle CurrentPin visibility
  void toggleNewPinVisibility() {
    obscureNewPin.value = !obscureNewPin.value;
  }

  // Toggle CurrentPin visibility
  void toggleConirmNewPinVisibility() {
    obscureConfirmNewPin.value = !obscureConfirmNewPin.value;
  }

  @override
  void onClose() {
    currentPin.dispose();
    newPin.dispose();
    confirmPin.dispose();
    super.onClose();
  }
}
