import 'package:davyking/core/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:davyking/core/utils/helper.dart';

class WithdrawalBankWidget extends StatelessWidget {
  const WithdrawalBankWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: DarkThemeColors.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: GestureDetector(
          onTap: () {
            copyToClipboard(text: '3098689024');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Polaris Bank',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white)),
                  const SizedBox(height: 5),
                  Text('3098689024',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: DarkThemeColors.shade)),
                ],
              ),
              const Icon(CupertinoIcons.doc_on_clipboard, color: Colors.white),
            ],
          ),
        ));
  }
}
