import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/errors/error_mapper.dart';
import 'package:davyking/core/errors/failure.dart';
import 'package:davyking/core/repository/vtu_repository.dart';
import 'package:davyking/core/utils/snackbar.dart';
import 'package:davyking/features/electricity/data/local/index_local_data.dart';
import 'package:davyking/features/electricity/data/repositories/electricity_repository.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ElectricityIndexController extends GetxController {
  final RxInt selectedDisco = 0.obs;
  final RxString selectedVariationId = 'prepaid'.obs;
  final RxString customerId = ''.obs;
  final RxString amount = ''.obs;
  final RxBool isInformationComplete = false.obs;
  final RxBool isLoading = false.obs;
  final customerIdController = TextEditingController();
  final amountController = TextEditingController();
  final ElectricityRepository electricityRepository = ElectricityRepository();
  final VtuRepository verifyCustomerRepository =
      VtuRepository();
  final UserAuthDetailsController userAuthDetailsController =
      Get.find<UserAuthDetailsController>();
  final Uuid uuid = Uuid();
  final RxBool isVerifying = false.obs;
  final RxMap<String, dynamic> customerDetails = <String, dynamic>{}.obs;
  final RxString error_customer_details = ''.obs;

  // Map Disco index to eBills Africa service_id
  final List<Map<String, String>> discoMapping = electricityList;

  @override
  void onInit() {
    super.onInit();
    customerIdController.addListener(() {
      customerId.value = customerIdController.text;
      checkInformation();
    });
    amountController.addListener(() {
      amount.value = amountController.text;
      checkInformation();
    });
  }

  void setDisco(int index) {
    selectedDisco.value = index;
    checkInformation();
  }

  void setVariation(String variationId) {
    selectedVariationId.value = variationId;
    checkInformation();
  }

  void setCustomerId(String id) {
    customerId.value = id;
    customerIdController.text = id;
    checkInformation();
  }

  void setAmount(String amount) {
    this.amount.value = amount;
    amountController.text = amount;
    checkInformation();
  }

  void checkInformation() {
    final double? parsedAmount = double.tryParse(amount.value);
    if (selectedVariationId.value.isNotEmpty &&
        // RegExp(r'^[0-9]{11,13}$').hasMatch(customerId.value) &&
        parsedAmount != null &&
        parsedAmount >= 100 &&
        parsedAmount <= 100000) {
      isInformationComplete.value = true;
    } else {
      isInformationComplete.value = false;
    }
  }

  Future<void> verifyCustomer() async {
    if (customerId.value.isEmpty) {
      showSnackbar(
        'Error',
        'Please enter a meter number.',
      );
      return;
    }

    isVerifying.value = true;
    try {
      final serviceId = discoMapping[selectedDisco.value]['service_id']!;
      final response = await verifyCustomerRepository.verifyCustomer(
          customerId: customerId.value,
          serviceId: serviceId,
          variationId: selectedVariationId.value);
      customerDetails.value = response!;
    } catch (e) {
      Failure failure = ErrorMapper.map(e as Exception);
      error_customer_details.value = "invalid meter no";
    } finally {
      isVerifying.value = false;
    }
  }

  Future<void> buyElectricity() async {
    if (!isInformationComplete.value) return;

    isLoading.value = true;
    try {
      final serviceId = discoMapping[selectedDisco.value]['service_id']!;
      final amountValue = double.parse(amount.value);
      final requestId = uuid.v4();

      final response = await electricityRepository.buyElectricity(
        userId: userAuthDetailsController.user.value!.id.toString(),
        customerId: customerId.value,
        serviceId: serviceId,
        variationId: selectedVariationId.value,
        amount: amountValue,
        requestId: requestId,
      );


      Get.offNamed(RoutesConstant.electricity_receipt, arguments: {
        'disco': serviceId,
        'customer_id': customerId.value,
        'variation_id': selectedVariationId.value,
        'amount': amount.value,
        'response': response
      });

      Get.snackbar('Success', 'Electricity top up succcessful',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Failure failure = ErrorMapper.map(e as Exception);
      if (failure.message.contains('below_minimum_amount')) {
        showSnackbar('Error',
            'The amount entered is below the minimum, Please enter a higher amount.');
      } else {
        showSnackbar('Error', failure.message);
      }
    } finally {
      isLoading.value = false;
    }
  }

  bool validateInputs() {
    final double? parsedAmount = double.tryParse(amount.value);
    final bool isCustomerIdValid =
        RegExp(r'^[0-9]{11,13}$').hasMatch(customerId.value);
    final bool isAmountValid =
        parsedAmount != null && parsedAmount >= 100 && parsedAmount <= 100000;
    final bool isVariationSelected = selectedVariationId.value.isNotEmpty;

    isInformationComplete.value =
        isCustomerIdValid && isAmountValid && isVariationSelected;

    final wallet_balance = double.parse(
        userAuthDetailsController.user.value?.walletBalance ?? "0");

    // if (!isCustomerIdValid) {
    //   showSnackbar(
    //       'Invalid Customer ID', 'Customer ID must be 11 to 13 digits.');
    //   return false;
    // }

    if (!isAmountValid) {
      showSnackbar(
          'Invalid Amount', 'Enter an amount between ₦100 and ₦100,000.');
      return false;
    }

    if (!isVariationSelected) {
      showSnackbar('Plan Not Selected',
          'Please select a metering type (Prepaid/Postpaid).');
      return false;
    }

    if (parsedAmount! > wallet_balance) {
      showSnackbar('Wallet Error', 'Amount exceeds your wallet balance');
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    customerIdController.dispose();
    amountController.dispose();
    super.onClose();
  }
}
