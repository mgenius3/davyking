import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:davyking/features/crypto/controllers/index_controller.dart';
import 'package:davyking/features/crypto/presentation/widgets/crypto_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyCryptoScreen extends StatelessWidget {
  const BuyCryptoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CryptoController controller = Get.put(CryptoController());

    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Container(
          margin: Spacing.defaultMarginSpacing,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopHeaderWidget(data: TopHeaderModel(title: 'Buy Crypto')),
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
                      ...controller.all_crypto.map((json) {
                        // Check if the gift card is enabled
                        bool isEnabled = json.isEnabled == 1;
                        return GestureDetector(
                          // Disable onTap if isEnabled is false
                          onTap: isEnabled
                              ? () {
                                  Get.toNamed(RoutesConstant.buy_crypto_field,
                                      arguments: json);
                                }
                              : null,
                          child: CryptoList(
                              cryptodata: json, isEnabled: isEnabled),
                        );
                      }),
                    ],
                  ))
            ],
          )),
    )));
  }
}
