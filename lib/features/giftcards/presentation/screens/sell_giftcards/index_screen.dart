import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/search_widget.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:davyking/features/giftcards/controllers/index_controller.dart';
import 'package:davyking/features/giftcards/presentation/widgets/giftcards_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellGiftCardScreen extends StatelessWidget {
  const SellGiftCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GiftCardController controller = Get.put(GiftCardController());
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Container(
          margin: Spacing.defaultMarginSpacing,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopHeaderWidget(
                  data: TopHeaderModel(title: 'Sell Gift Card')),
              const SizedBox(height: 20),
              // const searchBoxWidget(),
              const SizedBox(height: 20),
              Obx(() => Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    alignment: WrapAlignment.spaceBetween,
                    runAlignment: WrapAlignment.spaceBetween,
                    spacing: 10,
                    runSpacing: 20,
                    children: [
                      ...controller.all_giftCard.map((json) {
                        // Check if the gift card is enabled
                        bool isEnabled = json.isEnabled == 1;
                        return GestureDetector(
                          // Disable onTap if isEnabled is false
                          onTap: isEnabled
                              ? () {
                                  Get.toNamed(
                                      RoutesConstant.sell_giftcard_field,
                                      arguments: json);
                                }
                              : null,
                          child: GiftcardsList(
                            giftcardsdata: json,
                            isEnabled:
                                isEnabled, // Pass isEnabled to GiftcardsList
                          ),
                        );
                      }),
                    ],
                  ))
            ],
          )),
    )));
  }
}
