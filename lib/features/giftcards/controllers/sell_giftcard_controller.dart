// import 'package:davyking/core/constants/routes.dart';
// import 'package:davyking/core/controllers/user_auth_details_controller.dart';
// import 'package:davyking/features/giftcards/data/repositories/gift-card_repository.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:davyking/features/giftcards/data/model/giftcards_list_model.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';

// class SellGiftcardController extends GetxController {
//   // Reactive variables
//   var selectedCountry = ''.obs;
//   var selectedRange = ''.obs;
//   var quantity = 1.obs;
//   var totalAmount = 0.0.obs;

//   final isLoading = false.obs;

//   // Lists for dropdowns
//   final List<String> countries = ['USA', 'UK', 'Canada', 'Australia'];
//   RxList<String> ranges = <String>[].obs; // Make ranges reactive
//   // Add payment screenshot variable
//   var paymentScreenshot = Rxn<File>(); // Using Rxn for nullable reactive value

//   // Gift card data (nullable to avoid late initialization)
//   GiftcardsListModel? giftCard;

//   SellGiftcardController({required GiftcardsListModel giftCardData}) {
//     giftCard = giftCardData;
//   }

//   final GiftCardRepository giftCardRepository = GiftCardRepository();
//   final UserAuthDetailsController userAuthDetailsController =
//       Get.find<UserAuthDetailsController>();

//   @override
//   void onInit() {
//     super.onInit();
//     // Initialize default values

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       selectedCountry.value = countries.isNotEmpty ? countries[0] : '';
//       calculateTotalAmount();
//     });
//   }

//   // Update selected country
//   void updateSelectedCountry(String? country) {
//     if (country != null) {
//       selectedCountry.value = country;
//     }
//   }

//   // Update selected range
//   void updateSelectedRange(String? range) {
//     if (range != null) {
//       selectedRange.value = range;
//     }
//   }

//   // Increment quantity
//   void incrementQuantity() {
//     if (giftCard == null) return;
//     if (quantity.value < giftCard!.stock) {
//       quantity.value++;
//       calculateTotalAmount();
//     } else {
//       Get.snackbar('Error', 'Quantity exceeds available stock');
//     }
//   }

//   // Decrement quantity
//   void decrementQuantity() {
//     if (quantity.value > 1) {
//       quantity.value--;
//       calculateTotalAmount();
//     }
//   }

//   // Calculate total amount based on quantity, denomination, and sell rate
//   void calculateTotalAmount() {
//     if (giftCard == null) return;

//     double denomination = double.tryParse(giftCard!.denomination) ?? 0.0;
//     double sellRate = double.tryParse(giftCard!.sellRate) ?? 0.0;
//     totalAmount.value = denomination * sellRate * quantity.value;
//   }

//   // Validate inputs before proceeding
//   bool validateInputs() {
//     if (quantity.value <= 0) {
//       Get.snackbar('Error', 'Quantity must be greater than 0');
//       return false;
//     }

//     if (paymentScreenshot.value == null) {
//       Get.snackbar('Error', 'Please upload a giftcard image');
//       return false;
//     }
//     return true;
//   }

//   // Add new methods for screenshot handling
//   Future<void> uploadScreenshot() async {
//     try {
//       final ImagePicker picker = ImagePicker();
//       final XFile? image = await picker.pickImage(source: ImageSource.gallery);

//       if (image != null) {
//         paymentScreenshot.value = File(image.path);
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to upload screenshot: $e');
//     }
//   }

//   void removeScreenshot() {
//     paymentScreenshot.value = null;
//   }

//   //submit to server
//   Future<void> submitSellGiftCard() async {
//     isLoading.value = true;

//     try {
//       Map<String, dynamic> fields = {
//         "gift_card_name": giftCard!.name,
//         "user_id": userAuthDetailsController.user.value!.id,
//         "gift_card_id": giftCard!.id,
//         "type": "sell",
//         "amount": quantity.value.toString(),
//         "status": 'pending'
//       };

//       var response = await giftCardRepository.transactGiftCard(
//           fields, paymentScreenshot.value!.path);

//       Get.toNamed(RoutesConstant.home);
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to submit purchase');
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/utils/snackbar.dart';
import 'package:davyking/features/giftcards/data/model/giftcards_list_model.dart';
import 'package:davyking/features/giftcards/data/repositories/gift-card_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:davyking/core/controllers/currency_rate_controller.dart';

class SellGiftcardController extends GetxController {
  // Reactive variables
  var selectedCountry = ''.obs;
  var giftCardType = 'physical'.obs;
  var ecode = ''.obs;
  var quantity = 1.obs;
  var balance = ''.obs; // User input for balance (USD)
  var totalAmount = 0.0.obs;
  var isLoading = false.obs;

  // Gift card image
  var giftCardImage = Rxn<File>();

  // Gift card data
  final GiftcardsListModel giftCard;

  // Dependencies
  final GiftCardRepository giftCardRepository = GiftCardRepository();
  final UserAuthDetailsController userAuthDetailsController =
      Get.find<UserAuthDetailsController>();
  final CurrencyRateController currencyRateController =
      Get.find<CurrencyRateController>();

  SellGiftcardController({required this.giftCard});

  @override
  void onInit() {
    super.onInit();
    if (giftCard.countries.isNotEmpty) {
      selectedCountry.value = giftCard.countries[0].name;
    }
    calculateTotalAmount();
  }

  // Update selected country
  void updateSelectedCountry(String? country) {
    if (country != null) {
      print(giftCard.countries
          .indexWhere((giftcard) => giftcard.name == country));
      selectedCountry.value = country;
      calculateTotalAmount();
    }
  }

  // Update gift card type
  void updateGiftCardType(String? type) {
    if (type != null) {
      giftCardType.value = type;
      if (type == 'physical') {
        ecode.value = '';
      } else {
        giftCardImage.value = null;
      }
    }
  }

  // Update e-code
  void updateEcode(String value) {
    ecode.value = value;
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
    double sellRate = double.tryParse(countryRate.sellRate) ?? 0.0;
    totalAmount.value = bal * sellRate;
  }

  // Upload gift card image
  Future<void> uploadGiftCardImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        giftCardImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload gift card image: $e');
    }
  }

  // Remove gift card image
  void removeGiftCardImage() {
    giftCardImage.value = null;
  }

  // Validate inputs
  bool validateInputs() {
    if (selectedCountry.value.isEmpty) {
      showSnackbar('Error', 'Please select a country');
      return false;
    }
    if (balance.value.isEmpty ||
        double.tryParse(balance.value) == null ||
        double.tryParse(balance.value)! <= 0) {
      showSnackbar('Error', 'Please enter a valid balance');
      return false;
    }
    if (giftCardType.value.isEmpty) {
      showSnackbar('Error', 'Please select a gift card type');
      return false;
    }
    if (giftCardType.value == 'physical' && giftCardImage.value == null) {
      showSnackbar('Error', 'Please upload a gift card image');
      return false;
    }
    if (giftCardType.value == 'ecode' && ecode.value.isEmpty) {
      showSnackbar('Error', 'Please enter the e-code');
      return false;
    }
    // if (giftCardType.value == 'ecode') {
    //   final ecodeRegex =
    //       RegExp(r'^[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}$');
    //   if (!ecodeRegex.hasMatch(ecode.value)) {
    //     showSnackbar(
    //         'Error', 'Invalid e-code format (e.g., XXXX-XXXX-XXXX-XXXX)');
    //     return false;
    //   }
    // }
    return true;
  }

  // Submit to server
  Future<void> submitSellGiftCard() async {
    if (!validateInputs()) return;

    isLoading.value = true;
    try {
      Map<String, dynamic> fields = {
        'user_id': userAuthDetailsController.user.value!.id,
        'gift_card_id': giftCard.id,
        'gift_card_name': giftCard.name,
        'country': giftCard.countries
            .indexWhere((giftcard) => giftcard.name == selectedCountry.value)
            .toString(),
        'type': 'sell',
        'balance': balance.value,
        'gift_card_type': giftCardType.value,
        'ecode': giftCardType.value == 'ecode' ? ecode.value : null,
        'status': 'pending'
      };

      String? proofFile =
          giftCardType.value == 'physical' ? giftCardImage.value?.path : null;
      var response =
          await giftCardRepository.transactGiftCard(fields, proofFile);

      Get.offNamed(RoutesConstant.home);
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit sell request: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
