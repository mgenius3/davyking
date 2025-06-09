import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/constants/symbols.dart';
import 'package:davyking/core/controllers/transaction_log_controller.dart';
import 'package:davyking/core/models/transaction_log_model.dart';
import 'package:davyking/core/repository/vtu_repository.dart';
import 'package:davyking/core/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:davyking/features/crypto/controllers/index_controller.dart';
import 'package:davyking/features/giftcards/controllers/index_controller.dart';

class RecentTransactionsWidget extends StatelessWidget {
  const RecentTransactionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionLogController controller =
        Get.put(TransactionLogController());
    final VtuRepository vtuRepository = VtuRepository();
    final GiftCardController giftCardController = Get.put(GiftCardController());
    final CryptoController cryptoController = Get.put(CryptoController());

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildTransactionsList(
              controller, vtuRepository, giftCardController, cryptoController),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Recent Transactions",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        GestureDetector(
          onTap: () => Get.toNamed(RoutesConstant.recent_transaction),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "View all",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[700],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios,
                    size: 12, color: Colors.blue[700]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsList(
    TransactionLogController controller,
    VtuRepository vtuRepository,
    GiftCardController giftCardController,
    CryptoController cryptoController,
  ) {
    return Obx(() {
      final logs = controller.transactionLogs;
      final displayLogs = logs.length > 5 ? logs.sublist(0, 5) : logs;

      return logs.isEmpty
          ? _buildEmptyState()
          : SizedBox(
              height: 350,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: displayLogs.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final log = displayLogs[index];
                  return _buildTransactionCard(
                      log, vtuRepository, giftCardController, cryptoController);
                },
              ),
            );
    });
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.grey[100], shape: BoxShape.circle),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 32,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No transactions yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your recent transactions will appear here',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(
      TransactionLogModel log,
      VtuRepository vtuRepository,
      GiftCardController giftCardController,
      CryptoController cryptoController) {
    final transactionType =
        log.transactionType.replaceAll('_', ' ').capitalizeFirst ?? '';
    final amount = '${Symbols.currency_naira}${log.details['total_amount']}';
    final message = shortenString(log.details['message'], 20);
    final type = log.details['type']?.toString().capitalizeFirst ?? '';
    final date = log.timestamp.toString().substring(0, 10);
    final time = log.timestamp.toString().substring(11, 16);

    return GestureDetector(
      onTap: () => _handleTransactionTap(
        log,
        vtuRepository,
        giftCardController,
        cryptoController,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _handleTransactionTap(
                log, vtuRepository, giftCardController, cryptoController),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _getTransactionColor(log.transactionType)
                              .withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getTransactionIcon(log.transactionType),
                          color: _getTransactionColor(log.transactionType),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transactionType,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              message,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            amount,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(type).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              type,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: _getStatusColor(type),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Footer Row
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.access_time_outlined,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 10,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getTransactionIcon(String transactionType) {
    final type = transactionType.toLowerCase();
    if (type.contains('airtime')) return Icons.phone_android;
    if (type.contains('data')) return Icons.wifi;
    if (type.contains('electricity')) return Icons.flash_on;
    if (type.contains('gift')) return Icons.card_giftcard;
    if (type.contains('crypto')) return Icons.currency_bitcoin;
    if (type.contains('betting')) return Icons.sports_esports;
    if (type.contains('tv')) return Icons.tv;
    return Icons.receipt;
  }

  Color _getTransactionColor(String transactionType) {
    final type = transactionType.toLowerCase();
    if (type.contains('airtime')) return const Color(0xFF4CAF50);
    if (type.contains('data')) return const Color(0xFF2196F3);
    if (type.contains('electricity')) return const Color(0xFFFF9800);
    if (type.contains('gift')) return const Color(0xFFE91E63);
    if (type.contains('crypto')) return const Color(0xFFFF5722);
    if (type.contains('betting')) return const Color(0xFF9C27B0);
    if (type.contains('tv')) return const Color(0xFF3F51B5);
    return const Color(0xFF607D8B);
  }

  Color _getStatusColor(String status) {
    final statusLower = status.toLowerCase();
    if (statusLower.contains('success') || statusLower.contains('completed')) {
      return const Color(0xFF4CAF50);
    }
    if (statusLower.contains('pending') || statusLower.contains('processing')) {
      return const Color(0xFFFF9800);
    }
    if (statusLower.contains('failed') || statusLower.contains('error')) {
      return const Color(0xF44336);
    }
    return const Color(0xFF607D8B);
  }

  Future<void> _handleTransactionTap(
      TransactionLogModel log,
      VtuRepository vtuRepository,
      GiftCardController giftCardController,
      CryptoController cryptoController) async {
    try {
      final transactionType = log.transactionType.toLowerCase();
      final requestId = log.referenceId.toString();

      if (transactionType.contains('gift')) {
        print('giftcard yes');

        Get.toNamed(RoutesConstant.giftCardTransactionDetails,
            arguments:
                giftCardController.singleTransaction(requestId.toString()));
        return;
      } else if (transactionType.contains('crypto')) {
        Get.toNamed(RoutesConstant.cryptoTransactionDetails,
            arguments:
                cryptoController.singleTransaction(requestId.toString()));
        return;
      } else {
        final response =
            await vtuRepository.getVtuTransaction(requestId: requestId);
        if (response == null || response['receipt_data'] == null) {
          Get.snackbar("Error", "Unable to retrieve receipt details");
          return;
        }

        final receiptData = response['receipt_data'];
        String? route;

        if (transactionType.contains('airtime')) {
          route = RoutesConstant.airtime_receipt;
        } else if (transactionType.contains('data')) {
          route = RoutesConstant.data_receipt;
        } else if (transactionType.contains('electricity')) {
          route = RoutesConstant.electricity_receipt;
        } else if (transactionType.contains('betting')) {
          route = RoutesConstant.betting_receipt;
        } else if (transactionType.contains('tv')) {
          route = RoutesConstant.tv_receipt;
        }
        if (route != null) {
          Get.toNamed(route, arguments: receiptData);
        } else {
          // Get.snackbar("Notice", "Unsupported transaction type");
        }
      }
    } catch (e) {
      print("Error fetching transaction: $e");
    }
  }
}
