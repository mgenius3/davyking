import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/features/giftcards/data/repositories/gift-card_repository.dart';
import 'package:get/get.dart';
import 'package:davyking/features/giftcards/data/model/giftcards_list_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class SellGiftcardController extends GetxController {
  // Reactive variables
  var selectedCountry = ''.obs;
  var selectedRange = ''.obs;
  var quantity = 1.obs;
  var totalAmount = 0.0.obs;

  final isLoading = false.obs;

  // Lists for dropdowns
  final List<String> countries = ['USA', 'UK', 'Canada', 'Australia'];
  RxList<String> ranges = <String>[].obs; // Make ranges reactive
  // Add payment screenshot variable
  var paymentScreenshot = Rxn<File>(); // Using Rxn for nullable reactive value

  // Gift card data (nullable to avoid late initialization)
  GiftcardsListModel? giftCard;

  SellGiftcardController({required GiftcardsListModel giftCardData}) {
    giftCard = giftCardData;
  }

  final GiftCardRepository giftCardRepository = GiftCardRepository();
  final UserAuthDetailsController userAuthDetailsController =
      Get.find<UserAuthDetailsController>();

  @override
  void onInit() {
    super.onInit();
    // Initialize default values
    selectedCountry.value = countries.isNotEmpty ? countries[0] : '';

    // Use admin-defined ranges from giftCard
    if (giftCard != null && giftCard!.ranges.isNotEmpty) {
      ranges.assignAll(giftCard!.ranges);
    } else {
      // Fallback if no ranges are defined
      ranges.assignAll(['10 - 50', '50 - 100', '100 - 500']);
    }
    selectedRange.value = ranges.isNotEmpty ? ranges[0] : '';

    // Calculate initial total amount after giftCard is set
    calculateTotalAmount();
  }

  // Update selected country
  void updateSelectedCountry(String? country) {
    if (country != null) {
      selectedCountry.value = country;
    }
  }

  // Update selected range
  void updateSelectedRange(String? range) {
    if (range != null) {
      selectedRange.value = range;
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

  // Calculate total amount based on quantity, denomination, and sell rate
  void calculateTotalAmount() {
    if (giftCard == null) return;

    double denomination = double.tryParse(giftCard!.denomination) ?? 0.0;
    double sellRate = double.tryParse(giftCard!.sellRate) ?? 0.0;
    totalAmount.value = denomination * sellRate * quantity.value;
    if (!isTotalAmountInRange()) {
      Get.snackbar(
          'Error', 'Total gift card value does not match the selected range');
    }
  }

  // Check if the total gift card value matches the selected range
  bool isTotalAmountInRange() {
    if (selectedRange.value.isEmpty) return true;
    double totalDollarValue = (double.tryParse(giftCard!.denomination) ?? 0.0) *
        quantity.value *
        (double.tryParse(giftCard!.sellRate) ?? 0.0);
    var rangeParts = selectedRange.value.split(' - ');
    double min = double.parse(rangeParts[0].replaceAll('\$', ''));
    double max = double.parse(rangeParts[1].replaceAll('\$', ''));
    return totalDollarValue >= min && totalDollarValue <= max;
  }

  // Validate inputs before proceeding
  bool validateInputs() {
    // if (selectedCountry.value.isEmpty) {
    //   Get.snackbar('Error', 'Please select a country');
    //   return false;
    // }
    if (selectedRange.value.isEmpty) {
      Get.snackbar('Error', 'Please select a range');
      return false;
    }
    if (quantity.value <= 0) {
      Get.snackbar('Error', 'Quantity must be greater than 0');
      return false;
    }
    if (!isTotalAmountInRange()) {
      Get.snackbar(
          'Error', 'Total gift card value does not match the selected range');
      return false;
    }
    if (paymentScreenshot.value == null) {
      Get.snackbar('Error', 'Please upload a payment screenshot');
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

  //submit to server
  Future<void> submitSellGiftCard() async {
    isLoading.value = true;

    try {
      Map<String, dynamic> fields = {
        "name": giftCard!.name,
        "user_id": userAuthDetailsController.user.value!.id,
        "gift_card_id": giftCard!.id,
        "type": "sell",
        "amount": totalAmount.value.toString(),
        "status": 'pending'
      };

      var response = await giftCardRepository.transactGiftCard(
          fields, paymentScreenshot.value!.path);

      Get.toNamed(RoutesConstant.home);
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit purchase');
    } finally {
      isLoading.value = false;
    }
  }
}
