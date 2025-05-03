import 'package:davyking/core/constants/images.dart';
import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/features/auth/controllers/signin_controller.dart';
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

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              const TopHeaderWidget(data: TopHeaderModel(title: "Login")),
              Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    authInputField(AuthInputFieldModel(
                      inputcontroller: controller.emailController,
                      // hintText: "benmos16@gmail.com",
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
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RoutesConstant.forgotpassword);
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                            color: LightThemeColors.primaryColor,
                            fontSize: 13.39,
                            fontWeight: FontWeight.w400,
                            height: 1.43),
                      ),
                    ),
                  ],
                ),
              ),
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
                            controller.signIn();
                          }))),
              // Column(
              //   children: [
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         horizontalLine(),
              //         const SizedBox(width: 5),
              //         Text(
              //           'OR',
              //           textAlign: TextAlign.center,
              //           style: TextStyle(
              //             color: Colors.black.withOpacity(0.7300000190734863),
              //             fontSize: 14,
              //             fontFamily: 'Lexend',
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //         const SizedBox(width: 5),
              //         horizontalLine(),
              //       ],
              //     ),
              //     const SizedBox(height: 10),
              //     continueWithButton(
              //         iconRoutes: SvgConstant.appleIcon,
              //         text: "Continue With Apple"),
              //     const SizedBox(height: 15),
              //     continueWithButton(
              //         iconRoutes: SvgConstant.googleIcon,
              //         text: "Continue With Google")
              //   ],
              // ),
              SizedBox(
                width: Get.context!.width,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'New Here? ',
                      style: TextStyle(
                          color: Color(0xFF484C58),
                          fontSize: 13.39,
                          fontWeight: FontWeight.w400,
                          height: 1.43),
                    ),
                    const SizedBox(width: 3.83),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RoutesConstant.signup);
                      },
                      child: Text(
                        'Create an account',
                        style: TextStyle(
                            color: LightThemeColors.primaryColor,
                            fontSize: 13.39,
                            fontWeight: FontWeight.w500,
                            height: 1.43),
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
