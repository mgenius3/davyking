import 'package:davyking/features/deposit/controllers/index_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class DepositScreen extends StatelessWidget {
  const DepositScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DepositController controller = Get.put(DepositController());

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.green, Colors.teal],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                ),
                child: const Center(
                  child: Text(
                    'Deposit Funds',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            pinned: true,
            backgroundColor: Colors.green,
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter Amount',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ).animate().fadeIn(duration: 500.ms),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller.amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'e.g., 1000',
                      prefixText: '₦ ',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                    ),
                  ).animate().slideY(begin: 0.2, duration: 600.ms),
                  const SizedBox(height: 24),
                  const Text(
                    
                    // Select 
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ).animate().fadeIn(duration: 700.ms),
                  const SizedBox(height: 12),
                  Obx(() => Row(
                        children: [
                          Expanded(
                            child: PaymentMethodCard(
                              logo: 'assets/images/paystack.png',
                              label: 'Paystack',
                              isSelected: controller.selectedGateway.value ==
                                  'paystack',
                              onTap: () => controller.selectGateway('paystack'),
                            ),
                          ),
                          // const SizedBox(width: 12),
                          // Expanded(
                          //   child: PaymentMethodCard(
                          //     logo: 'assets/images/flutterwave.png',
                          //     label: 'Flutterwave',
                          //     isSelected: controller.selectedGateway.value ==
                          //         'flutterwave',
                          //     onTap: () =>
                          //         controller.selectGateway('flutterwave'),
                          //   ),
                          // ),
                        ],
                      )).animate().slideY(begin: 0.2, duration: 800.ms),
                  const SizedBox(height: 32),
                  Obx(() => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.initializePayment,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                          ),
                          child: controller.isLoading.value
                              ? const SpinKitFadingCircle(
                                  color: Colors.white, size: 24)
                              : const Text(
                                  'Proceed to Payment',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      )).animate().fadeIn(duration: 900.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom widget for payment method cards
class PaymentMethodCard extends StatelessWidget {
  final String logo;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.logo,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              logo,
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.green : Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
