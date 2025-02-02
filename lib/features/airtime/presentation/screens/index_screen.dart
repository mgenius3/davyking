import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/features/airtime/controllers/index_controller.dart';
import 'package:davyking/features/airtime/data/model/input_field_model.dart';
import 'package:davyking/features/airtime/presentation/widget/amount_widget.dart';
import 'package:davyking/features/airtime/presentation/widget/input_field_model.dart';
import 'package:davyking/features/airtime/presentation/widget/network_widget.dart';
import 'package:davyking/core/controllers/primary_button_controller.dart';
import 'package:davyking/core/models/primary_button_model.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/bottom_navigation_widget.dart';
import 'package:davyking/core/widgets/primary_button_widget.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AirtimeScreen extends StatefulWidget {
  const AirtimeScreen({super.key});

  @override
  State<AirtimeScreen> createState() => _AirtimeScreenState();
}

class _AirtimeScreenState extends State<AirtimeScreen> {
  final AirtimeIndexController airtimeIndexController =
      Get.put(AirtimeIndexController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: Spacing.defaultMarginSpacing,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopHeaderWidget(data: TopHeaderModel(title: "Airtime")),
              const SizedBox(height: 37.82),
              Text(
                'Select Network',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 12, fontWeight: FontWeight.w400, height: 1.83),
              ),
              const SizedBox(height: 10),
              const AirtimeNetworkWidget(),
              const SizedBox(height: 20),
              Text(
                'Select Amount',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 12, fontWeight: FontWeight.w400, height: 1.83),
              ),
              const SizedBox(height: 10),
              const AirtimeAmountWidget(),
              const SizedBox(height: 20),
              airtimeInputField(AirtimeInputFieldModel(
                  onChanged: airtimeIndexController.setAmount,
                  inputcontroller: airtimeIndexController.amountController,
                  // prefixIcon: Text('₦'),
                  name: 'Amount')),
              const SizedBox(height: 20),
              airtimeInputField(AirtimeInputFieldModel(
                  onChanged: airtimeIndexController.setPhoneNumber,
                  // inputcontroller: airtimeIndexController.phoneController,
                  hintText: '08134460259',
                  name: 'Phone Number')),
              const SizedBox(height: 40),
              Obx(() => CustomPrimaryButton(
                  controller: CustomPrimaryButtonController(
                      model: CustomPrimaryButtonModel(
                          text: 'Buy Airtime',
                          color: airtimeIndexController
                                      .isInformationComplete.value ==
                                  true
                              ? DarkThemeColors.primaryColor
                              : DarkThemeColors.disabledButtonColor),
                      onPressed: () {
                        Get.toNamed(RoutesConstant.airtime_details, arguments: {
                          'network':
                              airtimeIndexController.selectedNetwork.value,
                          'amount': airtimeIndexController.selectedAmount.value,
                          'phone': airtimeIndexController.phoneNumber.value
                        });
                      })))
            ],
          ),
        ),
      ),
      // bottomNavigationBar: const BottomNavigationWidget(currentIndex: 0)
    );
  }
}
