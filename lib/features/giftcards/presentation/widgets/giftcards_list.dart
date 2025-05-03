import 'dart:ui'; // Import for BackdropFilter
import 'package:davyking/core/constants/api_url.dart';
import 'package:davyking/core/constants/images.dart';
import 'package:davyking/features/giftcards/data/model/giftcards_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class GiftcardsList extends StatelessWidget {
  final GiftcardsListModel giftcardsdata;
  final bool isEnabled; // Add isEnabled parameter

  const GiftcardsList({
    super.key,
    required this.giftcardsdata,
    this.isEnabled = true, // Default to true
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main gift card container
        Container(
          width: Get.width * .4,
          height: 190,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            shadows: const [
              BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 4,
                  offset: Offset(4, 4),
                  spreadRadius: 0),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                giftcardsdata.image,
                fit: BoxFit.cover,
                width: Get.width * .4,
                height: 150,
                // Reduce opacity of the image if disabled
                color: isEnabled ? null : Colors.black.withOpacity(0.5),
                colorBlendMode: isEnabled ? null : BlendMode.dstATop,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  giftcardsdata.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: isEnabled
                          ? Colors.black
                          : Colors.grey, // Change text color if disabled
                      fontSize: 11.85,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        // Add a "Disabled" label if disabled
        if (!isEnabled)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Disabled',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }
}
