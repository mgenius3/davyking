import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/features/crypto/controllers/index_controller.dart';
import 'package:davyking/features/crypto/data/model/crypto_list_model.dart';
import 'package:davyking/features/crypto/data/repositories/crypto_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class SellCryptoController extends GetxController {
  // Crypto-related data
  final availableCryptos = <CryptoListModel>[].obs;
  var selectedCrypto = Rxn<CryptoListModel>();
  final availableNetworks = <String>[].obs;
  final selectedNetwork = ''.obs;

  // Input fields
  final amountController = TextEditingController();
  final isCryptoAmount = true.obs; // Toggle between Crypto and Fiat
  final cryptoAmount = 0.0.obs;
  final fiatAmount = 0.0.obs;
  final currentRate = 0.0.obs; // Rate in $ per unit of crypto

  // Proof of coin transfer
  var proofScreenshot = Rxn<File>(); // Using Rxn for nullable reactive value

  // Loading state
  final isLoading = false.obs;

  SellCryptoController({required CryptoListModel cryptoData}) {
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
      validateAmountToNotExceedUserBalance();
    });
  }

  @override
  void onClose() {
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
        } else {
          print('crypto\'s is empty');
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

  // Update current rate based on selected crypto
  void updateCurrentRate() {
    if (selectedCrypto.value != null) {
      currentRate.value =
          double.tryParse(selectedCrypto.value!.sellRate) ?? 0.0;
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

    double rate = double.tryParse(selectedCrypto.value!.sellRate) ?? 0.0;
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

  // Real-time validation for amount (ensure it doesn't exceed user's balance)
  void validateAmountToNotExceedUserBalance() {
    double inputAmount = double.tryParse(amountController.text) ?? 0.0;
    // For sell transactions, you might want to check if the user has enough crypto in their wallet.
    // Since we don't have a user crypto wallet balance in this setup, we'll assume the user can sell any amount.
    // If you have a user crypto balance, you can add validation here.
  }

  // Validate inputs
  bool validateInputs() {
    if (selectedCrypto.value == null) {
      Get.snackbar('Error', 'Please select a cryptocurrency');
      return false;
    }

    if (selectedCrypto.value!.wallet_address == null ||
        selectedCrypto.value!.wallet_address!.isEmpty) {
      Get.snackbar('Error',
          'Admin wallet address not set for this cryptocurrency. Please contact support.');
      return false;
    }

    if (amountController.text.isEmpty ||
        double.tryParse(amountController.text) == null ||
        double.tryParse(amountController.text)! <= 0) {
      Get.snackbar('Error', 'Please enter a valid amount greater than 0');
      return false;
    }

    if (proofScreenshot.value == null) {
      Get.snackbar('Error', 'Please upload a proof of coin transfer');
      return false;
    }

    return true;
  }

  // Methods for proof screenshot handling
  Future<void> uploadProofScreenshot() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        proofScreenshot.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload screenshot: $e');
    }
  }

  void removeProofScreenshot() {
    proofScreenshot.value = null;
  }

  // Submit sell crypto transaction
  Future<void> submitSellCrypto() async {
    isLoading.value = true;

    try {
      Map<String, dynamic> fields = {
        "crypto_name": selectedCrypto.value!.name,
        "user_id": userAuthDetailsController.user.value!.id,
        "crypto_currency_id": selectedCrypto.value!.id,
        "type": "sell",
        "amount": cryptoAmount.value.toString(),
        "wallet_address":
            null, // Not needed for sell (admin wallet address is used)
        "status": "pending",
        "payment_method":
            "wallet_balance", // Fiat will be credited to wallet balance
      };

      await cryptoRepository.transactCrypto(
          fields, proofScreenshot.value?.path ?? "");

      Get.showSnackbar(
        GetSnackBar(
            title: 'Success',
            message: 'Transaction created successfully',
            duration: const Duration(seconds: 3),
            backgroundColor: DarkThemeColors.primaryColor),
      );
      Get.offNamed(RoutesConstant.home);
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit sell request: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
