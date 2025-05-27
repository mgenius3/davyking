import 'package:davyking/core/constants/images.dart';
import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/controllers/primary_button_controller.dart';
import 'package:davyking/core/models/primary_button_model.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/widgets/primary_button_widget.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:davyking/features/airtime/controllers/index_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AirtimeReceiptScreen extends StatelessWidget {
  const AirtimeReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>;
    final serviceId = data['disco'];
    final phone = data['phone'];
    final amount = data['amount'];

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: Spacing.defaultMarginSpacing,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TopHeaderWidget(
                  data: TopHeaderModel(title: 'Airtime Receipt')),
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
                            spreadRadius: 0),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              serviceId.toString().toLowerCase() ==
                                      'MTN'.toLowerCase()
                                  ? SvgConstant.mtnIcon
                                  : serviceId.toString().toLowerCase() ==
                                          'Glo'.toLowerCase()
                                      ? SvgConstant.gloIcon
                                      : serviceId.toString().toLowerCase() ==
                                              'Airtel'.toLowerCase()
                                          ? SvgConstant.airtelIcon
                                          : SvgConstant.etisalatIcon,
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  serviceId,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          height: 1.38),
                                ),
                                Text(
                                  phone,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          height: 1.57,
                                          color: Colors.grey[600]),
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
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Column(
                            children: [
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
                              details('Amount Charged', '₦${amount}'),
                              const SizedBox(height: 10),
                              details('Phone', '$phone'),
                              const SizedBox(height: 10),
                              details(
                                  'Transaction Date',
                                  _formatDate(
                                      DateTime.parse(data['timestamp'])))
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
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
