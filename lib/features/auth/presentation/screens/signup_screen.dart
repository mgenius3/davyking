import 'package:davyking/core/constants/images.dart';
import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/features/auth/controllers/signup_controller.dart';
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

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
        body: SafeArea(
      child: Container(
          margin: Spacing.defaultMarginSpacing,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopHeaderWidget(model: TopHeaderModel(title: "Sign Up")),
              Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    authInputField(AuthInputFieldModel(
                      inputcontroller: controller.firstNameController,
                      hintText: "Moses",
                      name: "First Name",
                    )),
                    const SizedBox(height: 20),
                    authInputField(AuthInputFieldModel(
                      inputcontroller: controller.lastNameController,
                      hintText: "Benjamin",
                      name: "Last Name",
                    )),
                    const SizedBox(height: 20),
                    authInputField(AuthInputFieldModel(
                      inputcontroller: controller.emailController,
                      hintText: "benmos16@gmail.com",
                      name: "Email Address",
                    )),
                    const SizedBox(height: 20),
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
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() => Checkbox(
                            value: controller.checkedbox.value,
                            onChanged: controller.checkBoxChanged,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact)),
                        const SizedBox(width: 2),
                        const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Accept ',
                                style: TextStyle(
                                  color: Color(0xFFA7ADBF),
                                  fontSize: 12.93,
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                ),
                              ),
                              TextSpan(
                                text: 'Terms of Use',
                                style: TextStyle(
                                  color: Color(0xFF00CE7C),
                                  fontSize: 12.93,
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                ),
                              ),
                              TextSpan(
                                text: ' & ',
                                style: TextStyle(
                                  color: Color(0xFFA7ADBF),
                                  fontSize: 12.93,
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                ),
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: Color(0xFF00CE7C),
                                  fontSize: 12.93,
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                ),
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
              CustomPrimaryButton(
                  controller: CustomPrimaryButtonController(
                      model: const CustomPrimaryButtonModel(
                        text: "Sign Up",
                      ),
                      onPressed: () {
                        Get.toNamed(RoutesConstant.otpverify, arguments: {
                          "email": controller.emailController.text.trim()
                        });
                      })),
              SizedBox(
                width: Get.context!.width,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                          color: Color(0xFF484C58),
                          fontSize: 13.39,
                          fontWeight: FontWeight.w400,
                          height: 1.43),
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
                          fontWeight: FontWeight.w500,
                          height: 1.43,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
    ));
  }
}
