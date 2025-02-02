import 'package:davyking/core/controllers/primary_button_controller.dart';
import 'package:davyking/core/models/primary_button_model.dart';
import 'package:davyking/core/widgets/primary_button_widget.dart';
import 'package:davyking/features/profile/controllers/change_pin_controller.dart';
import 'package:davyking/features/profile/data/model/input_field_model.dart';
import 'package:davyking/features/profile/data/model/templates_model.dart';
import 'package:davyking/features/profile/presentation/widget/input_field_model.dart';
import 'package:davyking/features/profile/presentation/widget/templates_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePinScreen extends StatelessWidget {
  const ChangePinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChangePinController controller = Get.put(ChangePinController());

    return ProfileTemplatesWidget(
        data: ProfileTemplatesModel(
            showProfileDetails: false,
            title: "Change Pin",
            child: Container(
              margin: const EdgeInsets.only(top: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(() => profileInputField(ProfileInputFieldModel(
                      inputcontroller: controller.currentPin,
                      obscureText: controller.obscureCurrentPin.value,
                      suffixIcon: SizedBox(
                        width: 22,
                        height: 22,
                        child: IconButton(
                            onPressed: controller.toggleCurrentPinVisibility,
                            icon: Icon(controller.obscureCurrentPin.value
                                ? CupertinoIcons.eye
                                : CupertinoIcons.eye_slash)),
                      ),
                      name: 'Current Pin'))),
                  const SizedBox(height: 20),
                  Obx(() => profileInputField(ProfileInputFieldModel(
                      inputcontroller: controller.newPin,
                      obscureText: controller.obscureNewPin.value,
                      suffixIcon: SizedBox(
                        width: 22,
                        height: 22,
                        child: IconButton(
                            onPressed: controller.toggleNewPinVisibility,
                            icon: Icon(controller.obscureNewPin.value
                                ? CupertinoIcons.eye
                                : CupertinoIcons.eye_slash)),
                      ),
                      name: 'New Pin'))),
                  const SizedBox(height: 20),
                  Obx(() => profileInputField(ProfileInputFieldModel(
                      inputcontroller: controller.confirmPin,
                      obscureText: controller.obscureConfirmNewPin.value,
                      suffixIcon: SizedBox(
                        width: 22,
                        height: 22,
                        child: IconButton(
                            onPressed: controller.toggleConirmNewPinVisibility,
                            icon: Icon(controller.obscureConfirmNewPin.value
                                ? CupertinoIcons.eye
                                : CupertinoIcons.eye_slash)),
                      ),
                      name: 'Confirm New Pin'))),
                  const SizedBox(height: 40),
                  SizedBox(
                    // height: 50,
                    child: CustomPrimaryButton(
                        controller: CustomPrimaryButtonController(
                            model: const CustomPrimaryButtonModel(
                                text: 'Change Pin'),
                            onPressed: () {})),
                  ),
                  const SizedBox(height: 20)
                ],
              ),
            )));
  }
}
