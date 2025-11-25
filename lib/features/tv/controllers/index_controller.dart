import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/errors/error_mapper.dart';
import 'package:davyking/core/errors/failure.dart';
import 'package:davyking/core/repository/vtu_repository.dart';
import 'package:davyking/core/utils/snackbar.dart';
import 'package:davyking/features/data/data/repositories/data_repository.dart';
import 'package:davyking/features/tv/data/local/index_local_data.dart';
import 'package:davyking/features/tv/data/repositories/tv_repository.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';

class TvIndexController extends GetxController {
  final RxInt selectedTv = 0.obs;
  final RxString selectedVariationId = ''.obs;
  final RxString selectedPlan = ''.obs;
  final RxString selectedAmount = ''.obs;
  final RxString customerId = ''.obs;
  final RxBool isInformationComplete = false.obs;
  final RxBool isLoading = false.obs;
  final RxList<dynamic> variations = <dynamic>[].obs;
  final customerIdController = TextEditingController();
  final TvRepository tvRepository = TvRepository();
  final VtuRepository verifyCustomerRepository = VtuRepository();
  final UserAuthDetailsController userAuthDetailsController =
      Get.find<UserAuthDetailsController>();
  final Uuid uuid = const Uuid();
  final RxBool isVerifying = false.obs;
  final RxMap<String, dynamic> customerDetails = <String, dynamic>{}.obs;
  final RxString error_customer_details = ''.obs;

  // Map network index to eBills Africa service_id
  final List<Map<String, dynamic>> tvMapping = tvList;

  @override
  void onInit() {
    super.onInit();
    fetchVariations();
    customerIdController.addListener(() {
      customerId.value = customerIdController.text;
      checkInformation();
    });
  }

  void setTv(int index) {
    selectedTv.value = index;
    // Reset variation when network changes
    final filteredVariations =
        variations.where((v) => v['service_id'] == tvMapping[index]).toList();
    selectedVariationId.value = filteredVariations.isNotEmpty
        ? filteredVariations[0]['variation_id'].toString()
        : '';
    checkInformation();
  }

  void setVariation(
      String variationId, String variationPlan, String variationAmount) {
    selectedVariationId.value = variationId;
    selectedPlan.value = variationPlan;
    selectedAmount.value = variationAmount;

    print(variationId);
    checkInformation();
  }

  void setCustomerId(String phone) {
    customerId.value = phone;
    // customerIdController.text = phone;
    checkInformation();
  }

  void checkInformation() {
    final serviceId = tvMapping[selectedTv.value];
    if (selectedVariationId.value.isNotEmpty && customerId.value.isNotEmpty) {
      isInformationComplete.value = true;
    } else {
      isInformationComplete.value = false;
    }
  }

  bool validateInputs() {
    final customer_id = customerId.value.trim();
    final variation = selectedVariationId.value;
    print(variation);
    final serviceId = tvMapping[selectedTv.value];
    final double? amount = double.tryParse(selectedAmount.value);

    print(amount);

    final wallet_balance = double.parse(
        userAuthDetailsController.user.value?.walletBalance ?? "0");

    if (customer_id.isEmpty) {
      Get.snackbar('Input Error', 'Smart Card or IUC number is required',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (variation.isEmpty) {
      Get.snackbar('Input Error', 'Please select a tv plan',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (amount! > wallet_balance) {
      Get.snackbar('Wallet Error', 'Amount exceeds your wallet balance',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    return true;
  }

  Future<void> verifyCustomer() async {
    if (customerId.value.isEmpty) {
      showSnackbar('Error', 'Please enter a smart card or IUC number.');
      return;
    }
    isVerifying.value = true;
    try {
      final serviceId = tvMapping[selectedTv.value]['service_id']!;
      final response = await verifyCustomerRepository.verifyCustomer(
          customerId: customerId.value, serviceId: serviceId);
      customerDetails.value = response!;
    } catch (e) {
      Failure failure = ErrorMapper.map(e as Exception);
      error_customer_details.value = "invalid smart card or IUC";
    } finally {
      isVerifying.value = false;
    }
  }

  Future<void> fetchVariations() async {
    isLoading.value = true;
    try {
      final response = await tvRepository.getDataVariations();

      variations.value = response['data']
          .where((v) => v['availability'] == 'Available')
          .toList();

      if (variations.isNotEmpty) {
        selectedVariationId.value = variations[0]['variation_id'].toString();
        selectedAmount.value = variations[0]['price'].toString();
        selectedPlan.value = variations[0]['package_bouquet'].toString();

        // print(variations[0]);
        // print(tvMapping.indexOf(variations[0]));
        // selectedTv.value = tvMapping.indexOf(variations[0]);
      }
    } catch (e) {
      Failure failure = ErrorMapper.map(e as Exception);
      showSnackbar('Error', failure.message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> buyTv() async {
    if (!isInformationComplete.value) return;

    isLoading.value = true;
    try {
      final serviceId = tvMapping[selectedTv.value]['service_id'];
      final requestId = uuid.v4();
      final amount = double.parse(selectedAmount.value);

      final response = await tvRepository.buyTv(
          user_id: userAuthDetailsController.user.value!.id.toString(),
          amount: amount,
          customerId: customerId.value,
          serviceId: serviceId!,
          variationId: selectedVariationId.value,
          requestId: requestId);

      Get.offNamed(RoutesConstant.tv_receipt, arguments: {
        'disco': serviceId,
        'customer_id': customerId.value,
        'amount': amount,
        'response': response
      });
    } catch (e) {
      Failure failure = ErrorMapper.map(e as Exception);
      showSnackbar('Error', failure.message);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    customerIdController.dispose();
    super.onClose();
  }
}
