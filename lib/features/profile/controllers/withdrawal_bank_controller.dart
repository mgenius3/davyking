import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawalBankController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final accountNumberController = TextEditingController();
  String? selectedBank;
  var showAccountNameField = false.obs;

  @override
  void onClose() {
    accountNumberController.dispose();
    super.onClose();
  }
}
