import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/features/airtime/data/repositories/airtime_repository.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AirtimeIndexController extends GetxController {
  final RxInt selectedNetwork = 0.obs;
  final RxString selectedAmount = ''.obs;
  final RxString phoneNumber = ''.obs;
  final RxBool isInformationComplete = false.obs;
  final RxBool isLoading = false.obs; // Add loading state
  final amountController = TextEditingController();
  final phoneController = TextEditingController(); // Re-enable phoneController
  final AirtimeRepository airtimeRepository = AirtimeRepository();
  final Uuid uuid = Uuid();

  // Map network index to eBills Africa service_id
  final List<String> networkMapping = ['MTN', 'Glo', 'Airtel', '9mobile'];

  @override
  void onInit() {
    super.onInit();
    // Bind controllers to reactive variables
    amountController.addListener(() {
      selectedAmount.value = amountController.text;
      checkInformation();
    });
    phoneController.addListener(() {
      phoneNumber.value = phoneController.text;
      checkInformation();
    });
  }

  void setNetwork(int index) {
    selectedNetwork.value = index;
    checkInformation();
  }

  void setAmount(String amount) {
    selectedAmount.value = amount;
    amountController.text = amount;
    checkInformation();
  }

  void setPhoneNumber(String phone) {
    phoneNumber.value = phone;
    phoneController.text = phone;
    checkInformation();
  }

  void checkInformation() {
    final double? amount = double.tryParse(selectedAmount.value);
    final String serviceId = networkMapping[selectedNetwork.value];
    final minAmount = serviceId == 'MTN' ? 10 : 50;

    if (amount != null &&
        amount >= minAmount &&
        amount <= 50000 &&
        RegExp(r'^(\+234[0-9]{10}|[0-9]{11})$').hasMatch(phoneNumber.value)) {
      isInformationComplete.value = true;
    } else {
      isInformationComplete.value = false;
    }
  }

  /// 🔍 Validate inputs and return error message (null if all is valid)
  String? validateInputs() {
    final double? amount = double.tryParse(selectedAmount.value);

    final String serviceId = networkMapping[selectedNetwork.value];
    final minAmount = serviceId == 'MTN' ? 10 : 50;

    if (phoneNumber.value.isEmpty) {
      return "Phone number is required.";
    }
    if (!RegExp(r'^(\+234[0-9]{10}|[0-9]{11})$').hasMatch(phoneNumber.value)) {
      return "Invalid phone number format.";
    }
    if (selectedAmount.value.isEmpty) {
      return "Amount is required.";
    }
    if (amount == null || amount < minAmount || amount > 50000) {
      return "Amount must be between $minAmount and 50000.";
    }

    return null; // All inputs valid
  }

  Future<void> buyAirtime() async {
    isLoading.value = true;
    try {
      final serviceId = networkMapping[selectedNetwork.value];
      final amount = double.parse(selectedAmount.value);

      final requestId = uuid.v4();

      final response = await airtimeRepository.buyAirtime(
          phoneNumber.value, serviceId, amount, requestId);

      Get.toNamed(RoutesConstant.home);
    } catch (e) {
      Get.snackbar('Error', 'Failed to buy airtime: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
