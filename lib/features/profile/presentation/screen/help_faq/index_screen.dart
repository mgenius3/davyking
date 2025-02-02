import 'package:davyking/features/profile/controllers/help_faq_controller.dart';
import 'package:davyking/features/profile/data/model/templates_model.dart';
import 'package:davyking/features/profile/data/source/faq_data.dart';
import 'package:davyking/features/profile/presentation/screen/help_faq/widget/faq_widget.dart';
import 'package:davyking/features/profile/presentation/screen/help_faq/widget/help_widget.dart';
import 'package:davyking/features/profile/presentation/widget/templates_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpFaqScreen extends StatelessWidget {
  const HelpFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileTemplatesWidget(
        data: ProfileTemplatesModel(
            showProfileDetails: false,
            child: GetBuilder<HelpFaqController>(
                init: HelpFaqController(),
                builder: (controller) => Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: Column(
                        children: [
                          Text('How Can We Help You?',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                          const SizedBox(height: 20),
                          Container(
                            width: Get.width,
                            height: 56.41,
                            padding: const EdgeInsets.only(
                                top: 5.55,
                                left: 28.67,
                                right: 26.82,
                                bottom: 5.55),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFDFF7E2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.35),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.setBinary(0);
                                  },
                                  child: Container(
                                    width: Get.width * .3,
                                    height: 47.17,
                                    decoration: ShapeDecoration(
                                      color: controller.binary == 0
                                          ? const Color(0xFF00D09E)
                                          : null,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.65)),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            'FAQ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF052224),
                                              fontSize: 13.87,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.setBinary(1);
                                  },
                                  child: Container(
                                    width: Get.width * .3,
                                    height: 47.17,
                                    decoration: ShapeDecoration(
                                      color: controller.binary == 1
                                          ? const Color(0xFF00D09E)
                                          : null,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.65)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          width: 120,
                                          child: const Text(
                                            'Contact Us',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF232222),
                                                fontSize: 13.87,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          if (controller.binary == 0)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: faqDataSource
                                  .map((data) => FaqWidget(
                                      questions: data['questions'],
                                      answers: data['answers']))
                                  .toList(),
                            )
                          else
                            HelpWidget()
                        ],
                      ),
                    )),
            title: "Help & FAQS"));
  }
}
