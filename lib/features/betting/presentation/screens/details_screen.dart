import 'package:davyking/core/controllers/primary_button_controller.dart';
import 'package:davyking/core/controllers/transaction_auth_controller.dart';
import 'package:davyking/core/models/primary_button_model.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/primary_button_widget.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:davyking/features/betting/controllers/index_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BettingDetailsScreen extends StatelessWidget {
  const BettingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>;
    final disco = data['disco'];
    final customerId = data['customer_id'];
    final variationId = data['variation_id'];
    final amount = data['amount'];
    final response = data['response'] as Map<String, dynamic>?;

    final BettingIndexController controller =
        Get.find<BettingIndexController>();
    final TransactionAuthController transactionAuthController =
        Get.find<TransactionAuthController>();

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: Spacing.defaultMarginSpacing,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TopHeaderWidget(data: TopHeaderModel(title: 'Betting')),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF7F7F7),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(19.08),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 4,
                          offset: Offset(4, 4),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: Image.asset(
                                  controller.bettingMapping.firstWhere(
                                          (d) => d['service_id'] == disco)[
                                      'icon']!, // Replace with Disco-specific icon

                                  fit: BoxFit.contain),
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
                                          fontWeight: FontWeight.w500,
                                          height: 1.38),
                                ),
                                Text(
                                  customerId,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        fontSize: 17.75,
                                        fontWeight: FontWeight.w500,
                                        height: 1.57,
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
                            color: Colors.white.withOpacity(0.8999999761581421),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 0.50),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x1E000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              details(
                                  'Transaction Date',
                                  response != null
                                      ? _formatDate(DateTime.now())
                                      : 'Pending'),
                              const SizedBox(height: 5),
                              details('Transaction Type', 'Betting'),
                              // const SizedBox(height: 5),
                              // details('Variation',
                              //     variationId.toString().capitalizeFirst!),
                              const SizedBox(height: 5),
                              details('Amount', '₦$amount'),
                              const SizedBox(height: 5),
                              details('Betting ID', '${customerId}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                 
                ],
              ),
              Obx(() => controller.isLoading.value
                  ? CustomPrimaryButton(
                      controller: CustomPrimaryButtonController(
                        model: const CustomPrimaryButtonModel(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    )
                  : CustomPrimaryButton(
                      controller: CustomPrimaryButtonController(
                        model: const CustomPrimaryButtonModel(text: 'Proceed'),
                        onPressed: () async {
                          bool isAuthenticated = await transactionAuthController
                              .authenticate(context, 'Buy Betting');
                          if (isAuthenticated) {
                            await controller.buyBetting();
                          }
                        },
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  Widget details(String name, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: Theme.of(Get.context!).textTheme.displayMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.38,
              ),
        ),
        Text(
          value,
          style: Theme.of(Get.context!).textTheme.displayMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.38,
              ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
