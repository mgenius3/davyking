import 'package:davyking/core/constants/images.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/controllers/primary_button_controller.dart';
import 'package:davyking/core/models/primary_button_model.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/primary_button_widget.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:davyking/features/tv/controllers/index_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:davyking/core/controllers/transaction_auth_controller.dart';

class TvDetailsScreen extends StatelessWidget {
  const TvDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>;
    final customerId = data['customer_id'];
    final variationId = data['variation_id'];
    final amount = data['amount'];

    // final response = data['response']
    //     as Map<String, dynamic>?; // Response might be null before purchase
    // final dataPlan = response?['data']['data_plan'] ?? variationId;
    // final amount = response?['data']['amount_charged'] ?? 'N/A';

    final TvIndexController tvIndexController = Get.find<TvIndexController>();
    final TransactionAuthController transactionAuthController =
        Get.find<TransactionAuthController>();

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: Spacing.defaultMarginSpacing,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TopHeaderWidget(data: TopHeaderModel(title: 'Tv')),
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
                                  tvIndexController.tvMapping[tvIndexController
                                      .selectedTv.value]['icon'],
                                  fit: BoxFit.contain),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tvIndexController.tvMapping[tvIndexController
                                      .selectedTv.value]['name'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        height: 1.38,
                                      ),
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
                              details('Transaction Date',
                                  _formatDate(DateTime.now())),
                              const SizedBox(height: 5),
                              details('Transaction Type', 'Tv'),
                              const SizedBox(height: 5),
                              details(
                                  'Tv Plan',
                                  tvIndexController.selectedPlan.value
                                      .toString()),
                              const SizedBox(height: 5),
                              details('Amount',
                                  '₦${tvIndexController.selectedAmount.value.toString()}'),
                              const SizedBox(height: 5),
                              details('Smart Card / IUC NO', customerId),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('By tapping the trade button, you have agreed to our',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                              height: 2.20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Terms and Conditions',
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: DarkThemeColors.primaryColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                  height: 2.20,
                                ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'And Our',
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                  height: 2.20,
                                ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Privacy Policy',
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: DarkThemeColors.primaryColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                  height: 2.20,
                                ),
                      ),
                    ],
                  ),
                ],
              ),
              Obx(() => tvIndexController.isLoading.value
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
                              .authenticate(context, 'Buy Tv');
                          if (isAuthenticated) {
                            await tvIndexController.buyTv();
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
              fontSize: 12, fontWeight: FontWeight.w500, height: 1.38),
        ),
        Text(value,
            style: Theme.of(Get.context!).textTheme.displayMedium?.copyWith(
                fontSize: 12, fontWeight: FontWeight.w500, height: 1.38)),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
