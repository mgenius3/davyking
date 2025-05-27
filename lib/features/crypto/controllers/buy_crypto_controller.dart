import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/features/crypto/controllers/index_controller.dart';
import 'package:davyking/features/crypto/data/model/crypto_list_model.dart';
import 'package:davyking/features/crypto/data/repositories/crypto_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class BuyCryptoController extends GetxController {
  // Crypto-related data
  final availableCryptos = <CryptoListModel>[].obs;
  var selectedCrypto = Rxn<CryptoListModel>();
  final availableNetworks = <String>[].obs;
  final selectedNetwork = ''.obs;

  // Input fields
  final walletAddressController = TextEditingController();
  final amountController = TextEditingController();
  final isCryptoAmount = true.obs; // Toggle between Crypto and Fiat
  final cryptoAmount = 0.0.obs;
  final fiatAmount = 0.0.obs;
  final currentRate = 0.0.obs; // Rate in ₦ per $

  // Loading state
  var paymentScreenshot = Rxn<File>(); // Using Rxn for nullable reactive value

  // Add payment method state
  final paymentMethod = 'Bank Transfer'.obs; // Default to Bank Transfer
  final availablePaymentMethods = ['Bank Transfer', 'Wallet Balance'];

  final isLoading = false.obs;

  BuyCryptoController({required CryptoListModel cryptoData}) {
    selectedCrypto.value = cryptoData;
  }

  final CryptoRepository cryptoRepository = CryptoRepository();
  final UserAuthDetailsController userAuthDetailsController =
      Get.find<UserAuthDetailsController>();
  final CryptoController controller = Get.find<CryptoController>();

  @override
  void onInit() {
    super.onInit();
    fetchCryptocurrencies();
    // Add listener to amountController for real-time validation
    amountController.addListener(() {
      calculateEquivalentAmount();
      validateAmountToNotExceedLiquidation();
    });
  }

  @override
  void onClose() {
    walletAddressController.dispose();
    amountController.dispose();
    super.onClose();
  }

  // Fetch available cryptocurrencies
  Future<void> fetchCryptocurrencies() async {
    try {
      isLoading.value = true;

      final cryptos = controller.all_crypto;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        availableCryptos.assignAll(cryptos);

        if (cryptos.isNotEmpty) {
          updateCurrentRate();
        }
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch cryptocurrencies: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Update selected crypto
  void updateSelectedCrypto(CryptoListModel? crypto) {
    selectedCrypto.value = crypto;
    updateCurrentRate();
    calculateEquivalentAmount();
    // Update network if available
    if (crypto != null) {
      availableNetworks.assignAll([crypto.network]);
      selectedNetwork.value = crypto.network;
    }
  }

  // Update selected network
  void updateSelectedNetwork(String? network) {
    if (network != null) {
      selectedNetwork.value = network;
    }
  }

  // Update current rate based on selected crypto
  void updateCurrentRate() {
    if (selectedCrypto.value != null) {
      currentRate.value = double.tryParse(selectedCrypto.value!.buyRate) ?? 0.0;
    }
  }

  // Toggle between Crypto and Fiat input
  void toggleAmountType(bool isCrypto) {
    isCryptoAmount.value = isCrypto;
    calculateEquivalentAmount();
  }

  // Calculate equivalent amount based on input
  void calculateEquivalentAmount() {
    if (selectedCrypto.value == null) return;

    double rate = double.tryParse(selectedCrypto.value!.buyRate) ?? 0.0;
    double inputAmount = double.tryParse(amountController.text) ?? 0.0;
    double currentPrice =
        double.tryParse(selectedCrypto.value!.currentPrice) ?? 0.0;

    if (isCryptoAmount.value) {
      // Input is in crypto, calculate fiat
      cryptoAmount.value = inputAmount;
      fiatAmount.value = inputAmount * rate;
    } else {
      // Input is in fiat, calculate crypto
      fiatAmount.value = inputAmount;
      cryptoAmount.value = inputAmount / (rate * currentPrice);
    }
  }

  // Real-time validation for amount
  void validateAmountToNotExceedLiquidation() {
    // if (selectedCr) {}
    // if (selectedCrypto.value == null ||
    //     paymentMethod.value != 'Wallet Balance') {
    //   return;
    // }
    double inputAmount = double.tryParse(amountController.text) ?? 0.0;
    double availableBalance = selectedCrypto.value!.liquid_balance;

    if (isCryptoAmount.value) {
      // Input is in crypto
      if (inputAmount > availableBalance) {
        Get.snackbar(
          'Warning',
          'Enter amount not greater than  ${(selectedCrypto.value!.liquid_balance).toInt()}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } else {
      // Input is in fiat, convert to crypto for comparison
      double rate = double.tryParse(selectedCrypto.value!.buyRate) ?? 0.0;
      double cryptoEquivalent = inputAmount / rate;
      if (cryptoEquivalent > availableBalance) {
        Get.snackbar('Warning',
            'Enter amount not greater than  ${(selectedCrypto.value!.liquid_balance * rate).toInt()}',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange,
            colorText: Colors.white);
      }
    }
  }

  // Paste wallet address from clipboard
  Future<void> pasteWalletAddress() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      walletAddressController.text = data.text!;
    }
  }

  // Validate inputs
  bool validateInputs() {
    validateAmountToNotExceedLiquidation();

    if (selectedCrypto.value == null) {
      Get.snackbar('Error', 'Please select a cryptocurrency');
      return false;
    }
    if (walletAddressController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a wallet address');
      return false;
    }

    if (amountController.text.isEmpty ||
        double.tryParse(amountController.text) == null) {
      Get.snackbar('Error', 'Please enter a valid amount');
      return false;
    }

    // Validate amount against balance for Wallet Balance payment method
    if (paymentMethod.value == 'Wallet Balance') {
      double inputAmount = double.tryParse(amountController.text) ?? 0.0;
      double availableBalance = double.tryParse(
              userAuthDetailsController.user.value!.walletBalance) ??
          0.0;

      if (isCryptoAmount.value) {
        // Input is in crypto
        if (inputAmount > availableBalance) {
          Get.snackbar(
            'Error',
            'Amount exceeds available balance (${availableBalance.toStringAsFixed(2)} ${selectedCrypto.value!.symbol})',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
      } else {
        // Input is in fiat, convert to crypto for comparison
        double rate = double.tryParse(selectedCrypto.value!.buyRate) ?? 0.0;
        double cryptoEquivalent = inputAmount / rate;
        if (cryptoEquivalent > availableBalance) {
          Get.snackbar(
            'Error',
            'Amount exceeds available balance (${availableBalance.toStringAsFixed(2)} ${selectedCrypto.value!.symbol})',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
      }
    }

    if (paymentMethod.value == 'Bank Transfer' &&
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

  // Submit buy crypto transaction
  Future<void> submitBuyCrypto() async {
    isLoading.value = true;

    try {
      Map<String, dynamic> fields = {
        "crypto_name": selectedCrypto.value!.name,
        "user_id": userAuthDetailsController.user.value!.id,
        "crypto_currency_id": selectedCrypto.value!.id,
        "type": "buy",
        "amount": cryptoAmount.value.toString(),
        "wallet_address": walletAddressController.text,
        "status": "pending",
        "payment_method": paymentMethod.value.toLowerCase().replaceAll(
            ' ', '_'), // Convert to API format (e.g., "bank_transfer")
      };
      await cryptoRepository.transactCrypto(
          fields, paymentScreenshot.value?.path ?? "");
      Get.showSnackbar(
        GetSnackBar(
            title: 'Success',
            message: 'Transaction created successfully',
            duration: const Duration(seconds: 3),
            backgroundColor: DarkThemeColors.primaryColor),
      );
      Get.offNamed(RoutesConstant.home);
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit purchase: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Add method to update payment method
  void updatePaymentMethod(String? method) {
    if (method != null) {
      paymentMethod.value = method;
      // Clear screenshot if switching to Wallet Balance
      if (method == 'Wallet Balance') {
        paymentScreenshot.value = null;
      }
    }
  }
}
