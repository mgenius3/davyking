import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/controllers/transaction_auth_controller.dart';
import 'package:davyking/features/profile/controllers/edit_profile_controller.dart';
import 'package:davyking/features/profile/data/model/templates_model.dart';
import 'package:davyking/features/profile/presentation/widget/templates_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecurityIndexScreen extends StatelessWidget {
  const SecurityIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EditProfileController controller = Get.put(EditProfileController());
    final TransactionAuthController transactionAuthController =
        Get.find<TransactionAuthController>();

    return ProfileTemplatesWidget(
        data: ProfileTemplatesModel(
            title: 'Security',
            showProfileDetails: false,
            child: Container(
              margin: const EdgeInsets.only(top: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      print('hello');
                      await transactionAuthController.changePin(context);
                    },
                    child: securityList(name: "Change Pin"),
                    // route: ""
                  ),
                  const SizedBox(height: 40),

                  // GestureDetector(
                  //   onTap: () {
                  //     Get.toNamed(
                  //         RoutesConstant.profileSecurityTermsAndCondition);
                  //   },
                  //   child: securityList(name: "Terms And Conditions"),
                  // ),
                  // const SizedBox(height: 40),
                  // securityList(name: "FAQ", route: ''),
                  // const SizedBox(height: 40),
                  // GestureDetector(
                  //   onTap: () {
                  //     Get.toNamed('');
                  //   },
                  //   child: securityList(name: "Privacy Policy"),
                  // )
                  // const SizedBox(height: 40),
                  // securityList(name: "Support Center", route: '')
                ],
              ),
            )));
  }
}

Widget securityList({
  required String name,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(name,
          style: Theme.of(Get.context!)
              .textTheme
              .displayMedium
              ?.copyWith(fontSize: 15, fontWeight: FontWeight.w500)),
      const Icon(Icons.arrow_forward_ios, size: 15)
    ],
  );
}
