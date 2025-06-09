import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/errors/error_mapper.dart';
import 'package:davyking/core/errors/failure.dart';
import 'package:davyking/core/utils/snackbar.dart';
import 'package:davyking/features/giftcards/data/repositories/gift-card_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:davyking/core/controllers/currency_rate_controller.dart';
import 'package:davyking/features/giftcards/data/model/giftcards_list_model.dart';

class BuyGiftcardController extends GetxController {
  // Reactive variables
  var selectedCountry = ''.obs;
  var selectedPaymentMethod = ''.obs;
  var balance = ''.obs; // User input for balance (USD)
  var totalAmount = 0.0.obs;
  var isLoading = false.obs;

  // Payment screenshot
  var paymentScreenshot = Rxn<File>();

  // Gift card data
  final GiftcardsListModel giftCard;

  // Dependencies
  final GiftCardRepository giftCardRepository = GiftCardRepository();
  final UserAuthDetailsController userAuthDetailsController =
      Get.find<UserAuthDetailsController>();
  final CurrencyRateController currencyRateController =
      Get.find<CurrencyRateController>();

  BuyGiftcardController({required this.giftCard});

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (giftCard.countries.isNotEmpty) {
        selectedCountry.value = giftCard.countries[0].name;
      }
      selectedPaymentMethod.value =
          ['bank_transfer', 'wallet_balance'].isNotEmpty ? 'bank_transfer' : '';
      calculateTotalAmount();
    });
  }

  // Update selected country
  void updateSelectedCountry(String? country) {
    if (country != null) {
      selectedCountry.value = country;
      calculateTotalAmount();
    }
  }

  // Update selected payment method
  void updateSelectedPaymentMethod(String? method) {
    if (method != null) {
      selectedPaymentMethod.value = method;
      if (method == 'wallet_balance') {
        paymentScreenshot.value = null;
      }
      calculateTotalAmount();
    }
  }

  // Update balance
  void updateBalance(String value) {
    balance.value = value;
    calculateTotalAmount();
  }

  // Calculate total amount
  void calculateTotalAmount() {
    if (selectedCountry.value.isEmpty || balance.value.isEmpty) return;

    final countryRate = giftCard.countries.firstWhere(
      (c) => c.name == selectedCountry.value,
      orElse: () => giftCard.countries[0],
    );
    double bal = double.tryParse(balance.value) ?? 0.0;
    double buyRate = double.tryParse(countryRate.buyRate) ?? 0.0;
    totalAmount.value = bal * buyRate;
  }

  // Upload payment screenshot
  Future<void> uploadScreenshot() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        paymentScreenshot.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload screenshot: $e');
    }
  }

  // Remove payment screenshot
  void removeScreenshot() {
    paymentScreenshot.value = null;
  }

  // Validate inputs
  bool validateInputs() {
    if (selectedCountry.value.isEmpty) {
      Get.snackbar('Error', 'Please select a country');
      return false;
    }
    if (balance.value.isEmpty ||
        double.tryParse(balance.value) == null ||
        double.tryParse(balance.value)! <= 0) {
      showSnackbar('Error', 'Please enter a valid balance');
      return false;
    }
    if (selectedPaymentMethod.value.isEmpty) {
      showSnackbar('Error', 'Please select a payment method');
      return false;
    }
    if (selectedPaymentMethod.value == 'bank_transfer' &&
        paymentScreenshot.value == null) {
      showSnackbar(
          'Error', 'Please upload a payment screenshot for bank transfer');
      return false;
    }

    if (selectedPaymentMethod.value == 'wallet_balance' &&
        (double.parse(userAuthDetailsController.user.value!.walletBalance) <
            totalAmount.value)) {
      showSnackbar('Error', "Insufficent wallet balance");
      return false;
    }
    return true;
  }

  // Submit to server
  Future<void> submitBuyGiftCard() async {
    if (!validateInputs()) return;

    isLoading.value = true;
    try {
      Map<String, dynamic> fields = {
        'user_id': userAuthDetailsController.user.value!.id,
        'gift_card_id': giftCard.id,
        'gift_card_name': giftCard.name,
        'country': giftCard.countries
            .indexWhere((giftcard) => giftcard.name == selectedCountry.value)
            .toString(), // As per JSON
        'type': 'buy',
        'balance': balance.value,
        'status': 'pending',
        'payment_method': selectedPaymentMethod.value,
        'gift_card_type': 'physical', // Default for buys
      };

      String? screenshotPath = selectedPaymentMethod.value == 'bank_transfer'
          ? paymentScreenshot.value?.path
          : null;
      var response =
          await giftCardRepository.transactGiftCard(fields, screenshotPath);
      Get.offNamed(RoutesConstant.home);
    } catch (e) {
      Failure failure = ErrorMapper.map(e as Exception);
      showSnackbar('Error', failure.message);
    } finally {
      isLoading.value = false;
    }
  }
}
