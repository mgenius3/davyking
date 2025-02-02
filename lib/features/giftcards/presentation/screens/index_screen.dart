import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:davyking/features/giftcards/controllers/index_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GiftCardScreen extends StatelessWidget {
  const GiftCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GiftCardController controller = Get.put(GiftCardController());
    return Scaffold(
      body: SafeArea(
          child: Obx(() => Container(
                margin: Spacing.defaultMarginSpacing,
                child: Column(
                  children: [
                    const TopHeaderWidget(
                        data: TopHeaderModel(title: 'Gift Cards')),
                    const SizedBox(height: 20),
                    Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 3),
                      decoration: ShapeDecoration(
                        color: const Color(0x38009337),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.updateBuyOrSell('buy');
                            },
                            child: Container(
                              width: Get.width * .4,
                              height: 40,
                              padding: const EdgeInsets.all(10),
                              decoration: ShapeDecoration(
                                color: controller.buy_or_sell.value == 'buy'
                                    ? DarkThemeColors.primaryColor
                                    : null,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Buy',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        height: 0.71),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              controller.updateBuyOrSell('sell');
                            },
                            child: Container(
                              width: Get.width * .4,
                              height: 40,
                              padding: const EdgeInsets.all(10),
                              decoration: ShapeDecoration(
                                color: controller.buy_or_sell.value == 'sell'
                                    ? const Color(0xFF009337)
                                    : null,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Sell',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          height: 1.10))
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ))),
    );
  }
}
