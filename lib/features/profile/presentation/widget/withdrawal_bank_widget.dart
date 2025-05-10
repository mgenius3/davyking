import 'package:davyking/core/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:davyking/core/utils/helper.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:get/get.dart';

class WithdrawalBankWidget extends StatelessWidget {
  const WithdrawalBankWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final UserAuthDetailsController userAuthDetailsController =
        Get.find<UserAuthDetailsController>();

    return Container(
        width: 250,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: DarkThemeColors.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: GestureDetector(
            onTap: () {
              copyToClipboard(
                  text: userAuthDetailsController
                          .user.value?.withdrawalBank?.accountNumber ??
                      "");
            },
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          shortenString(
                              userAuthDetailsController
                                      .user.value?.withdrawalBank?.bankName ??
                                  "Not set",
                              25),
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                      const SizedBox(height: 5),
                      Text(
                          userAuthDetailsController
                                  .user.value?.withdrawalBank?.accountNumber ??
                              "nil",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: DarkThemeColors.shade)),
                    ],
                  ),
                  const Icon(CupertinoIcons.doc_on_clipboard,
                      color: Colors.white),
                ],
              ),
            )));
  }
}
