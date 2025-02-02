import 'package:get/get.dart';

class BuyGiftcardController extends GetxController {
  // State variables
  var selectedCountry = "United States".obs;
  var selectedRange = "US (\$50–\$100)".obs;
  var quantity = 1.obs;
  var exchangeRate = 1250.0; // Example rate (Naira per Dollar)
  var selectedPrice = 100.0.obs;

  // Available options
  final List<String> countries = ["United States", "Canada", "UK"];
  final List<String> ranges = ["US (\$50–\$100)", "US (\$101–\$200)"];

  // Computed property for total amount
  double get totalAmount => quantity.value * selectedPrice.value * exchangeRate;

  // Methods
  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void updateSelectedCountry(String? country) {
    if (country != null) {
      selectedCountry.value = country;
    }
  }

  void updateSelectedRange(String? range) {
    if (range != null) {
      selectedRange.value = range;
    }
  }

  void updateSelectedPrice(double price) {
    selectedPrice.value = price;
  }
}
