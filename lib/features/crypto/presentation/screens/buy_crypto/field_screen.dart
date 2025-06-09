import 'package:clipboard/clipboard.dart';
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
                              ? 'Buy ${controller.selectedCrypto.value?.symbol}'
                              : 'Buy Crypto'),
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
                        lightningModeController.currentMode.value.mode == "light"
                            ? Colors.white
                            : const Color(0xFF1E293B),
                    style: TextStyle(
                      color: lightningModeController.currentMode.value.mode == "light"
                          ? const Color(0xFF1E293B)
                          : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    icon: Icon(Icons.keyboard_arrow_down, 
                        color: lightningModeController.currentMode.value.mode == "light"
                            ? const Color(0xFF64748B)
                            : Colors.white70),
                    value: controller.selectedCrypto.value,
                    items: controller.availableCryptos
                        .map((crypto) => DropdownMenuItem(
                              value: crypto,
                              child: Text(
                                crypto.symbol,
                                style: TextStyle(
                                  color: lightningModeController.currentMode.value.mode == "light"
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: _getCardDecoration(lightningModeController),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Network',
                        style: TextStyle(
                          color: lightningModeController.currentMode.value.mode == "light"
                              ? const Color(0xFF64748B)
                              : Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      Obx(() => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

                // Wallet Address Input with enhanced styling
                _buildSectionTitle('Wallet Address'),
                const SizedBox(height: 8),
                Container(
                  decoration: _getCardDecoration(lightningModeController),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.walletAddressController,
                          style: TextStyle(
                            color: lightningModeController.currentMode.value.mode == "light"
                                ? const Color(0xFF1E293B)
                                : Colors.white,
                            fontSize: 16,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            hintText: 'Enter wallet address',
                            hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: TextButton.icon(
                          onPressed: controller.pasteWalletAddress,
                          icon: const Icon(Icons.content_paste, size: 18),
                          label: const Text('Paste'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF3B82F6),
                            backgroundColor: const Color(0xFF3B82F6).withOpacity(0.1),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),

                // Payment Method Dropdown with enhanced styling
                _buildSectionTitle('Payment Method'),
                const SizedBox(height: 8),
                Obx(() => Container(
                  decoration: _getCardDecoration(lightningModeController),
                  child: DropdownButtonFormField<String>(
                    dropdownColor:
                        lightningModeController.currentMode.value.mode == "light"
                            ? Colors.white
                            : const Color(0xFF1E293B),
                    style: TextStyle(
                      color: lightningModeController.currentMode.value.mode == "light"
                          ? const Color(0xFF1E293B)
                          : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    icon: Icon(Icons.keyboard_arrow_down,
                        color: lightningModeController.currentMode.value.mode == "light"
                            ? const Color(0xFF64748B)
                            : Colors.white70),
                    value: controller.paymentMethod.value,
                    items: controller.availablePaymentMethods
                        .map((method) => DropdownMenuItem(
                              value: method,
                              child: Text(
                                method,
                                style: TextStyle(
                                  color: lightningModeController.currentMode.value.mode == "light"
                                      ? const Color(0xFF1E293B)
                                      : Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: controller.updatePaymentMethod,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      hintText: 'Select Payment Method',
                      hintStyle: TextStyle(color: Color(0xFF64748B)),
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
                                padding: const EdgeInsets.symmetric(vertical: 12),
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
                                          : lightningModeController.currentMode.value.mode == "light"
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
                                padding: const EdgeInsets.symmetric(vertical: 12),
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
                                          : lightningModeController.currentMode.value.mode == "light"
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
                          color: lightningModeController.currentMode.value.mode == "light"
                              ? const Color(0xFF1E293B)
                              : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          label: Text(
                              "Amount to buy (${controller.isCryptoAmount.value ? controller.selectedCrypto.value!.name : '\$'})",
                              style: TextStyle(
                                color: lightningModeController.currentMode.value.mode == "light"
                                    ? const Color(0xFF64748B)
                                    : Colors.white70,
                                fontSize: 14,
                              )),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                                color: lightningModeController.currentMode.value.mode == "light"
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
                                color: lightningModeController.currentMode.value.mode == "light"
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
                                Icons.calculate,
                                color: Color(0xFF8B5CF6),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Total Amount',
                              style: TextStyle(
                                color: lightningModeController.currentMode.value.mode == "light"
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
                              .map((exchange) => Obx(() => Text(
                                  '${exchange.currencyCode} ${(controller.fiatAmount.value * double.parse(exchange.rate) * num.parse(controller.isCryptoAmount.value ? controller.selectedCrypto.value!.currentPrice : "1")).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: lightningModeController.currentMode.value.mode == "light"
                                        ? const Color(0xFF1E293B)
                                        : Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ))))
                              .toList(),
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                
                // Enhanced Bank Transfer Section
                Obx(() => controller.paymentMethod.value == 'Bank Transfer'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Payment Details'),
                          const SizedBox(height: 16),
                          
                          // Admin Bank Details Section
                          adminBankDetailsController.isLoading.value
                              ? Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: _getCardDecoration(lightningModeController),
                                    child: const CircularProgressIndicator(),
                                  ),
                                )
                              : adminBankDetailsController.errorMessage.value.isNotEmpty
                                  ? Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                                      ),
                                      child: Text(
                                        'Error: ${adminBankDetailsController.errorMessage.value}',
                                        style: const TextStyle(color: Colors.red),
                                      ),
                                    )
                                  : adminBankDetailsController.bank_details.isEmpty
                                      ? Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: _getCardDecoration(lightningModeController),
                                          child: const Text('No bank details available.'),
                                        )
                                      : Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Send payment to:',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: lightningModeController.currentMode.value.mode == "light"
                                                    ? const Color(0xFF1E293B)
                                                    : Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            ...adminBankDetailsController.bank_details
                                                .map((bank) => Container(
                                                      margin: const EdgeInsets.only(bottom: 16),
                                                      decoration: _getCardDecoration(lightningModeController),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(16),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            _buildBankDetailRow('Bank Name', bank.bankName),
                                                            _buildBankDetailRow('Account Name', bank.accountName),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child: _buildBankDetailRow('Account Number', bank.accountNumber),
                                                                ),
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                                                                    borderRadius: BorderRadius.circular(8),
                                                                  ),
                                                                  child: IconButton(
                                                                    icon: const Icon(Icons.copy, size: 20),
                                                                    color: const Color(0xFF3B82F6),
                                                                    onPressed: () {
                                                                      FlutterClipboard.copy(bank.accountNumber);
                                                                      Get.snackbar(
                                                                          'Success',
                                                                          'Account number copied to clipboard',
                                                                          snackPosition: SnackPosition.TOP,
                                                                          backgroundColor: const Color(0xFF10B981),
                                                                          colorText: Colors.white,
                                                                          borderRadius: 12,
                                                                          margin: const EdgeInsets.all(16));
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            if (bank.ifscCode != null)
                                                              _buildBankDetailRow('IFSC Code', bank.ifscCode!),
                                                            if (bank.swiftCode != null)
                                                              _buildBankDetailRow('SWIFT Code', bank.swiftCode!),
                                                          ],
                                                        ),
                                                      ),
                                                    )),
                                          ],
                                        ),
                          
                          const SizedBox(height: 24),
                          
                          // Enhanced Payment Screenshot Upload Section
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
                                          color: const Color(0xFFF59E0B).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.upload_file,
                                          color: Color(0xFFF59E0B),
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        "Upload Payment Screenshot",
                                        style: TextStyle(
                                          color: lightningModeController.currentMode.value.mode == "light"
                                              ? const Color(0xFF1E293B)
                                              : Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Obx(() => controller.paymentScreenshot.value == null
                                      ? Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(vertical: 32),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color(0xFF3B82F6).withOpacity(0.3),
                                              style: BorderStyle.solid,
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                            color: const Color(0xFF3B82F6).withOpacity(0.05),
                                          ),
                                          child: Column(
                                            children: [
                                              const Icon(
                                                Icons.cloud_upload_outlined,
                                                size: 48,
                                                color: Color(0xFF3B82F6),
                                              ),
                                              const SizedBox(height: 12),
                                              ElevatedButton.icon(
                                                onPressed: () => controller.uploadScreenshot(),
                                                icon: const Icon(Icons.add_photo_alternate),
                                                label: const Text("Choose Image"),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0xFF3B82F6),
                                                  foregroundColor: Colors.white,
                                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
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
                                                  image: FileImage(controller.paymentScreenshot.value!),
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
                                                    onPressed: () => controller.uploadScreenshot(),
                                                    icon: const Icon(Icons.edit),
                                                    label: const Text("Change Image"),
                                                    style: OutlinedButton.styleFrom(
                                                      foregroundColor: const Color(0xFF3B82F6),
                                                      side: const BorderSide(color: Color(0xFF3B82F6)),
                                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: OutlinedButton.icon(
                                                    onPressed: () => controller.removeScreenshot(),
                                                    icon: const Icon(Icons.delete),
                                                    label: const Text("Remove"),
                                                    style: OutlinedButton.styleFrom(
                                                      foregroundColor: Colors.red,
                                                      side: const BorderSide(color: Colors.red),
                                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
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

                const SizedBox(height: 40),

                // Enhanced Buy Button
                Obx(() => controller.isLoading.value
                    ? Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
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
                                    await transactionAuthController.authenticate(
                                        context, 'Buy Crypto');

                                if (isAuthenticated) {
                                  controller.submitBuyCrypto();
                                }
                              }
                            },
                            child: const Center(
                              child: Text(
                                'Buy Crypto',
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

  BoxDecoration _getCardDecoration(LightningModeController lightningModeController) {
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

  Widget _buildBankDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}