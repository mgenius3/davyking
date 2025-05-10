import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/features/wallet/data/model/wallet_transaction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WalletTransactionDetailsScreen extends StatelessWidget {
  const WalletTransactionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WalletTransactionModel transaction = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transaction Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: Spacing.defaultMarginSpacing,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transaction Summary Card
                Container(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: transaction.type == 'deposit'
                                  ? Colors.white
                                  : Colors.orange,
                            ),
                            child: Icon(
                              transaction.type == 'deposit'
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: transaction.type == 'deposit'
                                  ? Colors.green
                                  : Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              '${transaction.type.capitalizeFirst} via ${transaction.gateway.capitalizeFirst}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'NGN ${transaction.amount}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            transaction.status.capitalizeFirst ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color:
                                  transaction.status.toLowerCase() == 'success'
                                      ? Colors.white
                                      : (transaction.status.toLowerCase() ==
                                              'failed'
                                          ? Colors.red[200]
                                          : Colors.yellow[200]),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  transaction.status.toLowerCase() == 'success'
                                      ? Colors.green[700]
                                      : (transaction.status.toLowerCase() ==
                                              'failed'
                                          ? Colors.red[700]
                                          : Colors.orange[700]),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              transaction.status.toLowerCase() == 'success'
                                  ? 'Completed'
                                  : (transaction.status.toLowerCase() ==
                                          'failed'
                                      ? 'Failed'
                                      : 'Pending'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Transaction Details Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Transaction Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow('Reference', transaction.reference),
                      _buildDetailRow(
                          'Transaction ID', transaction.id.toString()),
                      _buildDetailRow(
                          'Type', transaction.type.capitalizeFirst ?? ''),
                      _buildDetailRow(
                          'Gateway', transaction.gateway.capitalizeFirst ?? ''),
                      _buildDetailRow(
                        'Date',
                        DateFormat('MMM d, yyyy HH:mm')
                            .format(transaction.createdAt),
                      ),
                      _buildDetailRow(
                        'Status',
                        transaction.status.capitalizeFirst ?? '',
                        valueColor:
                            transaction.status.toLowerCase() == 'success'
                                ? Colors.green
                                : (transaction.status.toLowerCase() == 'failed'
                                    ? Colors.red
                                    : Colors.orange),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Action Button (e.g., Report Issue)
                Center(
                  child: TextButton(
                    onPressed: () {
                      Get.snackbar(
                        'Report Issue',
                        'Contact support for assistance with this transaction.',
                      );
                    },
                    child: const Text(
                      'Report an Issue',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
