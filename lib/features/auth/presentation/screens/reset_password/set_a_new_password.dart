import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/features/auth/controllers/set_new_password_controller.dart';
import 'package:davyking/features/auth/data/models/input_field_model.dart';
import 'package:davyking/features/auth/presentation/widget/input_field_widget.dart';
import 'package:davyking/core/controllers/primary_button_controller.dart';
import 'package:davyking/core/models/primary_button_model.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/primary_button_widget.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetANewPasswordScreen extends StatelessWidget {
  const SetANewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments; // Access the arguments
    final email = args['email'];
    final SetNewPasswordController controller =
        Get.put(SetNewPasswordController());

    return Scaffold(
        body: SafeArea(
      child: Container(
          margin: Spacing.defaultMarginSpacing,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopHeaderWidget(
                  data: TopHeaderModel(title: "Reset Password")),
              const SizedBox(height: 50),
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Set A New Password',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                          letterSpacing: -0.53),
                    ),
                    Text(
                        'Create a new password. Ensure it differs from previous ones for security',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.5199999809265137),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.67,
                            letterSpacing: -0.50))
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Form(
                // key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => authInputField(AuthInputFieldModel(
                          inputcontroller: controller.passwordController,
                          name: "Password",
                          obscureText: controller.obscurePassword.value,
                          suffixIcon: SizedBox(
                            width: 22,
                            height: 22,
                            child: IconButton(
                                onPressed: controller.togglePasswordVisibility,
                                icon: Icon(controller.obscurePassword.value
                                    ? CupertinoIcons.eye
                                    : CupertinoIcons.eye_slash)),
                          ),
                        ))),
                    const SizedBox(height: 20),
                    Obx(() => authInputField(AuthInputFieldModel(
                          inputcontroller: controller.confirmPasswordController,
                          name: "Confirm Password",
                          obscureText: controller.obscurePassword.value,
                          suffixIcon: SizedBox(
                            width: 22,
                            height: 22,
                            child: IconButton(
                                onPressed: controller.togglePasswordVisibility,
                                icon: Icon(controller.obscurePassword.value
                                    ? CupertinoIcons.eye
                                    : CupertinoIcons.eye_slash)),
                          ),
                        ))),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Obx(() => controller.isLoading.value
                  ? CustomPrimaryButton(
                      controller: CustomPrimaryButtonController(
                          model: const CustomPrimaryButtonModel(
                              child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white))),
                          onPressed: () {}),
                    )
                  : CustomPrimaryButton(
                      controller: CustomPrimaryButtonController(
                          model: const CustomPrimaryButtonModel(
                            text: 'Set New Password',
                            textColor: Colors.white,
                          ),
                          onPressed: () {
                            controller.setNewPassword(email);
                          }))),
            ],
          )),
    ));
  }
}
