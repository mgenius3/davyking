// import 'package:davyking/core/constants/routes.dart';
// import 'package:davyking/core/utils/helper.dart';
// import 'package:davyking/features/profile/controllers/terms_conditions_controller.dart';
// import 'package:davyking/features/profile/data/model/templates_model.dart';
// import 'package:davyking/features/profile/presentation/widget/templates_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:davyking/core/controllers/primary_button_controller.dart';
// import 'package:davyking/core/models/primary_button_model.dart';
// import 'package:davyking/core/widgets/primary_button_widget.dart';

// class TermsConditionsScreen extends StatelessWidget {
//   const TermsConditionsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final TermsConditionsController controller =
//         Get.put(TermsConditionsController());

//     return ProfileTemplatesWidget(
//         data: ProfileTemplatesModel(
//             title: 'Terms and Conditions',
//             showProfileDetails: false,
//             child: Container(
//               margin: const EdgeInsets.only(top: 50),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       width: 334,
//                       height: 418,
//                       child: Text.rich(
//                         TextSpan(
//                           style: Theme.of(context)
//                               .textTheme
//                               .displayMedium
//                               ?.copyWith(
//                                   fontSize: 12.84, fontWeight: FontWeight.w500),
//                           children: const [
//                             TextSpan(
//                                 text:
//                                     'Est fugiat assumenda aut reprehenderit\n'),
//                             TextSpan(
//                               text:
//                                   '\nLorem ipsum dolor sit amet. Et odio officia aut voluptate internos est omnis vitae ut architecto sunt non tenetur fuga ut provident vero. Quo aspernatur facere et consectetur ipsum et facere corrupti est asperiores facere. Est fugiat assumenda aut reprehenderit voluptatem sed.\n\n',
//                             ),
//                             TextSpan(
//                               text:
//                                   'Ea voluptates omnis aut sequi sequi.\nEst dolore quae in aliquid ducimus et autem repellendus.\nAut ipsum Quis qui porro quasi aut minus placeat!\nSit consequatur neque ab vitae facere.\n',
//                             ),
//                             TextSpan(
//                               text:
//                                   '\nAut quidem accusantium nam alias autem eum officiis placeat et omnis autem id officiis perspiciatis qui corrupti officia eum aliquam provident. Eum voluptas error et optio dolorum cum molestiae nobis et odit molestiae quo magnam impedit sed fugiat nihil non nihil vitae.\n\n',
//                             ),
//                             TextSpan(
//                               text:
//                                   'Aut fuga sequi eum voluptatibus provident.\nEos consequuntur voluptas vel amet eaque aut dignissimos velit.\n',
//                             ),
//                             TextSpan(
//                               text:
//                                   '\nVel exercitationem quam vel eligendi rerum At harum obcaecati et nostrum beatae? Ea accusantium dolores qui rerum aliquam est perferendis mollitia et ipsum ipsa qui enim autem At corporis sunt. Aut odit quisquam est reprehenderit itaque aut accusantium dolor qui neque repellat.',
//                             ),
//                           ],
//                         ),
//                         textAlign: TextAlign.justify,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Text(
//                       'Read the terms and conditions in more details ',
//                       style: Theme.of(context)
//                           .textTheme
//                           .displayMedium
//                           ?.copyWith(
//                               fontSize: 12.84, fontWeight: FontWeight.w500),
//                     ),
//                     const SizedBox(height: 5),
//                     GestureDetector(
//                       onTap: () {
//                         openLink('https://davyking.com/terms-and-conditions');
//                       },
//                       child: Text(
//                         'https://davyking.com/terms-and-conditions',
//                         style: Theme.of(context)
//                             .textTheme
//                             .displayMedium
//                             ?.copyWith(
//                                 fontSize: 12.84,
//                                 fontWeight: FontWeight.w500,
//                                 color: const Color(0xFF0084FF)),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       children: [
//                         Checkbox(
//                             value: controller.checkedbox.value,
//                             onChanged: controller.checkBoxChanged,
//                             materialTapTargetSize:
//                                 MaterialTapTargetSize.shrinkWrap,
//                             visualDensity: VisualDensity.compact),
//                         const SizedBox(width: 2),
//                         Text('I accept all the terms and conditions',
//                             textAlign: TextAlign.justify,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .displayMedium
//                                 ?.copyWith(
//                                     fontSize: 11.13,
//                                     fontWeight: FontWeight.w300,
//                                     height: 1.15))
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     SizedBox(
//                       // height: 50,
//                       child: CustomPrimaryButton(
//                           controller: CustomPrimaryButtonController(
//                               model: const CustomPrimaryButtonModel(
//                                   text: 'Continue'),
//                               onPressed: () {
//                                 Get.toNamed(RoutesConstant.home);
//                               })),
//                     ),
//                   ],
//                 ),
//               ),
//             )));
//   }
// }
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
              margin: const EdgeInsets.only(top: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last Updated: October 15, 2025',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 20),
                    Text.rich(
                      TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                fontSize: 12.84,
                                fontWeight: FontWeight.w400,
                                height: 1.5),
                        children: const [
                          TextSpan(
                            text: '1. Acceptance of Terms\n\n',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text:
                                'By accessing and using DavyKing ("the App"), you accept and agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use our services.\n\n',
                          ),
                          TextSpan(
                            text: '2. Account Registration\n\n',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text:
                                'You must be at least 13 years old to create an account. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You agree to provide accurate, current, and complete information during registration and to update such information as necessary.\n\n',
                          ),
                          TextSpan(
                            text: '3. Financial Services\n\n',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text:
                                'DavyKing provides financial technology services including but not limited to digital payments, money transfers, and account management. All transactions are subject to verification and fraud prevention measures. We reserve the right to decline or reverse any transaction that violates our policies or applicable laws.\n\n',
                          ),
                          TextSpan(
                            text: '4. User Responsibilities\n\n',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text:
                                'You agree to use the App only for lawful purposes and in accordance with these Terms. You shall not:\n\n',
                          ),
                          TextSpan(
                            text:
                                '• Use the service for any fraudulent or illegal activities\n',
                          ),
                          TextSpan(
                            text:
                                '• Attempt to gain unauthorized access to our systems\n',
                          ),
                          TextSpan(
                            text:
                                '• Share your account credentials with third parties\n',
                          ),
                          TextSpan(
                            text:
                                '• Use the App in any manner that could damage or impair our services\n',
                          ),
                          TextSpan(
                            text:
                                '• Engage in money laundering or terrorist financing\n\n',
                          ),
                          TextSpan(
                            text: '5. Fees and Charges\n\n',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text:
                                'Certain services may be subject to fees as disclosed in the App. We reserve the right to modify our fee structure with 30 days\' notice. You authorize us to deduct applicable fees from your account balance.\n\n',
                          ),
                          TextSpan(
                            text: '6. Privacy and Data Protection\n\n',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text:
                                'Your privacy is important to us. We collect, use, and protect your personal information in accordance with our Privacy Policy and applicable data protection laws. By using the App, you consent to our data practices as described in our Privacy Policy.\n\n',
                          ),
                          TextSpan(
                            text: '7. Limitation of Liability\n\n',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text:
                                'To the maximum extent permitted by law, DavyKing shall not be liable for any indirect, incidental, special, or consequential damages arising from your use of the App. Our total liability shall not exceed the amount of fees paid by you in the 12 months preceding the claim.\n\n',
                          ),
                          TextSpan(
                            text: '8. Service Availability\n\n',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text:
                                'While we strive to ensure the App is available 24/7, we do not guarantee uninterrupted access. We may suspend or restrict access for maintenance, security reasons, or due to circumstances beyond our control.\n\n',
                          ),
                          TextSpan(
                            text: '9. Termination\n\n',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text:
                                'We may suspend or terminate your account at any time if you violate these Terms or engage in activities that harm our services or other users. Upon termination, you must cease all use of the App and any outstanding obligations remain due.\n\n',
                          ),
                          TextSpan(
                            text: '10. Modifications to Terms\n\n',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text:
                                'We reserve the right to modify these Terms at any time. We will notify you of material changes via email or in-app notification. Your continued use of the App after such modifications constitutes acceptance of the updated Terms.\n\n',
                          ),
                          TextSpan(
                            text: '11. Governing Law\n\n',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text:
                                'These Terms shall be governed by and construed in accordance with the laws of Nigeria, without regard to its conflict of law provisions. Any disputes shall be resolved in the courts of Nigeria.\n\n',
                          ),
                          TextSpan(
                            text: '12. Contact Information\n\n',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text:
                                'If you have any questions about these Terms, please contact us at support@davyking.com or visit our help center within the App.',
                          ),
                        ],
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Read the complete terms and conditions',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                    fontSize: 12.84,
                                    fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              openLink(
                                  'https://davyking.com/terms-and-conditions');
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.open_in_new,
                                  size: 16,
                                  color: Color(0xFF0084FF),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'davyking.com/terms-and-conditions',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                            fontSize: 12.84,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF0084FF),
                                            decoration:
                                                TextDecoration.underline),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFCD34D)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Color(0xFFD97706),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Please read carefully before accepting',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF92400E)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(() => Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: controller.checkedbox.value
                                ? const Color(0xFFECFDF5)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: controller.checkedbox.value
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFE5E7EB),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                  value: controller.checkedbox.value,
                                  onChanged: controller.checkBoxChanged,
                                  activeColor: const Color(0xFF10B981),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                    'I have read and accept all the terms and conditions',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            height: 1.3)),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 24),
                    CustomPrimaryButton(
                        controller: CustomPrimaryButtonController(
                            model: CustomPrimaryButtonModel(
                              text: 'Go Back',
                            ),
                            onPressed: () {
                              Get.back();
                            })),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            )));
  }
}
