import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:davyking/features/notifications/presentation/widget/notification_dialog_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widget/notification_section_widget.dart';
import 'package:davyking/core/utils/dimensions.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Scaffold(
                body: Container(
      margin: const EdgeInsets.only(
          left: Dimensions.defaultLeftSpacing,
          right: Dimensions.defaultRightSpacing,
          top: Dimensions.defaultTopSpacing),
      child: Column(
        children: [
          TopHeaderWidget(
              data: TopHeaderModel(
                  title: "Notification",
                  child: GestureDetector(
                      onTap: () {
                        Get.dialog(notifationDialogWidget(context));
                      },
                      child: const Icon(CupertinoIcons.ellipsis)))),
          const SizedBox(height: 50),
          SizedBox(
            height: Get.height - 150,
            child: ListView(
              // padding: EdgeInsets.all(16.0),
              children: const [
                NotificationSection(
                  sectionTitle: "Today",
                  notifications: [
                    NotificationItem(
                      title: "Deposit Confirmed",
                      description:
                          "Chief your deposit has been confirmed...\nDeposit amount: 0.0045BTC",
                      timestamp: "6:49 - 19 Nov. 24",
                    ),
                    NotificationItem(
                        title: "New App Update",
                        description:
                            "Chief please do well to update your app to be able to use our latest features...",
                        timestamp: "3:02 - 19 Nov. 24"),
                  ],
                ),
                NotificationSection(
                  sectionTitle: "Yesterday",
                  notifications: [
                    NotificationItem(
                      title: "Transactions Completed",
                      description:
                          "0.16586 ETH SOLD\nThank you for trading with DK Exchange. Looking forward to...",
                      timestamp: "17:56 - 18 Nov. 24",
                    ),
                    NotificationItem(
                      title: "Referral Contest",
                      description:
                          "Refer someone to DK Exchange and win amazing prizes. Terms & condi...",
                      timestamp: "11:09 - 18 Nov. 24",
                    ),
                  ],
                ),
                NotificationSection(
                  sectionTitle: "September",
                  notifications: [
                    NotificationItem(
                      title: "Deposit Confirmed",
                      description:
                          "Chief your deposit has been confirmed...\nDeposit amount: 0.0045BTC",
                      timestamp: "5:05 - 01 Sep. 24",
                    ),
                    NotificationItem(
                      title: "WELCOME CHIEF!",
                      description:
                          "Welcome to one of the biggest Crypto and giftcards trading platform. We look forward to your first trade...",
                      timestamp: "12:42 - 01 Sep. 24",
                    ),
                  ],
                ),
                NotificationSection(
                  sectionTitle: "September",
                  notifications: [
                    NotificationItem(
                      title: "Deposit Confirmed",
                      description:
                          "Chief your deposit has been confirmed...\nDeposit amount: 0.0045BTC",
                      timestamp: "5:05 - 01 Sep. 24",
                    ),
                    NotificationItem(
                      title: "WELCOME CHIEF!",
                      description:
                          "Welcome to one of the biggest Crypto and giftcards trading platform. We look forward to your first trade...",
                      timestamp: "12:42 - 01 Sep. 24",
                    ),
                  ],
                ),
                NotificationSection(
                  sectionTitle: "September",
                  notifications: [
                    NotificationItem(
                      title: "Deposit Confirmed",
                      description:
                          "Chief your deposit has been confirmed...\nDeposit amount: 0.0045BTC",
                      timestamp: "5:05 - 01 Sep. 24",
                    ),
                    NotificationItem(
                      title: "WELCOME CHIEF!",
                      description:
                          "Welcome to one of the biggest Crypto and giftcards trading platform. We look forward to your first trade...",
                      timestamp: "12:42 - 01 Sep. 24",
                    ),
                  ],
                ),
                NotificationSection(
                  sectionTitle: "September",
                  notifications: [
                    NotificationItem(
                      title: "Deposit Confirmed",
                      description:
                          "Chief your deposit has been confirmed...\nDeposit amount: 0.0045BTC",
                      timestamp: "5:05 - 01 Sep. 24",
                    ),
                    NotificationItem(
                      title: "WELCOME CHIEF!",
                      description:
                          "Welcome to one of the biggest Crypto and giftcards trading platform. We look forward to your first trade...",
                      timestamp: "12:42 - 01 Sep. 24",
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    ))));
  }
}
