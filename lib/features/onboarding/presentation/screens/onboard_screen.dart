import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/features/common/controllers/primary_button_controller.dart';
import 'package:davyking/features/common/data/models/primary_button_model.dart';
import 'package:davyking/features/common/presentation/widget/primary_button_widget.dart';
import 'package:davyking/features/onboarding/controllers/onboarding_controllers.dart';

import 'package:davyking/features/onboarding/presentation/widget/next_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.mediaQuery.size.width;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              itemCount: controller.pages.length,
              itemBuilder: (context, index) {
                final page = controller.pages[index];
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              height: 200,
                              width: screenWidth,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(page['images']!),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                          Text(
                            page["title"]!,
                            textAlign:
                                index > 2 ? TextAlign.center : TextAlign.start,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 27.68,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 1.28),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            page["description"]!,
                            textAlign:
                                index > 2 ? TextAlign.center : TextAlign.start,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 13.84,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 1.25,
                            ),
                          ),
                          if (index > 2)
                            Column(
                              children: [
                                const SizedBox(height: 30),
                                Center(
                                  child: SmoothPageIndicator(
                                    controller: controller.pageController,
                                    count: controller.pages.length,
                                    effect: ExpandingDotsEffect(
                                      dotHeight: 8,
                                      dotWidth: 8,
                                      activeDotColor:
                                          LightThemeColors.primaryColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                        ],
                      ),
                      if (index <= 2)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Center(
                              child: SmoothPageIndicator(
                                controller: controller.pageController,
                                count: controller.pages.length,
                                effect: ExpandingDotsEffect(
                                  dotHeight: 8,
                                  dotWidth: 8,
                                  activeDotColor: LightThemeColors.primaryColor,
                                ),
                              ),
                            ),
                            nextButton(controller.nextPage),
                          ],
                        )
                      else
                        Column(
                          children: [
                            CustomPrimaryButton(
                                controller: CustomPrimaryButtonController(
                                    model: const CustomPrimaryButtonModel(
                                      text: "Login",
                                    ),
                                    onPressed: () {
                                      Get.toNamed(RoutesConstant.signin);
                                    })),
                            const SizedBox(height: 10),
                            CustomPrimaryButton(
                                controller: CustomPrimaryButtonController(
                                    model: CustomPrimaryButtonModel(
                                        text: "Create Account",
                                        color: Colors.white,
                                        textColor:
                                            LightThemeColors.primaryColor),
                                    onPressed: () {
                                      Get.toNamed(RoutesConstant.signup);
                                    }))
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
