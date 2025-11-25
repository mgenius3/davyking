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
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Container(
          margin: Spacing.defaultMarginSpacing,
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: Get.height * .04),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildPersonalInfoCard(controller),
                      const SizedBox(height: 16),
                      _buildTermsCard(controller),
                      const SizedBox(height: 20),
                      _buildCreateAccountButton(controller),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const TopHeaderWidget(data: TopHeaderModel(title: "Sign Up")),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey[800],
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Join us and start your journey today',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoCard(SignupController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputSection(
            'Full Name',
            Icons.badge_outlined,
            authInputField(AuthInputFieldModel(
              inputcontroller: controller.nameController,
              name: "Name",
            )),
          ),
          const SizedBox(height: 20),
          _buildInputSection(
            'Phone Number',
            Icons.phone_outlined,
            authInputField(AuthInputFieldModel(
              inputcontroller: controller.phoneController,
              name: "Phone Number",
            )),
          ),
          const SizedBox(height: 20),
          _buildInputSection(
            'Email Address',
            Icons.email_outlined,
            authInputField(AuthInputFieldModel(
              inputcontroller: controller.emailController,
              name: "Email Address",
            )),
          ),
          const SizedBox(height: 24),
          _buildInputSection(
            'Password',
            Icons.lock_outline,
            Obx(() => authInputField(AuthInputFieldModel(
                  inputcontroller: controller.passwordController,
                  name: "Password",
                  obscureText: controller.obscurePassword.value,
                  suffixIcon: IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      controller.togglePasswordVisibility();
                    },
                    icon: Icon(controller.obscurePassword.value
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash),
                  ),
                ))),
          ),
          const SizedBox(height: 20),
          _buildInputSection(
            'Confirm Password',
            Icons.lock_outline,
            Obx(() => authInputField(AuthInputFieldModel(
                  inputcontroller: controller.passwordConfirmationController,
                  name: "Confirm Password",
                  obscureText: controller.obscurePassword.value,
                  suffixIcon: IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      controller.togglePasswordVisibility();
                    },
                    icon: Icon(controller.obscurePassword.value
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash),
                  ),
                ))),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.amber[200]!,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.amber[700],
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'At least 8 characters with uppercase letters and numbers',
                    style: TextStyle(
                      color: Color(0xFF77798D),
                      fontSize: 10,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.78,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCard(SignupController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.verified_user_outlined,
                  size: 18,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Terms & Conditions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Obx(() => Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        value: controller.checkedbox.value,
                        onChanged: (value) {
                          HapticFeedback.lightImpact();
                          controller.checkBoxChanged(value);
                        },
                        activeColor: const Color(0xFF00CE7C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    )),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'I accept the ',
                          style: TextStyle(
                            color: Color(0xFFA7ADBF),
                            fontSize: 12.93,
                          ),
                        ),
                        TextSpan(
                          text: 'Terms of Use',
                          style: TextStyle(
                            color: Color(0xFF00CE7C),
                            fontSize: 12.93,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: ' and ',
                          style: TextStyle(
                            color: Color(0xFFA7ADBF),
                            fontSize: 12.93,
                          ),
                        ),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: Color(0xFF00CE7C),
                            fontSize: 12.93,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection(String title, IconData icon, Widget inputField) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                icon,
                size: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        inputField,
      ],
    );
  }

  Widget _buildCreateAccountButton(SignupController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Obx(() => controller.isLoading.value
              ? Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: LightThemeColors.primaryColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                )
              : Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        LightThemeColors.primaryColor,
                        LightThemeColors.primaryColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: LightThemeColors.primaryColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        controller.signUp();
                      },
                      child: const Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.person_add_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Create Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Already have an account?',
            style: TextStyle(
              fontSize: 13.39,
              color: Color(0xFF484C58),
            ),
          ),
          const SizedBox(width: 3.83),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Get.toNamed(RoutesConstant.signin);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: LightThemeColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.login_rounded,
                    size: 14,
                    color: LightThemeColors.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Login',
                    style: TextStyle(
                      color: LightThemeColors.primaryColor,
                      fontSize: 13.39,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
