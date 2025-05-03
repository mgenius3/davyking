import 'package:clipboard/clipboard.dart';
import 'package:davyking/core/controllers/currency_rate_controller.dart';
import 'package:davyking/core/controllers/primary_button_controller.dart';
import 'package:davyking/core/models/primary_button_model.dart';
import 'package:davyking/core/states/mode.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/primary_button_widget.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:davyking/features/crypto/controllers/sell_crypto_controller.dart';
import 'package:davyking/features/crypto/data/model/crypto_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class SellCryptoInputField extends StatelessWidget {
  const SellCryptoInputField({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the arguments
    final CryptoListModel data = Get.arguments as CryptoListModel;
    final SellCryptoController controller =
        Get.put(SellCryptoController(cryptoData: data));
    final LightningModeController lightningModeController =
        Get.find<LightningModeController>();
    final CurrencyRateController currencyRateController =
        Get.find<CurrencyRateController>();

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: Spacing.defaultMarginSpacing,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => TopHeaderWidget(
                      data: TopHeaderModel(
                          title: controller.selectedCrypto.value?.symbol != null
                              ? 'Sell ${controller.selectedCrypto.value?.symbol}'
                              : 'Sell Crypto'),
                    )),
                const SizedBox(height: 20),
                Obx(
                  () => Center(
                    child: Container(
                      width: 229.09,
                      height: 148.38,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                controller.selectedCrypto.value!.image),
                            fit: BoxFit.fill),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.79)),
                        shadows: const [
                          BoxShadow(
                              color: Color(0x1E000000),
                              blurRadius: 5.42,
                              offset: Offset(0, 5.42),
                              spreadRadius: 0)
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Select Asset Dropdown
                Obx(() => DropdownButtonFormField<CryptoListModel>(
                      dropdownColor:
                          lightningModeController.currentMode.value.mode ==
                                  "light"
                              ? Colors.white
                              : Colors.black,
                      style: Theme.of(context).textTheme.displayMedium,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      value: controller.selectedCrypto.value,
                      items: controller.availableCryptos
                          .map((crypto) => DropdownMenuItem(
                                value: crypto,
                                child: Text(
                                  crypto.symbol,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ))
                          .toList(),
                      onChanged: controller.updateSelectedCrypto,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color(0xFFF7F7F7),
                        labelText: 'Select Asset',
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                    )),
                const SizedBox(height: 20),

                // Network Display
                Container(
                  width: Get.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF7F7F7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Network',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      Obx(() => Text(
                            controller.selectedCrypto.value!.network,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 15),
                          )),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Admin Wallet Address Display
                Obx(() => Container(
                      width: Get.width,
                      padding: const EdgeInsets.all(12),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF7F7F7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Admin Wallet Address (Send Crypto Here)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  controller.selectedCrypto.value
                                              ?.wallet_address !=
                                          null
                                      ? controller
                                          .selectedCrypto.value!.wallet_address!
                                      : 'No wallet address set',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                              ),
                              if (controller
                                      .selectedCrypto.value?.wallet_address !=
                                  null)
                                IconButton(
                                  icon: const Icon(Icons.copy, size: 20),
                                  onPressed: () {
                                    FlutterClipboard.copy(controller
                                        .selectedCrypto.value!.wallet_address!);
                                    Get.snackbar('Success',
                                        'Admin wallet address copied to clipboard',
                                        snackPosition: SnackPosition.TOP,
                                        backgroundColor: Colors.green,
                                        colorText: Colors.white);
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    )),

                const SizedBox(height: 20),

                // Crypto/Fiat Toggle
                Obx(() => Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF7F7F7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => controller.toggleAmountType(true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: controller.isCryptoAmount.value
                                    ? Colors.black
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Crypto',
                                style: TextStyle(
                                  color: controller.isCryptoAmount.value
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => controller.toggleAmountType(false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: !controller.isCryptoAmount.value
                                    ? Colors.black
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Fiat',
                                style: TextStyle(
                                  color: !controller.isCryptoAmount.value
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 20),

                // Amount Input
                Obx(() => Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF7F7F7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: controller.amountController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              label: Text(
                                "Amount to sell (${controller.isCryptoAmount.value ? controller.selectedCrypto.value!.name : '\$'})",
                                style: const TextStyle(color: Colors.black),
                              ),
                              border: InputBorder.none,
                              hintText: controller.isCryptoAmount.value
                                  ? '0.0'
                                  : '\$0.00',
                              hintStyle: const TextStyle(color: Colors.black87),
                            ),
                            onChanged: (value) =>
                                controller.calculateEquivalentAmount(),
                          ),
                        ],
                      ),
                    )),

                const SizedBox(height: 20),

                // Current Rate
                Container(
                  width: Get.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF7F7F7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Current Rate',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      Obx(() => Text(
                            '\$${controller.currentRate.value.toStringAsFixed(2)}/\$',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 15),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Amount in Naira
                Container(
                  width: Get.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF7F7F7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount (to receive)',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      Column(
                        children: currencyRateController.currencyRates
                            .map(
                              (x) => Obx(() => Text(
                                    '${x.currencyCode} ${controller.fiatAmount.value * double.parse(x.rate)}',
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  )),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Proof of Coin Transfer Upload Section
                Container(
                  width: Get.width,
                  padding: const EdgeInsets.all(12),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF7F7F7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Upload Proof of Coin Transfer",
                        style: TextStyle(
                          color: Color(0xFF093030),
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(() => controller.proofScreenshot.value == null
                          ? ElevatedButton.icon(
                              onPressed: () =>
                                  controller.uploadProofScreenshot(),
                              icon: const Icon(Icons.upload),
                              label: const Text("Choose Image"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF093030),
                                minimumSize: const Size(double.infinity, 45),
                              ),
                            )
                          : Column(
                              children: [
                                Container(
                                  height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                      image: FileImage(
                                          controller.proofScreenshot.value!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () =>
                                          controller.uploadProofScreenshot(),
                                      child: const Text("Change Image"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          controller.removeProofScreenshot(),
                                      child: const Text(
                                        "Remove",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                Obx(() => controller.isLoading.value
                    ? CustomPrimaryButton(
                        controller: CustomPrimaryButtonController(
                            model: const CustomPrimaryButtonModel(
                                child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white))),
                            onPressed: () {}),
                      )
                    : CustomPrimaryButton(
                        controller: CustomPrimaryButtonController(
                          model: const CustomPrimaryButtonModel(
                              text: 'Sell Crypto'),
                          onPressed: () {
                            if (controller.validateInputs()) {
                              controller.submitSellCrypto();
                            }
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
