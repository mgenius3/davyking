import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/features/data/data/repositories/data_repository.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class DataIndexController extends GetxController {
  final RxInt selectedNetwork = 0.obs;
  final RxString selectedVariationId = ''.obs;
  final RxString selectedPlan = ''.obs;
  final RxString phoneNumber = ''.obs;
  final RxBool isInformationComplete = false.obs;
  final RxBool isLoading = false.obs;
  final RxList<dynamic> variations = <dynamic>[].obs;
  final phoneController = TextEditingController();
  final DataRepository dataRepository = DataRepository();
  final Uuid uuid = Uuid();

  // Map network index to eBills Africa service_id
  final List<String> networkMapping = [
    'MTN',
    'Glo',
    'Airtel',
    '9mobile',
    'Smile'
  ];

  @override
  void onInit() {
    super.onInit();
    fetchVariations();
    phoneController.addListener(() {
      phoneNumber.value = phoneController.text;
      checkInformation();
    });
  }

  void setNetwork(int index) {
    selectedNetwork.value = index;
    // Reset variation when network changes
    final filteredVariations = variations
        .where((v) => v['service_id'] == networkMapping[index])
        .toList();
    selectedVariationId.value = filteredVariations.isNotEmpty
        ? filteredVariations[0]['variation_id'].toString()
        : '';
    checkInformation();
  }

  void setVariation(String variationId, String variationPlan) {
    selectedVariationId.value = variationId;
    selectedPlan.value = variationPlan;
    checkInformation();
  }

  void setPhoneNumber(String phone) {
    phoneNumber.value = phone;
    phoneController.text = phone;
    checkInformation();
  }

  void checkInformation() {
    final serviceId = networkMapping[selectedNetwork.value];
    if (selectedVariationId.value.isNotEmpty &&
        RegExp(r'^(\+234[0-9]{10}|[0-9]{11})$').hasMatch(phoneNumber.value) &&
        _isValidNetwork(phoneNumber.value, serviceId)) {
      isInformationComplete.value = true;
    } else {
      isInformationComplete.value = false;
    }

    print(isInformationComplete.value);
  }

  // Validate that the phone number matches the selected network
  bool _isValidNetwork(String phone, String serviceId) {
    final normalizedPhone =
        phone.startsWith('+234') ? '0${phone.substring(4)}' : phone;
    final prefixes = {
      'MTN': [
        '0803',
        '0806',
        '0703',
        '0706',
        '0810',
        '0813',
        '0814',
        '0816',
        '0903',
        '0906',
        '0913',
        '0916'
      ],
      'Glo': ['0805', '0807', '0811', '0815', '0705', '0905'],
      'Airtel': ['0802', '0808', '0812', '0701', '0708', '0902', '0907'],
      '9mobile': ['0809', '0817', '0818', '0908', '0909'],
      'Smile': ['0702'],
    };

    final networkPrefixes = prefixes[serviceId] ?? [];
    return networkPrefixes.any((prefix) => normalizedPhone.startsWith(prefix));
  }

  Future<void> fetchVariations() async {
    isLoading.value = true;
    try {
      final response = await dataRepository.getDataVariations();

      variations.value = response['data']
          .where((v) => v['availability'] == 'Available')
          .toList();

      if (variations.isNotEmpty) {
        selectedVariationId.value = variations[0]['variation_id'].toString();
        selectedNetwork.value =
            networkMapping.indexOf(variations[0]['service_id']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch data plans: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> buyData() async {
    if (!isInformationComplete.value) return;

    isLoading.value = true;
    try {
      final serviceId = networkMapping[selectedNetwork.value];
      final requestId = uuid.v4();
      final response = await dataRepository.buyData(
          phoneNumber.value, serviceId, selectedVariationId.value, requestId);
      Get.toNamed(RoutesConstant.home);
    } catch (e) {
      Get.snackbar('Error', 'Failed to buy data: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
