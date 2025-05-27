import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:davyking/features/giftcards/data/model/giftcards_transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GiftCardTransactionDetailsScreen extends StatelessWidget {
  const GiftCardTransactionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GiftCardTransactionModel transaction = Get.arguments;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: Spacing.defaultMarginSpacing,
          child: Column(
            children: [
              const TopHeaderWidget(
                data: TopHeaderModel(title: 'Gift Card Transaction Details'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 5)),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildStatusIcon(transaction.type, transaction.status),
                        const SizedBox(height: 16),
                        Text(
                          '₦${double.parse(transaction.amount).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${transaction.type.capitalizeFirst ?? ''} Transaction',
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const Divider(height: 32),
                        _buildDetailItem(
                            'Transaction ID', transaction.id.toString()),
                        _buildDetailItem('Gift Card',
                            '${transaction.giftCard.name} (${transaction.giftCard.denomination})'),
                        _buildDetailItem(
                          'Date',
                          DateFormat('dd MMM yyyy • hh:mm a')
                              .format(transaction.createdAt),
                        ),
                        _buildStatusDetailItem(
                            'Status', transaction.status.capitalizeFirst ?? ''),
                        // if (transaction.proofFile != null)
                        //   _buildDetailItem('Proof File', transaction.proofFile!),
                        if (transaction.txHash != null)
                          _buildDetailItem(
                              'Transaction Hash', transaction.txHash!),
                        if (transaction.adminNotes != null)
                          _buildDetailItem(
                              'Admin Notes', transaction.adminNotes!),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Go Back'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDetailItem(String label, String value) {
    Color statusColor;
    switch (value.toLowerCase()) {
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'completed':
        statusColor = Colors.green;
        break;
      case 'failed':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(String type, String status) {
    IconData icon;
    Color color;

    // Determine the icon based on the transaction type
    if (type.toLowerCase() == 'buy') {
      icon = Icons.arrow_downward_rounded;
    } else {
      icon = Icons.arrow_upward_rounded;
    }

    // Determine the color based on the status
    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'completed':
        color = Colors.green;
        break;
      case 'failed':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return CircleAvatar(
        radius: 30,
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color, size: 30));
  }
}
