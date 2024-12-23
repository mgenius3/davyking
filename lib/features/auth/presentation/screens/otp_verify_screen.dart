import 'package:davyking/core/constants/images.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/utils/spacing.dart';
import 'package:davyking/features/auth/controllers/otp_verification_controller.dart';
import 'package:davyking/features/common/controllers/primary_button_controller.dart';
import 'package:davyking/features/common/data/models/primary_button_model.dart';
import 'package:davyking/features/common/data/models/top_header_model.dart';
import 'package:davyking/features/common/presentation/widget/primary_button_widget.dart';
import 'package:davyking/features/common/presentation/widget/top_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final OtpVerifyController businessController = Get.put(OtpVerifyController());
  @override
  void initState() {
    businessController.startCountdownTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments; // Access the arguments
    final email = args['email'];
    double width = Get.context!.width;
    double height = Get.context!.height;

    Widget codeBox(TextEditingController controller, int focusnumber) {
      final focusNode = FocusNode();

      return RawKeyboardListener(
        focusNode: focusNode,
        onKey: (RawKeyEvent event) {
          if (event.runtimeType.toString() == 'RawKeyDownEvent' &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            if (focusnumber > 0 && controller.text.isEmpty) {
              businessController.focusNodes[focusnumber - 1].requestFocus();
            }
          }
        },
        child: SizedBox(
            width: width * 0.15,
            height: 65.64,
            child: Center(
              child: TextFormField(
                keyboardType: TextInputType.phone,
                obscureText: true,
                autofocus: true,
                focusNode: businessController.focusNodes[focusnumber],
                controller: controller,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1), // Limit to 1 character
                ],
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                            color: Color(0xFFD3D3D3), width: 1.0)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                            color: LightThemeColors.primaryColor, width: 1.0))),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value) {
                  businessController.updatePinValue(focusnumber, value);
                  businessController.isPinComplete();
                  if (focusnumber == 3 && value.isNotEmpty) {
                    businessController.submit();
                  }
                },
              ),
            )),
      );
    }

    return Scaffold(
        body: SafeArea(
            child: Container(
      margin: Spacing.defaultMarginSpacing,
      height: height - 90,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TopHeaderWidget(
                      model: TopHeaderModel(title: "OTP Verification")),
                  const SizedBox(height: 30),
                  Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Code have been sent to your email',
                              style: TextStyle(
                                color: Color(0xFF545457),
                                fontSize: 15.55,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 1.43,
                              ),
                            ),
                            TextSpan(
                              text: ' \n$email',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.55,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 1.43),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 35),
                      Form(
                          key: businessController.formKey,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: businessController.textControllers
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => codeBox(
                                        entry.value, // controller
                                        entry.key // index
                                        ),
                                  )
                                  .toList())),
                      const SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            Obx(() => Text(
                                  '${(businessController.secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(businessController.secondsRemaining % 60).toString().padLeft(2, '0')}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Color(0xFF545457),
                                      fontSize: 13.72,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 1.43),
                                )),
                            TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Resend Code',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF3AD29F),
                                    fontSize: 15.67,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    height: 1.50,
                                  ),
                                ))
                          ],
                        ),
                      )
                    ],
                  ))
                ],
              ),
            ),
            const SizedBox(height: 10),
            CustomPrimaryButton(
                controller: CustomPrimaryButtonController(
                    model: const CustomPrimaryButtonModel(
                      text: "Verify",
                    ),
                    onPressed: () {
                      Get.dialog(Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(ImagesConstant.email_verify_successful),
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
                    }))
          ]),
    )));
  }
}
