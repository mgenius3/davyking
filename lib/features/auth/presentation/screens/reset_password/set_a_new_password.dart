import 'package:davyking/core/constants/images.dart';
import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/features/auth/controllers/reset_password_controller.dart';
import 'package:davyking/features/auth/data/models/input_field_model.dart';
import 'package:davyking/features/auth/presentation/widget/button_continue_with.dart';
import 'package:davyking/features/auth/presentation/widget/horizontal_line_widget.dart';
import 'package:davyking/features/auth/presentation/widget/input_field_widget.dart';
import 'package:davyking/features/common/controllers/primary_button_controller.dart';
import 'package:davyking/features/common/data/models/primary_button_model.dart';
import 'package:davyking/features/common/data/models/top_header_model.dart';
import 'package:davyking/features/common/presentation/widget/primary_button_widget.dart';
import 'package:davyking/features/common/presentation/widget/top_header_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetANewPasswordScreen extends StatelessWidget {
  const SetANewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ResetPasswordController controller =
        Get.put(ResetPasswordController());

    return Scaffold(
        body: SafeArea(
      child: Container(
          margin: Spacing.defaultMarginSpacing,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopHeaderWidget(
                  model: TopHeaderModel(title: "Reset Password")),
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
                        letterSpacing: -0.53,
                      ),
                    ),
                    Text(
                      'Create a new password. Ensure it differs from previous ones for security',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.5199999809265137),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.67,
                          letterSpacing: -0.50),
                    )
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
              CustomPrimaryButton(
                  controller: CustomPrimaryButtonController(
                      model: const CustomPrimaryButtonModel(
                        text: "Continue",
                      ),
                      onPressed: () {
                        Get.dialog(Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                  ImagesConstant.reset_password_successful),
                              TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Go Home',
                                    style: TextStyle(
                                        color: LightThemeColors.primaryColor,
                                        fontWeight: FontWeight.w700),
                                  ))
                            ],
                          ),
                        ));
                      })),
            ],
          )),
    ));
  }
}
