import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/constants/symbols.dart';
import 'package:davyking/core/controllers/primary_button_controller.dart';
import 'package:davyking/core/models/primary_button_model.dart';
import 'package:davyking/core/states/mode.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/primary_button_widget.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:davyking/features/giftcards/controllers/sell_giftcard_controller.dart';
import 'package:davyking/features/giftcards/data/model/giftcards_list_model.dart';
import 'package:flutter/material.dart';
import 'package:davyking/core/controllers/currency_rate_controller.dart';

import 'package:get/get.dart';

class SellGiftCardInputField extends StatelessWidget {
  const SellGiftCardInputField({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the arguments
    final GiftcardsListModel data = Get.arguments as GiftcardsListModel;
    // Pass the gift card data to the controller during initialization
    final SellGiftcardController controller =
        Get.put(SellGiftcardController(giftCardData: data));
    final LightningModeController lightningModeController =
        Get.find<LightningModeController>();
    final CurrencyRateController currencyRateController =
        Get.find<CurrencyRateController>();

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: Spacing.defaultMarginSpacing,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TopHeaderWidget(
                    data: TopHeaderModel(title: 'Sell Gift Card')),
                const SizedBox(height: 30),
                Center(
                  child: Container(
                    width: 229.09,
                    height: 148.38,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                          image: NetworkImage(data.image), fit: BoxFit.fill),
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
                // Obx(
                //   () => DropdownButtonFormField<String>(
                //       style: TextStyle(fontSize: 16, color: Colors.black),
                //       value: controller.selectedCountry.value.isEmpty
                //           ? null
                //           : controller.selectedCountry.value,
                //       icon: const Icon(Icons.keyboard_arrow_down),
                //       borderRadius: BorderRadius.circular(12.79),
                //       items: controller.countries
                //           .map((country) => DropdownMenuItem(
                //                 value: country,
                //                 child: Text(country),
                //               ))
                //           .toList(),
                //       onChanged: controller.updateSelectedCountry,
                //       decoration: const InputDecoration(
                //           border: InputBorder.none,
                //           filled: true,
                //           fillColor: Color(0xFFF7F7F7),
                //           labelText: 'Select Country',
                //           labelStyle: TextStyle(color: Colors.black))),
                // ),
                // const SizedBox(height: 20),
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
                      const Text("Select Quantity",
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                      Container(
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
                              onPressed: controller.decrementQuantity,
                              icon: const Icon(Icons.remove, color: Colors.red),
                            ),
                            Obx(() => Text(
                                  "${controller.quantity.value}",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                )),
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: controller.incrementQuantity,
                              icon: const Icon(Icons.add, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Obx(
                //   () => DropdownButtonFormField<String>(
                //     dropdownColor:
                //         lightningModeController.currentMode.value.mode ==
                //                 "light"
                //             ? Colors.black
                //             : Colors.white,
                //     style: Theme.of(context).textTheme.displayMedium,
                //     icon: const Icon(Icons.keyboard_arrow_down),
                //     value: controller.selectedRange.value.isEmpty
                //         ? null
                //         : controller.selectedRange.value,
                //     items: controller.ranges
                //         .map((range) => DropdownMenuItem(
                //               value: range,
                //               child: Text(
                //                 range,
                //                 style: TextStyle(
                //                     color: DarkThemeColors.primaryColor),
                //                 // selectionColor: Colors.black,
                //               ),
                //             ))
                //         .toList(),
                //     onChanged: controller.updateSelectedRange,
                //     decoration: const InputDecoration(
                //         border: InputBorder.none,
                //         filled: true,
                //         fillColor: Color(0xFFF7F7F7),
                //         labelText: 'Select Sell Range (\$)',
                //         labelStyle: TextStyle(color: Colors.black)),
                //   ),
                // ),
                const SizedBox(height: 20),
                // Price Buttons (Dynamic)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 11, vertical: 10),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF7F7F7),
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFF263238)),
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      child: Text(
                        '\$${data.denomination}/giftcard',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Color(0xE5093030),
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 1.47),
                      ),
                    ),
                    Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF7F7F7),
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFF263238)),
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      child: Text(
                        'Sell Rate: ${Symbols.currency_naira}${(double.parse(data.sellRate) * double.parse(data.denomination) * double.parse(currencyRateController.currencyRates[0].rate)).toStringAsFixed(2)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Color(0xE5093030),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 1.83),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Total Amount
                Obx(() => Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF7F7F7),
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFF093030)),
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          Column(
                            children: currencyRateController.currencyRates
                                .map((exchange) => Obx(() => Text(
                                    '${exchange.currencyCode} ${controller.totalAmount.value * double.parse(exchange.rate)}',
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 15))))
                                .toList(),
                          )
                        ],
                      ),
                    )),
                const SizedBox(height: 40),
                // New Payment Screenshot Upload Section
                Container(
                  width: Get.width,
                  padding: const EdgeInsets.all(12),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF7F7F7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Upload GiftCard Image",
                        style: TextStyle(
                          color: Color(0xFF093030),
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(() => controller.paymentScreenshot.value == null
                          ? ElevatedButton.icon(
                              onPressed: () => controller.uploadScreenshot(),
                              icon: const Icon(Icons.upload),
                              label: const Text("Choose Image"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF093030),
                                minimumSize: const Size(double.infinity, 45),
                              ),
                            )
                          : Column(
                              children: [
                                Container(
                                  height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                      image: FileImage(
                                          controller.paymentScreenshot.value!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () =>
                                          controller.uploadScreenshot(),
                                      child: const Text("Change Image"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          controller.removeScreenshot(),
                                      child: const Text(
                                        "Remove",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Sell Button
                CustomPrimaryButton(
                  controller: CustomPrimaryButtonController(
                    model: const CustomPrimaryButtonModel(text: 'Sell'),
                    onPressed: () {
                      if (controller.validateInputs()) {
                        Get.toNamed(RoutesConstant.sell_giftcard_field_details,
                            arguments: {
                              "id": data.id,
                              "image_url": data.image,
                              "name": data.name,
                              "selectedCountry":
                                  controller.selectedCountry.value,
                              "quantity": controller.quantity.value,
                              "selectedRange": controller.selectedRange.value,
                              "totalAmount": controller.totalAmount.value,
                              "paymentScreenshot":
                                  controller.paymentScreenshot.value?.path
                            });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
