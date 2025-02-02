import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/controllers/primary_button_controller.dart';
import 'package:davyking/core/models/primary_button_model.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/primary_button_widget.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:davyking/features/giftcards/controllers/sell_giftcard_controller.dart';
import 'package:davyking/features/giftcards/data/model/giftcards_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SellGiftCardInputField extends StatelessWidget {
  const SellGiftCardInputField({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments; // Access the arguments
    GiftcardsListModel data = GiftcardsListModel.fromJson(args);
    final SellGiftcardController controller = Get.put(SellGiftcardController());

    return Scaffold(
      body: SafeArea(
          child: Container(
        margin: Spacing.defaultMarginSpacing,
        child: Column(children: [
          const TopHeaderWidget(data: TopHeaderModel(title: 'Sell Gift Card')),
          const SizedBox(height: 30),
          Container(
            width: 229.09,
            height: 148.38,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: AssetImage(data.image_url),
                fit: BoxFit.fill,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.79)),
              shadows: const [
                BoxShadow(
                    color: Color(0x1E000000),
                    blurRadius: 5.42,
                    offset: Offset(0, 5.42),
                    spreadRadius: 0)
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: Get.width,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 9.33),
            decoration: ShapeDecoration(
              color: const Color(0xFFE4F6EF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1.87),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  data.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color(0xFF093030),
                      fontSize: 11.19,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1.83),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // const SizedBox(height: 20),

          // Obx(
          //   () => DropdownButtonFormField<String>(
          //     value: controller.selectedCountry.value,
          //     icon: const Icon(Icons.keyboard_arrow_down),
          //     borderRadius: BorderRadius.circular(12.79),
          //     items: controller.countries
          //         .map((country) => DropdownMenuItem(
          //               value: country,
          //               child: Text(country),
          //             ))
          //         .toList(),
          //     onChanged: controller.updateSelectedCountry,
          //     decoration: const InputDecoration(
          //         border: InputBorder.none,
          //         filled: true,
          //         fillColor: Color(0xFFF7F7F7)),
          //   ),
          // ),
          const SizedBox(height: 20),
          Container(
            width: Get.width,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 9.33),
            decoration: ShapeDecoration(
              color: const Color(0xFFF7F7F7),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1.87)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("No of Card", style: TextStyle(fontSize: 16)),
                Container(
                  // width: 96,
                  height: 33.67,
                  decoration: ShapeDecoration(
                    color: Colors.white.withOpacity(0.8999999761581421),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.36),
                    ),
                    shadows: const [
                      BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 4.90,
                          offset: Offset(0, 4.90),
                          spreadRadius: 0)
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: controller.decrementNoOfCard,
                        icon: const Icon(Icons.remove, color: Colors.red),
                      ),
                      Obx(() => Text(
                            "${controller.no_of_card.value}",
                            style: const TextStyle(fontSize: 16),
                          )),
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: controller.incrementNoOfCard,
                        icon: const Icon(Icons.add, color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => DropdownButtonFormField<String>(
              icon: const Icon(Icons.keyboard_arrow_down),
              value: controller.selectedRange.value,
              items: controller.ranges
                  .map((range) => DropdownMenuItem(
                        value: range,
                        child: Text(range),
                      ))
                  .toList(),
              onChanged: controller.updateSelectedRange,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Color(0xFFF7F7F7),
              ),
            ),
          ),

          const SizedBox(height: 20),
          // Price Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // width: 160,
                height: 42,
                padding: const EdgeInsets.only(
                    top: 10, left: 11, right: 114, bottom: 10),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF7F7F7),
                  shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFF263238)),
                      borderRadius: BorderRadius.circular(5)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '\$100',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xE5093030),
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 1.47),
                    ),
                  ],
                ),
              ),
              Container(
                // width: 160,
                height: 42,
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 92,
                  right: 16,
                  bottom: 10,
                ),
                decoration: ShapeDecoration(
                  color: Color(0xFFF7F7F7),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFF263238)),
                      borderRadius: BorderRadius.circular(5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('N1,250/\$',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xE5093030),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 1.83)),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 20),

          // Total Amount
          Obx(() => Container(
                width: Get.width,
                // height: 45,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF7F7F7),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFF093030)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text(
                  "₦ ${controller.totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                      color: Color(0xE5093030),
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1.78),
                ),
              )),

          const SizedBox(height: 40),

          CustomPrimaryButton(
              controller: CustomPrimaryButtonController(
                  model: const CustomPrimaryButtonModel(text: 'Sell'),
                  onPressed: () {
                    Get.toNamed(RoutesConstant.buy_giftcard_field_details,
                        arguments: {
                          "image_url": data.image_url,
                          "name": data.name,
                          // "selectedCountry": controller.selectedCountry.value,
                          "no_of_card": controller.no_of_card.value,
                          "selectedRange": controller.selectedRange.value,
                          "totalAmount": controller.totalAmount
                        });
                  }))
        ]),
      )),
    );
  }
}
