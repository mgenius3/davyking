import 'package:davyking/core/controllers/transaction_log_controller.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:davyking/core/utils/dimensions.dart';

class RecentTransactionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TransactionLogController controller =
        Get.find<TransactionLogController>();

    return Scaffold(
        body: SafeArea(
            child: Scaffold(
                body: SingleChildScrollView(
                    child: Container(
      margin: const EdgeInsets.only(
          left: Dimensions.defaultLeftSpacing,
          right: Dimensions.defaultRightSpacing,
          top: Dimensions.defaultTopSpacing),
      child: Column(
        children: [
          const TopHeaderWidget(
              data: TopHeaderModel(
                  title: "Recent Transactions", child: SizedBox())),
          const SizedBox(height: 20),
          SingleChildScrollView(
            child: Obx(
              () => controller.transactionLogs.isEmpty
                  ? const Center(
                      child: Text('No activity yet'),
                    )
                  : SizedBox(
                      height: Get.height -
                          100, // Specify the height for scrollable area
                      child: ListView.builder(
                        shrinkWrap: true, // Ensures it takes only needed space
                        physics:
                            const BouncingScrollPhysics(), // Smooth scrolling
                        itemCount: controller.transactionLogs.length,
                        itemBuilder: (context, index) {
                          final log = controller.transactionLogs[index];
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
                    ),
            ),
          ),
        ],
      ),
    )))));
  }
}
