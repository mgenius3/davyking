import 'package:davyking/core/constants/images.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/controllers/primary_button_controller.dart';
import 'package:davyking/core/models/primary_button_model.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/primary_button_widget.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BuyGiftCardDetailsScreen extends StatelessWidget {
  const BuyGiftCardDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data =
        Get.arguments as Map<String, dynamic>; // Retrieve the arguments

    return Scaffold(
      body: SafeArea(
          child: Container(
        margin: Spacing.defaultMarginSpacing,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TopHeaderWidget(data: TopHeaderModel(title: 'Buy Gift Card')),
            Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF7F7F7),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(19.08),
                    ),
                    shadows: const [
                      BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 4,
                          offset: Offset(4, 4),
                          spreadRadius: 0)
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 118,
                            height: 81.49,
                            decoration: ShapeDecoration(
                              image: DecorationImage(
                                  image: AssetImage(data['image_url']),
                                  fit: BoxFit.fill),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.57),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x1E000000),
                                  blurRadius: 6.18,
                                  offset: Offset(0, 6.18),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            children: [
                              Text(data['name'],
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          height: 1.38)),
                              Text(data['selectedRange'],
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                          fontSize: 17.75,
                                          fontWeight: FontWeight.w500,
                                          height: 1.57))
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        decoration: ShapeDecoration(
                          color: Colors.white.withOpacity(0.8999999761581421),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 0.50),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x1E000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            details('Transaction Date', '12/12/2021'),
                            const SizedBox(height: 5),
                            details('No of Card', '1'),
                            const SizedBox(height: 5),
                            details('Trade Amount', '₦${data['totalAmount']}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(' By tapping the trade button, you have agreed to our   ',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        height: 2.20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Terms and Conditions',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                color: DarkThemeColors.primaryColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                                height: 2.20)),
                    const SizedBox(width: 5),
                    Text('And Our',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                                height: 2.20)),
                    const SizedBox(width: 5),
                    Text('Privacy Policy',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                color: DarkThemeColors.primaryColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                                height: 2.20))
                    // SvgPicture.asset(SvgConstant.arrowIcon, color: Colors.black, width: 10, height: 10)
                  ],
                )
              ],
            ),
            CustomPrimaryButton(
                controller: CustomPrimaryButtonController(
                    model: CustomPrimaryButtonModel(text: 'Proceed'),
                    onPressed: () {}))
          ],
        ),
      )),
    );
  }
}

Widget details(String name, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(name,
          textAlign: TextAlign.center,
          style: Theme.of(Get.context!).textTheme.displayMedium?.copyWith(
              fontSize: 12, fontWeight: FontWeight.w500, height: 1.38)),
      Text(value,
          textAlign: TextAlign.center,
          style: Theme.of(Get.context!).textTheme.displayMedium?.copyWith(
              fontSize: 12, fontWeight: FontWeight.w500, height: 1.38)),
    ],
  );
}
