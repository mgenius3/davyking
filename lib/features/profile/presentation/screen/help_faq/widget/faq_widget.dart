import 'package:davyking/features/profile/controllers/help_faq_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaqWidget extends StatefulWidget {
  final String questions;
  final String answers;
  const FaqWidget({super.key, required this.questions, required this.answers});

  @override
  State<FaqWidget> createState() => _FaqWidgetState();
}

class _FaqWidgetState extends State<FaqWidget> {
  bool showContent = false;

  void updateContent() {
    setState(() {
      showContent = !showContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
              onTap: () {
                updateContent();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.questions,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              height: 1.15)),
                  Icon(
                      showContent
                          ? CupertinoIcons.chevron_down
                          : CupertinoIcons.chevron_up,
                      size: 15)
                ],
              )),
          const SizedBox(height: 5),
          if (showContent)
            Text(widget.answers,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 13, height: 1.3, fontWeight: FontWeight.w300)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
