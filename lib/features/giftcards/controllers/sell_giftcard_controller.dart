import 'package:get/get.dart';
import 'package:flutter_country/flutter_country.dart';

class SellGiftcardController extends GetxController {
  // State variables
  // var selectedCountry = "United States".obs;
  var selectedRange = "US (\$50–\$100)".obs;
  var no_of_card = 1.obs;
  var exchangeRate = 1250.0; // Example rate (Naira per Dollar)
  var selectedPrice = 100.0.obs;

  // Available options
  final List<String> countries = ["United States", "Canada", "UK"];
  final List<String> ranges = ["US (\$50–\$100)", "US (\$101–\$200)"];

  // Computed property for total amount
  double get totalAmount =>
      no_of_card.value * selectedPrice.value * exchangeRate;

  // Observable selected country
  // var selectedCountry = Country(name: 'United States', countryCode: 'US').obs;

  // Function to update the selected country
  // void selectCountry(Country country) {
  //   selectedCountry.value = country;
  // }

  // Methods
  void incrementNoOfCard() {
    no_of_card.value++;
  }

  void decrementNoOfCard() {
    if (no_of_card.value > 1) {
      no_of_card.value--;
    }
  }

  // void updateSelectedCountry(String? country) {
  //   if (country != null) {
  //     selectedCountry.value = country;
  //   }
  // }

  void updateSelectedRange(String? range) {
    if (range != null) {
      selectedRange.value = range;
    }
  }

  void updateSelectedPrice(double price) {
    selectedPrice.value = price;
  }
}
