import 'dart:convert';
import 'package:davyking/core/constants/api_url.dart';
import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/errors/error_mapper.dart';
import 'package:davyking/core/errors/failure.dart';
import 'package:davyking/core/repository/payment_repository.dart';
import 'package:davyking/core/utils/snackbar.dart';
import 'package:davyking/core/widgets/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class DepositController extends GetxController {
  final amountController = TextEditingController();
  final RxString selectedGateway = RxString('');
  final RxBool isLoading = false.obs;
  final RxDouble walletBalance = 0.0.obs;
  final RxString authToken = ''.obs;
  final RxList<Map<String, dynamic>> banks = <Map<String, dynamic>>[].obs;
  final RxString selectedBankCode = ''.obs;

  // Withdrawal fields
  final accountNumberController = TextEditingController();
  final accountNameController = TextEditingController();

  final String paystackCallbackUrl =
      '${ApiUrl.base_url}/payment/paystack/callback';
  final String flutterwaveCallbackUrl =
      '${ApiUrl.base_url}/payment/flutterwave/callback';

  final UserAuthDetailsController userAuthDetailsController =
      Get.find<UserAuthDetailsController>();

  final PaymentRepository paymentRepository = PaymentRepository();

  @override
  void onInit() {
    super.onInit();
    // fetchBanks();
  }

  @override
  void onClose() {
    amountController.dispose();
    accountNumberController.dispose();
    accountNameController.dispose();
    super.onClose();
  }

  void selectGateway(String gateway) {
    selectedGateway.value = gateway;
  }

 
  // Initialize deposit
  Future<void> initializePayment() async {
    if (amountController.text.isEmpty ||
        double.tryParse(amountController.text) == null) {
      Get.snackbar('Error', 'Please enter a valid amount');
      return;
    }

    if (selectedGateway.value.isEmpty) {
      Get.snackbar('Error', 'Please select a payment method');
      return;
    }

    isLoading.value = true;

    try {
      final amount = double.parse(amountController.text);
      final reference = 'ref_${DateTime.now().millisecondsSinceEpoch}';
      var email = userAuthDetailsController
          .user.value!.email; // Replace with authenticated user email
      var name = userAuthDetailsController
          .user.value!.name; // Replace with authenticated user name
      var userId = userAuthDetailsController
          .user.value!.id; // Replace with authenticated user ID

      String url;
      Map<String, dynamic> body;

      if (selectedGateway.value == 'paystack') {
        url = '${ApiUrl.base_url}/payment/paystack/initialize';
        body = {
          'email': email,
          'amount': amount,
          'reference': reference,
          'user_id': userId,
        };
      } else {
        url = '${ApiUrl.base_url}/payment/flutterwave/initialize';
        body = {
          'amount': amount,
          'email': email,
          'name': name,
          'tx_ref': reference,
          'user_id': userId
        };
      }

      var checkoutUrl = await paymentRepository.depositFunds(
          selectedGateway.value, url, body);

      if (checkoutUrl != null) {
        isLoading.value = false;
        Get.to(() => WebViewScreen(
              initialUrl: checkoutUrl,
              title: 'Deposit ₦${amount}',
              navigationDelegate: NavigationDelegate(
                onNavigationRequest: (NavigationRequest request) {
                  final callbackUrl = selectedGateway.value == 'paystack'
                      ? paystackCallbackUrl
                      : flutterwaveCallbackUrl;
                  if (request.url.startsWith(callbackUrl)) {
                    final uri = Uri.parse(request.url);
                    final reference = uri.queryParameters['reference'] ??
                        uri.queryParameters['transaction_id'];
                    if (reference != null) {
                      // Webhook handles fundWallet, but verify for UI feedback
                      verifyPayment(reference, selectedGateway.value);
                    }
                    Get.toNamed(RoutesConstant.home);
                    showSnackbar('Success',
                        'Payment processing. Balance will update soon.',
                        isError: false);
                    // fetchWalletBalance();
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
            ));
      } else {
        throw Exception('Failed to initialize payment');
      }
    } catch (e) {
      isLoading.value = false;
      Failure failure = ErrorMapper.map(e as Exception);
      showSnackbar('Error', failure.message);
    }
  }

  // Verify payment (optional, for UI feedback)
  Future<void> verifyPayment(String reference, String gateway) async {
    try {
      final url = gateway == 'paystack'
          ? '${ApiUrl.base_url}/payment/paystack/verify/$reference'
          : '${ApiUrl.base_url}/payment/flutterwave/verify/$reference';

      bool response = await paymentRepository.verifyPayment(url, gateway);
      print(response);
      if (response) {
        showSnackbar('Success', 'Payment verified successfully',
            isError: false);
        Get.find<UserAuthDetailsController>().getUserDetail();
      } else {
        showSnackbar('Error', 'Payment verification failed');
      }
    } catch (e) {
      Failure failure = ErrorMapper.map(e as Exception);
      showSnackbar('Error', failure.message);
    }
  }

  // Initialize withdrawal
  Future<void> initializeWithdrawal() async {
    if (amountController.text.isEmpty ||
        double.tryParse(amountController.text) == null) {
      Get.snackbar('Error', 'Please enter a valid amount');
      return;
    }

    if (selectedBankCode.value.isEmpty ||
        accountNumberController.text.isEmpty ||
        accountNameController.text.isEmpty) {
      Get.snackbar('Error', 'Please provide complete bank details');
      return;
    }

    final amount = double.parse(amountController.text);
    if (amount > walletBalance.value) {
      Get.snackbar('Error', 'Insufficient wallet balance');
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('${ApiUrl.base_url}/paystack/paystack/transfer'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authToken.value}',
        },
        body: jsonEncode({
          'user_id': 1, // Replace with authenticated user ID
          'amount': amount,
          'bank_code': selectedBankCode.value,
          'account_number': accountNumberController.text,
          'account_name': accountNameController.text,
        }),
      );

      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        isLoading.value = false;
        Get.snackbar('Success', 'Withdrawal initiated successfully');
        // fetchWalletBalance();
        amountController.clear();
        selectedBankCode.value = '';
        accountNumberController.clear();
        accountNameController.clear();
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Withdrawal failed: $e');
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
