// otp_verify_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpVerifyController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final List<TextEditingController> textControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  final pinValues = List<String>.filled(4, '').obs;

  var isLoading = false.obs;
  var focus = 1.obs;
  var secondsRemaining = 120.obs;
  Timer? _timer;
  var checkIfInputFieldIsComplete = false.obs;
  var codeVerified = false.obs;

  @override
  void onClose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.onClose();
  }

  void updatePinValue(int index, String value) {
    pinValues[index] = value;
    if (value.isNotEmpty && index < 3) {
      focusNodes[index + 1].requestFocus();
    }
  }

  bool isPinComplete() {
    return pinValues.every((value) => value.isNotEmpty);
  }

  void startCountdownTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> submit() async {
    if (!isPinComplete()) return;
    try {
      isLoading.value = true;
      // FocusScope.of(context).unfocus();

      final userDetails = {
        "code": pinValues.join(),
      };

      // Call your API with `userDetails`
    } catch (err) {
      // Handle errors
    } finally {
      isLoading.value = false;
    }
  }

  void onBackspacePressed(int index) {
    if (index > 0 && textControllers[index].text.isEmpty) {
      focusNodes[index - 1].requestFocus();
    }
  }
}
