import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/constants/symbols.dart';
import 'package:davyking/core/controllers/currency_rate_controller.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/models/currency_rate_model.dart';
import 'package:davyking/features/home/controllers/balance_display_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BalanceDisplayWidget extends StatelessWidget {
  const BalanceDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final BalanceDisplayController controller =
        Get.put(BalanceDisplayController());
    final userAuthController = Get.find<UserAuthDetailsController>();
    final currencyRateController = Get.find<CurrencyRateController>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      height: 126,
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          end: Alignment(0.99, -0.12),
          begin: Alignment(-0.99, 0.12),
          colors: [
            // Color(0xFFE2FFF3),
            Color(0xFF00CE7C),
            Color(0xFF00CE7C),
            Color(0xFF1ABD1A),
            Color(0xFF1ABD1A),
            Color(0xFF00664A)
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: const [
          BoxShadow(
              color: Color(0x14000000),
              blurRadius: 4,
              offset: Offset(4, 4),
              spreadRadius: 0)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Available Balance',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.75,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(width: 4),
                  Obx(() => GestureDetector(
                      onTap: () {
                        controller.toggleBalanceVisibility();
                      },
                      child: Icon(
                          !controller.showBalance.value
                              ? CupertinoIcons.eye_fill
                              : CupertinoIcons.eye_slash,
                          size: 15,
                          color: Colors.white)))
                ],
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(RoutesConstant.recent_transaction);
                },
                child: const Row(
                  children: [
                    Text(
                      'Transaction History',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.75,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 15, color: Colors.white)
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          Obx(() => GestureDetector(
                onTap: () {
                  controller.toggleBalanceVisibility();
                },
                child: Text(
                  controller.showBalance.value
                      ? '${Symbols.currency_naira}${userAuthController.user.value?.walletBalance ?? 0}'
                      : "******",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                ),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                if (currencyRateController.currencyRates.isNotEmpty) {
                  final walletBalance = double.tryParse(
                          userAuthController.user.value?.walletBalance ??
                              '0') ??
                      0;
                  final ngnRate =
                      currencyRateController.currencyRates.firstWhere(
                    (rate) => rate.currencyCode == 'NGN',
                    orElse: () => CurrencyRateModel(
                        currencyCode: 'NGN', rate: '0', id: 0),
                  );

                  final rateValue = ngnRate.rate.isEmpty
                      ? 1
                      : num.tryParse(ngnRate.rate) ?? 1;

                  final dollarValue =
                      (walletBalance / rateValue).toStringAsFixed(2);

                  return Text(
                    "\$${dollarValue}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  );
                }

                return const Text("\$0",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600));
              }),
              GestureDetector(
                onTap: () {
                  Get.toNamed(RoutesConstant.deposit);
                },
                child: Container(
                  width: 57,
                  height: 28.45,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '+ ',
                                style: TextStyle(
                                  color: Color(0xFF2E5572),
                                  fontSize: 8,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: 'Deposit',
                                style: TextStyle(
                                  color: Color(0xFF2E5572),
                                  fontSize: 10,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
