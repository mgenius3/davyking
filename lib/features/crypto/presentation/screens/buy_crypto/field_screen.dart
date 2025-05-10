import 'package:clipboard/clipboard.dart'; // Add this import
import 'package:davyking/core/controllers/admin_bank_details_controller.dart';
import 'package:davyking/core/controllers/currency_rate_controller.dart';
import 'package:davyking/core/controllers/primary_button_controller.dart';
import 'package:davyking/core/models/primary_button_model.dart';
import 'package:davyking/core/states/mode.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/primary_button_widget.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:davyking/features/crypto/controllers/buy_crypto_controller.dart';
import 'package:davyking/features/crypto/data/model/crypto_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:davyking/core/controllers/transaction_auth_controller.dart';

class BuyCryptoInputField extends StatelessWidget {
  const BuyCryptoInputField({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the arguments
    final CryptoListModel data = Get.arguments as CryptoListModel;
    final BuyCryptoController controller =
        Get.put(BuyCryptoController(cryptoData: data));
    final LightningModeController lightningModeController =
        Get.find<LightningModeController>();
    final AdminBankDetailsController adminBankDetailsController =
        Get.find<AdminBankDetailsController>();
    final CurrencyRateController currencyRateController =
        Get.find<CurrencyRateController>();
    final TransactionAuthController transactionAuthController =
        Get.find<TransactionAuthController>();

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
                              ? 'Buy ${controller.selectedCrypto.value?.symbol}'
                              : 'Buy Crypto'),
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
                          labelStyle: TextStyle(color: Colors.black)),
                    )),
                const SizedBox(height: 20),

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

                // Enter Wallet Address
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
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.walletAddressController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Address',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: controller.pasteWalletAddress,
                        child: const Text(
                          'Paste',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Payment Method Dropdown
                Obx(() => DropdownButtonFormField<String>(
                      dropdownColor:
                          lightningModeController.currentMode.value.mode ==
                                  "light"
                              ? Colors.white
                              : Colors.black,
                      style: Theme.of(context).textTheme.displayMedium,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      value: controller.paymentMethod.value,
                      items: controller.availablePaymentMethods
                          .map((method) => DropdownMenuItem(
                                value: method,
                                child: Text(
                                  method,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ))
                          .toList(),
                      onChanged: controller.updatePaymentMethod,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color(0xFFF7F7F7),
                        labelText: 'Select Payment Method',
                        labelStyle: TextStyle(color: Colors.black),
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
                                  "Amount to buy (${controller.isCryptoAmount.value ? controller.selectedCrypto.value!.name : '\$'})",
                                  style: const TextStyle(color: Colors.black)),
                              border: InputBorder.none,
                              hintText: controller.isCryptoAmount.value
                                  ? '0.0'
                                  : '\$0.00',
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                            onChanged: (value) =>
                                controller.calculateEquivalentAmount(),
                          ),
                          // const SizedBox(height: 5),
                          // Text(
                          //   'Min (0.00358BTC = \$50)',
                          //   style: const TextStyle(
                          //       color: Colors.grey, fontSize: 12),
                          // ),
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
                            '${controller.currentRate.value.toStringAsFixed(2)}/${controller.selectedCrypto.value?.symbol}',
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
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      Column(
                        children: currencyRateController.currencyRates
                            .map((exchange) => Obx(() => Text(
                                '${exchange.currencyCode} ${controller.fiatAmount.value * double.parse(exchange.rate) * num.parse(controller.isCryptoAmount.value ? controller.selectedCrypto.value!.currentPrice : "1")}',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 15))))
                            .toList(),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                // Conditionally Display Admin Bank Details and Image Upload for Bank Transfer
                Obx(() => controller.paymentMethod.value == 'Bank Transfer'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Admin Bank Details Section
                          adminBankDetailsController.isLoading.value
                              ? const Center(child: CircularProgressIndicator())
                              : adminBankDetailsController
                                      .errorMessage.value.isNotEmpty
                                  ? Text(
                                      'Error: ${adminBankDetailsController.errorMessage.value}',
                                      style: const TextStyle(color: Colors.red),
                                    )
                                  : adminBankDetailsController
                                          .bank_details.isEmpty
                                      ? const Text('No bank details available.')
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Admin Bank Details for Payment',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 10),
                                            ...adminBankDetailsController
                                                .bank_details
                                                .map((bank) => Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xFFF7F7F7),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              'Bank Name: ${bank.bankName}'),
                                                          Text(
                                                              'Account Name: ${bank.accountName}'),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  'Account Number: ${bank.accountNumber}'),
                                                              IconButton(
                                                                icon: const Icon(
                                                                    Icons.copy,
                                                                    size: 20),
                                                                onPressed: () {
                                                                  FlutterClipboard
                                                                      .copy(bank
                                                                          .accountNumber);
                                                                  Get.snackbar(
                                                                      'Success',
                                                                      'Account number copied to clipboard',
                                                                      snackPosition:
                                                                          SnackPosition
                                                                              .TOP,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .green,
                                                                      colorText:
                                                                          Colors
                                                                              .white);
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                          if (bank.ifscCode !=
                                                              null)
                                                            Text(
                                                                'IFSC Code: ${bank.ifscCode}'),
                                                          if (bank.swiftCode !=
                                                              null)
                                                            Text(
                                                                'SWIFT Code: ${bank.swiftCode}'),
                                                        ],
                                                      ),
                                                    )),
                                          ],
                                        ),
                          const SizedBox(height: 20),
                          // Payment Screenshot Upload Section
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
                                  "Upload Payment Screenshot",
                                  style: TextStyle(
                                    color: Color(0xFF093030),
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Obx(() => controller.paymentScreenshot.value ==
                                        null
                                    ? ElevatedButton.icon(
                                        onPressed: () =>
                                            controller.uploadScreenshot(),
                                        icon: const Icon(Icons.upload),
                                        label: const Text("Choose Image"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor:
                                              const Color(0xFF093030),
                                          minimumSize:
                                              const Size(double.infinity, 45),
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          Container(
                                            height: 100,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              image: DecorationImage(
                                                image: FileImage(controller
                                                    .paymentScreenshot.value!),
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
                                                onPressed: () => controller
                                                    .uploadScreenshot(),
                                                child:
                                                    const Text("Change Image"),
                                              ),
                                              TextButton(
                                                onPressed: () => controller
                                                    .removeScreenshot(),
                                                child: const Text(
                                                  "Remove",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                              ],
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink()),

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
                              text: 'Buy Crypto'),
                          onPressed: () async {
                            // transactionAuthController.resetPin(context);
                            if (controller.validateInputs()) {
                              bool isAuthenticated =
                                  await transactionAuthController.authenticate(
                                      context, 'Buy Crypto');

                              if (isAuthenticated) {
                                controller.submitBuyCrypto();
                              }
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
