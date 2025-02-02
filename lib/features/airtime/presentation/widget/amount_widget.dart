import 'package:davyking/core/constants/symbols.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:davyking/features/airtime/controllers/index_controller.dart';

class AirtimeAmountWidget extends StatelessWidget {
  const AirtimeAmountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final AirtimeIndexController airtimeIndexController =
        Get.find<AirtimeIndexController>();

    return Column(
      children: [
        Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AmountCard(
                  amount: '100',
                  isSelected:
                      airtimeIndexController.selectedAmount.value == '100',
                  onTap: () {
                    airtimeIndexController.setAmount('100');
                  },
                ),
                AmountCard(
                  amount: '200',
                  isSelected:
                      airtimeIndexController.selectedAmount.value == '200',
                  onTap: () {
                    airtimeIndexController.setAmount('200');
                  },
                ),
                AmountCard(
                  amount: '500',
                  isSelected:
                      airtimeIndexController.selectedAmount.value == '500',
                  onTap: () {
                    airtimeIndexController.setAmount('500');
                  },
                ),
              ],
            )),
        const SizedBox(height: 20),
        Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AmountCard(
                  amount: '1000',
                  isSelected:
                      airtimeIndexController.selectedAmount.value == '1000',
                  onTap: () {
                    airtimeIndexController.setAmount('1000');
                  },
                ),
                AmountCard(
                  amount: '2000',
                  isSelected:
                      airtimeIndexController.selectedAmount.value == '2000',
                  onTap: () {
                    airtimeIndexController.setAmount('2000');
                  },
                ),
                AmountCard(
                  amount: '3000',
                  isSelected:
                      airtimeIndexController.selectedAmount.value == '3000',
                  onTap: () {
                    airtimeIndexController.setAmount('3000');
                  },
                ),
              ],
            )),
      ],
    );
  }
}

class AmountCard extends StatelessWidget {
  final String amount;
  final bool isSelected;
  final Function() onTap;

  const AmountCard({
    super.key,
    required this.amount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 60,
        decoration: ShapeDecoration(
          color: const Color(0x3FAFAFAF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.98),
            side: isSelected
                ? BorderSide(color: DarkThemeColors.primaryColor, width: 2)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Symbols.currency,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 16, fontWeight: FontWeight.w400, height: 1.83),
            ),
            const SizedBox(width: 5),
            Text(
              amount,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 16, fontWeight: FontWeight.w400, height: 1.83),
            ),
          ],
        ),
      ),
    );
  }
}
