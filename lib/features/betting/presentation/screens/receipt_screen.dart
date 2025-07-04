import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/controllers/primary_button_controller.dart';
import 'package:davyking/core/models/primary_button_model.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/primary_button_widget.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:davyking/features/betting/controllers/index_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BettingReceiptScreen extends StatelessWidget {
  const BettingReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>;
    final disco = data['disco'];
    final customerId = data['customer_id'];

    final BettingIndexController controller = Get.put(BettingIndexController());

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: Spacing.defaultMarginSpacing,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TopHeaderWidget(
                  data: TopHeaderModel(title: 'Betting Receipt')),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(19.08),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              controller.bettingMapping.firstWhere(
                                  (d) => d['service_id'] == disco)['icon']!,
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.bettingMapping.firstWhere(
                                      (d) => d['service_id'] == disco)['name']!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        height: 1.38,
                                      ),
                                ),
                                Text(
                                  customerId,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        height: 1.57,
                                        color: Colors.grey[600],
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          decoration: ShapeDecoration(
                            color: Colors.grey[50],
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 0.5, color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Column(
                            children: [
                              details(
                                  'Customer Name',
                                  data['response']['data']['customer_name'] ??
                                      'N/A'),
                              const SizedBox(height: 10),
                              details(
                                  'Service Name',
                                  data['response']['data']['service_name'] ??
                                      'N/A'),
                              const SizedBox(height: 10),
                              details(
                                  'Order ID',
                                  data['response']['data']['order_id']
                                      .toString()),
                              const SizedBox(height: 10),
                              details(
                                  'Request ID',
                                  data['response']['data']['request_id']
                                      .toString()),
                              const SizedBox(height: 10),
                              details(
                                  'Status',
                                  data['response']['data']['status']
                                      .replaceAll('-api', '')
                                      .toString()
                                      .capitalizeFirst!),
                              const SizedBox(height: 10),
                              details('Amount',
                                  '₦${data['response']['data']['amount']}'),
                              const SizedBox(height: 10),
                              details('Transaction Date',
                                  _formatDate(DateTime.now())),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              CustomPrimaryButton(
                controller: CustomPrimaryButtonController(
                  model: CustomPrimaryButtonModel(
                      text: 'Done', color: DarkThemeColors.primaryColor),
                  onPressed: () {
                    Get.offAllNamed(
                        RoutesConstant.home); // Or navigate to home screen
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget details(String name, String value, {bool isHighlighted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: Theme.of(Get.context!).textTheme.displayMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.38,
                color: Colors.grey[700],
              ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: Theme.of(Get.context!).textTheme.displayMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
                  height: 1.38,
                  color: isHighlighted
                      ? DarkThemeColors.primaryColor
                      : Colors.black87,
                ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
