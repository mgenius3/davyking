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
import 'package:davyking/core/controllers/transaction_auth_controller.dart';

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
    final TransactionAuthController transactionAuthController =
        Get.find<TransactionAuthController>();

    return Scaffold(
      backgroundColor: lightningModeController.currentMode.value.mode == "light"
          ? const Color(0xFFF8FAFC)
          : const Color(0xFF0F172A),
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
                const SizedBox(height: 24),

                // Crypto Image with enhanced styling
                Obx(
                  () => Center(
                    child: Container(
                      width: 240,
                      height: 160,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                controller.selectedCrypto.value!.image),
                            fit: BoxFit.fill),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        shadows: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                              spreadRadius: 0)
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Select Asset Dropdown with enhanced styling
                _buildSectionTitle('Select Asset'),
                const SizedBox(height: 8),
                Obx(() => Container(
                      decoration: _getCardDecoration(lightningModeController),
                      child: DropdownButtonFormField<CryptoListModel>(
                        dropdownColor:
                            lightningModeController.currentMode.value.mode ==
                                    "light"
                                ? Colors.white
                                : const Color(0xFF1E293B),
                        style: TextStyle(
                          color:
                              lightningModeController.currentMode.value.mode ==
                                      "light"
                                  ? const Color(0xFF1E293B)
                                  : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        icon: Icon(Icons.keyboard_arrow_down,
                            color: lightningModeController
                                        .currentMode.value.mode ==
                                    "light"
                                ? const Color(0xFF64748B)
                                : Colors.white70),
                        value: controller.selectedCrypto.value,
                        items: controller.availableCryptos
                            .map((crypto) => DropdownMenuItem(
                                  value: crypto,
                                  child: Text(
                                    crypto.symbol,
                                    style: TextStyle(
                                      color: lightningModeController
                                                  .currentMode.value.mode ==
                                              "light"
                                          ? const Color(0xFF1E293B)
                                          : Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: controller.updateSelectedCrypto,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            hintText: 'Select Asset',
                            hintStyle: TextStyle(color: Color(0xFF64748B))),
                      ),
                    )),

                const SizedBox(height: 24),

                // Network Display with enhanced styling
                _buildSectionTitle('Network'),
                const SizedBox(height: 8),
                Container(
                  width: Get.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: _getCardDecoration(lightningModeController),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Network',
                        style: TextStyle(
                          color:
                              lightningModeController.currentMode.value.mode ==
                                      "light"
                                  ? const Color(0xFF64748B)
                                  : Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      Obx(() => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF3B82F6).withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              controller.selectedCrypto.value!.network,
                              style: const TextStyle(
                                  color: Color(0xFF3B82F6),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Enhanced Admin Wallet Address Display
                _buildSectionTitle('Admin Wallet Address'),
                const SizedBox(height: 8),
                Obx(() => Container(
                      decoration: _getCardDecoration(lightningModeController),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.account_balance_wallet,
                                    color: Color(0xFF10B981),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Send your crypto to this address:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: lightningModeController
                                                  .currentMode.value.mode ==
                                              "light"
                                          ? const Color(0xFF1E293B)
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: lightningModeController
                                            .currentMode.value.mode ==
                                        "light"
                                    ? const Color(0xFFF1F5F9)
                                    : const Color(0xFF334155),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      const Color(0xFF10B981).withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      controller.selectedCrypto.value
                                                  ?.wallet_address !=
                                              null
                                          ? controller.selectedCrypto.value!
                                              .wallet_address!
                                          : 'No wallet address set',
                                      style: TextStyle(
                                        color: lightningModeController
                                                    .currentMode.value.mode ==
                                                "light"
                                            ? const Color(0xFF1E293B)
                                            : Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ),
                                  if (controller.selectedCrypto.value
                                          ?.wallet_address !=
                                      null)
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF10B981)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.copy, size: 18),
                                        color: const Color(0xFF10B981),
                                        onPressed: () {
                                          FlutterClipboard.copy(controller
                                              .selectedCrypto
                                              .value!
                                              .wallet_address!);
                                          Get.snackbar('Success',
                                              'Admin wallet address copied to clipboard',
                                              snackPosition: SnackPosition.TOP,
                                              backgroundColor:
                                                  const Color(0xFF10B981),
                                              colorText: Colors.white,
                                              borderRadius: 12,
                                              margin: const EdgeInsets.all(16));
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),

                const SizedBox(height: 24),

                // Enhanced Crypto/Fiat Toggle
                _buildSectionTitle('Amount Type'),
                const SizedBox(height: 8),
                Obx(() => Container(
                      decoration: _getCardDecoration(lightningModeController),
                      padding: const EdgeInsets.all(6),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.toggleAmountType(true),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: controller.isCryptoAmount.value
                                      ? const Color(0xFF3B82F6)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: controller.isCryptoAmount.value
                                      ? null
                                      : Border.all(color: Colors.transparent),
                                ),
                                child: Center(
                                  child: Text(
                                    'Crypto',
                                    style: TextStyle(
                                      color: controller.isCryptoAmount.value
                                          ? Colors.white
                                          : lightningModeController
                                                      .currentMode.value.mode ==
                                                  "light"
                                              ? const Color(0xFF64748B)
                                              : Colors.white70,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.toggleAmountType(false),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: !controller.isCryptoAmount.value
                                      ? const Color(0xFF3B82F6)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    'Fiat',
                                    style: TextStyle(
                                      color: !controller.isCryptoAmount.value
                                          ? Colors.white
                                          : lightningModeController
                                                      .currentMode.value.mode ==
                                                  "light"
                                              ? const Color(0xFF64748B)
                                              : Colors.white70,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),

                const SizedBox(height: 24),

                // Enhanced Amount Input
                _buildSectionTitle('Amount'),
                const SizedBox(height: 8),
                Obx(() => Container(
                      decoration: _getCardDecoration(lightningModeController),
                      child: TextFormField(
                        controller: controller.amountController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color:
                              lightningModeController.currentMode.value.mode ==
                                      "light"
                                  ? const Color(0xFF1E293B)
                                  : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          label: Text(
                              "Amount to sell (${controller.isCryptoAmount.value ? controller.selectedCrypto.value!.name : '\$'})",
                              style: TextStyle(
                                color: lightningModeController
                                            .currentMode.value.mode ==
                                        "light"
                                    ? const Color(0xFF64748B)
                                    : Colors.white70,
                                fontSize: 14,
                              )),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          hintText: controller.isCryptoAmount.value
                              ? '0.0'
                              : '\$0.00',
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                        ),
                        onChanged: (value) =>
                            controller.calculateEquivalentAmount(),
                      ),
                    )),

                const SizedBox(height: 24),

                // Enhanced Current Rate Display
                Container(
                  decoration: _getCardDecoration(lightningModeController),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.trending_up,
                                color: Color(0xFF10B981),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Current Rate',
                              style: TextStyle(
                                color: lightningModeController
                                            .currentMode.value.mode ==
                                        "light"
                                    ? const Color(0xFF64748B)
                                    : Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Obx(() => Text(
                              '\$${controller.currentRate.value.toStringAsFixed(2)}/${controller.selectedCrypto.value?.symbol}',
                              style: TextStyle(
                                color: lightningModeController
                                            .currentMode.value.mode ==
                                        "light"
                                    ? const Color(0xFF1E293B)
                                    : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Enhanced Crypto Amount to Send Display
                Container(
                  decoration: _getCardDecoration(lightningModeController),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF59E0B).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.send,
                                color: Color(0xFFF59E0B),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Crypto to Send',
                              style: TextStyle(
                                color: lightningModeController
                                            .currentMode.value.mode ==
                                        "light"
                                    ? const Color(0xFF64748B)
                                    : Colors.white70,
                                fontSize: 16
                              ),
                            ),
                          ],
                        ),
                        Obx(() => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF59E0B).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      const Color(0xFFF59E0B).withOpacity(0.2),
                                ),
                              ),
                              child: Text(
                                '${controller.cryptoAmount.value} ${controller.selectedCrypto.value?.symbol}',
                                style: const TextStyle(
                                    color: Color(0xFFF59E0B),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Enhanced Total Amount Display
                Container(
                  decoration: _getCardDecoration(lightningModeController),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5CF6).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.account_balance,
                                color: Color(0xFF8B5CF6),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Amount (to receive)',
                              style: TextStyle(
                                color: lightningModeController
                                            .currentMode.value.mode ==
                                        "light"
                                    ? const Color(0xFF64748B)
                                    : Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: currencyRateController.currencyRates
                              .map(
                                (x) => Obx(() => Text(
                                      '${x.currencyCode} ${(controller.fiatAmount.value * double.parse(x.rate) * num.parse(controller.isCryptoAmount.value ? controller.selectedCrypto.value!.currentPrice : "1")).toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: lightningModeController
                                                    .currentMode.value.mode ==
                                                "light"
                                            ? const Color(0xFF1E293B)
                                            : Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Enhanced Proof of Transfer Upload Section
                _buildSectionTitle('Proof of Transfer'),
                const SizedBox(height: 8),
                Container(
                  decoration: _getCardDecoration(lightningModeController),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.verified_user,
                                color: Color(0xFFEF4444),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Upload Proof of Coin Transfer",
                              style: TextStyle(
                                color: lightningModeController
                                            .currentMode.value.mode ==
                                        "light"
                                    ? const Color(0xFF1E293B)
                                    : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Obx(() => controller.proofScreenshot.value == null
                            ? Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 32),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFFEF4444)
                                        .withOpacity(0.3),
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color:
                                      const Color(0xFFEF4444).withOpacity(0.05),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.cloud_upload_outlined,
                                      size: 48,
                                      color: Color(0xFFEF4444),
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton.icon(
                                      onPressed: () =>
                                          controller.uploadProofScreenshot(),
                                      icon:
                                          const Icon(Icons.add_photo_alternate),
                                      label: const Text("Choose Image"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFEF4444),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: FileImage(
                                            controller.proofScreenshot.value!),
                                        fit: BoxFit.cover,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () => controller
                                              .uploadProofScreenshot(),
                                          icon: const Icon(Icons.edit),
                                          label: const Text("Change Image"),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor:
                                                const Color(0xFFEF4444),
                                            side: const BorderSide(
                                                color: Color(0xFFEF4444)),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () => controller
                                              .removeProofScreenshot(),
                                          icon: const Icon(Icons.delete),
                                          label: const Text("Remove"),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.red,
                                            side: const BorderSide(
                                                color: Colors.red),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Enhanced Sell Button
                Obx(() => controller.isLoading.value
                    ? Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFEF4444).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () async {
                              if (controller.validateInputs()) {
                                bool isAuthenticated =
                                    await transactionAuthController
                                        .authenticate(
                                  context,
                                  'Sell Crypto',
                                );

                                if (isAuthenticated) {
                                  controller.submitSellCrypto();
                                }
                              }
                            },
                            child: const Center(
                              child: Text(
                                'Sell Crypto',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1E293B),
      ),
    );
  }

  BoxDecoration _getCardDecoration(
      LightningModeController lightningModeController) {
    return BoxDecoration(
      color: lightningModeController.currentMode.value.mode == "light"
          ? Colors.white
          : const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: lightningModeController.currentMode.value.mode == "light"
            ? const Color(0xFFE2E8F0)
            : const Color(0xFF334155),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
