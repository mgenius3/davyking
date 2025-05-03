import 'package:davyking/core/constants/images.dart';
import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/features/auth/controllers/signup_controller.dart';
import 'package:davyking/features/auth/data/models/input_field_model.dart';
import 'package:davyking/features/auth/presentation/widget/button_continue_with.dart';
import 'package:davyking/features/auth/presentation/widget/horizontal_line_widget.dart';
import 'package:davyking/features/auth/presentation/widget/input_field_widget.dart';
import 'package:davyking/core/controllers/primary_button_controller.dart';
import 'package:davyking/core/models/primary_button_model.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/widgets/primary_button_widget.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: Spacing.defaultMarginSpacing,
          child: Column(
            children: [
              const TopHeaderWidget(data: TopHeaderModel(title: "Sign Up")),
              SizedBox(height: Get.height * .1),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            authInputField(AuthInputFieldModel(
                              inputcontroller: controller.nameController,
                              // hintText: "Moses",
                              name: "Name",
                            )),
                            const SizedBox(height: 20),
                            authInputField(AuthInputFieldModel(
                              inputcontroller: controller.phoneController,
                              // hintText: "Moses",
                              name: "Phone Number",
                            )),
                            const SizedBox(height: 20),
                            authInputField(AuthInputFieldModel(
                                inputcontroller: controller.emailController,
                                // hintText: "benmos16@gmail.com",
                                name: "Email Address")),
                            const SizedBox(height: 20),
                            Obx(() => authInputField(AuthInputFieldModel(
                                  inputcontroller:
                                      controller.passwordController,
                                  name: "Password",
                                  obscureText: controller.obscurePassword.value,
                                  suffixIcon: IconButton(
                                    onPressed:
                                        controller.togglePasswordVisibility,
                                    icon: Icon(controller.obscurePassword.value
                                        ? CupertinoIcons.eye
                                        : CupertinoIcons.eye_slash),
                                  ),
                                ))),
                            const SizedBox(height: 20),
                            Obx(() => authInputField(AuthInputFieldModel(
                                  inputcontroller:
                                      controller.passwordConfirmationController,
                                  name: "Confirm Password",
                                  obscureText: controller.obscurePassword.value,
                                  suffixIcon: IconButton(
                                    onPressed:
                                        controller.togglePasswordVisibility,
                                    icon: Icon(controller.obscurePassword.value
                                        ? CupertinoIcons.eye
                                        : CupertinoIcons.eye_slash),
                                  ),
                                ))),
                            const SizedBox(height: 3),
                            const Text(
                              'At least 8 characters with uppercase letters and numbers',
                              style: TextStyle(
                                  color: Color(0xFF77798D),
                                  fontSize: 10,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 1.78),
                            ),
                            Row(
                              children: [
                                Obx(() => Checkbox(
                                    value: controller.checkedbox.value,
                                    onChanged: controller.checkBoxChanged)),
                                const SizedBox(width: 2),
                                const Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Accept ',
                                        style: TextStyle(
                                            color: Color(0xFFA7ADBF),
                                            fontSize: 12.93),
                                      ),
                                      TextSpan(
                                        text: 'Terms of Use',
                                        style: TextStyle(
                                            color: Color(0xFF00CE7C),
                                            fontSize: 12.93),
                                      ),
                                      TextSpan(
                                        text: ' & ',
                                        style: TextStyle(
                                            color: Color(0xFFA7ADBF),
                                            fontSize: 12.93),
                                      ),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                            color: Color(0xFF00CE7C),
                                            fontSize: 12.93),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(() => controller.isLoading.value
                          ? CustomPrimaryButton(
                              controller: CustomPrimaryButtonController(
                                  model: const CustomPrimaryButtonModel(
                                      child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                              color: Colors.white))
                                              ),
                                  onPressed: () {}),
                            )
                          : CustomPrimaryButton(
                              controller: CustomPrimaryButtonController(
                                  model: const CustomPrimaryButtonModel(
                                    text: 'Create Account',
                                    textColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    controller.signUp();
                                  })))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style:
                          TextStyle(fontSize: 13.39, color: Color(0xFF484C58)),
                    ),
                    const SizedBox(width: 3.83),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RoutesConstant.signin);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: LightThemeColors.primaryColor,
                            fontSize: 13.39,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
