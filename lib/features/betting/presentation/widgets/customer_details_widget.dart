import 'package:davyking/features/betting/controllers/index_controller.dart';
import 'package:davyking/features/electricity/controllers/index_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Assuming you're using GetX for Obx

class CustomerDetailsWidget extends StatelessWidget {
  final BettingIndexController
      controller; // Replace with your actual controller type

  const CustomerDetailsWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blueGrey.shade50,
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9, // Responsive width
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Colors.blueGrey.shade100,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => controller.customerDetails.isNotEmpty
                  ? Text(
                      'Name: ${controller.customerDetails['customer_name']}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey.shade800,
                          ),
                    )
                  : const SizedBox.shrink()),
              const SizedBox(height: 12),
              Obx(() => controller.customerDetails.isNotEmpty
                  ? Text(
                      'Min betting amount: ${Symbols.currency_naira}${controller.customerDetails['minimum_amount']}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey.shade600,
                          ),
                    )
                  : const SizedBox.shrink()),
              const SizedBox(height: 12),
              Obx(() => controller.customerDetails.isNotEmpty
                  ? Text(
                      'Max betting amount: ${Symbols.currency_naira}${controller.customerDetails['maximum_amount']}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey.shade600,
                          ),
                    )
                  : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder for Symbols class (ensure this is defined in your project)
class Symbols {
  static const String currency_naira = '₦';
}
