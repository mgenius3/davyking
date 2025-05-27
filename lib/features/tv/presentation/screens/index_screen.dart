import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/core/widgets/vtu_input_field.dart';
import 'package:davyking/features/airtime/data/model/input_field_model.dart';
import 'package:davyking/core/controllers/primary_button_controller.dart';
import 'package:davyking/core/models/primary_button_model.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/primary_button_widget.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:davyking/features/tv/controllers/index_controller.dart';
import 'package:davyking/features/tv/presentation/widgets/customer_details_widget.dart';
import 'package:davyking/features/tv/presentation/widgets/tv_network_widget.dart';
import 'package:davyking/features/tv/presentation/widgets/tv_variation_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TvScreen extends StatefulWidget {
  const TvScreen({super.key});

  @override
  State<TvScreen> createState() => _TvScreenState();
}

class _TvScreenState extends State<TvScreen> {
  final TvIndexController controller = Get.put(TvIndexController());

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
                  const TopHeaderWidget(data: TopHeaderModel(title: "Tv")),
                  const SizedBox(height: 37.82),
                  Text(
                    'Select Network',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.83),
                  ),
                  const SizedBox(height: 10),
                  const TvNetworkWidget(),
                  const SizedBox(height: 20),
                  Text(
                    'Select Tv Plan',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.83),
                  ),
                  const SizedBox(height: 10),
                  const TvVariationWidget(),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                          child: vtuInputField(AirtimeInputFieldModel(
                        onChanged: controller.setCustomerId,
                        inputcontroller: controller.customerIdController,
                        hintText: '1111111111',
                        name: 'Smart card or IUC Number',
                      ))),
                      const SizedBox(width: 10),
                      Obx(() => SizedBox(
                            height: 30,
                            width: 100,
                            child: GestureDetector(
                              onTap: () {
                                if (!controller.isVerifying.value) {
                                  controller.verifyCustomer();
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: DarkThemeColors.primaryColor),
                                child: controller.isVerifying.value
                                    ? const Center(
                                        child: SizedBox(
                                            width: 10,
                                            height: 10,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            )))
                                    : const Center(
                                        child: Text('Verify',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                              ),
                            ),
                          ))
                    ],
                  ),
                  Obx(() => controller.customerDetails.isNotEmpty
                      ? CustomerDetailsWidget(controller: controller)
                      : controller.error_customer_details.isNotEmpty
                          ? Text(
                              controller.error_customer_details.value,
                              style: const TextStyle(color: Colors.red),
                            )
                          : const SizedBox()),
                  const SizedBox(height: 40),
                  Obx(() => CustomPrimaryButton(
                        controller: CustomPrimaryButtonController(
                            model: CustomPrimaryButtonModel(
                                text: 'Buy Tv',
                                color: controller.isInformationComplete.value
                                    ? DarkThemeColors.primaryColor
                                    : DarkThemeColors.disabledButtonColor),
                            onPressed: () {
                              if (controller.validateInputs()) {
                                Get.toNamed(RoutesConstant.tv_details,
                                    arguments: {
                                      'varation_id':
                                          controller.selectedVariationId.value,
                                      'customer_id': controller.customerId.value
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
