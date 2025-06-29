import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/errors/error_mapper.dart';
import 'package:davyking/core/errors/failure.dart';
import 'package:davyking/core/utils/snackbar.dart';
import 'package:davyking/features/airtime/data/repositories/airtime_repository.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
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
  final UserAuthDetailsController userAuthDetailsController =
      Get.find<UserAuthDetailsController>();
  final Uuid uuid = const Uuid();

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
    final wallet_balance = double.parse(
        userAuthDetailsController.user.value?.walletBalance ?? "0");

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
    if (amount > wallet_balance) {
      return "Amount exceeds your wallet balance";
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
          user_id: userAuthDetailsController.user.value!.id.toString(),
          phone: phoneNumber.value,
          serviceId: serviceId,
          amount: amount,
          requestId: requestId);

      print(response);
      // Use the receipt_data returned from the backend
      final receiptData = response!['receipt_data'];
      print(receiptData);
      Get.offNamed(RoutesConstant.airtime_receipt, arguments: receiptData);
    } catch (e) {
      Failure failure = ErrorMapper.map(e as Exception);
      showSnackbar('Error', failure.message);
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
