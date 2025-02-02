import 'package:davyking/core/constants/images.dart';
import 'package:davyking/features/giftcards/data/model/giftcards_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class GiftcardsList extends StatelessWidget {
  final GiftcardsListModel giftcardsdata;
  const GiftcardsList({super.key, required this.giftcardsdata});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * .4,
      // height: 113,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        shadows: const [
          BoxShadow(
              color: Color(0x19000000),
              blurRadius: 4,
              offset: Offset(4, 4),
              spreadRadius: 0)
        ],
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(giftcardsdata.image_url,
              fit: BoxFit.cover, width: Get.width * .4),
          Container(
            // height: 113,
            padding: const EdgeInsets.all(10),
            child: Text(giftcardsdata.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 11.85,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
