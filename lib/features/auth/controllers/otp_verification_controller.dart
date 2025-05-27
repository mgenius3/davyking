// otp_verify_controller.dart
import 'dart:async';
import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/errors/error_mapper.dart';
import 'package:davyking/core/errors/failure.dart';
import 'package:davyking/core/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:davyking/features/auth/data/repositories/auth_repository.dart';

class OtpVerifyController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final List<TextEditingController> textControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  final pinValues = List<String>.filled(6, '').obs;

  var isLoading = false.obs;
  var focus = 1.obs;
  var secondsRemaining = 890.obs;
  Timer? _timer;
  var checkIfInputFieldIsComplete = false.obs;
  var codeVerified = false.obs;

  final AuthRepository authRepository = AuthRepository();

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
    if (value.isNotEmpty && index < 5) {
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

  Future<void> submit(String email) async {
    if (!isPinComplete()) return;
    try {
      isLoading.value = true;
      // FocusScope.of(context).unfocus();

      final data = {
        "email": email,
        "code": pinValues.join(),
      };

      await authRepository.sendOtp(data);

      Get.toNamed(RoutesConstant.setnewpassword, arguments: {'email': email});
    } catch (err) {
      Failure failure = ErrorMapper.map(err as Exception);
      showSnackbar('Error', failure.message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp(String email) async {
    try {
      await authRepository.forgotPassword(email);
    } catch (err) {
      isLoading.value = false;
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
