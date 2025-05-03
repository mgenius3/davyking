// recent_transactions_screen.dart
import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/controllers/transaction_log_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecentTransactionsWidget extends StatelessWidget {
  const RecentTransactionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionLogController controller =
        Get.put(TransactionLogController());

    return SizedBox(
      height: 500, // Specifies the container height
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Recent Transaction"),
              GestureDetector(
                onTap: () {
                  Get.toNamed(RoutesConstant.recent_transaction);
                },
                child: const Text("View all",
                    style: TextStyle(fontWeight: FontWeight.w300)),
              )
            ],
          ),
          const SizedBox(height: 10),
          Obx(
            () {
              final logs = controller.transactionLogs;
              final displayLogs = logs.length > 5 ? logs.sublist(0, 5) : logs;
              return logs.isEmpty
                  ? const Center(child: Text('No activity yet'))
                  : SizedBox(
                      height: 400, // Height for scrollable area
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: displayLogs.length, // Limit to max 5 items
                        itemBuilder: (context, index) {
                          final log = displayLogs[index];
                          return Card(
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
                                    '\$${log.details['total_amount']}',
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
                                      Text('${log.details['message']}'),
                                      Text(
                                        '${log.details['type']}'
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
                          );
                        },
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
