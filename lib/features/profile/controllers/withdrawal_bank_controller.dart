import 'package:davyking/core/models/user_auth_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:davyking/core/constants/api_url.dart';
import 'package:davyking/core/errors/error_mapper.dart';
import 'package:davyking/core/errors/failure.dart';
import 'package:davyking/core/models/paystack_bank_model.dart';
import 'package:davyking/core/repository/payment_repository.dart';
import 'package:davyking/core/utils/snackbar.dart';
import 'package:davyking/features/profile/data/repositories/edit_profile_repository.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/services/secure_storage_service.dart';
import 'dart:convert';
import 'package:davyking/core/controllers/transaction_auth_controller.dart';

class WithdrawalBankController extends GetxController {
  final formKey = GlobalKey<FormState>();
  var banks = <PaystackBankModel>[].obs; // Observable list of banks
  final accountNumberController = TextEditingController();
  var selectedBank =
      Rxn<PaystackBankModel>(); // Nullable reactive selected bank
  var isLoading = false.obs; // Loading state for the save button
  final PaymentRepository paymentRepository = PaymentRepository();
  final EditProfileRepository editrepo = EditProfileRepository();
  final UserAuthDetailsController authDetailsController =
      Get.find<UserAuthDetailsController>();

  @override
  void onInit() {
    super.onInit();
    fetchBanks(); // Fetch banks when the controller initializes
  }

  bool validateInputs() {
    if (accountNumberController.text.trim().length != 10) {
      showSnackbar('Validation Error', "Enter correct account number");
      return false;
    } else if (selectedBank.value == null) {
      showSnackbar('Validation Error', "Pelease select bank name");
    }
    return true;
  }

  // Fetch the list of banks from the API
  Future<void> fetchBanks() async {
    try {
      final response = await paymentRepository
          .fetchBanks('${ApiUrl.base_url}/payment/paystack/banks');
      banks.assignAll(response); // Populate the banks list
    } catch (e) {
      Failure failure = ErrorMapper.map(e as Exception);
      showSnackbar('Error', failure.message);
    }
  }

  // Update the user's withdrawal bank details
  Future<void> updateWithdrawalBank() async {
    // Validate that a bank is selected and account number is provided
    if (selectedBank.value == null || accountNumberController.text.isEmpty) {
      showSnackbar('Error', 'Please select a bank and enter an account number');
      return;
    }

    try {
      isLoading(true); // Show loading indicator

      Map data = {
        'bank_name': selectedBank.value!.name, // Send bank name
        'bank_code': selectedBank.value!.code, // Send bank code
        'account_number': accountNumberController.text, // Send account number
      };

      User response = await editrepo.updateWithdrawalBank(
          '${ApiUrl.users}/${authDetailsController.user.value?.id.toString()}/withdrawal-bank',
          data);

      Get.find<UserAuthDetailsController>().updateUser(response);
      await _storeAuthDetails(response);
    } catch (e) {
      showSnackbar('Error', 'Failed to update withdrawal bank: $e');
    } finally {
      isLoading(false); // Hide loading indicator
    }
  }

  // Store authentication details
  Future<void> _storeAuthDetails(User response) async {
    final storageService = SecureStorageService();
    await storageService.saveData(
        'user_details', jsonEncode(response.toJson()));
  }

  @override
  void onClose() {
    accountNumberController.dispose(); // Clean up controller
    super.onClose();
  }
}
