import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DepositController extends GetxController {
  final amountController = TextEditingController();
  final RxString selectedGateway = RxString('');
  final RxBool isLoading = false.obs;

  final String backendUrl =
      'https://your-ngrok-url.ngrok.io/api'; // Your Laravel API base URL
  final String paystackCallbackUrl =
      'https://your-ngrok-url.ngrok.io/paystack/callback';
  final String flutterwaveCallbackUrl =
      'https://your-ngrok-url.ngrok.io/flutterwave/callback';

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }

  // Set the selected payment gateway
  void selectGateway(String gateway) {
    selectedGateway.value = gateway;
  }

  // Initialize payment for Paystack or Flutterwave
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
      final email = 'user@example.com'; // Replace with actual user email
      final name = 'Test User'; // Replace with actual user name

      String url;
      Map<String, dynamic> body;

      if (selectedGateway.value == 'paystack') {
        url = '$backendUrl/paystack/initialize';
        body = {
          'email': email,
          'amount': amount,
          'reference': reference,
        };
      } else {
        url = '$backendUrl/flutterwave/initialize';
        body = {
          'amount': amount,
          'email': email,
          'name': name,
          'tx_ref': reference,
        };
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);
      String? checkoutUrl;

      if (selectedGateway.value == 'paystack' && data['status'] == true) {
        checkoutUrl = data['data']['authorization_url'];
      } else if (selectedGateway.value == 'flutterwave' &&
          data['status'] == 'success') {
        checkoutUrl = data['data']['link'];
      }

      if (checkoutUrl != null) {
        isLoading.value = false;
        // Navigate to WebViewScreen
        Get.to(() => WebViewScreen(
              initialUrl: checkoutUrl,
              title: '${selectedGateway.value.capitalize()} Payment',
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
                      verifyPayment(reference, selectedGateway.value);
                    }
                    Get.back();
                    Get.snackbar('Success', 'Payment completed: Reference $reference');
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
            ));
      } else {
        throw Exception('Failed to initialize payment: ${data['message']}');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Payment failed: $e');
    }
  }

  // Verify payment (optional, ideally done on backend)
  Future<void> verifyPayment(String reference, String gateway) async {
    try {
      final url = gateway == 'paystack'
          ? '$backendUrl/paystack/verify/$reference'
          : '$backendUrl/flutterwave/verify/$reference';
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      final data = jsonDecode(response.body);
      if ((gateway == 'paystack' &&
              data['status'] == true &&
              data['data']['status'] == 'success') ||
          (gateway == 'flutterwave' && data['status'] == 'success')) {
        Get.snackbar('Success', 'Payment verified successfully');
      } else {
        Get.snackbar('Error', 'Payment verification failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Verification error: $e');
    }
  }
}

// Extension to capitalize strings
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
