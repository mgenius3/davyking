import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/features/wallet/controllers/index_controller.dart';
import 'package:davyking/features/wallet/data/model/wallet_transaction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String selectedFilter = 'All'; // Default filter
  final WalletController walletController = Get.put(WalletController());
  final UserAuthDetailsController userAuthDetailsController =
      Get.find<UserAuthDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: Spacing.defaultMarginSpacing,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const SizedBox(height: 20),
              _buildWalletBalanceCard(),
              const SizedBox(height: 20),
              _buildFilterTabs(),
              const SizedBox(height: 20),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: walletController.fetchWalletData,
                  child: Obx(() {
                    if (walletController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (walletController
                        .all_wallet_transaction.isEmpty) {
                      return const Center(
                          child: Text('No transactions found.'));
                    }

                    // Filter transactions based on selected filter
                    final filteredTransactions = selectedFilter == 'All'
                        ? walletController.all_wallet_transaction
                        : walletController.all_wallet_transaction
                            .where((tx) =>
                                tx.status.toLowerCase() ==
                                (selectedFilter == 'Failed'
                                    ? 'failed'
                                    : selectedFilter.toLowerCase()))
                            .toList();

                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = filteredTransactions[index];
                        return _buildTransactionItem(transaction);
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(),
        const Text(
          'Wallet',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildWalletBalanceCard() {
    return Obx(() => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.green, Colors.greenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Wallet Balance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'NGN ${userAuthDetailsController.user.value?.walletBalance ?? ""}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed(RoutesConstant.withdraw);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Withdraw funds',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildFilterTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFilterTab('All'),
        _buildFilterTab('Success'),
        _buildFilterTab('Pending'),
        _buildFilterTab('Failed'),
      ],
    );
  }

  Widget _buildFilterTab(String title) {
    final isSelected = selectedFilter == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          title,
          style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(WalletTransactionModel transaction) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RoutesConstant.wallet_transaction_details,
            arguments: transaction);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Transaction Icon (placeholder)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: transaction.type == 'deposit'
                    ? Colors.green
                    : Colors.orange,
              ),
              child: Icon(
                transaction.type == 'deposit'
                    ? Icons.arrow_downward
                    : Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            // Transaction Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${transaction.type.capitalizeFirst} via ${transaction.gateway.capitalizeFirst}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ref: ${transaction.reference} • ${DateFormat('MMM d, yyyy').format(transaction.createdAt)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            // Amount and Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'NGN ${transaction.amount}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      transaction.status.capitalizeFirst ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: transaction.status.toLowerCase() == 'success'
                            ? Colors.green
                            : (transaction.status.toLowerCase() == 'failed'
                                ? Colors.red
                                : Colors.orange),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
