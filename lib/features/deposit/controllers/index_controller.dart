import 'dart:convert';
import 'package:davyking/core/constants/api_url.dart';
import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/errors/error_mapper.dart';
import 'package:davyking/core/errors/failure.dart';
import 'package:davyking/core/repository/payment_repository.dart';
import 'package:davyking/core/utils/snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// Only import WebView for non-web platforms
import 'package:davyking/core/widgets/webview_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'dart:html' as html; // For web-specific navigation

class DepositController extends GetxController {
  final amountController = TextEditingController();
  final RxString selectedGateway = RxString('paystack');
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

  // Initialize deposit with platform detection
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
      var email = userAuthDetailsController.user.value!.email;
      var name = userAuthDetailsController.user.value!.name;
      var userId = userAuthDetailsController.user.value!.id;

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

        // Platform-specific navigation
        if (kIsWeb) {
          // For web: Open payment in new tab/window
          await _handleWebPayment(checkoutUrl, amount);
        } else {
          // For mobile: Use WebView
          await _handleMobilePayment(checkoutUrl, amount);
        }
      } else {
        throw Exception('Failed to initialize payment');
      }
    } catch (e) {
      isLoading.value = false;
      Failure failure = ErrorMapper.map(e as Exception);
      showSnackbar('Error', failure.message);
    }
  }

  // Handle web payment (opens in new tab)
  Future<void> _handleWebPayment(String checkoutUrl, double amount) async {
    try {
      final Uri paymentUri = Uri.parse(checkoutUrl);

      // Extract reference from the checkout URL for later verification
      final reference = 'ref_${DateTime.now().millisecondsSinceEpoch}';

      if (await canLaunchUrl(paymentUri)) {
        // html.window.location.assign(checkoutUrl);


        await launchUrl(
          paymentUri,
          mode: LaunchMode.externalApplication, // Opens in new tab
        );
        // Show dialog to user about payment process with reference
        _showWebPaymentDialog(amount, reference);
      } else {
        showSnackbar('Error', 'Could not open payment page');
      }
    } catch (e) {
      showSnackbar('Error', 'Failed to open payment page: $e');
    }
  }

  // Handle mobile payment (WebView) - only works on mobile
  Future<void> _handleMobilePayment(String checkoutUrl, double amount) async {
    try {
      Get.to(() => WebViewScreen(
            initialUrl: checkoutUrl,
            title: 'Deposit ₦${amount.toStringAsFixed(0)}',
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
                  Get.toNamed(RoutesConstant.home);
                  showSnackbar('Success',
                      'Payment processing. Balance will update soon.',
                      isError: false);
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          ));
    } catch (e) {
      showSnackbar('Error', 'Failed to open payment screen: $e');
    }
  }

  // Show dialog for web payment instruction
  void _showWebPaymentDialog(double amount, String reference) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.open_in_new, color: Colors.blue[600]),
            const SizedBox(width: 8),
            const Text('Payment Gateway'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Colors.blue[600], size: 20),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Payment page opened in new tab',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Amount: ₦${amount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ref: $reference',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '📱 Complete your payment in the new tab\n'
              '🔄 Your wallet will update automatically\n'
              '✅ Return here when done',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              _verifyWebPayment(reference);
            },
            child: const Text('I\'ve completed payment'),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Verify web payment with specific reference
  Future<void> _verifyWebPayment(String reference) async {
    Get.dialog(
      AlertDialog(
        title: const Text('Verifying Payment'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Checking your payment status...'),
          ],
        ),
      ),
      barrierDismissible: false,
    );

    try {
      // Wait a bit for payment to process
      await Future.delayed(const Duration(seconds: 2));

      // Call the actual verify payment method
      await verifyPayment(reference, selectedGateway.value);

      // Close the verification dialog
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Navigate back to home
      Get.toNamed(RoutesConstant.home);
    } catch (e) {
      // Close the verification dialog
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Show fallback success message
      showSnackbar(
        'Info',
        'Payment verification in progress. Your balance will update shortly if successful.',
        isError: false,
      );

      // Refresh user data anyway
      Get.find<UserAuthDetailsController>().getUserDetail();
    }
  }

  // Check payment status for web users (fallback method)
  void _checkPaymentStatus() {
    Get.dialog(
      AlertDialog(
        title: const Text('Checking Payment'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Verifying your payment...'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.find<UserAuthDetailsController>().getUserDetail();
              showSnackbar(
                'Info',
                'Payment status will update shortly if successful.',
                isError: false,
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );

    // Auto-close after 3 seconds and refresh user data
    Future.delayed(const Duration(seconds: 3), () {
      if (Get.isDialogOpen ?? false) {
        Get.back();
        Get.find<UserAuthDetailsController>().getUserDetail();
        showSnackbar(
          'Success',
          'If payment was successful, your balance will update shortly.',
          isError: false,
        );
      }
    });
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
          'user_id': userAuthDetailsController.user.value!.id,
          'amount': amount,
          'bank_code': selectedBankCode.value,
          'account_number': accountNumberController.text,
          'account_name': accountNameController.text
        }),
      );

      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        isLoading.value = false;
        Get.snackbar('Success', 'Withdrawal initiated successfully');
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
