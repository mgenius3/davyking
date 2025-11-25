import 'dart:convert';
import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/errors/error_mapper.dart';
import 'package:davyking/core/errors/failure.dart';
import 'package:davyking/core/utils/snackbar.dart';
import 'package:davyking/features/data/data/repositories/data_repository.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';

class DataIndexController extends GetxController {
  final RxInt selectedNetwork = 0.obs;
  final RxString selectedVariationId = ''.obs;
  final RxString selectedPlan = ''.obs;
  final RxString selectedAmount = ''.obs;
  final RxString phoneNumber = ''.obs;
  final RxBool isInformationComplete = false.obs;
  final RxBool isLoading = false.obs;
  final RxList<dynamic> variations = <dynamic>[].obs;
  final phoneController = TextEditingController();
  final DataRepository dataRepository = DataRepository();
  final UserAuthDetailsController userAuthDetailsController =
      Get.find<UserAuthDetailsController>();
  final Uuid uuid = const Uuid();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Key for storing variations in FlutterSecureStorage
  static const String _variationsKey = 'data_variations';

  // Map network index to eBills Africa service_id
  final List<String> networkMapping = [
    'MTN',
    'Glo',
    'Airtel',
    '9mobile',
    'Smile'
  ];

  @override
  void onInit() async {
    super.onInit();
    await _loadVariationsFromStorage(); // Load variations from secure storage
    fetchVariations(); // Fetch fresh data from API
    phoneController.addListener(() {
      phoneNumber.value = phoneController.text;
      checkInformation();
    });
  }

  // Load variations from FlutterSecureStorage
  Future<void> _loadVariationsFromStorage() async {
    try {
      final variationsJson = await _secureStorage.read(key: _variationsKey);
      if (variationsJson != null) {
        final List<dynamic> storedVariations = jsonDecode(variationsJson);
        variations.value = storedVariations
            .where((v) => v['availability'] == 'Available')
            .toList();
        if (variations.isNotEmpty) {
          selectedVariationId.value = variations[0]['variation_id'].toString();
          selectedNetwork.value =
              networkMapping.indexOf(variations[0]['service_id']);
        }
      }
    } catch (e) {
      // Handle any errors during reading from storage
      print('Error loading variations from storage: $e');
    }
  }

  // Save variations to FlutterSecureStorage
  Future<void> _saveVariationsToStorage() async {
    try {
      final variationsJson = jsonEncode(variations);
      await _secureStorage.write(
        key: _variationsKey,
        value: variationsJson
      );
    } catch (e) {
      // Handle any errors during saving to storage
      print('Error saving variations to storage: $e');
    }
  }

  void setNetwork(int index) {
    selectedNetwork.value = index;
    final filteredVariations = variations
        .where((v) => v['service_id'] == networkMapping[index])
        .toList();
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
    checkInformation();
  }

  void setPhoneNumber(String phone) {
    phoneNumber.value = phone;
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
  }

  bool validateInputs() {
    final phone = phoneNumber.value.trim();
    final variation = selectedVariationId.value;
    final serviceId = networkMapping[selectedNetwork.value];
    final double? amount = double.tryParse(selectedAmount.value);

    final wallet_balance = double.parse(
        userAuthDetailsController.user.value?.walletBalance ?? "0");

    if (phone.isEmpty) {
      Get.snackbar('Input Error', 'Phone number is required',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (!RegExp(r'^(\+234[0-9]{10}|0[0-9]{10})$').hasMatch(phone)) {
      Get.snackbar('Input Error', 'Enter a valid Nigerian phone number',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (!_isValidNetwork(phone, serviceId)) {
      Get.snackbar(
          'Input Error', 'Phone number does not match selected network',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (variation.isEmpty) {
      Get.snackbar('Input Error', 'Please select a data plan',
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
      // Save fetched variations to secure storage
      await _saveVariationsToStorage();
    } catch (e) {
      Failure failure = ErrorMapper.map(e as Exception);
      showSnackbar('Error', failure.message);
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
      final amount = double.parse(selectedAmount.value);

      final response = await dataRepository.buyData(
          user_id: userAuthDetailsController.user.value!.id.toString(),
          amount: amount,
          phone: phoneNumber.value,
          serviceId: serviceId,
          variationId: selectedVariationId.value,
          requestId: requestId);

      final receiptData = response!['receipt_data'];
      Get.offNamed(RoutesConstant.data_receipt, arguments: receiptData);
    } catch (e) {
      Failure failure = ErrorMapper.map(e as Exception);
      showSnackbar('Error', failure.message);
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