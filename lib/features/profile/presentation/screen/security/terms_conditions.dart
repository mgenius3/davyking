import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/utils/helper.dart';
import 'package:davyking/features/profile/controllers/terms_conditions_controller.dart';
import 'package:davyking/features/profile/data/model/templates_model.dart';
import 'package:davyking/features/profile/presentation/widget/templates_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:davyking/core/controllers/primary_button_controller.dart';
import 'package:davyking/core/models/primary_button_model.dart';
import 'package:davyking/core/widgets/primary_button_widget.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TermsConditionsController controller =
        Get.put(TermsConditionsController());

    return ProfileTemplatesWidget(
        data: ProfileTemplatesModel(
            title: 'Terms and Conditions',
            showProfileDetails: false,
            child: Container(
              margin: const EdgeInsets.only(top: 50),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 334,
                      height: 418,
                      child: Text.rich(
                        TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                  fontSize: 12.84, fontWeight: FontWeight.w500),
                          children: const [
                            TextSpan(
                                text:
                                    'Est fugiat assumenda aut reprehenderit\n'),
                            TextSpan(
                              text:
                                  '\nLorem ipsum dolor sit amet. Et odio officia aut voluptate internos est omnis vitae ut architecto sunt non tenetur fuga ut provident vero. Quo aspernatur facere et consectetur ipsum et facere corrupti est asperiores facere. Est fugiat assumenda aut reprehenderit voluptatem sed.\n\n',
                            ),
                            TextSpan(
                              text:
                                  'Ea voluptates omnis aut sequi sequi.\nEst dolore quae in aliquid ducimus et autem repellendus.\nAut ipsum Quis qui porro quasi aut minus placeat!\nSit consequatur neque ab vitae facere.\n',
                            ),
                            TextSpan(
                              text:
                                  '\nAut quidem accusantium nam alias autem eum officiis placeat et omnis autem id officiis perspiciatis qui corrupti officia eum aliquam provident. Eum voluptas error et optio dolorum cum molestiae nobis et odit molestiae quo magnam impedit sed fugiat nihil non nihil vitae.\n\n',
                            ),
                            TextSpan(
                              text:
                                  'Aut fuga sequi eum voluptatibus provident.\nEos consequuntur voluptas vel amet eaque aut dignissimos velit.\n',
                            ),
                            TextSpan(
                              text:
                                  '\nVel exercitationem quam vel eligendi rerum At harum obcaecati et nostrum beatae? Ea accusantium dolores qui rerum aliquam est perferendis mollitia et ipsum ipsa qui enim autem At corporis sunt. Aut odit quisquam est reprehenderit itaque aut accusantium dolor qui neque repellat.',
                            ),
                          ],
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Read the terms and conditions in more details ',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              fontSize: 12.84, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                        openLink('https://davyking.com/terms-and-conditions');
                      },
                      child: Text(
                        'https://davyking.com/terms-and-conditions',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                fontSize: 12.84,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF0084FF)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                            value: controller.checkedbox.value,
                            onChanged: controller.checkBoxChanged,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact),
                        const SizedBox(width: 2),
                        Text('I accept all the terms and conditions',
                            textAlign: TextAlign.justify,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                    fontSize: 11.13,
                                    fontWeight: FontWeight.w300,
                                    height: 1.15))
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      // height: 50,
                      child: CustomPrimaryButton(
                          controller: CustomPrimaryButtonController(
                              model: const CustomPrimaryButtonModel(
                                  text: 'Continue'),
                              onPressed: () {
                                Get.toNamed(RoutesConstant.home);
                              })),
                    ),
                  ],
                ),
              ),
            )));
  }
}
