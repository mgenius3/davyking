import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/widgets/vtu_input_field.dart';
import 'package:davyking/features/electricity/controllers/index_controller.dart';
import 'package:davyking/features/airtime/data/model/input_field_model.dart';
import 'package:davyking/core/controllers/primary_button_controller.dart';
import 'package:davyking/core/models/primary_button_model.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/primary_button_widget.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:davyking/features/electricity/presentation/widgets/electricity_disco_widget.dart';
import 'package:davyking/features/electricity/presentation/widgets/electricity_variation_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ElectricityScreen extends StatefulWidget {
  const ElectricityScreen({super.key});

  @override
  State<ElectricityScreen> createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends State<ElectricityScreen> {
  final ElectricityIndexController controller =
      Get.put(ElectricityIndexController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: Spacing.defaultMarginSpacing,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TopHeaderWidget(
                    data: TopHeaderModel(title: "Electricity")),
                const SizedBox(height: 37.82),
                Text(
                  'Select Distribution Company',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.83,
                      ),
                ),
                const SizedBox(height: 10),
                const ElectricityDiscoWidget(),
                const SizedBox(height: 20),
                Text(
                  'Select Variation',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.83,
                      ),
                ),
                const SizedBox(height: 10),
                const ElectricityVariationWidget(),
                const SizedBox(height: 20),
                vtuInputField(AirtimeInputFieldModel(
                  onChanged: controller.setCustomerId,
                  inputcontroller: controller.customerIdController,
                  hintText: '12345678901',
                  name: 'Meter Number',
                )),
                const SizedBox(height: 20),
                vtuInputField(AirtimeInputFieldModel(
                  onChanged: controller.setAmount,
                  inputcontroller: controller.amountController,
                  hintText: '1000',
                  name: 'Amount',
                  // keyboardType: TextInputType.number,
                  prefixIcon: const Text('₦'),
                )),
                const SizedBox(height: 40),
                Obx(() => CustomPrimaryButton(
                      controller: CustomPrimaryButtonController(
                          model: CustomPrimaryButtonModel(
                            text: 'Proceed',
                            color: controller.isInformationComplete.value
                                ? DarkThemeColors.primaryColor
                                : DarkThemeColors.disabledButtonColor,
                          ),
                          onPressed: () {
                            if (controller.validateInputs()) {
                              Get.toNamed(RoutesConstant.electricity_details,
                                  arguments: {
                                    'disco': controller.discoMapping[controller
                                        .selectedDisco.value]['service_id'],
                                    'customer_id': controller.customerId.value,
                                    'variation_id':
                                        controller.selectedVariationId.value,
                                    'amount': controller.amount.value
                                  });
                            }
                          }),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
