import 'package:clipboard/clipboard.dart';
import 'package:davyking/core/constants/symbols.dart';
import 'package:davyking/core/controllers/currency_rate_controller.dart';
import 'package:davyking/core/states/mode.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/models/top_header_model.dart';
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
    final CryptoListModel data = Get.arguments as CryptoListModel;
    final SellCryptoController controller =
        Get.put(SellCryptoController(cryptoData: data));
    final LightningModeController lightningModeController =
        Get.find<LightningModeController>();
    final CurrencyRateController currencyRateController =
        Get.find<CurrencyRateController>();
    final TransactionAuthController transactionAuthController =
        Get.find<TransactionAuthController>();

    // Calculate dynamic sizing based on screen width
    final double screenWidth = Get.width;
    final double padding = screenWidth * 0.05; // 5% of screen width
    final double imageSize = screenWidth * 0.6; // 60% of screen width for image
    final double fontScale = screenWidth < 300 ? 0.85 : 1.0; // Scale down for small screens

    return Scaffold(
      backgroundColor: lightningModeController.currentMode.value.mode == "light"
          ? const Color(0xFFF8FAFC)
          : const Color(0xFF0F172A),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(padding),
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
                SizedBox(height: padding * 1.5),

                // Crypto Image with dynamic sizing
                Obx(
                  () => Center(
                    child: Container(
                      width: imageSize,
                      height: imageSize * 2 / 3, // Maintain aspect ratio
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                controller.selectedCrypto.value!.image),
                            fit: BoxFit.cover),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        shadows: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                              spreadRadius: 0)
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: padding * 2),

                // Select Asset Dropdown
                _buildSectionTitle('Select Asset', fontScale),
                SizedBox(height: padding),
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
                          fontSize: 14 * fontScale,
                          fontWeight: FontWeight.w500,
                        ),
                        icon: Icon(Icons.keyboard_arrow_down,
                            color: lightningModeController
                                        .currentMode.value.mode ==
                                    "light"
                                ? const Color(0xFF64748B)
                                : Colors.white70,
                            size: 20 * fontScale),
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
                                      fontSize: 14 * fontScale,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: controller.updateSelectedCrypto,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: padding, vertical: padding),
                            hintText: 'Select Asset',
                            hintStyle: TextStyle(
                                color: const Color(0xFF64748B),
                                fontSize: 14 * fontScale)),
                      ),
                    )),

                SizedBox(height: padding * 1.5),

                // Network Display
                _buildSectionTitle('Network', fontScale),
                SizedBox(height: padding),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding),
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
                          fontSize: 14 * fontScale,
                        ),
                      ),
                      Obx(() => Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: padding * 0.75, vertical: padding * 0.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF3B82F6).withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              controller.selectedCrypto.value!.network,
                              style: TextStyle(
                                  color: const Color(0xFF3B82F6),
                                  fontSize: 12 * fontScale,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    ],
                  ),
                ),

                SizedBox(height: padding * 1.5),

                // Admin Wallet Address Display
                _buildSectionTitle('Admin Wallet Address', fontScale),
                SizedBox(height: padding),
                Obx(() => Container(
                      decoration: _getCardDecoration(lightningModeController),
                      child: Padding(
                        padding: EdgeInsets.all(padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(padding * 0.5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.account_balance_wallet,
                                    color: const Color(0xFF10B981),
                                    size: 16 * fontScale,
                                  ),
                                ),
                                SizedBox(width: padding),
                                Expanded(
                                  child: Text(
                                    'Send your crypto to this address:',
                                    style: TextStyle(
                                      fontSize: 14 * fontScale,
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
                            SizedBox(height: padding),
                            Container(
                              padding: EdgeInsets.all(padding * 0.75),
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
                                        fontSize: 12 * fontScale,
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
                                        icon: Icon(Icons.copy, size: 16 * fontScale),
                                        color: const Color(0xFF10B981),
                                        onPressed: () {
                                          FlutterClipboard.copy(controller
                                              .selectedCrypto
                                              .value!
                                              .wallet_address!);
                                          Get.snackbar(
                                              'Success',
                                              'Admin wallet address copied to clipboard',
                                              snackPosition: SnackPosition.TOP,
                                              backgroundColor:
                                                  const Color(0xFF10B981),
                                              colorText: Colors.white,
                                              borderRadius: 12,
                                              margin: EdgeInsets.all(padding));
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

                SizedBox(height: padding * 1.5),

                // Crypto/Fiat Toggle
                _buildSectionTitle('Amount Type', fontScale),
                SizedBox(height: padding),
                Obx(() => Container(
                      decoration: _getCardDecoration(lightningModeController),
                      padding: EdgeInsets.all(padding * 0.5),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.toggleAmountType(true),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: padding),
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
                                      fontSize: 14 * fontScale,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: padding * 0.5),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.toggleAmountType(false),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: padding),
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
                                      fontSize: 14 * fontScale,
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

                SizedBox(height: padding * 1.5),

                // Amount Input
                _buildSectionTitle('Amount', fontScale),
                SizedBox(height: padding),
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
                          fontSize: 16 * fontScale,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          label: Text(
                              "Amount to sell (${controller.isCryptoAmount.value ? controller.selectedCrypto.value!.name : '${Symbols.currency_naira}'})",
                              style: TextStyle(
                                color: lightningModeController
                                            .currentMode.value.mode ==
                                        "light"
                                    ? const Color(0xFF64748B)
                                    : Colors.white70,
                                fontSize: 12 * fontScale,
                              )),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: padding, vertical: padding),
                          hintText: controller.isCryptoAmount.value
                              ? '0.0'
                              : '\$0.00',
                          hintStyle: TextStyle(
                              color: const Color(0xFF94A3B8),
                              fontSize: 14 * fontScale),
                        ),
                        onChanged: (value) =>
                            controller.calculateEquivalentAmount(),
                      ),
                    )),

                SizedBox(height: padding * 1.5),

                // Current Rate Display
                Container(
                  decoration: _getCardDecoration(lightningModeController),
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(padding * 0.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.trending_up,
                                color: const Color(0xFF10B981),
                                size: 16 * fontScale,
                              ),
                            ),
                            SizedBox(width: padding),
                            Text(
                              'Current Rate',
                              style: TextStyle(
                                color: lightningModeController
                                            .currentMode.value.mode ==
                                        "light"
                                    ? const Color(0xFF64748B)
                                    : Colors.white70,
                                fontSize: 14 * fontScale,
                              ),
                            ),
                          ],
                        ),
                        Obx(() => Text(
                              '${Symbols.currency_naira}${controller.currentRate.value.toStringAsFixed(2)}/${controller.selectedCrypto.value?.symbol}',
                              style: TextStyle(
                                color: lightningModeController
                                            .currentMode.value.mode ==
                                        "light"
                                    ? const Color(0xFF1E293B)
                                    : Colors.white,
                                fontSize: 14 * fontScale,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: padding),

                // Crypto Amount to Send Display
                Container(
                  decoration: _getCardDecoration(lightningModeController),
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(padding * 0.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF59E0B).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.send,
                                color: const Color(0xFFF59E0B),
                                size: 16 * fontScale,
                              ),
                            ),
                            SizedBox(width: padding),
                            Text(
                              'Crypto to Send',
                              style: TextStyle(
                                  color: lightningModeController
                                              .currentMode.value.mode ==
                                          "light"
                                      ? const Color(0xFF64748B)
                                      : Colors.white70,
                                  fontSize: 14 * fontScale),
                            ),
                          ],
                        ),
                        Obx(() => Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: padding * 0.75, vertical: padding * 0.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF59E0B).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      const Color(0xFFF59E0B).withOpacity(0.2),
                                ),
                              ),
                              child: Text(
                                '${controller.cryptoAmount.value} ${controller.selectedCrypto.value?.symbol}',
                                style: TextStyle(
                                    color: const Color(0xFFF59E0B),
                                    fontSize: 12 * fontScale,
                                    fontWeight: FontWeight.w600),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: padding),

                // Total Amount Display
                Container(
                  decoration: _getCardDecoration(lightningModeController),
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(padding * 0.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5CF6).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.account_balance,
                                color: const Color(0xFF8B5CF6),
                                size: 16 * fontScale,
                              ),
                            ),
                            SizedBox(width: padding),
                            Text(
                              'Amount (to receive)',
                              style: TextStyle(
                                color: lightningModeController
                                            .currentMode.value.mode ==
                                        "light"
                                    ? const Color(0xFF64748B)
                                    : Colors.white70,
                                fontSize: 14 * fontScale,
                              ),
                            ),
                          ],
                        ),
                        Obx(() => Text(
                              '${Symbols.currency_naira} ${(controller.fiatAmount.value).toStringAsFixed(2)}',
                              style: TextStyle(
                                color: lightningModeController
                                            .currentMode.value.mode ==
                                        "light"
                                    ? const Color(0xFF1E293B)
                                    : Colors.white,
                                fontSize: 14 * fontScale,
                                fontWeight: FontWeight.w600,
                              ),
                            ))
                      ],
                    ),
                  ),
                ),

                SizedBox(height: padding * 1.5),

                // Proof of Transfer Upload Section
                _buildSectionTitle('Proof of Transfer', fontScale),
                SizedBox(height: padding),
                Container(
                  decoration: _getCardDecoration(lightningModeController),
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(padding * 0.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.verified_user,
                                color: const Color(0xFFEF4444),
                                size: 16 * fontScale,
                              ),
                            ),
                            SizedBox(width: padding),
                            Text(
                              "Upload Proof of Coin Transfer",
                              style: TextStyle(
                                color: lightningModeController
                                            .currentMode.value.mode ==
                                        "light"
                                    ? const Color(0xFF1E293B)
                                    : Colors.white,
                                fontSize: 14 * fontScale,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: padding),
                        Obx(() => controller.proofScreenshot.value == null
                            ? Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: padding * 2),
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
                                    Icon(
                                      Icons.cloud_upload_outlined,
                                      size: 36 * fontScale,
                                      color: const Color(0xFFEF4444),
                                    ),
                                    SizedBox(height: padding),
                                    ElevatedButton.icon(
                                      onPressed: () =>
                                          controller.uploadProofScreenshot(),
                                      icon: Icon(
                                          Icons.add_photo_alternate,
                                          size: 16 * fontScale),
                                      label: Text(
                                        "Choose Image",
                                        style: TextStyle(fontSize: 12 * fontScale),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFEF4444),
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: padding * 1.5,
                                            vertical: padding),
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
                                    height: screenWidth * 0.5,
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
                                  SizedBox(height: padding),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () => controller
                                              .uploadProofScreenshot(),
                                          icon: Icon(Icons.edit,
                                              size: 16 * fontScale),
                                          label: Text(
                                            "Change Image",
                                            style: TextStyle(
                                                fontSize: 12 * fontScale),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor:
                                                const Color(0xFFEF4444),
                                            side: const BorderSide(
                                                color: Color(0xFFEF4444)),
                                            padding: EdgeInsets.symmetric(
                                                vertical: padding),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: padding),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () => controller
                                              .removeProofScreenshot(),
                                          icon: Icon(Icons.delete,
                                              size: 16 * fontScale),
                                          label: Text(
                                            "Remove",
                                            style: TextStyle(
                                                fontSize: 12 * fontScale),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.red,
                                            side: const BorderSide(
                                                color: Colors.red),
                                            padding: EdgeInsets.symmetric(
                                                vertical: padding),
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

                SizedBox(height: padding * 2),

                // Sell Button
                Obx(() => controller.isLoading.value
                    ? Container(
                        width: double.infinity,
                        height: 48 * fontScale,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 24 * fontScale,
                            height: 24 * fontScale,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: 48 * fontScale,
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
                                        .authenticate(context, 'Sell Crypto');

                                if (isAuthenticated) {
                                  controller.submitSellCrypto();
                                }
                              }
                            },
                            child: Center(
                              child: Text(
                                'Sell Crypto',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16 * fontScale,
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

  Widget _buildSectionTitle(String title, double fontScale) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14 * fontScale,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1E293B),
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