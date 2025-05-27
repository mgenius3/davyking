import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/features/auth/controllers/reset_password_controller.dart';
import 'package:davyking/features/auth/data/models/input_field_model.dart';
import 'package:davyking/features/auth/presentation/widget/input_field_widget.dart';
import 'package:davyking/core/controllers/primary_button_controller.dart';
import 'package:davyking/core/models/primary_button_model.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/primary_button_widget.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
                  data: TopHeaderModel(title: "Reset Password")),
              const SizedBox(height: 50),
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Forgot Password',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        height: 1.50,
                        letterSpacing: -0.53,
                      ),
                    ),
                    Text(
                      'Please enter your email to reset the password',
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
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    authInputField(AuthInputFieldModel(
                        inputcontroller: controller.emailController,
                        hintText: "",
                        name: "Verify Email")),
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
                            text: 'Sign In',
                            textColor: Colors.white,
                          ),
                          onPressed: () {
                            controller.resetPassword();
                          }))),
            ],
          )),
    ));
  }
}
