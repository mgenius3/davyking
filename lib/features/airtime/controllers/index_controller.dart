import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AirtimeIndexController extends GetxController {
  final RxInt selectedNetwork = 0.obs;
  final RxString selectedAmount =
      ''.obs; // Reactive variable for selected amount
  final RxString phoneNumber = ''.obs;
  final amountController = TextEditingController();
  // final phoneController = TextEditingController();
  final RxBool isInformationComplete = false.obs;

  void setNetwork(int index) {
    selectedNetwork.value = index;
    checkInformation();
  }

  void setAmount(String amount) {
    selectedAmount.value = amount; // Update the reactive variable
    amountController.text = amount; // Update the text field
    checkInformation();
  }

  void setPhoneNumber(String phone) {
    phoneNumber.value = phone;
    // phoneController.text = phone;
    checkInformation();
  }

  void checkInformation() {
    if (selectedAmount.value.isNotEmpty && phoneNumber.value.length == 11) {
      isInformationComplete.value = true;
    } else {
      isInformationComplete.value = false;
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    // phoneController.dispose();
    super.onClose();
  }
}
