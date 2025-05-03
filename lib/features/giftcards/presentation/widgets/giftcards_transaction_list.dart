import 'package:davyking/core/constants/api_url.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/features/giftcards/data/model/giftcards_transaction_model.dart';
import 'package:flutter/material.dart';

class GiftcardsTransactionListWidget extends StatelessWidget {
  final GiftCardTransactionModel data;

  const GiftcardsTransactionListWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            ApiUrl.domain + "storage/" + data.giftCard.image))),
              ),
              const SizedBox(width: 20),
              Expanded(
                  child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${data.amount} ${data.giftCard.name}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: DarkThemeColors.primaryColor),
                      ),
                      Text(
                        "${data.status}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: data.status == "pending"
                                ? Colors.orange
                                : data.status == "completed"
                                    ? DarkThemeColors.primaryColor
                                    : Colors.red),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date: ${data.createdAt.toString().substring(0, 10)}',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w300),
                      ),
                      Text(
                        'Time: ${data.createdAt.toString().substring(11, 16)}',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ],
              ))
            ],
          ),
        ));
  }
}
