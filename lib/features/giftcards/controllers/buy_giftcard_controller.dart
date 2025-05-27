import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/features/giftcards/data/repositories/gift-card_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:davyking/features/giftcards/data/model/giftcards_list_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class BuyGiftcardController extends GetxController {
  // Reactive variables
  var selectedCountry = ''.obs;
  var selectedPaymentMethod = ''.obs;
  var quantity = 1.obs;
  var totalAmount = 0.0.obs;

  final isLoading = false.obs;

  // Lists for dropdowns
  final List<String> countries = ['USA', 'UK', 'Canada', 'Australia'];
  final List<String> paymentMethods = ['bank_transfer', 'wallet_balance'];

  // Add payment screenshot variable
  var paymentScreenshot = Rxn<File>(); // Using Rxn for nullable reactive value

  // Gift card data (nullable to avoid late initialization)
  GiftcardsListModel? giftCard;

  BuyGiftcardController({required GiftcardsListModel giftCardData}) {
    giftCard = giftCardData;
  }

  final GiftCardRepository giftCardRepository = GiftCardRepository();
  final UserAuthDetailsController userAuthDetailsController =
      Get.find<UserAuthDetailsController>();

  @override
  void onInit() {
    super.onInit();
    // Initialize default values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedCountry.value = countries.isNotEmpty ? countries[0] : '';
      selectedPaymentMethod.value =
          paymentMethods.isNotEmpty ? paymentMethods[0] : '';
      calculateTotalAmount();
    });
  }

  // Update selected country
  void updateSelectedCountry(String? country) {
    if (country != null) {
      selectedCountry.value = country;
    }
  }

  // Update selected payment method
  void updateSelectedPaymentMethod(String? method) {
    if (method != null) {
      selectedPaymentMethod.value = method;
      // Reset payment screenshot if switching to wallet_balance
      if (method == 'wallet_balance') {
        paymentScreenshot.value = null;
      }
    }
  }

  // Increment quantity
  void incrementQuantity() {
    if (giftCard == null) return;
    if (quantity.value < giftCard!.stock) {
      quantity.value++;
      calculateTotalAmount();
    } else {
      Get.snackbar('Error', 'Quantity exceeds available stock');
    }
  }

  // Decrement quantity
  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
      calculateTotalAmount();
    }
  }

  // Calculate total amount based on quantity, denomination, and buy rate
  void calculateTotalAmount() {
    if (giftCard == null) return;

    double denomination = double.tryParse(giftCard!.denomination) ?? 0.0;
    double buyRate = double.tryParse(giftCard!.buyRate) ?? 0.0;
    totalAmount.value = denomination * buyRate * quantity.value;
  }

  // Validate inputs before proceeding
  bool validateInputs() {
    if (selectedPaymentMethod.value.isEmpty) {
      Get.snackbar('Error', 'Please select a payment method');
      return false;
    }
    if (quantity.value <= 0) {
      Get.snackbar('Error', 'Quantity must be greater than 0');
      return false;
    }
    if (selectedPaymentMethod.value == 'bank_transfer' &&
        paymentScreenshot.value == null) {
      Get.snackbar(
          'Error', 'Please upload a payment screenshot for bank transfer');
      return false;
    }
    return true;
  }

  // Add new methods for screenshot handling
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

  void removeScreenshot() {
    paymentScreenshot.value = null;
  }

  // Submit to server
  Future<void> submitBuyGiftCard() async {
    isLoading.value = true;

    try {
      Map<String, dynamic> fields = {
        "gift_card_name": giftCard!.name,
        "user_id": userAuthDetailsController.user.value!.id,
        "gift_card_id": giftCard!.id,
        "type": "buy",
        "amount": quantity.value.toString(), // Send quantity
        "status": 'pending',
        "payment_method": selectedPaymentMethod.value,
      };

      // Only include payment screenshot for bank_transfer
      String? screenshotPath = selectedPaymentMethod.value == 'bank_transfer'
          ? paymentScreenshot.value?.path
          : null;
      var response =
          await giftCardRepository.transactGiftCard(fields, screenshotPath!);
      Get.offNamed(RoutesConstant.home);
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit purchase: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
