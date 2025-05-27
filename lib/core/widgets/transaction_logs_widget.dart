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

    return SizedBox(
      height: 500,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Recent Transaction"),
              GestureDetector(
                onTap: () => Get.toNamed(RoutesConstant.recent_transaction),
                child: const Text("View all",
                    style: TextStyle(fontWeight: FontWeight.w300)),
              )
            ],
          ),
          const SizedBox(height: 10),
          Obx(() {
            final logs = controller.transactionLogs;
            final displayLogs = logs.length > 5 ? logs.sublist(0, 5) : logs;
            return logs.isEmpty
                ? const Center(child: Text('No activity yet'))
                : SizedBox(
                    height: 400,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: displayLogs.length,
                      itemBuilder: (context, index) {
                        final log = displayLogs[index];
                        return GestureDetector(
                          onTap: () => _handleTransactionTap(log, vtuRepository,
                              giftCardController, cryptoController),
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    log.transactionType
                                            .replaceAll('_', ' ')
                                            .capitalizeFirst ??
                                        '',
                                  ),
                                  Text(
                                    '${Symbols.currency_naira}${log.details['total_amount']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(shortenString(
                                          log.details['message'], 20)),
                                      Text(
                                        log.details['type']
                                                ?.toString()
                                                .capitalizeFirst ??
                                            '',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Date: ${log.timestamp.toString().substring(0, 10)}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        'Time: ${log.timestamp.toString().substring(11, 16)}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
          }),
        ],
      ),
    );
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
