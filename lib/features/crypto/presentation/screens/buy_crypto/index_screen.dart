import 'package:davyking/core/constants/routes.dart';
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

    // Calculate dynamic sizing based on screen width
    final double screenWidth = Get.width;
    final double padding = screenWidth * 0.05; // 5% of screen width
    final double fontScale = screenWidth < 300 ? 0.85 : 1.0; // Scale down for small screens
    final double wrapSpacing = screenWidth * 0.03; // 3% of screen width for spacing
    final double wrapRunSpacing = screenWidth * 0.05; // 5% of screen width for run spacing

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopHeaderWidget(
                  data: TopHeaderModel(title: 'Buy Crypto'),
                ),
                SizedBox(height: padding * 1.5),
                // const searchBoxWidget(), // Uncomment if needed and make responsive
                SizedBox(height: padding * 1.5),
                Obx(() => Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      alignment: WrapAlignment.spaceBetween,
                      runAlignment: WrapAlignment.spaceBetween,
                      spacing: wrapSpacing,
                      runSpacing: wrapRunSpacing,
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
                            child: SizedBox(
                              width: (screenWidth - (3 * padding) - wrapSpacing) / 2, // Two cards per row
                              child: CryptoList(
                                cryptodata: json,
                                isEnabled: isEnabled,
                                // fontScale: fontScale, // Pass fontScale to CryptoList
                              ),
                            ),
                          );
                        }),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}