import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/constants/symbols.dart';
import 'package:davyking/core/controllers/currency_rate_controller.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/models/currency_rate_model.dart';
import 'package:davyking/features/home/controllers/balance_display_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BalanceDisplayWidget extends StatelessWidget {
  const BalanceDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final BalanceDisplayController controller =
        Get.put(BalanceDisplayController());
    final userAuthController = Get.find<UserAuthDetailsController>();
    final currencyRateController = Get.find<CurrencyRateController>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          end: Alignment(0.99, -0.12),
          begin: Alignment(-0.99, 0.12),
          colors: [
            Color(0xFF00CE7C),
            Color(0xFF00CE7C),
            Color(0xFF1ABD1A),
            Color(0xFF1ABD1A),
            Color(0xFF00664A)
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00CE7C).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          const BoxShadow(
            color: Color(0x14000000),
            blurRadius: 4,
            offset: Offset(4, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderRow(),
          const SizedBox(height: 20),
          _buildBalanceSection(controller, userAuthController),
          const SizedBox(height: 16),
          _buildBottomRow(currencyRateController, userAuthController),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildBalanceLabel(),
        _buildTransactionHistoryButton(),
      ],
    );
  }

  Widget _buildBalanceLabel() {
    final BalanceDisplayController controller = Get.find<BalanceDisplayController>();
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.account_balance_wallet,
            size: 14,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'Available Balance',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(width: 8),
        Obx(() => GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            controller.toggleBalanceVisibility();
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              !controller.showBalance.value
                  ? CupertinoIcons.eye_fill
                  : CupertinoIcons.eye_slash,
              size: 14,
              color: Colors.white,
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildTransactionHistoryButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Get.toNamed(RoutesConstant.recent_transaction);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history_rounded,
              size: 14,
              color: Colors.white,
            ),
            SizedBox(width: 6),
            Text(
              'History',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios,
              size: 10,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceSection(BalanceDisplayController controller, UserAuthDetailsController userAuthController) {
    return Obx(() => GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        controller.toggleBalanceVisibility();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.showBalance.value
                ? '${Symbols.currency_naira}${userAuthController.user.value?.walletBalance ?? 0}'
                : "••••••••",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Tap to toggle visibility',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildBottomRow(CurrencyRateController currencyRateController, UserAuthDetailsController userAuthController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildDollarEquivalent(currencyRateController, userAuthController),
        _buildDepositButton(),
      ],
    );
  }

  Widget _buildDollarEquivalent(CurrencyRateController currencyRateController, UserAuthDetailsController userAuthController) {
    return Obx(() {
      if (currencyRateController.currencyRates.isNotEmpty) {
        final walletBalance = double.tryParse(
                userAuthController.user.value?.walletBalance ?? '0') ??
            0;
        final ngnRate = currencyRateController.currencyRates.firstWhere(
          (rate) => rate.currencyCode == 'NGN',
          orElse: () => CurrencyRateModel(
              currencyCode: 'NGN', rate: '0', id: 0),
        );

        final rateValue = ngnRate.rate.isEmpty
            ? 1
            : num.tryParse(ngnRate.rate) ?? 1;

        final dollarValue = (walletBalance / rateValue).toStringAsFixed(2);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.currency_exchange,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "\$${dollarValue}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              "USD Equivalent",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.currency_exchange,
                  size: 12,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                "\$0.00",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            "USD Equivalent",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildDepositButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Get.toNamed(RoutesConstant.deposit);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: const Color(0xFF2E5572).withOpacity(0.1),
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Icon(
                Icons.add_rounded,
                size: 12,
                color: Color(0xFF2E5572),
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'Deposit',
              style: TextStyle(
                color: Color(0xFF2E5572),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}