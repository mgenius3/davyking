import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/widgets/vtu_input_field.dart';
import 'package:davyking/features/data/controllers/index_controller.dart';
import 'package:davyking/core/models/input_field_model.dart';
import 'package:davyking/core/controllers/primary_button_controller.dart';
import 'package:davyking/core/models/primary_button_model.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/primary_button_widget.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:davyking/features/data/presentation/widgets/data_network_widget.dart';
import 'package:davyking/features/data/presentation/widgets/data_variation_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final DataIndexController controller = Get.put(DataIndexController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            margin: Spacing.defaultMarginSpacing,
            child:
                // Obx(() =>
                // controller.isLoading.value &&
                //         controller.variations.isEmpty
                //     ? const Center(child: CircularProgressIndicator())
                //     :

                SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TopHeaderWidget(data: TopHeaderModel(title: "Data")),
                  const SizedBox(height: 37.82),
                  Text(
                    'Select Network',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.83),
                  ),
                  const SizedBox(height: 10),
                  const DataNetworkWidget(),
                  const SizedBox(height: 20),
                  Text(
                    'Select Data Plan',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.83),
                  ),
                  const SizedBox(height: 10),
                  const DataVariationWidget(),
                  const SizedBox(height: 20),
                  vtuInputField(VtuInputFieldModel(
                      onChanged: controller.setPhoneNumber,
                      inputcontroller: controller.phoneController,
                      hintText: '08134460259',
                      name: 'Phone Number'
                      // keyboardType: TextInputType.phone,
                      )),
                  const SizedBox(height: 40),
                  Obx(() => CustomPrimaryButton(
                        controller: CustomPrimaryButtonController(
                            model: CustomPrimaryButtonModel(
                                text: 'Buy Data',
                                color: controller.isInformationComplete.value
                                    ? DarkThemeColors.primaryColor
                                    : DarkThemeColors.disabledButtonColor),
                            onPressed: () {
                              if (controller.validateInputs()) {
                                Get.toNamed(RoutesConstant.data_details,
                                    arguments: {
                                      'network':
                                          controller.selectedNetwork.value,
                                      'varation_id':
                                          controller.selectedVariationId.value,
                                      'phone': controller.phoneNumber.value
                                    });
                              }
                            }),
                      ))
                ],
              ),
            )

            // ),
            ),
      ),
    );
  }
}
