import 'package:clipboard/clipboard.dart';
import 'package:davyking/core/constants/symbols.dart';
import 'package:davyking/core/controllers/admin_bank_details_controller.dart';
import 'package:davyking/core/controllers/currency_rate_controller.dart';
import 'package:davyking/core/controllers/primary_button_controller.dart';
import 'package:davyking/core/states/mode.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/models/top_header_model.dart';
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

    // Calculate dynamic padding based on screen width
    final double screenWidth = Get.width;
    final double padding = screenWidth * 0.05; // 5% of screen width
    final double imageSize = screenWidth * 0.6; // 60% of screen width for image
    final double fontScale = screenWidth < 300 ? 0.85 : 1.0; // Scale down fonts for very small screens

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
                              ? 'Buy ${controller.selectedCrypto.value?.symbol}'
                              : 'Buy Crypto'),
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

                // Wallet Address Input
                _buildSectionTitle('Wallet Address', fontScale),
                SizedBox(height: padding),
                Container(
                  decoration: _getCardDecoration(lightningModeController),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.walletAddressController,
                          style: TextStyle(
                            color: lightningModeController
                                        .currentMode.value.mode ==
                                    "light"
                                ? const Color(0xFF1E293B)
                                : Colors.white,
                            fontSize: 14 * fontScale,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: padding, vertical: padding),
                            hintText: 'Enter wallet address',
                            hintStyle: TextStyle(
                                color: const Color(0xFF94A3B8),
                                fontSize: 14 * fontScale),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: padding * 0.5),
                        child: TextButton.icon(
                          onPressed: controller.pasteWalletAddress,
                          icon: Icon(Icons.content_paste, size: 16 * fontScale),
                          label: Text(
                            'Paste',
                            style: TextStyle(fontSize: 12 * fontScale),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF3B82F6),
                            backgroundColor:
                                const Color(0xFF3B82F6).withOpacity(0.1),
                            padding: EdgeInsets.symmetric(
                                horizontal: padding * 0.75, vertical: padding * 0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: padding * 1.5),

                // Payment Method Dropdown
                _buildSectionTitle('Payment Method', fontScale),
                SizedBox(height: padding),
                Obx(() => Container(
                      decoration: _getCardDecoration(lightningModeController),
                      child: DropdownButtonFormField<String>(
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
                        value: controller.paymentMethod.value,
                        items: controller.availablePaymentMethods
                            .map((method) => DropdownMenuItem(
                                  value: method,
                                  child: Text(
                                    method,
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
                        onChanged: controller.updatePaymentMethod,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: padding, vertical: padding),
                          hintText: 'Select Payment Method',
                          hintStyle: TextStyle(
                              color: const Color(0xFF64748B),
                              fontSize: 14 * fontScale),
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
                              "Amount to buy (${controller.isCryptoAmount.value ? controller.selectedCrypto.value!.name : '${Symbols.currency_naira}'})",
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
                                  fontWeight: FontWeight.w600),
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
                                Icons.calculate,
                                color: const Color(0xFF8B5CF6),
                                size: 16 * fontScale,
                              ),
                            ),
                            SizedBox(width: padding),
                            Text(
                              'Total Amount',
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
                            )))
                      ],
                    ),
                  ),
                ),

                SizedBox(height: padding * 1.5),

                // Bank Transfer Section
                Obx(() => controller.paymentMethod.value == 'Bank Transfer'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Payment Details', fontScale),
                          SizedBox(height: padding),

                          // Admin Bank Details Section
                          adminBankDetailsController.isLoading.value
                              ? Center(
                                  child: Container(
                                    padding: EdgeInsets.all(padding * 1.5),
                                    decoration: _getCardDecoration(
                                        lightningModeController),
                                    child: const CircularProgressIndicator(),
                                  ),
                                )
                              : adminBankDetailsController
                                      .errorMessage.value.isNotEmpty
                                  ? Container(
                                      padding: EdgeInsets.all(padding),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.red.withOpacity(0.3)),
                                      ),
                                      child: Text(
                                        'Error: ${adminBankDetailsController.errorMessage.value}',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 14 * fontScale),
                                      ),
                                    )
                                  : adminBankDetailsController
                                          .bank_details.isEmpty
                                      ? Container(
                                          padding: EdgeInsets.all(padding),
                                          decoration: _getCardDecoration(
                                              lightningModeController),
                                          child: Text(
                                            'No bank details available.',
                                            style: TextStyle(
                                                fontSize: 14 * fontScale),
                                          ),
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Send payment to:',
                                              style: TextStyle(
                                                fontSize: 16 * fontScale,
                                                fontWeight: FontWeight.w600,
                                                color: lightningModeController
                                                            .currentMode
                                                            .value
                                                            .mode ==
                                                        "light"
                                                    ? const Color(0xFF1E293B)
                                                    : Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: padding),
                                            ...adminBankDetailsController
                                                .bank_details
                                                .map((bank) => Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: padding),
                                                      decoration:
                                                          _getCardDecoration(
                                                              lightningModeController),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(padding),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            _buildBankDetailRow(
                                                                'Bank Name',
                                                                bank.bankName,
                                                                fontScale),
                                                            _buildBankDetailRow(
                                                                'Account Name',
                                                                bank.accountName,
                                                                fontScale),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child: _buildBankDetailRow(
                                                                      'Account Number',
                                                                      bank.accountNumber,
                                                                      fontScale),
                                                                ),
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: const Color(
                                                                            0xFF3B82F6)
                                                                        .withOpacity(
                                                                            0.1),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                  child:
                                                                      IconButton(
                                                                    icon: Icon(
                                                                        Icons
                                                                            .copy,
                                                                        size: 16 *
                                                                            fontScale),
                                                                    color: const Color(
                                                                        0xFF3B82F6),
                                                                    onPressed:
                                                                        () {
                                                                      FlutterClipboard
                                                                          .copy(
                                                                              bank.accountNumber);
                                                                      Get.snackbar(
                                                                          'Success',
                                                                          'Account number copied to clipboard',
                                                                          snackPosition: SnackPosition
                                                                              .TOP,
                                                                          backgroundColor: const Color(
                                                                              0xFF10B981),
                                                                          colorText: Colors
                                                                              .white,
                                                                          borderRadius:
                                                                              12,
                                                                          margin: EdgeInsets
                                                                              .all(
                                                                              padding));
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            if (bank.ifscCode !=
                                                                null)
                                                              _buildBankDetailRow(
                                                                  'IFSC Code',
                                                                  bank.ifscCode!,
                                                                  fontScale),
                                                            if (bank.swiftCode !=
                                                                null)
                                                              _buildBankDetailRow(
                                                                  'SWIFT Code',
                                                                  bank.swiftCode!,
                                                                  fontScale),
                                                          ],
                                                        ),
                                                      ),
                                                    )),
                                          ],
                                        ),

                          SizedBox(height: padding * 1.5),

                          // Payment Screenshot Upload Section
                          Container(
                            decoration:
                                _getCardDecoration(lightningModeController),
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
                                          color: const Color(0xFFF59E0B)
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          Icons.upload_file,
                                          color: const Color(0xFFF59E0B),
                                          size: 16 * fontScale,
                                        ),
                                      ),
                                      SizedBox(width: padding),
                                      Text(
                                        "Upload Payment Screenshot",
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
                                  Obx(() => controller
                                              .paymentScreenshot.value ==
                                          null
                                      ? Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              vertical: padding * 2),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color(0xFF3B82F6)
                                                  .withOpacity(0.3),
                                              style: BorderStyle.solid,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: const Color(0xFF3B82F6)
                                                .withOpacity(0.05),
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.cloud_upload_outlined,
                                                size: 36 * fontScale,
                                                color: const Color(0xFF3B82F6),
                                              ),
                                              SizedBox(height: padding),
                                              ElevatedButton.icon(
                                                onPressed: () => controller
                                                    .uploadScreenshot(),
                                                icon: Icon(
                                                    Icons.add_photo_alternate,
                                                    size: 16 * fontScale),
                                                label: Text(
                                                  "Choose Image",
                                                  style: TextStyle(
                                                      fontSize: 12 * fontScale),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFF3B82F6),
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
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                image: DecorationImage(
                                                  image: FileImage(controller
                                                      .paymentScreenshot
                                                      .value!),
                                                  fit: BoxFit.cover,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
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
                                                        .uploadScreenshot(),
                                                    icon: Icon(Icons.edit,
                                                        size: 16 * fontScale),
                                                    label: Text(
                                                      "Change Image",
                                                      style: TextStyle(
                                                          fontSize:
                                                              12 * fontScale),
                                                    ),
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      foregroundColor:
                                                          const Color(
                                                              0xFF3B82F6),
                                                      side: const BorderSide(
                                                          color: Color(
                                                              0xFF3B82F6)),
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                              vertical: padding),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: padding),
                                                Expanded(
                                                  child: OutlinedButton.icon(
                                                    onPressed: () => controller
                                                        .removeScreenshot(),
                                                    icon: Icon(Icons.delete,
                                                        size: 16 * fontScale),
                                                    label: Text(
                                                      "Remove",
                                                      style: TextStyle(
                                                          fontSize:
                                                              12 * fontScale),
                                                    ),
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      foregroundColor:
                                                          Colors.red,
                                                      side: const BorderSide(
                                                          color: Colors.red),
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                              vertical: padding),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
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
                        ],
                      )
                    : const SizedBox.shrink()),

                SizedBox(height: padding * 2),

                // Buy Button
                Obx(() => controller.isLoading.value
                    ? Container(
                        width: double.infinity,
                        height: 48 * fontScale,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
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
                            colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withOpacity(0.3),
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
                                        .authenticate(context, 'Buy Crypto');

                                if (isAuthenticated) {
                                  controller.submitBuyCrypto();
                                }
                              }
                            },
                            child: Center(
                              child: Text(
                                'Buy Crypto',
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

  Widget _buildBankDetailRow(String label, String value, double fontScale) {
    return Padding(
      padding: EdgeInsets.only(bottom: Get.width * 0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: Get.width * 0.3, // 30% of screen width for label
            child: Text(
              '$label:',
              style: TextStyle(
                color: const Color(0xFF64748B),
                fontSize: 12 * fontScale,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: const Color(0xFF1E293B),
                fontSize: 12 * fontScale,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}