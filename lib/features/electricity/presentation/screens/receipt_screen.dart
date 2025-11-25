import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/controllers/primary_button_controller.dart';
import 'package:davyking/core/models/primary_button_model.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/primary_button_widget.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:davyking/features/electricity/controllers/index_controller.dart';
import 'package:davyking/features/giftcards/controllers/index_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ElectricityReceiptScreen extends StatelessWidget {
  const ElectricityReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>;
    final disco = data['disco'];
    final customerId = data['customer_id'];

    final ElectricityIndexController controller =
        Get.put(ElectricityIndexController());


    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Container(
          margin: Spacing.defaultMarginSpacing,
          child: Column(
            children: [
              const TopHeaderWidget(
                  data: TopHeaderModel(title: 'Electricity Receipt')),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      
                      // Success Icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.green.shade200,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green.shade600,
                          size: 40,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Text(
                        'Transaction Successful',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.green.shade700,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        'Your electricity bill payment has been completed',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Main Receipt Card
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Header Section with Service Info
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      controller.discoMapping.firstWhere(
                                          (d) => d['service_id'] == disco)['icon']!,
                                      width: 32,
                                      height: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.discoMapping.firstWhere(
                                              (d) => d['service_id'] == disco)['name']!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            customerId,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.blue.shade700,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Transaction Details
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Transaction Details',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                  ),
                                  const SizedBox(height: 20),
                                  
                                  // Token - Special highlighting if available
                                  if (data['response']['data']['token'] != null) ...[
                                    _buildDetailRow(
                                      context,
                                      'Token',
                                      data['response']['data']['token'],
                                      Icons.qr_code_2_outlined,
                                      valueColor: DarkThemeColors.primaryColor,
                                      isSpecial: true,
                                    ),
                                  ],
                                  
                                  _buildDetailRow(
                                    context,
                                    'Customer Name',
                                    data['response']['data']['customer_name'] ?? 'N/A',
                                    Icons.person_outline,
                                  ),
                                  
                                  _buildDetailRow(
                                    context,
                                    'Service Name',
                                    data['response']['data']['service_name'] ?? 'N/A',
                                    Icons.electrical_services_outlined,
                                  ),
                                  
                                  _buildDetailRow(
                                    context,
                                    'Units',
                                    data['response']['data']['units'] ?? 'N/A',
                                    Icons.flash_on_outlined,
                                  ),
                                  
                                  _buildDetailRow(
                                    context,
                                    'Order ID',
                                    data['response']['data']['order_id'].toString(),
                                    Icons.receipt_long_outlined,
                                  ),
                                  
                                  _buildDetailRow(
                                    context,
                                    'Request ID',
                                    data['response']['data']['request_id'].toString(),
                                    Icons.tag_outlined,
                                  ),
                                  
                                  _buildDetailRow(
                                    context,
                                    'Status',
                                    data['response']['data']['status']
                                        .replaceAll('-api', '')
                                        .toString()
                                        .capitalizeFirst!,
                                    Icons.check_circle_outline,
                                    valueColor: Colors.green.shade600,
                                  ),
                                  
                                  _buildDetailRow(
                                    context,
                                    'Transaction Date',
                                    _formatDate(DateTime.now()),
                                    Icons.access_time_outlined,
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Amount Section - Highlighted
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          DarkThemeColors.primaryColor.withOpacity(0.1),
                                          DarkThemeColors.primaryColor.withOpacity(0.05),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: DarkThemeColors.primaryColor.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total Amount',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: DarkThemeColors.primaryColor,
                                              ),
                                        ),
                                        Text(
                                          '₦${data['response']['data']['amount']}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w700,
                                                color: DarkThemeColors.primaryColor,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              
              // Bottom Button
              CustomPrimaryButton(
                controller: CustomPrimaryButtonController(
                  model: CustomPrimaryButtonModel(
                      text: 'Done', color: DarkThemeColors.primaryColor),
                  onPressed: () {
                    Get.offAllNamed(RoutesConstant.home);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
    bool isSpecial = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isSpecial 
                  ? DarkThemeColors.primaryColor.withOpacity(0.1)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 18,
              color: isSpecial 
                  ? DarkThemeColors.primaryColor
                  : Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 15,
                    fontWeight: isSpecial ? FontWeight.w700 : FontWeight.w600,
                    color: valueColor ?? Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}