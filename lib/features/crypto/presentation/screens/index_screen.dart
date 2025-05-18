import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:davyking/features/crypto/controllers/index_controller.dart'; // Assuming this is CryptoController
import 'package:davyking/features/crypto/presentation/widgets/crypto_transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CryptoScreen extends StatelessWidget {
  const CryptoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CryptoController controller = Get.put(CryptoController());

    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Container(
            margin: Spacing.defaultMarginSpacing,
            child: Column(
              children: [
                const TopHeaderWidget(
                  data: TopHeaderModel(title: 'Crypto'),
                ),
                const SizedBox(height: 20),
                Container(
                  width: Get.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
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
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Row(
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
                              ),
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
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Sell',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    height: 1.10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                    child: RefreshIndicator(
                  onRefresh: controller.fetchAllCryptosTransaction,
                  child: controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : controller.errorMessage.isNotEmpty
                          ? Center(
                              child: Text(
                                  'Error: ${controller.errorMessage.value}'))
                          : controller.filteredTransactions.isEmpty
                              ? Center(
                                  child: Column(
                                  children: [
                                    SvgPicture.asset(
                                        "assets/svg/empty_transaction.svg"),
                                    const SizedBox(height: 20),
                                    const Text('No transactions available')
                                  ],
                                ))
                              : ListView.builder(
                                  itemCount:
                                      controller.filteredTransactions.length,
                                  itemBuilder: (context, index) {
                                    final transaction =
                                        controller.filteredTransactions[index];
                                    return GestureDetector(
                                      onTap: () {
                                        // Navigate to details screen with the selected transaction
                                        Get.toNamed(
                                            RoutesConstant
                                                .cryptoTransactionDetails,
                                            arguments: transaction);
                                      },
                                      child: CryptoTransactionListWidget(
                                          data: transaction),
                                    );
                                  },
                                ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
