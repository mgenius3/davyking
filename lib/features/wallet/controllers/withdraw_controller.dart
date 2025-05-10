import 'package:davyking/core/constants/api_url.dart';
import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/errors/error_mapper.dart';
import 'package:davyking/core/errors/failure.dart';
import 'package:davyking/core/utils/helper.dart';
import 'package:davyking/core/utils/snackbar.dart';
import 'package:davyking/features/wallet/data/model/wallet_transaction.dart';
import 'package:davyking/features/wallet/data/repository/wallet_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawController extends GetxController {
  Rx<String> selectedPaymentMethod = "".obs;
  final UserAuthDetailsController userAuthDetailsController =
      Get.find<UserAuthDetailsController>();
  var isLoading = false.obs;

  final amountController = TextEditingController();
  var account_name = "".obs;
  var bank_code = "".obs;
  var account_number = "".obs;
  var bank_name = "".obs;

  WalletRepository walletRepository = WalletRepository();

  bool validateInputs() {
    final amount = double.tryParse(amountController.text);
    final wallet_balance = double.parse(
        userAuthDetailsController.user.value?.walletBalance ?? "0");
    if (amount == null || amount <= 0) {
      Get.snackbar('Error', 'Please enter a valid amount');
      return false;
    }
    if (amount > wallet_balance) {
      Get.snackbar('Error', 'Amount exceeds your of N$wallet_balance');
      return false;
    }
    if (selectedPaymentMethod.isEmpty) {
      Get.snackbar('Error', 'Please select a payment method');
      return false;
    }

    return true;
  }

  updateSelectedInput() {
    selectedPaymentMethod.value =
        '${userAuthDetailsController.user.value?.withdrawalBank?.accountNumber} (${shortenString(userAuthDetailsController.user.value?.withdrawalBank?.bankName ?? "", 20)})';
    account_name.value = userAuthDetailsController.user.value?.name ?? "";
    bank_code.value =
        userAuthDetailsController.user.value?.withdrawalBank?.bankCode ?? "";
    bank_name.value =
        userAuthDetailsController.user.value?.withdrawalBank?.bankName ?? "";
    account_number.value =
        userAuthDetailsController.user.value?.withdrawalBank?.accountNumber ??
            "";
  }

  Future<void> withdrawFunds() async {
    try {
      isLoading(true);

      if (validateInputs()) {
        Map data = {
          'user_id': userAuthDetailsController.user.value?.id,
          'amount': amountController.text,
          'account_number': account_number.value,
          'account_name': account_name.value,
          'bank_code': bank_code.value
        };

        final endpoint = '${ApiUrl.base_url}/payment/paystack/transfer';

        final response = await walletRepository.withdrawFunds(endpoint, data);

        if (response) {
          showSnackbar('Success', 'Withdrawal successful', isError: false);
          amountController.clear();
          Get.toNamed(RoutesConstant.home);
        }
      }
    } catch (err) {
      Failure failure = ErrorMapper.map(err as Exception);
      showSnackbar('Error', failure.message);
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
